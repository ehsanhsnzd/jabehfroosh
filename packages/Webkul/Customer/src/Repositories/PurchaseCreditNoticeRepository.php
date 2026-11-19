<?php

namespace Webkul\Customer\Repositories;

use Webkul\Core\Eloquent\Repository;
use Webkul\Customer\Contracts\PurchaseCreditNotice;

class PurchaseCreditNoticeRepository extends Repository
{
    protected function allowedCache($method)
    {
        return false;
    }

    public function model(): string
    {
        return PurchaseCreditNotice::class;
    }
}
