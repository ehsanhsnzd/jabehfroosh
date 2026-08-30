<?php

use App\Http\Controllers\BlogController;
use App\Http\Controllers\CustomerOtpController;
use Illuminate\Support\Facades\Route;
use Webkul\Core\Http\Middleware\PreventRequestsDuringMaintenance;

Route::middleware(['shop', PreventRequestsDuringMaintenance::class])->controller(BlogController::class)->group(function () {
    Route::get('/blog', 'index')->name('shop.blog.index');
    Route::get('/blog/{slug}', 'show')->name('shop.blog.show');
});

Route::middleware(['shop', PreventRequestsDuringMaintenance::class])->prefix('customer/login/otp')->group(function () {
    Route::post('send', [CustomerOtpController::class, 'send'])->middleware('throttle:5,1')->name('shop.customer.otp.send');
    Route::post('verify', [CustomerOtpController::class, 'verify'])->middleware('throttle:10,1')->name('shop.customer.otp.verify');
});
