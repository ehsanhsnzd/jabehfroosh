<?php

namespace Webkul\Customer\Payment;

use Webkul\Customer\Helpers\CreditIdentity;
use Webkul\Customer\Helpers\CreditSplitCheckout;
use Webkul\Customer\Repositories\CreditAccountRepository;
use Webkul\Payment\Payment\Payment;

class CustomerCredit extends Payment
{
    protected $code = 'customer_credit';

    public function isAvailable()
    {
        $cart = $this->getCart();
        $customer = auth()->guard('customer')->user();
        if (! $cart || ! $customer || $cart->customer_id !== $customer->id) {
            return false;
        }
        $account = app(CreditAccountRepository::class)->forCustomer($customer);
        try {
            $amount = CreditIdentity::orderRial($cart->base_grand_total, $cart->base_currency_code);
        } catch (\InvalidArgumentException) {
            return false;
        }

        $available = $account ? app(CreditAccountRepository::class)->availableBalance($account) : 0;

        return $account && $account->is_active && $amount > 0 && intdiv($available, CreditIdentity::orderRial(1, $cart->base_currency_code)) > 0 && ($available >= $amount || CreditSplitCheckout::gatewayAvailable());
    }

    public function getTitle()
    {
        return trans('customer::credit.pay-with-credit');
    }

    public function getDescription()
    {
        $account = app(CreditAccountRepository::class)->forCustomer(auth()->guard('customer')->user());

        return trans('customer::credit.balance').': '.CreditIdentity::toman($account?->balance_rial ?? 0).' '.trans('customer::credit.toman');
    }

    public function getImage()
    {
        return bagisto_asset('images/money-transfer.png', 'shop');
    }

    public function getSortOrder()
    {
        return 0;
    }

    public function getRedirectUrl()
    {
        $cart = $this->getCart();
        $account = app(CreditAccountRepository::class)->forCustomer(auth()->guard('customer')->user());
        if ($cart && $account && app(CreditAccountRepository::class)->availableBalance($account) < CreditIdentity::orderRial($cart->base_grand_total, $cart->base_currency_code)) {
            return route('shop.customers.account.credit.payment.redirect');
        }
    }
}
