<?php

namespace App\Repositories;

use App\Services\PackagingProducts;
use Illuminate\Support\Facades\DB;
use Webkul\Product\Repositories\ProductRepository;

class PackagingProductRepository extends ProductRepository
{
    public function create(array $data)
    {
        return DB::transaction(function () use ($data) {
            $data = app(PackagingProducts::class)->prepareCreation($data);

            return parent::create($data);
        });
    }
}
