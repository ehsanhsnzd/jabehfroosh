<?php

namespace Webkul\Customer\Helpers;

use Carbon\Carbon;
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
            ->whereHas('payment', fn ($q) => $q->where('method', '!=', 'customer_credit'))
            ->whereHas('invoices', fn ($q) => $q->where('state', 'paid'));
    }

    public function calculate($customer): array
    {
        $settings = PurchaseCreditSettings::all();
        $empty = ['ceiling' => 0, 'total' => 0, 'last_order_id' => null, 'last_paid_at' => null];
        if (! $settings['enabled'] || ! $customer->status || $customer->is_suspended) {
            return $empty;
        }
        $orders = $this->orders($customer->id)->with(['invoices' => fn ($q) => $q->where('state', 'paid')])->get();
        $purchases = [];
        foreach ($orders as $order) {
            // Only a fully paid invoice balance qualifies; pending transfers do not.
            $paid = (float) $order->invoices->sum('base_grand_total');
            if ($paid + 0.0001 < (float) $order->base_grand_total || $paid <= 0) {
                continue;
            }
            try {
                $rial = CreditIdentity::orderRial($order->base_grand_total, $order->base_currency_code);
            } catch (\InvalidArgumentException) {
                continue;
            }
            $date = $order->invoices->map(fn ($invoice) => Carbon::parse($invoice->purchase_credit_paid_at ?? $invoice->created_at))->max();
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
        $ceiling = min(1000000000000, intdiv($scaled, PurchaseCreditSettings::STEP) * PurchaseCreditSettings::STEP);

        return ['ceiling' => $ceiling, 'total' => intdiv($rial, 10), 'last_order_id' => $last['id'], 'last_paid_at' => $last['date']];
    }
}
