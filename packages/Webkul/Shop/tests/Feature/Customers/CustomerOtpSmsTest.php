<?php

use App\Services\CustomerOtpSms;
use Illuminate\Foundation\Http\Middleware\ValidateCsrfToken;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken;
use Illuminate\Http\Client\Request;
use Illuminate\Routing\Middleware\ThrottleRequests;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
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
    config(['cache.default' => 'array']);
});

function otpGhasedakFake(array $body, int $status = 200): void
{
    Http::fake([
        'gateway.ghasedak.me/rest/api/v1/WebService/SendOtpSMS' => Http::response($body, $status),
    ]);
}

function otpKavenegarSettings(bool $testing = false, string $key = 'test-kavenegar-key', string $template = 'LoginOtp'): void
{
    otpSmsSettings($testing);

    foreach (['ghasedak.provider' => 'kavenegar', 'kavenegar.api_key' => $key, 'kavenegar.template' => $template] as $field => $value) {
        CoreConfig::updateOrCreate(['code' => 'customer.sms.'.$field, 'channel_code' => null, 'locale_code' => null], ['value' => $value]);
    }
}

it('uses Kavenegar only when selected for login and credit verification', function (bool $creditVerification) {
    otpKavenegarSettings();
    Http::fake(['api.kavenegar.com/*' => Http::response(['return' => ['status' => 200], 'entries' => [['messageid' => 1]]])]);
    $phone = '0912'.random_int(1000000, 9999999);
    $customer = Customer::factory()->create(['phone' => $phone]);

    if ($creditVerification) {
        $this->loginAsCustomer($customer);
    }

    postJson(route('shop.customer.otp.send'), ['phone' => $phone, 'credit_verification' => $creditVerification])
        ->assertOk()->assertJsonPath('debug_code', null);

    $code = null;
    Http::assertSent(function (Request $request) use ($phone, &$code) {
        $code = $request['token'];

        return $request->method() === 'POST'
            && $request->url() === 'https://api.kavenegar.com/v1/test-kavenegar-key/verify/lookup.json'
            && $request->hasHeader('Content-Type', 'application/x-www-form-urlencoded')
            && $request['receptor'] === $phone
            && $request['template'] === 'LoginOtp'
            && $request['type'] === 'sms'
            && preg_match('/^\d{6}$/', $code)
            && Hash::check($code, Cache::get('customer-otp:'.$phone));
    });

    postJson(route('shop.customer.otp.verify'), [
        'phone' => $phone, 'code' => $code, 'credit_verification' => $creditVerification,
    ])->assertOk();
    expect(auth()->guard('customer')->id())->toBe($customer->id);
    Http::assertSentCount(1);
})->with([false, true]);

it('rejects unsuccessful or malformed Kavenegar responses without exposing provider text', function ($body, int $status) {
    otpKavenegarSettings();
    Http::fake(['api.kavenegar.com/*' => Http::response($body, $status)]);
    $phone = '0912'.random_int(1000000, 9999999);

    postJson(route('shop.customer.otp.send'), ['phone' => $phone])
        ->assertStatus(502)->assertJsonMissingPath('debug_code')->assertDontSee('secret-provider-message');
    expect(Cache::get('customer-otp:'.$phone))->toBeNull();
    Http::assertSentCount(1);
})->with([
    [['return' => ['status' => 424, 'message' => 'secret-provider-message']], 200],
    [['return' => ['status' => '200']], 200],
    [['unexpected' => true], 200],
    ['invalid-json', 200],
    [['return' => ['status' => 200]], 500],
    [['return' => ['status' => 200]], 302],
]);

it('does not send Kavenegar requests in test mode', function () {
    otpKavenegarSettings(true);
    $this->app->instance('env', 'production');

    postJson(route('shop.customer.otp.send'), ['phone' => '0912'.random_int(1000000, 9999999)])
        ->assertOk()->assertJsonStructure(['debug_code']);
    Http::assertNothingSent();
});

it('requires Kavenegar credentials and handles connection failures without caching a code', function () {
    otpKavenegarSettings(false, '', '');
    $phone = '0912'.random_int(1000000, 9999999);
    postJson(route('shop.customer.otp.send'), ['phone' => $phone])->assertStatus(502);
    Http::assertNothingSent();

    otpKavenegarSettings();
    Http::fake(['api.kavenegar.com/*' => Http::failedConnection()]);
    postJson(route('shop.customer.otp.send'), ['phone' => $phone])->assertStatus(502);
    expect(Cache::get('customer-otp:'.$phone))->toBeNull();
});

it('sends real login OTP through Ghasedak without exposing or logging the code', function ($body) {
    otpSmsSettings();
    otpGhasedakFake($body);
    $phone = '0912'.random_int(1000000, 9999999);
    $customer = Customer::factory()->create(['phone' => $phone]);

    postJson(route('shop.customer.otp.send'), ['phone' => $phone])
        ->assertOk()->assertJsonPath('debug_code', null);

    $code = null;
    Http::assertSent(function (Request $request) use ($phone, &$code) {
        if ($request->method() !== 'POST') {
            return false;
        }

        $code = $request['inputs'][0]['value'];

        return $request->method() === 'POST'
            && $request->hasHeader('ApiKey', 'test-api-key')
            && $request['templateName'] === 'login-test'
            && $request->url() === 'https://gateway.ghasedak.me/rest/api/v1/WebService/SendOtpSMS'
            && $request['inputs'][0]['param'] === 'Code'
            && $request['receptors'][0]['mobile'] === $phone
            && preg_match('/^\d{6}$/', $code)
            && Hash::check($code, Cache::get('customer-otp:'.$phone));
    });

    postJson(route('shop.customer.otp.verify'), ['phone' => $phone, 'code' => $code])->assertOk();
    expect(auth()->guard('customer')->id())->toBe($customer->id);
    Http::assertSentCount(1);
})->with([
    [['IsSuccess' => true, 'StatusCode' => 200]],
    [['isSuccess' => true, 'statusCode' => 200]],
]);

it('does not treat a failed or malformed Ghasedak reply as successful delivery', function ($body, $status) {
    otpSmsSettings();
    otpGhasedakFake($body, $status);
    $phone = '0912'.random_int(1000000, 9999999);

    postJson(route('shop.customer.otp.send'), ['phone' => $phone])
        ->assertStatus(502)->assertJsonMissingPath('debug_code');
    expect(Cache::get('customer-otp:'.$phone))->toBeNull();
})->with([
    [['IsSuccess' => false, 'StatusCode' => 401], 200],
    [['isSuccess' => false, 'statusCode' => 401], 200],
    [['isSuccess' => 'true', 'statusCode' => 200], 200],
    [['unexpected' => true], 200],
    [['IsSuccess' => false], 500],
    [['isSuccess' => true, 'statusCode' => 200], 302],
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

it('sends one request per OTP using the fixed Code parameter without a metadata lookup', function () {
    otpSmsSettings();
    otpGhasedakFake(['isSuccess' => true]);
    $sms = app(CustomerOtpSms::class);
    $sms->send('09123456789', '123456');
    $sms->send('09123456789', '654321');

    Http::assertSentCount(2);
    Http::assertSent(fn (Request $request) => $request->method() === 'POST' && $request['inputs'] === [['param' => 'Code', 'value' => '123456']]);
    Http::assertNotSent(fn (Request $request) => $request->method() === 'GET');
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
    otpGhasedakFake(['isSuccess' => true]);
    $phone = '0912'.random_int(1000000, 9999999);
    $this->loginAsCustomer(Customer::factory()->create(['phone' => $phone]));

    post(route('shop.customer.otp.send'), ['credit_verification' => 1])
        ->assertRedirect()->assertSessionMissing('otp_debug_code');
    Http::assertSent(fn (Request $request) => $request->method() === 'POST' && $request['receptors'][0]['mobile'] === $phone);
});

it('normalizes international profile numbers for credit verification without trusting the submitted phone', function ($format) {
    otpSmsSettings();
    otpGhasedakFake(['isSuccess' => true]);
    $phone = '0912'.random_int(1000000, 9999999);
    $stored = $format === 'persian'
        ? strtr('0098'.substr($phone, 1), array_combine(str_split('0123456789'), preg_split('//u', '۰۱۲۳۴۵۶۷۸۹', -1, PREG_SPLIT_NO_EMPTY)))
        : $format.substr($phone, 1);
    $customer = Customer::factory()->create(['phone' => $stored]);
    $this->loginAsCustomer($customer);
    get(route('shop.customers.account.credit.verify'))->assertOk()->assertSee('value="'.$phone.'"', false);

    postJson(route('shop.customer.otp.send'), ['credit_verification' => 1, 'phone' => '09999999999'])->assertOk();
    $code = null;
    Http::assertSent(function (Request $request) use ($phone, &$code) {
        $code = $request['inputs'][0]['value'];

        return $request['receptors'][0]['mobile'] === $phone;
    });
    postJson(route('shop.customer.otp.verify'), ['credit_verification' => 1, 'phone' => '09999999999', 'code' => $code])->assertOk();
    expect($customer->fresh()->credit_verified_phone)->toBe($phone);
    Http::assertSentCount(1);
})->with(['0098', '+98', 'persian']);

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
        'vip0098.test_mode' => $testing ? '1' : '0',
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

it('uses 0098VIP for credit phone verification and its independent test switch', function ($testing) {
    otpVipSettings($testing);
    CoreConfig::where('code', 'customer.sms.ghasedak.test_mode')->update(['value' => $testing ? '0' : '1']);
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

it('records the safe SOAP result code without logging provider text or credentials', function ($result, $expected) {
    otpVipSettings();
    Log::spy();
    Http::fake(['webservice.0098vip.com/*' => Http::response(otpSoapReply($result))]);

    postJson(route('shop.customer.otp.send'), ['phone' => '0912'.random_int(1000000, 9999999)])->assertStatus(502);

    Log::shouldHaveReceived('warning')->once()->with('0098VIP OTP delivery failed', [
        'http_status' => 200,
        'response_code' => $expected,
    ]);
})->with([
    ['-26', '-26'],
    ['10', '10'],
    ['sensitive provider text', 'unknown_response_code'],
]);

it('keeps 0098 test mode independent from Ghasedak login delivery', function () {
    otpVipSettings(true);
    otpSmsSettings(false);
    otpGhasedakFake(['isSuccess' => true, 'statusCode' => 200]);

    postJson(route('shop.customer.otp.send'), ['phone' => '0912'.random_int(1000000, 9999999)])
        ->assertOk()->assertJsonPath('debug_code', null);

    Http::assertSentCount(1);
    Http::assertSent(fn (Request $request) => str_contains($request->url(), 'gateway.ghasedak.me'));
});

it('does not apply OTP test switches to 0098 credit advertising', function () {
    otpVipSettings(true);
    Http::fake(['webservice.0098vip.com/*' => Http::response(otpSoapReply())]);

    app(CustomerOtpSms::class)->sendVipMessage('09123456789', 'Credit offer');

    Http::assertSentCount(1);
});
