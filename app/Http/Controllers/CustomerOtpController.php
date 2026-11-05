<?php

namespace App\Http\Controllers;

use App\Services\CustomerOtpSms;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use RuntimeException;
use Webkul\Customer\Models\Customer;

class CustomerOtpController extends Controller
{
    public function send(Request $request): JsonResponse|RedirectResponse
    {
        $phone = $this->normalizePhone($request->input('phone', ''));
        if ($request->boolean('credit_verification') && auth()->guard('customer')->check()) {
            $phone = $this->normalizePhone((string) auth()->guard('customer')->user()->phone);
        }

        if (! preg_match('/^09\d{9}$/', $phone)) {
            return $this->errorResponse($request, 'شماره موبایل باید با ۰۹ شروع شود و ۱۱ رقم باشد.', 422);
        }

        $code = (string) random_int(100000, 999999);
        $key = $this->cacheKey($phone);

        try {
            $testing = app(CustomerOtpSms::class)->send($phone, $code);
        } catch (ConnectionException|RuntimeException $exception) {
            Cache::forget($key);
            Cache::forget($key.':attempts');
            Cache::forget($key.':testing');

            return $this->errorResponse($request, 'ارسال پیامک ناموفق بود؛ تنظیمات پیامک را بررسی کنید یا چند لحظه دیگر تلاش کنید.', 502);
        }

        Cache::put($key, Hash::make($code), now()->addMinutes(2));
        Cache::put($key.':attempts', 0, now()->addMinutes(2));
        Cache::put($key.':testing', $testing, now()->addMinutes(2));

        $payload = [
            'message' => $testing ? 'حالت آزمایشی فعال است؛ پیامک واقعی ارسال نشد.' : 'کد ورود ارسال شد.',
            'expires_in' => 120,
            'debug_code' => $testing ? $code : null,
        ];

        if ($request->expectsJson()) {
            return response()->json($payload);
        }

        return redirect()
            ->route($request->boolean('credit_verification') && auth()->guard('customer')->check() ? 'shop.customers.account.credit.verify' : 'shop.customer.session.index', array_filter(['redirect_to' => $request->input('redirect_to')]))
            ->with('otp_sent', true)
            ->with('otp_phone', $phone)
            ->with('otp_message', $payload['message'])
            ->with('otp_debug_code', $payload['debug_code']);
    }

    public function verify(Request $request): JsonResponse|RedirectResponse
    {
        $phone = $this->normalizePhone($request->input('phone', ''));
        if ($request->boolean('credit_verification') && auth()->guard('customer')->check()) {
            $phone = $this->normalizePhone((string) auth()->guard('customer')->user()->phone);
        }
        $code = $this->normalizeDigits($request->input('code', ''));
        $key = $this->cacheKey($phone);

        if (! preg_match('/^09\d{9}$/', $phone) || ! preg_match('/^\d{6}$/', $code)) {
            return $this->verificationErrorResponse($request, $phone, 'شماره موبایل یا کد ورود معتبر نیست.');
        }

        $attempts = (int) Cache::increment($key.':attempts');
        $hashedCode = Cache::get($key);
        $testing = Cache::get($key.':testing');

        if (
            $attempts > 5 || ! $hashedCode || ! Hash::check($code, $hashedCode)
            || ($testing !== null && $testing !== app(CustomerOtpSms::class)->isTesting())
        ) {
            return $this->verificationErrorResponse($request, $phone, 'کد ورود اشتباه یا منقضی شده است.');
        }

        Cache::forget($key);
        Cache::forget($key.':attempts');
        Cache::forget($key.':testing');

        $customer = $request->boolean('credit_verification') && auth()->guard('customer')->check()
            ? auth()->guard('customer')->user()
            : Customer::query()->whereIn('phone', [$phone, '98'.substr($phone, 1), '+98'.substr($phone, 1), '0098'.substr($phone, 1)])->first();

        if (! $customer) {
            $customer = Customer::query()->create([
                'first_name' => 'کاربر',
                'last_name' => mb_substr($phone, -4),
                'phone' => $phone,
                'password' => Hash::make(Str::random(40)),
                'customer_group_id' => 2,
                'channel_id' => core()->getCurrentChannel()->id,
                'status' => 1,
                'is_verified' => 1,
            ]);
        }

        if (! $customer->status || $customer->is_suspended) {
            return $this->errorResponse($request, 'حساب شما غیرفعال است؛ با پشتیبانی تماس بگیرید.', 403);
        }

        $customer->forceFill(['credit_verified_phone' => $phone, 'credit_phone_verified_at' => now()])->save();

        auth()->guard('customer')->login($customer, true);
        $request->session()->regenerate();
        Event::dispatch('customer.after.login', $customer);

        $payload = [
            'message' => 'ورود با موفقیت انجام شد.',
            'redirect' => $this->safeRedirect($request->input('redirect_to')),
        ];

        if ($request->expectsJson()) {
            return response()->json($payload);
        }

        return redirect()->to($payload['redirect']);
    }

    private function errorResponse(Request $request, string $message, int $status): JsonResponse|RedirectResponse
    {
        if ($request->expectsJson()) {
            return response()->json(['message' => $message], $status);
        }

        return redirect()->back()->withInput()->with('otp_error', $message);
    }

    private function verificationErrorResponse(Request $request, string $phone, string $message): JsonResponse|RedirectResponse
    {
        if ($request->expectsJson()) {
            return response()->json(['message' => $message], 422);
        }

        return redirect()
            ->route($request->boolean('credit_verification') && auth()->guard('customer')->check() ? 'shop.customers.account.credit.verify' : 'shop.customer.session.index', array_filter(['redirect_to' => $request->input('redirect_to')]))
            ->with('otp_sent', true)
            ->with('otp_phone', $phone)
            ->with('otp_error', $message);
    }

    private function safeRedirect(?string $redirect): string
    {
        if ($redirect && str_starts_with($redirect, '/') && ! str_starts_with($redirect, '//')) {
            return url($redirect);
        }

        return route('shop.home.index');
    }

    private function normalizePhone(string $phone): string
    {
        $phone = preg_replace('/\D+/', '', $this->normalizeDigits($phone));

        if (str_starts_with($phone, '98')) {
            $phone = '0'.substr($phone, 2);
        }

        return $phone;
    }

    private function normalizeDigits(string $value): string
    {
        return strtr($value, ['۰' => '0', '۱' => '1', '۲' => '2', '۳' => '3', '۴' => '4', '۵' => '5', '۶' => '6', '۷' => '7', '۸' => '8', '۹' => '9', '٠' => '0', '١' => '1', '٢' => '2', '٣' => '3', '٤' => '4', '٥' => '5', '٦' => '6', '٧' => '7', '٨' => '8', '٩' => '9']);
    }

    private function cacheKey(string $phone): string
    {
        return 'customer-otp:'.$phone;
    }
}
