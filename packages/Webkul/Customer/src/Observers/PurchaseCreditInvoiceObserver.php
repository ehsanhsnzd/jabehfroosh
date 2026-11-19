<?php

namespace Webkul\Customer\Observers;

class PurchaseCreditInvoiceObserver
{
    public function saving($invoice): void
    {
        if ($invoice->state === 'paid' && $invoice->isDirty('state') && ($invoice->exists || ! $invoice->purchase_credit_paid_at)) {
            $invoice->purchase_credit_paid_at = now();
        }
    }
}
