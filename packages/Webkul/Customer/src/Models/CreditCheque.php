<?php

namespace Webkul\Customer\Models;

use Illuminate\Database\Eloquent\Model;
use Webkul\Customer\Contracts\CreditCheque as CreditChequeContract;

class CreditCheque extends Model implements CreditChequeContract
{
    protected $table = 'customer_credit_cheques';

    protected $guarded = ['id'];

    protected $casts = ['reference' => 'encrypted', 'sayad_id' => 'encrypted', 'due_date' => 'date', 'sayad_confirmed' => 'boolean', 'amount_toman' => 'integer', 'allocated_toman' => 'integer', 'allocated_at' => 'datetime', 'history' => 'array', 'document' => 'array'];

    public function customer()
    {
        return $this->belongsTo(CustomerProxy::modelClass());
    }
}
