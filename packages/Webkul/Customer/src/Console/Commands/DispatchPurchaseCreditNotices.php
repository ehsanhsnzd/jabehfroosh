<?php

namespace Webkul\Customer\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Cache;
use Webkul\Customer\Helpers\PurchaseCreditEligibility;
use Webkul\Customer\Helpers\PurchaseCreditSettings;
use Webkul\Customer\Jobs\SendPurchaseCreditNotice;
use Webkul\Customer\Repositories\CustomerRepository;
use Webkul\Sales\Repositories\InvoiceRepository;
use Webkul\Sales\Repositories\OrderRepository;

class DispatchPurchaseCreditNotices extends Command
{
    protected $signature = 'credit:dispatch-notices {--now : Ignore the configured sending hour}';

    protected $description = 'Queue one purchase-credit eligibility and SMS job per customer';

    public function handle(): int
    {
        $settings = PurchaseCreditSettings::all();
        if (! $settings['enabled'] || (! $this->option('now') && (int) now('Asia/Tehran')->format('G') !== (int) $settings['send_hour'])) {
            return self::SUCCESS;
        }
        if (! $this->option('now') && ! Cache::add('purchase-credit-dispatch:'.now('Asia/Tehran')->format('YmdH'), true, 7200)) {
            return self::SUCCESS;
        }
        $count = 0;
        $paidInvoices = app(InvoiceRepository::class)->getModel()->newQuery()
            ->where('state', 'paid')->select('order_id')
            ->selectRaw('MAX(COALESCE(purchase_credit_paid_at, created_at)) AS paid_at, SUM(base_grand_total) AS paid_total')
            ->groupBy('order_id');
        $allocations = PurchaseCreditEligibility::allocationDates();
        $purchases = app(OrderRepository::class)->getModel()->newQuery()
            ->joinSub($paidInvoices, 'paid_purchases', fn ($join) => $join->on('paid_purchases.order_id', '=', 'orders.id'))
            ->leftJoinSub($allocations, 'allocations', fn ($join) => $join->on('allocations.customer_id', '=', 'orders.customer_id'))
            ->where(fn ($query) => $query->whereNull('allocations.allocated_at')->orWhereColumn('paid_purchases.paid_at', '>', 'allocations.allocated_at'))
            ->whereRaw('paid_purchases.paid_total + 0.0001 >= orders.base_grand_total')
            ->where('paid_purchases.paid_total', '>', 0)
            ->whereIn('orders.base_currency_code', ['IRR', 'IRT', 'TOMAN', 'TMN'])
            ->whereIn('orders.status', ['processing', 'completed'])
            ->where('orders.base_grand_total_refunded', '<=', 0)->whereDoesntHave('refunds')
            ->join('order_payment as qualifying_payment', 'qualifying_payment.order_id', '=', 'orders.id');
        PurchaseCreditEligibility::qualifyingPayment($purchases, 'qualifying_payment.');
        $latestPurchases = (clone $purchases)->select('orders.customer_id')
            ->selectRaw('MAX(paid_purchases.paid_at) AS last_paid_at')->groupBy('orders.customer_id');
        $eligibleCustomers = (clone $purchases)->select('orders.customer_id')
            ->joinSub($latestPurchases, 'last_purchase', fn ($join) => $join->on('last_purchase.customer_id', '=', 'orders.customer_id'))
            ->whereRaw('paid_purchases.paid_at >= DATE_SUB(last_purchase.last_paid_at, INTERVAL ? MONTH)', [(int) $settings['months']])
            ->groupBy('orders.customer_id')
            ->havingRaw("SUM((CASE WHEN qualifying_payment.method = 'customer_credit' THEN LEAST(orders.base_grand_total, GREATEST(0, CAST(JSON_UNQUOTE(JSON_EXTRACT(qualifying_payment.additional, '$.credit_split.gateway_amount')) AS DECIMAL(20,4)))) ELSE orders.base_grand_total END) / (CASE WHEN orders.base_currency_code = 'IRR' THEN 10 ELSE 1 END)) > ?", [$settings['minimum_amount']]);

        app(CustomerRepository::class)->getModel()->newQuery()
            ->where('status', 1)->where('is_suspended', 0)->whereNotNull('credit_phone_verified_at')
            ->whereIn('customers.id', $eligibleCustomers)
            ->chunkById(200, function ($customers) use (&$count) {
                foreach ($customers as $customer) {
                    SendPurchaseCreditNotice::dispatch($customer->id)->onConnection('database')->onQueue('purchase-credit')->afterCommit();
                    $count++;
                }
            });
        $this->info('Queued customers: '.$count);

        return self::SUCCESS;
    }
}
