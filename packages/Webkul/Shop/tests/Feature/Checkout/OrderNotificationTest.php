<?php

use Illuminate\Support\Facades\Mail;
use Webkul\Sales\Models\Invoice;
use Webkul\Sales\Models\Order;
use Webkul\Sales\Models\OrderComment;
use Webkul\Sales\Models\Refund;
use Webkul\Sales\Models\Shipment;
use Webkul\Shop\Listeners\Base;
use Webkul\Shop\Mail\Order\CanceledNotification;
use Webkul\Shop\Mail\Order\CommentedNotification;
use Webkul\Shop\Mail\Order\CreatedNotification;
use Webkul\Shop\Mail\Order\InvoicedNotification;
use Webkul\Shop\Mail\Order\RefundedNotification;
use Webkul\Shop\Mail\Order\ShippedNotification;

function prepareOrderNotification($entity, $notification): bool
{
    return (new class extends Base
    {
        public function prepare($entity, $notification): bool
        {
            return $this->prepareMail($entity, $notification);
        }
    })->prepare($entity, $notification);
}

it('skips customer order emails without a valid recipient and queues valid recipients', function ($entityClass, $notificationClass, $email) {
    Mail::fake();
    $order = new Order(['customer_email' => $email]);
    $order->setRelation('items', collect());
    $entity = $entityClass === Order::class ? $order : (new $entityClass)->setRelation('order', $order);
    $entity->setRelation('items', collect());
    $notification = new $notificationClass($entity);

    $queued = prepareOrderNotification($entity, $notification);

    if ($email === 'customer@example.com') {
        expect($queued)->toBeTrue();
        Mail::assertQueued($notificationClass);
    } else {
        expect($queued)->toBeFalse();
        Mail::assertNothingQueued();
    }
})->with([
    [Order::class, CreatedNotification::class],
    [Order::class, CanceledNotification::class],
    [OrderComment::class, CommentedNotification::class],
    [Invoice::class, InvoicedNotification::class],
    [Shipment::class, ShippedNotification::class],
    [Refund::class, RefundedNotification::class],
])->with([null, '', 'invalid-email', 'customer@example.com']);

it('allows an explicit invoice recipient for a customer without email', function () {
    Mail::fake();
    $invoice = (new Invoice)->setRelation('order', new Order(['customer_email' => null]));
    $invoice->setRelation('items', collect());
    $notification = new InvoicedNotification($invoice, 'recipient@example.com');

    expect(prepareOrderNotification($invoice, $notification))->toBeTrue();
    Mail::assertQueued(InvoicedNotification::class);
    expect($notification->envelope()->to[0]->address)->toBe('recipient@example.com');
});
