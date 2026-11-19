<?php

namespace Webkul\Customer\Models;

use Illuminate\Database\Eloquent\Model;
use Webkul\Customer\Contracts\PurchaseCreditApplication as PurchaseCreditApplicationContract;

class PurchaseCreditApplication extends Model implements PurchaseCreditApplicationContract
{
    protected $table = 'purchase_credit_applications';

    protected $guarded = ['id'];

    protected $casts = ['documents' => 'array', 'history' => 'array', 'requested_toman' => 'integer', 'ceiling_toman' => 'integer', 'approved_toman' => 'integer', 'activated_at' => 'datetime', 'cheque_reference' => 'encrypted', 'identity_bypassed' => 'boolean'];

    public function customer()
    {
        return $this->belongsTo(CustomerProxy::modelClass());
    }
}
