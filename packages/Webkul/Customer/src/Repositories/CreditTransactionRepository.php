<?php

namespace Webkul\Customer\Repositories;

use Webkul\Core\Eloquent\Repository;
use Webkul\Customer\Contracts\CreditTransaction;

class CreditTransactionRepository extends Repository
{
    public function model(): string
    {
        return CreditTransaction::class;
    }
}
