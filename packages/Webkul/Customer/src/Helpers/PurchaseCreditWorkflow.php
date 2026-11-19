<?php

namespace Webkul\Customer\Helpers;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Webkul\Customer\Repositories\CreditAccountRepository;
use Webkul\Customer\Repositories\CreditChequeRepository;
use Webkul\Customer\Repositories\CustomerRepository;
use Webkul\Customer\Repositories\PurchaseCreditApplicationRepository;

class PurchaseCreditWorkflow
{
    public function verified($customer): bool
    {
        return $customer->status && ! $customer->is_suspended
            && $customer->credit_phone_verified_at
            && preg_match('/^09\d{9}$/', CreditIdentity::phone((string) $customer->phone))
            && $customer->credit_verified_phone === CreditIdentity::phone((string) $customer->phone);
    }

    public function submit($customer, int $amount, array $documents)
    {
        if (! $this->verified($customer)) {
            $this->fail('verify');
        }

        return DB::transaction(function () use ($customer, $amount, $documents) {
            // Serialize concurrent applications for the same customer.
            app(CustomerRepository::class)->getModel()->newQuery()->whereKey($customer->id)->lockForUpdate()->firstOrFail();
            $ceiling = app(PurchaseCreditEligibility::class)->calculate($customer)['ceiling'];
            $this->validateAmount($amount, $ceiling);
            $repository = app(PurchaseCreditApplicationRepository::class);
            $application = $repository->getModel()->newQuery()->where('customer_id', $customer->id)->lockForUpdate()->first();
            if ($application && ! in_array($application->status, ['documents_pending', 'rejected'])) {
                $this->fail('locked');
            }
            $data = [
                'customer_id' => $customer->id, 'requested_toman' => $amount, 'ceiling_toman' => $ceiling,
                'status' => 'documents_pending', 'documents' => $documents, 'rejection_reason' => null,
                'history' => array_merge($application?->history ?? [], [['action' => 'submitted', 'at' => now()->toIso8601String(), 'amount' => $amount]]),
            ];

            return $application ? tap($application)->update($data) : $repository->create($data);
        });
    }

    public function submitCheque($customer, int $id, array $document)
    {
        return DB::transaction(function () use ($customer, $id, $document) {
            $application = app(PurchaseCreditApplicationRepository::class)->getModel()->newQuery()->lockForUpdate()->findOrFail($id);
            abort_unless($application->customer_id === $customer->id, 404);
            if (! $this->verified($customer) || $application->status !== 'cheque_pending') {
                $this->fail('locked');
            }
            $application->documents = array_merge(array_values(array_filter($application->documents, fn ($file) => ($file['type'] ?? '') !== 'cheque')), [array_merge($document, ['type' => 'cheque'])]);
            $application->history = array_merge($application->history, [['action' => 'cheque_submitted', 'at' => now()->toIso8601String()]]);
            $application->save();

            return $application;
        });
    }

    public function review(int $id, string $action, array $data, int $adminId)
    {
        return DB::transaction(function () use ($id, $action, $data, $adminId) {
            $application = app(PurchaseCreditApplicationRepository::class)->getModel()->newQuery()->lockForUpdate()->findOrFail($id);
            if ($application->status === 'active') {
                if ($action === 'activate') {
                    return $application;
                }
                $this->fail('locked');
            }
            if ($action === 'documents') {
                if ($application->status !== 'documents_pending' || ! $application->documents) {
                    $this->fail('locked');
                }
                $application->status = 'cheque_pending';
            } elseif ($action === 'cheque') {
                if ($application->status !== 'cheque_pending' || ! collect($application->documents)->contains(fn ($file) => ($file['type'] ?? '') === 'cheque')) {
                    $this->fail('locked');
                }
                validator($data, ['cheque_reference' => 'required|string|max:250', 'due_date' => 'required|date_format:Y-m-d', 'cheque_amount' => 'required|integer|min:1|max:1000000000000', 'sayad_confirmed' => 'accepted', 'company_name' => 'nullable|string|max:255', 'bank_name' => 'nullable|string|max:100'])->validate();
                $cheques = app(CreditChequeRepository::class);
                $previous = $cheques->getModel()->newQuery()->where('application_id', $id)->lockForUpdate()->first();
                if ($previous) {
                    if ($previous->allocated_at) {
                        $this->fail('locked');
                    }
                    $previous->update(['application_id' => null, 'status' => 'canceled', 'history' => array_merge($previous->history, [['action' => 'superseded', 'admin_id' => $adminId, 'at' => now()->toIso8601String()]])]);
                }
                $cheques->register(['customer_id' => $application->customer_id, 'application_id' => $id, 'request_key' => (string) Str::uuid(), 'reference' => $data['cheque_reference'], 'due_date' => $data['due_date'], 'amount_toman' => (int) $data['cheque_amount'], 'sayad_confirmed' => true, 'status' => 'received', 'company_name' => $data['company_name'] ?? null, 'bank_name' => $data['bank_name'] ?? null, 'document' => collect($application->documents)->first(fn ($file) => ($file['type'] ?? '') === 'cheque')], $adminId);
                $application->fill(['status' => 'allocation_pending', 'cheque_reference' => $data['cheque_reference']]);
            } elseif ($action === 'reject') {
                validator($data, ['reason' => 'required|string|max:2000'])->validate();
                $application->status = 'rejected';
                $application->rejection_reason = $data['reason'];
            } else {
                if ($action !== 'activate' || $application->status !== 'allocation_pending' || ! $application->cheque_reference) {
                    $this->fail('locked');
                }
                validator($data, ['amount' => 'required|integer|min:1'])->validate();
                $customer = app(CustomerRepository::class)->getModel()->newQuery()->findOrFail($application->customer_id);
                if (! $this->verified($customer)) {
                    $this->fail('verify');
                }
                $ceiling = app(PurchaseCreditEligibility::class)->calculate($customer)['ceiling'];
                $amount = (int) $data['amount'];
                $this->validateAmount($amount, min($ceiling, $application->requested_toman));
                $cheque = app(CreditChequeRepository::class)->getModel()->newQuery()->where('application_id', $id)->lockForUpdate()->first();
                if (! $cheque || ! $cheque->sayad_confirmed || ! in_array($cheque->status, ['received', 'cleared']) || $amount > $cheque->amount_toman) {
                    $this->fail('locked');
                }
                $accounts = app(CreditAccountRepository::class);
                $phone = CreditIdentity::phone((string) $customer->phone);
                if (! $accounts->findOneByField('phone', $phone)) {
                    $accounts->open(['phone' => $phone, 'holder_name' => $customer->name], 0, 'purchase-credit-open:'.$id, $adminId);
                }
                $account = $accounts->forCustomer($customer);
                if (! $account || ! $account->is_active) {
                    $this->fail('verify');
                }
                $accounts->adjust($account->id, $amount, 'increase', 'purchase-credit:'.$id, trans('customer::purchase-credit.grantReason'), $application->cheque_reference, $adminId);
                $application->fill(['status' => 'active', 'approved_toman' => $amount, 'activated_at' => now()]);
                $cheque->update(['allocated_toman' => $amount, 'allocated_at' => now(), 'allocated_by' => $adminId, 'history' => array_merge($cheque->history, [['action' => 'allocated', 'amount' => $amount, 'admin_id' => $adminId, 'at' => now()->toIso8601String()]])]);
            }
            $application->history = array_merge($application->history ?? [], [[
                'action' => $action, 'admin_id' => $adminId, 'at' => now()->toIso8601String(),
                'amount' => $application->approved_toman, 'reason' => $data['reason'] ?? null,
            ]]);
            $application->save();

            return $application;
        }, 3);
    }

    private function validateAmount(int $amount, int $ceiling): void
    {
        $minimum = PurchaseCreditSettings::minimumAmount();
        if ($amount < $minimum || $amount > $ceiling || ($amount - $minimum) % PurchaseCreditSettings::STEP !== 0) {
            $this->fail('invalidAmount');
        }
    }

    private function fail(string $key): never
    {
        throw ValidationException::withMessages(['credit' => trans('customer::purchase-credit.'.$key, [
            'minimum' => number_format(PurchaseCreditSettings::minimumAmount()),
            'step' => number_format(PurchaseCreditSettings::STEP),
        ])]);
    }
}
