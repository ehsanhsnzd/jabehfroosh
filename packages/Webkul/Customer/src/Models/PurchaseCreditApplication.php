<?php

namespace Webkul\Customer\Models;

use Illuminate\Database\Eloquent\Model;
use Webkul\Customer\Contracts\PurchaseCreditApplication as PurchaseCreditApplicationContract;
use Webkul\Customer\Helpers\PurchaseCreditWorkflow;

class PurchaseCreditApplication extends Model implements PurchaseCreditApplicationContract
{
    protected $table = 'purchase_credit_applications';

    protected $guarded = ['id'];

    protected $casts = ['monthly_deduction_percent' => 'integer', 'amount_is_net' => 'boolean', 'repayment_months' => 'integer', 'documents' => 'array', 'history' => 'array', 'requested_toman' => 'integer', 'ceiling_toman' => 'integer', 'approved_toman' => 'integer', 'activated_at' => 'datetime', 'cheque_reference' => 'encrypted', 'identity_bypassed' => 'boolean', 'identity_approved_at' => 'datetime', 'cheque_approved_at' => 'datetime'];

    public function netAmount(): int
    {
        return $this->amount_is_net ? $this->requested_toman : PurchaseCreditWorkflow::netAmount($this->requested_toman, $this->repayment_months ?? 1, $this->monthly_deduction_percent ?? 10);
    }

    public function deductionPercent(): int
    {
        return min(100, (($this->repayment_months ?? 1) - 1) * ($this->monthly_deduction_percent ?? 10));
    }

    public function identityApproved(): bool
    {
        return $this->status !== 'rejected' && ($this->identity_bypassed || $this->identity_approved_at || in_array($this->status, ['cheque_pending', 'allocation_pending', 'active']));
    }

    public function chequeApproved(): bool
    {
        return $this->status !== 'rejected' && ($this->cheque_approved_at || in_array($this->status, ['allocation_pending', 'active']));
    }

    public function customer()
    {
        return $this->belongsTo(CustomerProxy::modelClass());
    }
}
