<?php

namespace Webkul\Customer\Helpers;

use Webkul\Customer\Payment\CustomerCredit;
use Webkul\Customer\Repositories\CreditAccountRepository;

class CreditSummary
{
    public static function forCart($cart): array
    {
        $customer = auth()->guard('customer')->user();
        $account = $customer ? app(CreditAccountRepository::class)->forCustomer($customer) : null;

        $available = $account ? app(CreditAccountRepository::class)->availableBalance($account) : 0;

        try {
            $total = CreditIdentity::orderRial($cart->base_grand_total, $cart->base_currency_code);
        } catch (\InvalidArgumentException) {
            $total = 0;
        }

        return [
            'authenticated' => (bool) $customer,
            'verified' => (bool) ($customer?->credit_phone_verified_at && $customer->credit_verified_phone === CreditIdentity::phone((string) $customer->phone)),
            'credit_used' => CreditIdentity::toman(min($available, $total)),
            'gateway_due' => CreditIdentity::toman(max(0, $total - $available)),
            'balance' => CreditIdentity::toman($account?->balance_rial ?? 0),
            'active' => $account?->is_active ?? true,
            'eligible' => $account && app(CustomerCredit::class)->isAvailable(),
            'history_url' => route('shop.customers.account.credit.index'),
            'verify_url' => route('shop.customers.account.credit.verify', ['redirect_to' => '/checkout/onepage']),
        ];
    }
}
