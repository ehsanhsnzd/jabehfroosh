<?php

namespace Webkul\Shop\Http\Controllers\Customer\Account;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Webkul\Checkout\Facades\Cart;
use Webkul\Customer\Helpers\CreditSplitCheckout;
use Webkul\Sales\Repositories\OrderRepository;
use Webkul\Zarinpal\Http\Controllers\ZarinpalController;

class CreditPaymentController extends ZarinpalController
{
    public function redirect()
    {
        $order = null;
        try {
            $pending = session('credit_split_order_id');
            if ($pending) {
                $order = app(OrderRepository::class)->getModel()->newQuery()
                    ->where('customer_id', auth()->guard('customer')->id())->find($pending);
                if (data_get($order?->payment?->additional, 'credit_split.state') !== 'pending') {
                    $order = null;
                }
            }
            if (! $order) {
                Cart::collectTotals();
                $cart = Cart::getCart();
                abort_unless($cart && ! Cart::hasError(), 422);
                $order = app(CreditSplitCheckout::class)->reserve($cart);
                session(['credit_split_order_id' => $order->id]);
            }

            return Cache::lock('credit-gateway:'.$order->id, 60)->block(5, function () use ($order) {
                $split = $order->payment->fresh()->additional['credit_split'];
                if (now()->greaterThanOrEqualTo($split['expires_at'])) {
                    throw new \RuntimeException('Expired credit payment');
                }
                if (! empty($split['authority'])) {
                    return redirect()->away(rtrim($this->redirectUrl, '/').'/'.$split['authority']);
                }
                if (! $this->active || (! $this->isSandboxEnable && ! $this->merchantId)) {
                    throw new \RuntimeException('Inactive gateway');
                }
                $result = $this->client->post($this->requestUrl, [
                    'merchant_id' => $this->merchantId ?: '00000000-0000-0000-0000-000000000000',
                    'amount' => $split['gateway_amount'],
                    'currency' => strtoupper($order->base_currency_code) === 'IRR' ? 'IRR' : 'IRT',
                    'description' => 'Order #'.$order->increment_id,
                    'callback_url' => route('shop.customers.account.credit.payment.callback', ['order' => $order->id, 'token' => $split['token']]),
                ])->json();
                if ((int) data_get($result, 'data.code') !== 100 || ! is_string(data_get($result, 'data.authority')) || ! preg_match('/^[A-Za-z0-9_-]{1,100}$/', $result['data']['authority'])) {
                    throw new \RuntimeException('Gateway rejected the payment');
                }
                DB::transaction(function () use ($order, $result) {
                    $locked = app(OrderRepository::class)->getModel()->newQuery()->lockForUpdate()->findOrFail($order->id);
                    $split = $locked->payment->additional['credit_split'];
                    abort_unless($split['state'] === 'pending', 422);
                    $split['authority'] = $result['data']['authority'];
                    $locked->payment->update(['additional' => ['credit_split' => $split]]);
                });

                return redirect()->away(rtrim($this->redirectUrl, '/').'/'.$result['data']['authority']);
            });
        } catch (\Throwable $e) {
            report($e);
            if ($order) {
                if (data_get($order->payment->fresh()->additional, 'credit_split.authority')) {
                    $this->reconcileExpired($order->fresh());
                } else {
                    app(CreditSplitCheckout::class)->cancel($order->id);
                }
            }

            return redirect()->route('shop.checkout.onepage.index')->with('error', trans('customer::credit.splitFailed'));
        }
    }

    public function reconcileExpired($order): void
    {
        $split = $order->payment->additional['credit_split'] ?? [];
        $checkout = app(CreditSplitCheckout::class);
        if (empty($split['authority'])) {
            $checkout->cancel($order->id);

            return;
        }
        $code = null;
        try {
            $checkout->complete($order->id, $split['authority'], function ($payment) use (&$code) {
                $result = $this->client->post($this->verifyUrl, [
                    'merchant_id' => $this->merchantId ?: '00000000-0000-0000-0000-000000000000',
                    'amount' => $payment['gateway_amount'], 'authority' => $payment['authority'],
                ])->json() ?? [];
                $code = data_get($result, 'errors.code');

                return $result;
            });
        } catch (\Throwable $e) {
            if (in_array((int) $code, [-51, -54], true)) {
                $checkout->cancel($order->id);
            } else {
                report($e);
            }
        }
    }

    public function callback()
    {
        $order = app(OrderRepository::class)->getModel()->newQuery()->findOrFail(request()->integer('order'));
        abort_unless($order->customer_id === auth()->guard('customer')->id(), 404);
        $split = $order->payment->additional['credit_split'] ?? [];
        abort_unless(isset($split['token'], $split['authority']) && hash_equals($split['token'], (string) request('token')) && hash_equals($split['authority'], (string) request('Authority')), 403);
        $checkout = app(CreditSplitCheckout::class);
        if (request('Status') !== 'OK') {
            $checkout->cancel($order->id);

            return redirect()->route('shop.checkout.onepage.index')->with('error', trans('customer::credit.splitFailed'));
        }
        $verifyCode = null;
        try {
            $order = $checkout->complete($order->id, $split['authority'], function ($payment) use (&$verifyCode) {
                $result = $this->client->post($this->verifyUrl, [
                    'merchant_id' => $this->merchantId ?: '00000000-0000-0000-0000-000000000000',
                    'amount' => $payment['gateway_amount'], 'authority' => $payment['authority'],
                ])->json() ?? [];
                $verifyCode = data_get($result, 'errors.code');

                return $result;
            });
            session()->forget('credit_split_order_id');
            session()->flash('order_id', $order->id);

            return redirect()->route('shop.checkout.onepage.success');
        } catch (\Throwable $e) {
            if (in_array((int) $verifyCode, [-51, -54], true)) {
                $checkout->cancel($order->id);
            }
            // An unavailable verify endpoint is ambiguous: keep the reservation for a retry.
            report($e);

            return redirect()->route('shop.checkout.onepage.index')->with('error', trans('customer::credit.splitFailed'));
        }
    }
}
