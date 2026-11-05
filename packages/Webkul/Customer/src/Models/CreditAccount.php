<?php

namespace Webkul\Customer\Models;

use Illuminate\Database\Eloquent\Model;
use Webkul\Customer\Contracts\CreditAccount as CreditAccountContract;

class CreditAccount extends Model implements CreditAccountContract
{
    protected $table = 'customer_credit_accounts';

    protected $fillable = ['phone', 'customer_id', 'holder_name', 'iban', 'iban_last_four', 'notes', 'is_active'];

    protected $casts = ['balance_rial' => 'integer', 'is_active' => 'boolean', 'iban' => 'encrypted'];

    protected $hidden = ['iban', 'notes'];

    public function customer()
    {
        return $this->belongsTo(CustomerProxy::modelClass());
    }

    public function transactions()
    {
        return $this->hasMany(CreditTransactionProxy::modelClass(), 'credit_account_id');
    }
}
