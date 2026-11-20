<?php

namespace Webkul\Customer\Jobs;

use App\Services\CustomerOtpSms;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Webkul\Customer\Helpers\CreditIdentity;
use Webkul\Customer\Helpers\PurchaseCreditEligibility;
use Webkul\Customer\Helpers\PurchaseCreditSettings;
use Webkul\Customer\Helpers\PurchaseCreditWorkflow;
use Webkul\Customer\Repositories\CustomerRepository;
use Webkul\Customer\Repositories\PurchaseCreditNoticeRepository;
use Webkul\Sales\Repositories\InvoiceRepository;
use Webkul\Sales\Repositories\OrderRepository;

class SendPurchaseCreditNotice implements ShouldBeUnique, ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $tries = 1;

    public int $timeout = 30;

    public int $uniqueFor = 3600;

    public function __construct(public int $customerId) {}

    public function uniqueId(): string
    {
        return 'purchase-credit:'.$this->customerId;
    }

    public function handle(): void
    {
        $settings = PurchaseCreditSettings::all();
        $customer = app(CustomerRepository::class)->getModel()->newQuery()->find($this->customerId);
        if (! $settings['enabled'] || ! $customer || ! app(PurchaseCreditWorkflow::class)->verified($customer)) {
            return;
        }
        $eligibility = app(PurchaseCreditEligibility::class)->calculate($customer);
        if ($eligibility['ceiling'] < $settings['minimum_amount']) {
            return;
        }
        $phone = CreditIdentity::phone((string) $customer->phone);
        $notices = app(PurchaseCreditNoticeRepository::class);
        $prefix = $settings['sms_testing'] ? 'test:' : '';
        $offerKey = $prefix.'offer:'.$customer->id.':'.$eligibility['last_order_id'];
        $kind = 'offer';
        $key = $offerKey;
        if ($notices->findOneByField('delivery_key', $offerKey)) {
            $interval = max(1, (int) $settings['reminder_days']);
            $limit = max(0, (int) $settings['reminder_limit']);
            if (! $settings['marketing_enabled'] || ! $limit || $customer->credit_marketing_opt_out) {
                return;
            }
            $lastPaid = app(OrderRepository::class)->getModel()->newQuery()->where('customer_id', $customer->id)
                ->whereHas('payment', fn ($q) => PurchaseCreditEligibility::qualifyingPayment($q))
                ->whereHas('invoices', fn ($q) => $q->where('state', 'paid'))
                ->addSelect(['paid_time' => app(InvoiceRepository::class)->getModel()->newQuery()
                    ->selectRaw('MAX(COALESCE(purchase_credit_paid_at, created_at))')
                    ->whereColumn('order_id', 'orders.id')->where('state', 'paid')])
                ->orderByDesc('paid_time')->first();
            if ($lastPaid?->id !== $eligibility['last_order_id']) {
                return;
            }
            $days = (int) $eligibility['last_paid_at']->diffInDays(now(), false);
            if ($days < $interval) {
                return;
            }
            $deliveryStates = $settings['sms_testing'] ? ['tested'] : ['sent', 'sending', 'uncertain'];
            $reminderCount = $notices->getModel()->newQuery()->where('customer_id', $customer->id)
                ->where('order_id', $eligibility['last_order_id'])->where('kind', 'marketing')
                ->whereIn('status', $deliveryStates)->count();
            if ($reminderCount >= $limit) {
                return;
            }
            $kind = 'marketing';
            $key = $prefix.'marketing:'.$customer->id.':'.$eligibility['last_order_id'].':reminder:'.($reminderCount + 1);
            if ($notices->getModel()->newQuery()->where('customer_id', $customer->id)
                ->whereIn('status', $deliveryStates)
                ->where('created_at', '>', now()->subDays($interval))->exists()) {
                return;
            }
        }
        $message = strtr((string) $settings[$kind === 'offer' ? 'offer_text' : 'marketing_text'], [
            '{name}' => $customer->name, '{amount}' => strtr(number_format($eligibility['ceiling']), array_combine(str_split('0123456789'), preg_split('//u', '۰۱۲۳۴۵۶۷۸۹', -1, PREG_SPLIT_NO_EMPTY))),
            '{link}' => trim((string) $settings['sms_link']) ?: route('shop.credit.short'),
        ]);
        // Reserve before sending. An ambiguous failure is never retried automatically.
        $inserted = $notices->getModel()->newQuery()->insertOrIgnore([
            'customer_id' => $customer->id, 'delivery_key' => $key, 'kind' => $kind,
            'status' => $settings['sms_testing'] ? 'tested' : 'sending',
            'amount_toman' => $eligibility['ceiling'], 'order_id' => $eligibility['last_order_id'],
            'phone' => $phone, 'message' => $message, 'created_at' => now(), 'updated_at' => now(),
        ]);
        if (! $inserted || $settings['sms_testing']) {
            return;
        }
        $notice = $notices->findOneByField('delivery_key', $key);
        try {
            app(CustomerOtpSms::class)->sendVipMessage($phone, $message);
            $notice->update(['status' => 'sent', 'sent_at' => now()]);
        } catch (\Throwable $exception) {
            $notice->update(['status' => 'uncertain', 'error' => 'delivery_failed']);
        }
    }
}
