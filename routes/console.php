<?php

use App\Services\PackagingProducts;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Webkul\Product\Models\ProductProxy;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote')->hourly();

Artisan::command('products:convert-packaging', function (PackagingProducts $packaging) {
    $products = ProductProxy::query()->whereNull('parent_id')->orderBy('id')->get();

    if ($products->isEmpty()) {
        $this->info('No products need conversion or synchronization.');

        return self::SUCCESS;
    }

    $converted = 0;
    $synchronized = 0;
    $failed = [];

    $this->withProgressBar($products, function ($product) use ($packaging, &$converted, &$synchronized, &$failed) {
        try {
            if ($product->type === 'simple') {
                $converted += (int) $packaging->convert($product);
            } else {
                $synchronized += (int) $packaging->synchronize($product);
            }
        } catch (Throwable $exception) {
            $failed[] = "{$product->sku}: {$exception->getMessage()}";
        }
    });

    $this->newLine(2);
    $this->info("Converted {$converted} products to packaging configurables.");
    $this->info("Synchronized {$synchronized} existing packaging products.");

    foreach ($failed as $failure) {
        $this->error($failure);
    }

    return $failed === [] ? self::SUCCESS : self::FAILURE;
})->purpose('Convert all existing simple products to packaging configurables');
