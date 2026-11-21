<?php

use Webkul\Core\Models\Channel;
use Webkul\Core\Models\Locale;
use Webkul\Core\SystemConfig\ItemField;

use function Pest\Laravel\get;
use function Pest\Laravel\postJson;

it('renders and saves separate Neshan map and private service keys', function () {
    $this->loginAsAdmin();
    get(route('admin.configuration.index', ['customer', 'address']))->assertOk()
        ->assertSee(trans('shop::delivery.map-settings'))
        ->assertSee('validations="max:500"', false)
        ->assertDontSee('validations="nullable|string|max:500"', false);
    expect(core()->getConfigField('customer.address.neshan.service_key')['type'])->toBe('password');
    $channel = Channel::factory()->create();
    $locale = Locale::factory()->create();
    $section = collect(config('core'))->firstWhere('key', 'customer.address.neshan');
    postJson(route('admin.configuration.store', ['customer', 'address']), [
        'channel' => $channel->code,
        'locale' => $locale->code,
        'keys' => [json_encode($section)],
        'customer' => ['address' => ['neshan' => ['web_key' => 'web-test-key', 'service_key' => 'service-test-key']]],
    ])->assertRedirect()->assertSessionHas('success');
    expect(core()->getConfigData('customer.address.neshan.web_key'))->toBe('web-test-key')
        ->and(core()->getConfigData('customer.address.neshan.service_key'))->toBe('service-test-key');
});

it('keeps Laravel-only validation on the server without passing unsupported rules to the browser', function () {
    $field = new ItemField(
        'customer.address.neshan', 'web_key', 'Key', null, 'text', null,
        'nullable|string|max:500', null, null, null, null, null, []
    );
    expect($field->getValidations())->toBe('max:500')
        ->and($field->validation)->toBe('nullable|string|max:500')
        ->and($field->getValidations())->toBe('max:500');
});

it('rejects malformed Neshan keys on the server and allows clearing optional keys', function ($key) {
    $this->loginAsAdmin();
    $channel = Channel::factory()->create();
    $locale = Locale::factory()->create();
    $section = collect(config('core'))->firstWhere('key', 'customer.address.neshan');
    $payload = [
        'channel' => $channel->code, 'locale' => $locale->code, 'keys' => [json_encode($section)],
        'customer' => ['address' => ['neshan' => ['web_key' => $key, 'service_key' => null]]],
    ];
    $response = postJson(route('admin.configuration.store', ['customer', 'address']), $payload);
    if ($key === null) {
        $response->assertRedirect()->assertSessionHas('success');
        $this->assertDatabaseHas('core_config', ['code' => 'customer.address.neshan.web_key', 'value' => '']);
        $this->assertDatabaseHas('core_config', ['code' => 'customer.address.neshan.service_key', 'value' => '']);
    } else {
        $response->assertUnprocessable()->assertJsonValidationErrors('customer.address.neshan.web_key');
    }
})->with(['empty' => [null], 'array' => [['bad']], 'overlong' => [str_repeat('x', 501)]]);

it('maps supported client validators without mutating server rules on repeated reads', function ($type, $rules, $expected) {
    $field = new ItemField('customer.address.neshan', 'test', 'Key', null, $type, null,
        $rules, null, null, null, null, null, []);
    expect($field->getValidations())->toBe($expected)
        ->and($field->getValidations())->toBe($expected)
        ->and($field->validation)->toBe($rules);
})->with([
    ['number', 'required|min:1|max:500', 'required|min_value:1|max_value:500'],
    ['password', 'nullable|string|max:500', 'max:500'],
    ['text', 'nullable|string|email|max:500', 'email|max:500'],
    ['text', 'nullable', ''],
]);
