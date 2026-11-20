<?php

use Webkul\Core\Models\Channel;
use Webkul\Core\Models\CoreConfig;
use Webkul\Core\Models\Locale;

use function Pest\Laravel\get;
use function Pest\Laravel\postJson;

it('renders SMS configuration with independent 0098 and Ghasedak test checkboxes', function () {
    $this->loginAsAdmin();

    get(route('admin.configuration.index', ['customer', 'sms']))
        ->assertOk()
        ->assertSee(trans('customer::sms.title'))
        ->assertSee(trans('customer::sms.provider'))
        ->assertSee(trans('customer::sms.vip0098'))
        ->assertSee(trans('customer::sms.kavenegar'))
        ->assertSee(trans('customer::sms.kavenegarTemplate'))
        ->assertSee(trans('customer::sms.testMode'))
        ->assertSee(trans('customer::sms.vipTestMode'));

    expect(core()->getConfigField('customer.sms.vip0098.test_mode')['type'])->toBe('boolean')
        ->and(core()->getConfigField('customer.sms.vip0098.test_mode')['default'])->toBeTrue();

    expect(core()->getConfigField('customer.sms.ghasedak.test_mode')['type'])->toBe('boolean')
        ->and(core()->getConfigField('customer.sms.ghasedak.test_mode')['default'])->toBeFalse()
        ->and(core()->getConfigField('customer.sms.ghasedak.api_key')['type'])->toBe('password');

    expect(core()->getConfigField('customer.sms.ghasedak.provider')['default'])->toBe('ghasedak')
        ->and(core()->getConfigField('customer.sms.kavenegar.api_key')['type'])->toBe('password')
        ->and(core()->getConfigField('customer.sms.vip0098.domain'))->toBeNull();
});

it('saves Kavenegar settings without activating it or changing the existing provider credentials', function () {
    $this->loginAsAdmin();
    $channel = Channel::factory()->create();
    $locale = Locale::factory()->create();
    CoreConfig::updateOrCreate([
        'code' => 'customer.sms.ghasedak.provider', 'channel_code' => null, 'locale_code' => null,
    ], ['value' => 'vip0098']);
    CoreConfig::updateOrCreate([
        'code' => 'customer.sms.vip0098.username', 'channel_code' => null, 'locale_code' => null,
    ], ['value' => 'existing-sms-account']);
    $section = collect(config('core'))->firstWhere('key', 'customer.sms.kavenegar');

    postJson(route('admin.configuration.store', ['customer', 'sms']), [
        'channel' => $channel->code,
        'locale' => $locale->code,
        'keys' => [json_encode($section)],
        'customer' => ['sms' => ['kavenegar' => [
            'api_key' => 'new-kavenegar-key',
            'template' => 'LoginOtp',
        ]]],
    ])->assertRedirect()->assertSessionHas('success');

    expect(core()->getConfigData('customer.sms.kavenegar.api_key'))->toBe('new-kavenegar-key')
        ->and(core()->getConfigData('customer.sms.kavenegar.template'))->toBe('LoginOtp')
        ->and(core()->getConfigData('customer.sms.ghasedak.provider'))->toBe('vip0098')
        ->and(core()->getConfigData('customer.sms.vip0098.username'))->toBe('existing-sms-account');
});

it('saves and disables SMS test mode through admin configuration', function () {
    $this->loginAsAdmin();
    $channel = Channel::factory()->create();
    $locale = Locale::factory()->create();
    $section = collect(config('core'))->firstWhere('key', 'customer.sms.ghasedak');

    foreach (['1', '0'] as $testMode) {
        postJson(route('admin.configuration.store', ['customer', 'sms']), [
            'locale' => $locale->code,
            'channel' => $channel->code,
            'keys' => [json_encode($section)],
            'customer' => ['sms' => ['ghasedak' => [
                'api_key' => 'admin-saved-test-key',
                'template' => 'admin-login-template',
                'test_mode' => $testMode,
            ]]],
        ])->assertRedirect()->assertSessionHas('success');

        $this->assertDatabaseHas('core_config', ['code' => 'customer.sms.ghasedak.test_mode', 'value' => $testMode]);
        expect(core()->getConfigData('customer.sms.ghasedak.api_key'))->toBe('admin-saved-test-key')
            ->and(core()->getConfigData('customer.sms.ghasedak.template'))->toBe('admin-login-template');
    }
});

it('does not expose SMS configuration to unauthenticated visitors', function () {
    get(route('admin.configuration.index', ['customer', 'sms']))
        ->assertRedirect(route('admin.session.create'));
});

it('saves 0098VIP credentials and switches the active SMS provider without losing Ghasedak settings', function () {
    $this->loginAsAdmin();
    $channel = Channel::factory()->create();
    $locale = Locale::factory()->create();
    $sections = collect(config('core'))->whereIn('key', ['customer.sms.ghasedak', 'customer.sms.vip0098'])->map(fn ($section) => json_encode($section))->values()->all();

    foreach (['vip0098', 'ghasedak'] as $provider) {
        postJson(route('admin.configuration.store', ['customer', 'sms']), [
            'locale' => $locale->code,
            'channel' => $channel->code,
            'keys' => $sections,
            'customer' => ['sms' => [
                'ghasedak' => ['provider' => $provider, 'api_key' => 'existing-ghasedak-key', 'template' => 'login-template', 'test_mode' => '0'],
                'vip0098' => ['from' => '300012345', 'username' => 'account', 'password' => 'webservice-password', 'message' => 'جعبه فروش: {code}'],
            ]],
        ])->assertRedirect()->assertSessionHas('success');

        expect(core()->getConfigData('customer.sms.ghasedak.provider'))->toBe($provider)
            ->and(core()->getConfigData('customer.sms.ghasedak.api_key'))->toBe('existing-ghasedak-key')
            ->and(core()->getConfigData('customer.sms.vip0098.password'))->toBe('webservice-password')
            ->and(core()->getConfigData('customer.sms.vip0098.message'))->toBe('جعبه فروش: {code}');
    }
});

it('saves 0098 test mode without changing Ghasedak test mode', function () {
    $this->loginAsAdmin();
    $channel = Channel::factory()->create();
    $locale = Locale::factory()->create();
    CoreConfig::updateOrCreate([
        'code' => 'customer.sms.ghasedak.test_mode', 'channel_code' => null, 'locale_code' => null,
    ], ['value' => '1']);
    $section = collect(config('core'))->firstWhere('key', 'customer.sms.vip0098');

    foreach (['0', '1'] as $testMode) {
        postJson(route('admin.configuration.store', ['customer', 'sms']), [
            'channel' => $channel->code,
            'locale' => $locale->code,
            'keys' => [json_encode($section)],
            'customer' => ['sms' => ['vip0098' => ['test_mode' => $testMode]]],
        ])->assertRedirect()->assertSessionHas('success');

        expect(core()->getConfigData('customer.sms.vip0098.test_mode'))->toBe($testMode)
            ->and(core()->getConfigData('customer.sms.ghasedak.test_mode'))->toBe('1');
    }
});
