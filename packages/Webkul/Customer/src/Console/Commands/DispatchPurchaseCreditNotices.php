<?php

namespace Webkul\Customer\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Cache;
use Webkul\Customer\Helpers\PurchaseCreditSettings;
use Webkul\Customer\Jobs\SendPurchaseCreditNotice;
use Webkul\Customer\Repositories\CustomerRepository;

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
        app(CustomerRepository::class)->getModel()->newQuery()
            ->where('status', 1)->where('is_suspended', 0)->whereNotNull('credit_phone_verified_at')
            ->whereHas('orders', fn ($q) => $q->whereIn('status', ['processing', 'completed'])
                ->where('base_grand_total_refunded', '<=', 0)->whereDoesntHave('refunds')
                ->whereHas('payment', fn ($payment) => $payment->where('method', '!=', 'customer_credit'))
                ->whereHas('invoices', fn ($invoice) => $invoice->where('state', 'paid')))
            ->whereNotExists(function ($query) {
                $query->selectRaw('1')->from('purchase_credit_applications')
                    ->whereColumn('purchase_credit_applications.customer_id', 'customers.id')->where('status', 'active');
            })
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
