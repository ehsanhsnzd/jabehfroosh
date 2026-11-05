<?php

use Illuminate\Foundation\Http\Middleware\ValidateCsrfToken;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken;
use Illuminate\Http\Client\Request;
use Illuminate\Routing\Middleware\ThrottleRequests;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;
use Webkul\Core\Models\CoreConfig;
use Webkul\Customer\Models\Customer;

use function Pest\Laravel\get;
use function Pest\Laravel\post;
use function Pest\Laravel\postJson;

function otpSmsSettings(bool $testing = false, string $key = 'test-api-key', string $template = 'login-test'): void
{
    foreach (['provider' => 'ghasedak', 'api_key' => $key, 'template' => $template, 'test_mode' => $testing ? '1' : '0'] as $field => $value) {
        CoreConfig::updateOrCreate(['code' => 'customer.sms.ghasedak.'.$field, 'channel_code' => null, 'locale_code' => null], ['value' => $value]);
    }
}

beforeEach(function () {
    Http::preventStrayRequests();
    $this->withoutMiddleware([
        ThrottleRequests::class,
        ValidateCsrfToken::class,
        VerifyCsrfToken::class,
    ]);
    config(['services.ghasedak.api_key' => null, 'services.ghasedak.template' => null]);
});

it('sends real login OTP through Ghasedak without exposing or logging the code', function () {
    otpSmsSettings();
    Http::fake(['gateway.ghasedak.me/*' => Http::response(['IsSuccess' => true, 'StatusCode' => 200])]);
    $phone = '0912'.random_int(1000000, 9999999);
    $customer = Customer::factory()->create(['phone' => $phone]);

    postJson(route('shop.customer.otp.send'), ['phone' => $phone])
        ->assertOk()->assertJsonPath('debug_code', null);

    $code = null;
    Http::assertSent(function (Request $request) use ($phone, &$code) {
        $code = $request['param1'];

        return $request->method() === 'POST'
            && $request->hasHeader('ApiKey', 'test-api-key')
            && $request['templateName'] === 'login-test'
            && $request['receptors'][0]['mobile'] === $phone
            && preg_match('/^\d{6}$/', $code)
            && Hash::check($code, Cache::get('customer-otp:'.$phone));
    });

    postJson(route('shop.customer.otp.verify'), ['phone' => $phone, 'code' => $code])->assertOk();
    expect(auth()->guard('customer')->id())->toBe($customer->id);
});

it('does not treat a failed or malformed Ghasedak reply as successful delivery', function ($body, $status) {
    otpSmsSettings();
    Http::fake(['gateway.ghasedak.me/*' => Http::response($body, $status)]);
    $phone = '0912'.random_int(1000000, 9999999);

    postJson(route('shop.customer.otp.send'), ['phone' => $phone])
        ->assertStatus(502)->assertJsonMissingPath('debug_code');
    expect(Cache::get('customer-otp:'.$phone))->toBeNull();
})->with([
    [['IsSuccess' => false, 'StatusCode' => 401], 200],
    [['unexpected' => true], 200],
    [['IsSuccess' => false], 500],
]);

it('requires credentials in real mode and handles connection failures', function () {
    otpSmsSettings(false, '', '');
    $phone = '0912'.random_int(1000000, 9999999);
    postJson(route('shop.customer.otp.send'), ['phone' => $phone])->assertStatus(502);
    Http::assertNothingSent();

    otpSmsSettings();
    Http::fake(['gateway.ghasedak.me/*' => Http::failedConnection()]);
    postJson(route('shop.customer.otp.send'), ['phone' => $phone])->assertStatus(502);
    expect(Cache::get('customer-otp:'.$phone))->toBeNull();
});

it('uses the admin test switch for login even outside the local environment', function () {
    app()->instance('env', 'production');
    otpSmsSettings(true, '', '');
    $phone = '0912'.random_int(1000000, 9999999);
    $code = postJson(route('shop.customer.otp.send'), ['phone' => $phone])->assertOk()->json('debug_code');

    expect($code)->toMatch('/^\d{6}$/');
    Http::assertNothingSent();
    postJson(route('shop.customer.otp.verify'), ['phone' => $phone, 'code' => $code])->assertOk();
    expect(auth()->guard('customer')->user()->credit_verified_phone)->toBe($phone);
});

it('shows the same test code on credit verification and never sends an SMS', function () {
    app()->instance('env', 'production');
    otpSmsSettings(true, '', '');
    $phone = '0912'.random_int(1000000, 9999999);
    $customer = Customer::factory()->create(['phone' => $phone]);
    $this->loginAsCustomer($customer);

    $response = post(route('shop.customer.otp.send'), ['credit_verification' => 1, 'phone' => '09999999999']);
    $response->assertRedirect(route('shop.customers.account.credit.verify'))->assertSessionHas('otp_debug_code');
    $code = session('otp_debug_code');
    get(route('shop.customers.account.credit.verify'))->assertOk()->assertSee($code);
    Http::assertNothingSent();

    postJson(route('shop.customer.otp.verify'), ['credit_verification' => 1, 'code' => $code])->assertOk();
    expect($customer->fresh()->credit_verified_phone)->toBe($phone);
});

it('uses real delivery for credit verification when the test switch is off', function () {
    otpSmsSettings();
    Http::fake(['gateway.ghasedak.me/*' => Http::response(['IsSuccess' => true])]);
    $phone = '0912'.random_int(1000000, 9999999);
    $this->loginAsCustomer(Customer::factory()->create(['phone' => $phone]));

    post(route('shop.customer.otp.send'), ['credit_verification' => 1])
        ->assertRedirect()->assertSessionMissing('otp_debug_code');
    Http::assertSent(fn (Request $request) => $request['receptors'][0]['mobile'] === $phone);
});

it('rejects a test code after the admin disables test mode', function () {
    otpSmsSettings(true);
    $phone = '0912'.random_int(1000000, 9999999);
    $code = postJson(route('shop.customer.otp.send'), ['phone' => $phone])->assertOk()->json('debug_code');
    otpSmsSettings(false);

    postJson(route('shop.customer.otp.verify'), ['phone' => $phone, 'code' => $code])->assertUnprocessable();
    expect(auth()->guard('customer')->check())->toBeFalse();
    Http::assertNothingSent();
});

function otpVipSettings(bool $testing = false): void
{
    otpSmsSettings($testing, '', '');

    foreach ([
        'ghasedak.provider' => 'vip0098',
        'vip0098.from' => '300012345678',
        'vip0098.username' => 'user+&=name',
        'vip0098.password' => 'pass+&=? word',
        'vip0098.message' => "جعبه فروش\nکد تأیید: {code}",
    ] as $field => $value) {
        CoreConfig::updateOrCreate(['code' => 'customer.sms.'.$field, 'channel_code' => null, 'locale_code' => null], ['value' => $value]);
    }
}

function otpSoapReply(string $result = '2', string $prefix = 'soap'): string
{
    return '<?xml version="1.0" encoding="utf-8"?>'
        .'<'.$prefix.':Envelope xmlns:'.$prefix.'="http://schemas.xmlsoap.org/soap/envelope/">'
        .'<'.$prefix.':Body><SendSMSResponse xmlns="http://tempuri.org/">'
        .'<SendSMSResult>'.$result.'</SendSMSResult>'
        .'</SendSMSResponse></'.$prefix.':Body></'.$prefix.':Envelope>';
}

function otpSoapRequestData(Request $request): array
{
    $document = new DOMDocument;
    $document->loadXML($request->body(), LIBXML_NONET);
    $xpath = new DOMXPath($document);
    $xpath->registerNamespace('soap', 'http://schemas.xmlsoap.org/soap/envelope/');
    $xpath->registerNamespace('sms', 'http://tempuri.org/');
    $data = [];

    foreach ($xpath->query('/soap:Envelope/soap:Body/sms:SendSMS/*') as $node) {
        $data[$node->localName] = $node->textContent;
    }

    return $data;
}

it('sends login codes through 0098VIP SOAP with credentials only in the XML body', function ($prefix) {
    otpVipSettings();
    Http::fake(['webservice.0098vip.com/*' => Http::response(otpSoapReply('2', $prefix))]);
    $phone = '0912'.random_int(1000000, 9999999);

    postJson(route('shop.customer.otp.send'), ['phone' => $phone])->assertOk()->assertJsonPath('debug_code', null);

    $code = null;
    Http::assertSent(function (Request $request) use ($phone, &$code) {
        $data = otpSoapRequestData($request);
        preg_match('/\d{6}/', $data['text'], $matches);
        $code = $matches[0] ?? '';

        return $request->method() === 'POST'
            && $request->url() === 'https://webservice.0098vip.com/service.asmx'
            && $request->hasHeader('SOAPAction', '"http://tempuri.org/SendSMS"')
            && $request->hasHeader('Content-Type', 'text/xml; charset=utf-8')
            && array_keys($data) === ['username', 'password', 'text', 'mobileno', 'pnlno']
            && $data['pnlno'] === '300012345678'
            && $data['mobileno'] === $phone
            && $data['username'] === 'user+&=name'
            && $data['password'] === 'pass+&=? word'
            && $data['text'] === "جعبه فروش\nکد تأیید: ".$code
            && Hash::check($code, Cache::get('customer-otp:'.$phone));
    });
    Http::assertSentCount(1);
    postJson(route('shop.customer.otp.verify'), ['phone' => $phone, 'code' => $code])->assertOk();
})->with(['soap', 's']);

it('rejects 0098VIP errors empty replies redirects and unrelated HTML without caching a code', function ($body, $status) {
    otpVipSettings();
    Http::fake(['webservice.0098vip.com/*' => Http::response($body, $status)]);
    $phone = '0912'.random_int(1000000, 9999999);

    postJson(route('shop.customer.otp.send'), ['phone' => $phone])->assertStatus(502);
    expect(Cache::get('customer-otp:'.$phone))->toBeNull();
    Http::assertSentCount(1);
})->with([
    [otpSoapReply('-19'), 200],
    [otpSoapReply('10'), 200],
    [otpSoapReply('0'), 200],
    ['<soap:Envelope', 200],
    ['<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><soap:Fault><faultcode>soap:Server</faultcode><faultstring>Failed</faultstring></soap:Fault></soap:Body></soap:Envelope>', 200],
    ['<!DOCTYPE soap:Envelope [<!ENTITY test SYSTEM "file:///etc/passwd">]>'.otpSoapReply(), 200],
    ['', 200],
    ['<html>Login page</html>', 200],
    [otpSoapReply(), 302],
    [otpSoapReply(), 500],
]);

it('uses 0098VIP for credit phone verification and the shared test switch', function ($testing) {
    otpVipSettings($testing);
    Http::fake(['webservice.0098vip.com/*' => Http::response(otpSoapReply())]);
    $phone = '0912'.random_int(1000000, 9999999);
    $customer = Customer::factory()->create(['phone' => $phone]);
    $this->loginAsCustomer($customer);

    $response = postJson(route('shop.customer.otp.send'), ['credit_verification' => 1, 'phone' => '09999999999'])->assertOk();

    if ($testing) {
        $code = $response->json('debug_code');
        expect($code)->toMatch('/^\d{6}$/');
        Http::assertNothingSent();
    } else {
        $response->assertJsonPath('debug_code', null);
        $code = null;
        Http::assertSent(function (Request $request) use ($phone, &$code) {
            $data = otpSoapRequestData($request);
            preg_match('/\d{6}/', $data['text'], $matches);
            $code = $matches[0];

            return $data['mobileno'] === $phone;
        });
    }

    postJson(route('shop.customer.otp.verify'), ['credit_verification' => 1, 'code' => $code])->assertOk();
    expect($customer->fresh()->credit_verified_phone)->toBe($phone);
})->with([true, false]);

it('requires the OTP placeholder before sending through 0098VIP', function () {
    otpVipSettings();
    CoreConfig::where('code', 'customer.sms.vip0098.message')->update(['value' => 'متن بدون کد']);

    postJson(route('shop.customer.otp.send'), ['phone' => '0912'.random_int(1000000, 9999999)])->assertStatus(502);
    Http::assertNothingSent();
});
