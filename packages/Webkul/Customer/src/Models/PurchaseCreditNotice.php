<?php

namespace Webkul\Customer\Models;

use Illuminate\Database\Eloquent\Model;
use Webkul\Customer\Contracts\PurchaseCreditNotice as PurchaseCreditNoticeContract;

class PurchaseCreditNotice extends Model implements PurchaseCreditNoticeContract
{
    protected $table = 'purchase_credit_notices';

    protected $guarded = ['id'];

    protected $casts = ['amount_toman' => 'integer', 'sent_at' => 'datetime'];

    public function customer()
    {
        return $this->belongsTo(CustomerProxy::modelClass());
    }
}
