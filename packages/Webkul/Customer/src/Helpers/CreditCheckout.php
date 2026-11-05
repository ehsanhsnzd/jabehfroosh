<?php

namespace Webkul\Customer\Helpers;

use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Webkul\Checkout\Repositories\CartRepository;
use Webkul\Customer\Payment\CustomerCredit;
use Webkul\Sales\Repositories\OrderRepository;

class CreditCheckout
{
    public function place($cart, array $data)
    {
        return DB::transaction(function () use ($cart, $data) {
            $locked = app(CartRepository::class)->getModel()->newQuery()->lockForUpdate()->findOrFail($cart->id);
            $customer = auth()->guard('customer')->user();
            if (! $customer || $locked->customer_id !== $customer->id) {
                throw ValidationException::withMessages(['credit' => trans('customer::credit.verify-phone')]);
            }

            $existing = app(OrderRepository::class)->getModel()->newQuery()->where('cart_id', $locked->id)->first();
            if ($existing) {
                if ($existing->customer_id === $customer->id && $existing->payment->method === 'customer_credit') {
                    return $existing;
                }
                throw ValidationException::withMessages(['credit' => trans('customer::credit.duplicate-request')]);
            }

            if (! $locked->is_active || ! app(CustomerCredit::class)->isAvailable()) {
                throw ValidationException::withMessages(['credit' => trans('customer::credit.insufficient')]);
            }

            $order = app(OrderRepository::class)->create($data);
            $locked->update(['is_active' => false]);

            return $order;
        }, 3);
    }
}
