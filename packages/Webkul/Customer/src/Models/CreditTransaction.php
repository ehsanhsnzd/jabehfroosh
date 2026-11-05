<?php

namespace Webkul\Customer\Models;

use Illuminate\Database\Eloquent\Model;
use Webkul\Customer\Contracts\CreditTransaction as CreditTransactionContract;
use Webkul\Sales\Models\OrderProxy;
use Webkul\User\Models\AdminProxy;

class CreditTransaction extends Model implements CreditTransactionContract
{
    public const UPDATED_AT = null;

    protected $table = 'customer_credit_transactions';

    protected $guarded = ['id'];

    protected $casts = ['amount_rial' => 'integer', 'balance_after_rial' => 'integer', 'metadata' => 'array'];

    protected static function booted(): void
    {
        static::updating(fn () => throw new \LogicException('Credit ledger entries are immutable.'));
        static::deleting(fn () => throw new \LogicException('Credit ledger entries are immutable.'));
    }

    public function account()
    {
        return $this->belongsTo(CreditAccountProxy::modelClass(), 'credit_account_id');
    }

    public function order()
    {
        return $this->belongsTo(OrderProxy::modelClass());
    }

    public function admin()
    {
        return $this->belongsTo(AdminProxy::modelClass());
    }
}
