<?php

namespace Webkul\Customer\Listeners;

use Webkul\Customer\Helpers\CreditIdentity;
use Webkul\Customer\Repositories\CreditAccountRepository;
use Webkul\Sales\Models\Order;
use Webkul\Sales\Repositories\InvoiceRepository;

class CustomerCredit
{
    public function login($customer = null): void
    {
        app(CreditAccountRepository::class)->forCustomer($customer ?? auth()->guard('customer')->user());
    }

    public function orderCreated($order): void
    {
        if ($order->payment->method !== 'customer_credit') {
            return;
        }
        app(CreditAccountRepository::class)->chargeOrder($order);
        if (! $order->invoices()->exists()) {
            $items = $order->items->mapWithKeys(fn ($item) => [$item->id => $item->qty_to_invoice])->filter()->all();
            if ($items) {
                app(InvoiceRepository::class)->create(['order_id' => $order->id, 'invoice' => ['items' => $items]], 'paid');
            }
        }
    }

    public function canceled($order): void
    {
        if ($order->payment->method !== 'customer_credit' || $order->status !== Order::STATUS_CANCELED) {
            return;
        }
        app(CreditAccountRepository::class)->returnOrderCredit($order, PHP_INT_MAX, 'order:'.$order->id.':cancel', 'cancel');
    }

    public function refunded($refund): void
    {
        $order = $refund->order;
        if ($order->payment->method !== 'customer_credit') {
            return;
        }
        app(CreditAccountRepository::class)->returnOrderCredit($order, CreditIdentity::orderRial($refund->base_grand_total, $order->base_currency_code), 'refund:'.$refund->id, 'refund', $refund->id);
    }
}
