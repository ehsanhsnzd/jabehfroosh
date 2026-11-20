<?php

namespace Webkul\Customer\Helpers;

use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Webkul\Customer\Repositories\CreditTransactionRepository;
use Webkul\Customer\Repositories\PurchaseCreditApplicationRepository;
use Webkul\Sales\Repositories\OrderRepository;

class PurchaseCreditEligibility
{
    public function orders(int $customerId)
    {
        return app(OrderRepository::class)->getModel()->newQuery()
            ->where('customer_id', $customerId)
            ->whereIn('status', ['processing', 'completed'])
            ->where('base_grand_total_refunded', '<=', 0)
            ->whereDoesntHave('refunds')
            ->whereHas('payment', fn ($q) => self::qualifyingPayment($q))
            ->whereHas('invoices', fn ($q) => $q->where('state', 'paid'));
    }

    public static function allocationDates()
    {
        $applications = app(PurchaseCreditApplicationRepository::class)->getModel()->newQuery()
            ->select('customer_id')->selectRaw('activated_at AS allocated_at')->whereNotNull('activated_at');
        $manual = app(CreditTransactionRepository::class)->getModel()->newQuery()
            ->join('customer_credit_accounts as grant_account', 'grant_account.id', '=', 'customer_credit_transactions.credit_account_id')
            ->where('customer_credit_transactions.kind', 'manual_credit')
            ->where('customer_credit_transactions.amount_rial', '>', 0)->whereNotNull('grant_account.customer_id')
            ->select('grant_account.customer_id')->selectRaw('customer_credit_transactions.created_at AS allocated_at');
        $grants = $applications->toBase()->unionAll($manual->toBase());

        return DB::query()->fromSub($grants, 'credit_allocations')->select('customer_id')
            ->selectRaw('MAX(allocated_at) AS allocated_at')->groupBy('customer_id');
    }

    public static function qualifyingPayment($query, string $prefix = '')
    {
        return $query->where(function ($query) use ($prefix) {
            $query->where($prefix.'method', '!=', 'customer_credit')
                ->orWhere(fn ($query) => $query->where($prefix.'method', 'customer_credit')
                    ->where($prefix.'additional->credit_split->state', 'paid')
                    ->where($prefix.'additional->credit_split->gateway_amount', '>', 0));
        });
    }

    public function calculate($customer): array
    {
        $settings = PurchaseCreditSettings::all();
        $empty = ['ceiling' => 0, 'total' => 0, 'last_order_id' => null, 'last_paid_at' => null];
        if (! $settings['enabled'] || ! $customer->status || $customer->is_suspended) {
            return $empty;
        }
        $allocatedAt = self::allocationDates()->where('customer_id', $customer->id)->first()?->allocated_at;
        $orders = $this->orders($customer->id)->with(['payment', 'invoices' => fn ($q) => $q->where('state', 'paid')])->get();
        $purchases = [];
        foreach ($orders as $order) {
            // Only a fully paid invoice balance qualifies; pending transfers do not.
            $paid = (float) $order->invoices->sum('base_grand_total');
            if ($paid + 0.0001 < (float) $order->base_grand_total || $paid <= 0) {
                continue;
            }
            try {
                $cash = $order->payment->method === 'customer_credit'
                    ? min((float) $order->base_grand_total, (float) data_get($order->payment->additional, 'credit_split.gateway_amount', 0))
                    : $order->base_grand_total;
                $rial = CreditIdentity::orderRial($cash, $order->base_currency_code);
            } catch (\InvalidArgumentException) {
                continue;
            }
            if ($rial <= 0) {
                continue;
            }
            $date = $order->invoices->map(fn ($invoice) => Carbon::parse($invoice->purchase_credit_paid_at ?? $invoice->created_at))->max();
            if ($allocatedAt && $date->lte(Carbon::parse($allocatedAt))) {
                continue;
            }
            $purchases[] = ['id' => $order->id, 'rial' => $rial, 'date' => $date];
        }
        if (! $purchases) {
            return $empty;
        }
        usort($purchases, fn ($a, $b) => $b['date'] <=> $a['date']);
        $last = $purchases[0];
        $from = $last['date']->copy()->subMonthsNoOverflow((int) $settings['months']);
        $rial = array_sum(array_map(fn ($p) => $p['date']->gte($from) ? $p['rial'] : 0, $purchases));
        // Fixed four-decimal factor arithmetic; amounts remain integer Rial/Toman.
        $factor = (int) round((float) $settings['factor'] * 10000);
        $toman = intdiv($rial, 10);
        $scaled = intdiv($toman, 10000) * $factor + intdiv(($toman % 10000) * $factor, 10000);
        $ceiling = min(1000000000000, intdiv($scaled, (int) $settings['amount_step']) * (int) $settings['amount_step']);

        return ['ceiling' => $ceiling, 'total' => intdiv($rial, 10), 'last_order_id' => $last['id'], 'last_paid_at' => $last['date']];
    }
}
