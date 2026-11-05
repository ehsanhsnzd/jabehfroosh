<x-shop::layouts>
    <x-slot:title>@lang('customer::credit.verify')</x-slot>
    <div class="mx-auto my-10 w-full max-w-lg rounded-xl border p-6">
        <h1 class="mb-5 text-xl font-semibold">@lang('customer::credit.verify')</h1>
        <p class="mb-5 text-sm">@lang('customer::credit.verifyHelp')</p>
        @if(session('otp_error'))<p role="alert" class="mb-4 text-red-600">{{ session('otp_error') }}</p>@endif
        @if(session('otp_message'))<p class="mb-4 text-green-700">{{ session('otp_message') }}</p>@endif
        @if(session('otp_debug_code') && app(\App\Services\CustomerOtpSms::class)->isTesting())
            <p class="mb-4">@lang('customer::sms.testCode', ['code' => session('otp_debug_code')])</p>
        @endif
        <form method="POST" action="{{ route(session('otp_sent') ? 'shop.customer.otp.verify' : 'shop.customer.otp.send') }}">
            @csrf
            <input type="hidden" name="credit_verification" value="1">
            <input type="hidden" name="redirect_to" value="{{ $redirectTo }}">
            <label class="mb-4 grid gap-2 text-sm">@lang('customer::credit.phone')<input name="phone" type="tel" value="{{ $customer->phone }}" readonly required dir="ltr" class="rounded border px-3 py-2"></label>
            @if(session('otp_sent'))<label class="mb-4 grid gap-2 text-sm">@lang('customer::credit.code')<input name="code" required inputmode="numeric" autocomplete="one-time-code" maxlength="6" class="rounded border px-3 py-2" autofocus></label>@endif
            <button class="primary-button">@lang('customer::credit.'.(session('otp_sent') ? 'confirm' : 'send'))</button>
        </form>
    </div>
</x-shop::layouts>
