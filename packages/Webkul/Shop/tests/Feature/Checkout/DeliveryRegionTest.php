<?php

use Illuminate\Support\Facades\Http;
use Illuminate\Validation\ValidationException;
use Webkul\Checkout\Models\Cart;
use Webkul\Checkout\Models\CartAddress;
use Webkul\Core\Models\CoreConfig;
use Webkul\Customer\Models\Customer;
use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Product\Helpers\CatalogRegionSettings;
use Webkul\Sales\Transformers\OrderAddressResource;
use Webkul\Shop\Helpers\CartRegionAvailability;

use function Pest\Laravel\getJson;
use function Pest\Laravel\postJson;

function deliveryCart(array $regions)
{
    $customer = Customer::factory()->create();
    test()->loginAsCustomer($customer);
    $cart = Cart::factory()->create(['customer_id' => $customer->id, 'is_active' => 1, 'is_guest' => 0]);
    cart()->setCart($cart);
    foreach ($regions as $region) {
        $product = (new ProductFaker)->getSimpleProductFactory()->create();
        $product = $product->fresh();
        $product->forceFill(['catalog_regions' => $region])->save();
        cart()->addProduct($product, ['product_id' => $product->id, 'quantity' => 1]);
    }

    return cart()->getCart();
}

function deliveryAddress(string $city = 'تبریز', string $state = 'آذربایجان شرقی'): array
{
    return ['first_name' => 'علی', 'last_name' => 'رضایی', 'country' => 'IR', 'state' => $state, 'city' => $city,
        'address' => ['خیابان اصلی پلاک ۱۲'], 'postcode' => '5136812345', 'use_for_shipping' => true];
}

beforeEach(function () {
    CatalogRegionSettings::save(['tabriz', 'ardabil', 'other', 'tehran'], ['tabriz', 'ardabil', 'tehran']);
});

it('marks only compatible and public cart items available for each city', function ($region, $expected) {
    $cart = deliveryCart([null, ['tabriz'], ['ardabil'], ['other']]);
    $ids = app(CartRegionAvailability::class)->availableItemIds($cart, $region);
    $items = $cart->items->values();
    expect($ids)->toBe(collect($expected)->map(fn ($index) => $items[$index]->id)->all());
})->with([['tabriz', [0, 1, 3]], ['ardabil', [0, 2, 3]], ['other', [0, 3]], ['tehran', [0, 3]]]);

it('keeps incompatible cart items until continuing and then removes only those items', function () {
    $cart = deliveryCart([null, ['tabriz'], ['ardabil']]);
    $items = $cart->items->values();
    postJson(route('shop.catalog.region.store'), ['region' => 'tabriz'])->assertOk();
    expect($cart->fresh()->items)->toHaveCount(3);
    postJson(route('shop.api.checkout.cart.prepare'))->assertOk()->assertJsonPath('data.redirect_url', route('shop.checkout.onepage.index'));
    expect($cart->fresh()->items->pluck('id')->all())->toBe([$items[0]->id, $items[1]->id]);
});

it('never deletes the whole cart when no item supports the selected city', function () {
    $cart = deliveryCart([['tabriz']]);
    postJson(route('shop.catalog.region.store'), ['region' => 'ardabil'])->assertOk();
    postJson(route('shop.api.checkout.cart.prepare'))->assertUnprocessable()->assertJsonValidationErrors('region');
    expect($cart->fresh()->items)->toHaveCount(1);
});

it('requires a city before preparing checkout', function () {
    $cart = deliveryCart([null]);
    session()->forget('catalog_region');
    postJson(route('shop.api.checkout.cart.prepare'))->assertUnprocessable()->assertJsonValidationErrors('region');
    expect($cart->fresh()->items)->toHaveCount(1);
});

it('rejects a different shipping city without saving an incompatible address', function () {
    $cart = deliveryCart([['tabriz']]);
    postJson(route('shop.checkout.onepage.addresses.store'), ['billing' => deliveryAddress('اردبیل', 'اردبیل')])
        ->assertUnprocessable()->assertJsonValidationErrors('shipping.city');
    expect($cart->fresh()->billing_address)->toBeNull();
    expect(fn () => app(CartRegionAvailability::class)->validateAddress($cart, deliveryAddress()))->not->toThrow(ValidationException::class);
});

it('validates the shipping destination instead of a separate billing address', function () {
    $cart = deliveryCart([['tabriz']]);
    postJson(route('shop.checkout.onepage.addresses.store'), [
        'billing' => [...deliveryAddress(), 'use_for_shipping' => false],
        'shipping' => deliveryAddress('اردبیل', 'اردبیل'),
    ])->assertUnprocessable()->assertJsonValidationErrors('shipping.city');
});

it('rechecks an incompatible saved destination for shipping payment and final order APIs', function ($route, $payload) {
    $cart = deliveryCart([['tabriz']]);
    CartAddress::factory()->create(['cart_id' => $cart->id, 'address_type' => 'cart_shipping', 'country' => 'IR', 'state' => 'اردبیل', 'city' => 'اردبیل']);
    $cart->refresh();
    cart()->setCart($cart);
    postJson(route($route), $payload)->assertUnprocessable()->assertJsonValidationErrors('shipping.city');
})->with([
    ['shop.checkout.onepage.shipping_methods.store', ['shipping_method' => 'flatrate_flatrate']],
    ['shop.checkout.onepage.payment_methods.store', ['payment' => ['method' => 'moneytransfer']]],
    ['shop.checkout.onepage.orders.store', []],
]);

it('inherits variant delivery restrictions and supports province and custom city addresses', function () {
    $cart = deliveryCart([['tabriz']]);
    $parent = $cart->items->first()->product;
    $variant = (new ProductFaker)->getSimpleProductFactory()->create();
    $variant = $variant->fresh();
    $variant->forceFill(['parent_id' => $parent->id, 'catalog_regions' => null])->save();
    $cart->items->first()->update(['product_id' => $variant->id]);
    $cart->refresh();
    expect(app(CartRegionAvailability::class)->availableItemIds($cart, 'ardabil'))->toBe([])
        ->and(app(CartRegionAvailability::class)->availableItemIds($cart, 'tabriz'))->toHaveCount(1);
    $custom = CatalogRegionSettings::add('مراغه');
    $variant->forceFill(['catalog_regions' => [$custom, 'east_azerbaijan']])->save();
    expect(fn () => app(CartRegionAvailability::class)->validateAddress($cart, deliveryAddress('مراغه')))->not->toThrow(ValidationException::class);
});

it('persists selected map coordinates through customer cart and order address data', function () {
    $cart = deliveryCart([null]);
    $address = [...deliveryAddress(), 'latitude' => 38.08, 'longitude' => 46.29];
    $saved = postJson(route('shop.api.customers.account.addresses.store'), $address)->assertOk()->json('data');
    expect((float) $saved['latitude'])->toBe(38.08);
    cart()->saveAddresses(['billing' => $address]);
    $billing = cart()->getCart()->billing_address;
    $shipping = cart()->getCart()->shipping_address;
    expect((float) $billing->longitude)->toBe(46.29)
        ->and((float) $shipping->latitude)->toBe(38.08)
        ->and((float) (new OrderAddressResource($shipping))->jsonSerialize()['longitude'])->toBe(46.29);
});

it('proxies Persian Neshan addresses without exposing the service key', function () {
    Http::preventStrayRequests();
    CoreConfig::updateOrCreate(['code' => 'customer.address.neshan.service_key', 'channel_code' => null, 'locale_code' => null], ['value' => 'private-service-key']);
    Http::fake(['api.neshan.org/v5/reverse*' => Http::response(['status' => 'OK', 'formatted_address' => 'تبریز، خیابان اصلی', 'state' => 'استان آذربایجان شرقی', 'city' => 'تبریز'])]);
    getJson(route('shop.address.neshan.reverse', ['lat' => 38.08, 'lng' => 46.29]))->assertOk()
        ->assertJsonPath('city', 'تبریز')->assertJsonPath('state', 'آذربایجان شرقی')->assertDontSee('private-service-key');
    Http::assertSent(fn ($request) => $request->hasHeader('Api-Key', 'private-service-key'));
});

it('handles unavailable Neshan credentials and rejects invalid coordinates without external calls', function () {
    Http::preventStrayRequests();
    CoreConfig::where('code', 'customer.address.neshan.service_key')->delete();
    getJson(route('shop.address.neshan.reverse', ['lat' => 38, 'lng' => 46]))->assertStatus(503);
    getJson(route('shop.address.neshan.reverse', ['lat' => 'bad', 'lng' => 100]))->assertUnprocessable();
    Http::assertNothingSent();
});

it('shows a recoverable address lookup error when Neshan rejects the request', function () {
    Http::preventStrayRequests();
    CoreConfig::updateOrCreate(['code' => 'customer.address.neshan.service_key', 'channel_code' => null, 'locale_code' => null], ['value' => 'private-service-key']);
    Http::fake(['api.neshan.org/v5/reverse*' => Http::response(['message' => 'unauthorized'], 403)]);
    getJson(route('shop.address.neshan.reverse', ['lat' => 38, 'lng' => 46]))->assertStatus(502)
        ->assertJsonPath('message', trans('shop::delivery.map-error'))->assertDontSee('private-service-key');
});

it('previews selected address eligibility without saving or removing anything', function () {
    $cart = deliveryCart([['tabriz']]);
    postJson(route('shop.checkout.onepage.addresses.check'), deliveryAddress('اردبیل', 'اردبیل'))
        ->assertUnprocessable()->assertJsonValidationErrors('shipping.city');
    postJson(route('shop.checkout.onepage.addresses.check'), deliveryAddress())->assertOk()->assertJsonPath('data.available', true);
    expect($cart->fresh()->billing_address)->toBeNull()
        ->and($cart->fresh()->items)->toHaveCount(1);
});
