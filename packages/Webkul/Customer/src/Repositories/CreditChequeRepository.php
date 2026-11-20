<?php

namespace Webkul\Customer\Repositories;

use Illuminate\Database\UniqueConstraintViolationException;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Webkul\Core\Eloquent\Repository;
use Webkul\Customer\Contracts\CreditCheque;
use Webkul\Customer\Helpers\CreditIdentity;
use Webkul\Customer\Helpers\PurchaseCreditWorkflow;

class CreditChequeRepository extends Repository
{
    protected function allowedCache($method)
    {
        return false;
    }

    public function model(): string
    {
        return CreditCheque::class;
    }

    public function register(array $data, int $adminId)
    {
        return DB::transaction(function () use ($data, $adminId) {
            app(CustomerRepository::class)->getModel()->newQuery()->whereKey($data['customer_id'])->lockForUpdate()->firstOrFail();
            $existing = $this->getModel()->newQuery()->where('request_key', $data['request_key'])->first();
            if ($existing) {
                if ($existing->customer_id !== (int) $data['customer_id'] || $existing->amount_toman !== (int) $data['amount_toman']) {
                    $this->fail('duplicate');
                }

                return $existing;
            }
            $data['reference_hash'] = hash('sha256', self::normalizeReference($data['reference']));
            $data['sayad_hash'] = ! empty($data['sayad_id']) ? hash('sha256', CreditIdentity::digits($data['sayad_id'])) : null;
            $duplicates = $this->getModel()->newQuery()->where(fn ($query) => $query->where('customer_id', $data['customer_id'])->where('reference_hash', $data['reference_hash']));
            if ($data['sayad_hash']) {
                $duplicates->orWhere('sayad_hash', $data['sayad_hash']);
            }
            if ($duplicates->exists()) {
                $this->fail('duplicate');
            }
            $data['created_by'] = $adminId;
            $data['history'] = [['action' => 'registered', 'admin_id' => $adminId, 'at' => now()->toIso8601String()]];
            try {
                return $this->create($data);
            } catch (UniqueConstraintViolationException) {
                $this->fail('duplicate');
            }
        });
    }

    public function revise(int $id, array $data, int $adminId)
    {
        return DB::transaction(function () use ($id, $data, $adminId) {
            $cheque = $this->getModel()->newQuery()->lockForUpdate()->findOrFail($id);
            if ($cheque->allocated_at && ((int) $data['amount_toman'] !== $cheque->amount_toman || ! $data['sayad_confirmed'])) {
                $this->fail('immutable');
            }
            $before = $cheque->only(['due_date', 'status', 'amount_toman', 'sayad_confirmed', 'company_name']);
            $cheque->fill($data);
            $cheque->history = array_merge($cheque->history, [['action' => 'updated', 'before' => $before, 'after' => $data, 'admin_id' => $adminId, 'at' => now()->toIso8601String()]]);
            $cheque->save();

            return $cheque;
        });
    }

    public function allocate(int $id, int $amount, int $adminId)
    {
        return DB::transaction(function () use ($id, $amount, $adminId) {
            $cheque = $this->getModel()->newQuery()->lockForUpdate()->findOrFail($id);
            if ($cheque->allocated_at) {
                return $cheque;
            }
            if ($cheque->application_id) {
                app(PurchaseCreditWorkflow::class)->review($cheque->application_id, 'activate', ['amount' => $amount], $adminId);

                return $cheque->fresh();
            }
            if (! $cheque->sayad_confirmed || ! in_array($cheque->status, ['received', 'cleared']) || $amount < 1 || $amount > $cheque->amount_toman || $amount > 1000000000000) {
                $this->fail('notReady');
            }
            $customer = app(CustomerRepository::class)->getModel()->newQuery()->whereKey($cheque->customer_id)->lockForUpdate()->firstOrFail();
            $phone = CreditIdentity::phone((string) $customer->phone);
            if (! $customer->status || $customer->is_suspended || ! preg_match('/^09\d{9}$/', $phone)) {
                $this->fail('phone');
            }
            $accounts = app(CreditAccountRepository::class);
            $account = $accounts->getModel()->newQuery()->where('phone', $phone)->first();
            if (! $account) {
                $account = $accounts->open(['phone' => $phone, 'holder_name' => $customer->name], 0, 'cheque-open:'.$cheque->id, $adminId)->fresh();
            }
            if (($account->customer_id && $account->customer_id !== $customer->id) || ! $account->is_active) {
                $this->fail('phone');
            }
            $accounts->forCustomer($customer);
            $accounts->adjust($account->id, $amount, 'increase', 'cheque:'.$cheque->id, trans('customer::cheques.grantReason'), $cheque->reference, $adminId);
            $applications = app(PurchaseCreditApplicationRepository::class);
            $application = $applications->getModel()->newQuery()->where('customer_id', $customer->id)->latest('id')->lockForUpdate()->first();
            $total = ($application?->status === 'active' ? $application->approved_toman : 0) + $amount;
            $bypassed = ! $application || $application->identity_bypassed || ! in_array($application->status, ['cheque_pending', 'allocation_pending', 'active']);
            $data = ['customer_id' => $customer->id, 'status' => 'active', 'identity_bypassed' => $bypassed,
                'approved_toman' => $total, 'requested_toman' => max($application?->requested_toman ?? 0, $total),
                'ceiling_toman' => max($application?->ceiling_toman ?? 0, $total), 'cheque_reference' => $cheque->reference,
                'activated_at' => now(), 'rejection_reason' => null, 'documents' => $application?->documents ?? [],
                'history' => array_merge($application?->history ?? [], [['action' => 'admin_cheque', 'cheque_id' => $cheque->id, 'amount' => $amount, 'admin_id' => $adminId, 'at' => now()->toIso8601String()]])];
            if ($application) {
                $application->update($data);
            } else {
                $applications->create($data);
            }
            $cheque->fill(['allocated_toman' => $amount, 'allocated_at' => now(), 'allocated_by' => $adminId]);
            $cheque->history = array_merge($cheque->history, [['action' => 'allocated', 'amount' => $amount, 'admin_id' => $adminId, 'at' => now()->toIso8601String()]]);
            $cheque->save();

            return $cheque;
        }, 3);
    }

    public static function normalizeReference(string $value): string
    {
        return strtoupper(preg_replace('/[\s-]+/', '', CreditIdentity::digits(trim($value))));
    }

    private function fail(string $key): never
    {
        throw ValidationException::withMessages(['cheque' => trans('customer::cheques.'.$key)]);
    }
}
