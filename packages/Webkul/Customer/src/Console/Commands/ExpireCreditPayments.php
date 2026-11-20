<?php

namespace Webkul\Customer\Console\Commands;

use Illuminate\Console\Command;
use Webkul\Sales\Repositories\OrderRepository;
use Webkul\Shop\Http\Controllers\Customer\Account\CreditPaymentController;

class ExpireCreditPayments extends Command
{
    protected $signature = 'credit:expire-payments';

    protected $description = 'Reconcile expired combined credit and gateway payments';

    public function handle(): int
    {
        $orders = app(OrderRepository::class)->getModel()->newQuery()->where('status', 'pending')
            ->whereHas('payment', fn ($query) => $query->where('method', 'customer_credit')
                ->where('additional->credit_split->state', 'pending')
                ->where('additional->credit_split->expires_at', '<=', now()->toDateTimeString()))
            ->orderBy('id')->limit(100)->get();
        foreach ($orders as $order) {
            app(CreditPaymentController::class)->reconcileExpired($order);
        }

        return self::SUCCESS;
    }
}
