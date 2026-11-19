<?php

namespace Webkul\Customer\Repositories;

use Webkul\Core\Eloquent\Repository;
use Webkul\Customer\Contracts\PurchaseCreditApplication;

class PurchaseCreditApplicationRepository extends Repository
{
    protected function allowedCache($method)
    {
        return false;
    }

    public function model(): string
    {
        return PurchaseCreditApplication::class;
    }
}
