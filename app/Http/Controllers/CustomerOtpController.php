<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Webkul\Customer\Models\Customer;

class CustomerOtpController extends Controller
{
    public function send(Request $request): JsonResponse|RedirectResponse
    {
        $phone = $this->normalizePhone($request->input('phone', ''));

        if (! preg_match('/^09\d{9}$/', $phone)) {
            return $this->errorResponse($request, 'شماره موبایل باید با ۰۹ شروع شود و ۱۱ رقم باشد.', 422);
        }

        $code = (string) random_int(100000, 999999);
        $key = $this->cacheKey($phone);

        Cache::put($key, Hash::make($code), now()->addMinutes(2));
        Cache::put($key.':attempts', 0, now()->addMinutes(2));

        $apiKey = config('services.kavenegar.api_key');

        if ($apiKey) {
            $response = Http::timeout(10)->get("https://api.kavenegar.com/v1/{$apiKey}/verify/lookup.json", [
                'receptor' => $phone,
                'token' => $code,
                'template' => config('services.kavenegar.template', 'login'),
            ]);

            if ($response->failed()) {
                Log::error('Kavenegar OTP delivery failed', ['phone' => $phone, 'status' => $response->status()]);

                return $this->errorResponse($request, 'ارسال پیامک ناموفق بود؛ چند لحظه دیگر تلاش کنید.', 502);
            }
        } else {
            Log::info('Local customer OTP', ['phone' => $phone, 'code' => $code]);
        }

        $payload = [
            'message' => 'کد ورود ارسال شد.',
            'expires_in' => 120,
            'debug_code' => app()->isLocal() && ! $apiKey ? $code : null,
        ];

        if ($request->expectsJson()) {
            return response()->json($payload);
        }

        return redirect()
            ->route('shop.customer.session.index', array_filter(['redirect_to' => $request->input('redirect_to')]))
            ->with('otp_sent', true)
            ->with('otp_phone', $phone)
            ->with('otp_message', $payload['message'])
            ->with('otp_debug_code', $payload['debug_code']);
    }

    public function verify(Request $request): JsonResponse|RedirectResponse
    {
        $phone = $this->normalizePhone($request->input('phone', ''));
        $code = $this->normalizeDigits($request->input('code', ''));
        $key = $this->cacheKey($phone);

        if (! preg_match('/^09\d{9}$/', $phone) || ! preg_match('/^\d{6}$/', $code)) {
            return $this->verificationErrorResponse($request, $phone, 'شماره موبایل یا کد ورود معتبر نیست.');
        }

        $attempts = (int) Cache::increment($key.':attempts');
        $hashedCode = Cache::get($key);

        if ($attempts > 5 || ! $hashedCode || ! Hash::check($code, $hashedCode)) {
            return $this->verificationErrorResponse($request, $phone, 'کد ورود اشتباه یا منقضی شده است.');
        }

        Cache::forget($key);
        Cache::forget($key.':attempts');

        $customer = Customer::query()->where('phone', $phone)->first();

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
            ->route('shop.customer.session.index', array_filter(['redirect_to' => $request->input('redirect_to')]))
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
