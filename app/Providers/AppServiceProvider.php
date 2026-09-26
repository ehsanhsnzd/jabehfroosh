<?php

namespace App\Providers;

use App\ProductTypes\PackagingConfigurable;
use App\Repositories\PackagingProductRepository;
use App\Services\PackagingImporter;
use Barryvdh\Debugbar\Facades\Debugbar;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\ParallelTesting;
use Illuminate\Support\Facades\Request;
use Illuminate\Support\ServiceProvider;
use Webkul\DataTransfer\Helpers\Importers\Product\Importer;
use Webkul\Product\Repositories\ProductRepository;
use Webkul\Product\Type\Configurable;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->bind(Importer::class, PackagingImporter::class);
        $this->app->bind(ProductRepository::class, PackagingProductRepository::class);
        $this->app->bind(Configurable::class, PackagingConfigurable::class);

        $allowedIPs = array_map('trim', explode(',', config('app.debug_allowed_ips', '')));

        $allowedIPs = array_filter($allowedIPs);

        if (empty($allowedIPs)) {
            return;
        }

        if (in_array(Request::ip(), $allowedIPs)) {
            Debugbar::enable();
        } else {
            Debugbar::disable();
        }
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        ParallelTesting::setUpTestDatabase(function (string $database, int $token) {
            Artisan::call('db:seed');
        });
    }
}
