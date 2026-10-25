<?php

use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Shop\Http\Resources\ProductCardResource;

use function Pest\Laravel\getJson;

it('omits the heavy description and gallery fields from the products listing', function () {
    (new ProductFaker)->getSimpleProductFactory()->create();

    $product = getJson(route('shop.api.products.index'))
        ->assertOk()
        ->json('data.0');

    expect($product)
        ->not->toHaveKey('description')
        ->not->toHaveKey('images');
});

it('keeps the fields the product card needs in the listing', function () {
    (new ProductFaker)->getSimpleProductFactory()->create();

    $product = getJson(route('shop.api.products.index'))
        ->assertOk()
        ->json('data.0');

    expect($product)
        ->toHaveKeys([
            'id',
            'name',
            'url_key',
            'base_image',
            'is_new',
            'is_saleable',
            'is_wishlist',
            'unit_price',
            'price_html',
            'ratings',
            'reviews',
        ]);
});

it('uses a configurable parent price as the unit price for its variants', function () {
    $configurable = (new ProductFaker)->getConfigurableProductFactory()->create();

    $variant = $configurable->variants()->first();

    $card = (new ProductCardResource($variant))->resolve(request());

    expect($card['unit_price'])->toBe(core()->formatPrice($configurable->price));
});
