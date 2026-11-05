<?php

namespace App\Providers;

use App\ProductTypes\PackagingSimple;
use Barryvdh\Debugbar\Facades\Debugbar;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\ParallelTesting;
use Illuminate\Support\Facades\Request;
use Illuminate\Support\ServiceProvider;
use Webkul\Customer\Payment\CustomerCredit;
use Webkul\Product\Type\Simple;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->bind(Simple::class, PackagingSimple::class);

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
        config(['payment_methods.customer_credit' => ['class' => CustomerCredit::class, 'code' => 'customer_credit']]);
        Event::listen('customer.after.login', [\Webkul\Customer\Listeners\CustomerCredit::class, 'login']);
        Event::listen('customer.registration.after', [\Webkul\Customer\Listeners\CustomerCredit::class, 'login']);
        Event::listen('checkout.order.save.after', [\Webkul\Customer\Listeners\CustomerCredit::class, 'orderCreated']);
        Event::listen('sales.order.cancel.after', [\Webkul\Customer\Listeners\CustomerCredit::class, 'canceled']);
        Event::listen('sales.refund.save.after', [\Webkul\Customer\Listeners\CustomerCredit::class, 'refunded']);

        Event::listen('checkout.cart.update.before', function ($item) {
            $type = $item->getTypeInstance();

            if ($type instanceof PackagingSimple) {
                $type->preparePackagingUpdate($item);
            }
        });

        ParallelTesting::setUpTestDatabase(function (string $database, int $token) {
            Artisan::call('db:seed');
        });
    }
}
