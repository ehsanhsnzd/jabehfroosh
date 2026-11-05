<?php

namespace Webkul\Customer\Repositories;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Webkul\Core\Eloquent\Repository;
use Webkul\Customer\Contracts\CreditAccount;
use Webkul\Customer\Helpers\CreditIdentity;

class CreditAccountRepository extends Repository
{
    public function model(): string
    {
        return CreditAccount::class;
    }

    public function open(array $profile, int $toman, string $key, ?int $adminId)
    {
        $profile['phone'] = CreditIdentity::phone($profile['phone'] ?? '');
        validator($profile, ['phone' => ['required', 'regex:/^09\d{9}$/']])->validate();
        if ($toman < 0 || $toman > 1000000000000) {
            $this->fail('invalid-amount');
        }

        return DB::transaction(function () use ($profile, $toman, $key, $adminId) {
            $existing = app(CreditTransactionRepository::class)->findOneByField('idempotency_key', 'admin:'.$key);
            if ($existing) {
                $account = $this->find($existing->credit_account_id);
                if ($account->phone !== $profile['phone'] || $existing->amount_rial !== $toman * 10) {
                    $this->fail('duplicate-request');
                }

                return $account;
            }

            if ($this->findOneByField('phone', $profile['phone'])) {
                $this->fail('phone-exists');
            }

            $account = $this->create($profile);
            $this->postLocked($account, $toman * 10, 'admin:'.$key, $toman ? 'manual_credit' : 'profile', trans('customer::credit.opening'), $adminId);

            return $account;
        }, 3);
    }

    public function adjust(int $id, int $toman, string $direction, string $key, string $reason, ?string $reference, int $adminId)
    {
        if ($toman < 1 || $toman > 1000000000000 || ! in_array($direction, ['increase', 'decrease'])) {
            $this->fail('invalid-amount');
        }

        return DB::transaction(function () use ($id, $toman, $direction, $key, $reason, $reference, $adminId) {
            $account = $this->getModel()->newQuery()->lockForUpdate()->findOrFail($id);

            return $this->postLocked($account, $toman * 10 * ($direction === 'increase' ? 1 : -1), 'admin:'.$key, $direction === 'increase' ? 'manual_credit' : 'manual_debit', $reason, $adminId, ['reference' => $reference]);
        }, 3);
    }

    public function profile(int $id, array $profile, int $adminId): void
    {
        DB::transaction(function () use ($id, $profile, $adminId) {
            $account = $this->getModel()->newQuery()->lockForUpdate()->findOrFail($id);
            $before = $account->only(['holder_name', 'is_active', 'iban_last_four']);
            $account->fill($profile)->save();
            $this->postLocked($account, 0, 'profile:'.Str::uuid(), 'profile', trans('customer::credit.profile-updated'), $adminId, ['metadata' => ['before' => $before, 'after' => $account->only(array_keys($before))]]);
        });
    }

    public function forCustomer($customer)
    {
        if (! $customer || ! $customer->status || $customer->is_suspended || ! $customer->credit_phone_verified_at) {
            return null;
        }

        $phone = CreditIdentity::phone((string) $customer->phone);
        if (! preg_match('/^09\d{9}$/', $phone) || $phone !== $customer->credit_verified_phone) {
            return null;
        }

        return DB::transaction(function () use ($customer, $phone) {
            $account = $this->getModel()->newQuery()->where('phone', $phone)->lockForUpdate()->first();
            if (! $account || ($account->customer_id && $account->customer_id !== $customer->id)) {
                return null;
            }

            if (! $account->customer_id) {
                if ($this->getModel()->newQuery()->where('customer_id', $customer->id)->whereKeyNot($account->id)->exists()) {
                    return null;
                }
                $account->update(['customer_id' => $customer->id]);
                $this->postLocked($account, 0, 'claim:'.$account->id.':'.$customer->id, 'claim', trans('customer::credit.claimed'), null);
            }

            return $account;
        });
    }

    public function chargeOrder($order): void
    {
        if ($order->payment->method !== 'customer_credit') {
            return;
        }

        $customer = auth()->guard('customer')->user();
        if (! $customer || $order->customer_id !== $customer->id) {
            $this->fail('verify-phone');
        }

        $account = $this->forCustomer($customer);
        if (! $account) {
            $this->fail('verify-phone');
        }

        DB::transaction(function () use ($order, $account) {
            $account = $this->getModel()->newQuery()->lockForUpdate()->findOrFail($account->id);
            if (! $account->is_active) {
                $this->fail('frozen');
            }
            $amount = CreditIdentity::orderRial($order->base_grand_total, $order->base_currency_code);
            if ($amount <= 0 || ! $order->cart_id) {
                $this->fail('invalid-amount');
            }
            $this->postLocked($account, -$amount, 'order:'.$order->id.':charge', 'purchase', trans('customer::credit.order-charge', ['order' => $order->increment_id]), null, ['order_id' => $order->id, 'cart_id' => $order->cart_id]);
        });
    }

    public function returnOrderCredit($order, int $amountRial, string $key, string $kind, ?int $refundId = null): void
    {
        $entries = app(CreditTransactionRepository::class)->getModel();
        $charge = $entries->newQuery()->where('order_id', $order->id)->where('kind', 'purchase')->first();
        if (! $charge) {
            return;
        }

        DB::transaction(function () use ($order, $amountRial, $key, $kind, $refundId, $entries, $charge) {
            $account = $this->getModel()->newQuery()->lockForUpdate()->findOrFail($charge->credit_account_id);
            if ($entries->newQuery()->where('idempotency_key', $key)->exists()) {
                return;
            }
            $returned = (int) $entries->newQuery()->where('order_id', $order->id)->whereIn('kind', ['refund', 'cancel'])->sum('amount_rial');
            $amount = min($amountRial, -$charge->amount_rial - $returned);
            if ($amount > 0) {
                $this->postLocked($account, $amount, $key, $kind, trans('customer::credit.order-return', ['order' => $order->increment_id]), auth()->guard('admin')->id(), ['order_id' => $order->id, 'refund_id' => $refundId]);
            }
        });
    }

    private function postLocked($account, int $amount, string $key, string $kind, string $reason, ?int $adminId, array $extra = [])
    {
        $repository = app(CreditTransactionRepository::class);
        $existing = $repository->findOneByField('idempotency_key', $key);
        if ($existing) {
            if ($existing->credit_account_id !== $account->id || $existing->amount_rial !== $amount || $existing->kind !== $kind) {
                $this->fail('duplicate-request');
            }

            return $existing;
        }

        $balance = $account->balance_rial + $amount;
        if ($balance < 0) {
            $this->fail('insufficient');
        }
        if ($balance > 100000000000000) {
            $this->fail('invalid-amount');
        }
        $account->forceFill(['balance_rial' => $balance])->save();

        return $repository->create(array_merge($extra, [
            'credit_account_id' => $account->id,
            'amount_rial' => $amount,
            'balance_after_rial' => $balance,
            'idempotency_key' => $key,
            'kind' => $kind,
            'reason' => $reason,
            'admin_id' => $adminId,
        ]));
    }

    private function fail(string $key): never
    {
        throw ValidationException::withMessages(['credit' => trans('customer::credit.'.$key)]);
    }
}
