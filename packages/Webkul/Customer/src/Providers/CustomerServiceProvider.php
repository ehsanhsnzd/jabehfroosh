<?php

namespace Webkul\Customer\Providers;

use Illuminate\Support\ServiceProvider;
use Webkul\Customer\Console\Commands\DispatchPurchaseCreditNotices;
use Webkul\Customer\Facades\Captcha;
use Webkul\Customer\Observers\PurchaseCreditInvoiceObserver;
use Webkul\Sales\Models\InvoiceProxy;

class CustomerServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap application services.
     */
    public function boot(): void
    {
        $this->commands([DispatchPurchaseCreditNotices::class]);
        InvoiceProxy::observe(PurchaseCreditInvoiceObserver::class);
        $this->loadMigrationsFrom(__DIR__.'/../Database/Migrations');

        $this->loadTranslationsFrom(__DIR__.'/../Resources/lang', 'customer');

        $this->loadViewsFrom(__DIR__.'/../Resources/views', 'customer');

        $this->app['validator']->extend('captcha', function ($attribute, $value, $parameters) {
            return Captcha::getFacadeRoot()->validateResponse($value);
        });
    }
}
