<?php

use App\Services\PackagingProducts;
use Illuminate\Validation\ValidationException;
use Webkul\Checkout\Models\Cart;
use Webkul\Product\Repositories\ProductRepository;

function packagingTestProduct(): mixed
{
    $repository = app(ProductRepository::class);
    $product = $repository->create([
        'type' => 'simple', 'attribute_family_id' => 1,
        'sku' => 'pack-test-'.uniqid(), 'name' => 'Test box', 'pack_unit_price' => 20,
    ]);

    return $repository->update([
        'name' => 'Test box', 'pack_unit_price' => 20, 'status' => 1,
        'guest_checkout' => 1, 'url_key' => $product->sku,
    ], $product->id);
}

it('creates seven real variants and keeps prices synchronized without duplicates', function () {
    $product = packagingTestProduct();
    expect($product->type)->toBe('configurable');
    expect($product->variants)->toHaveCount(7);
    $ids = $product->variants->pluck('id')->all();

    foreach ($product->variants as $variant) {
        expect((float) $variant->price)->toBe(20.0 * app(PackagingProducts::class)->multiplier($variant));
        expect((bool) $variant->manage_stock)->toBeFalse();
        expect($variant->isSaleable())->toBeTrue();
    }

    $product = app(ProductRepository::class)->update([
        'pack_unit_price' => 30, 'name' => 'Updated box', 'status' => 1,
        'variants' => [$ids[0] => ['price' => 1]],
    ], $product->id);
    expect($product->variants->pluck('id')->all())->toBe($ids);

    foreach ($product->variants as $variant) {
        expect((float) $variant->price)->toBe(30.0 * app(PackagingProducts::class)->multiplier($variant));
    }
});

it('prices custom units and fixed packs on the server and rejects unrelated variants', function () {
    cart()->setCart(Cart::factory()->create());
    $product = packagingTestProduct();
    $service = app(PackagingProducts::class);
    $custom = $product->variants->first(fn ($variant) => $service->multiplier($variant) === 1);
    $pack = $product->variants->first(fn ($variant) => $service->multiplier($variant) === 100);

    $items = $product->getTypeInstance()->prepareForCart([
        'product_id' => $product->id, 'selected_configurable_option' => $custom->id,
        'quantity' => 237, 'price' => 1,
    ]);
    expect((float) $items[0]['base_total'])->toBe(4740.0);

    $items = $product->getTypeInstance()->prepareForCart([
        'product_id' => $product->id, 'selected_configurable_option' => $pack->id,
        'quantity' => 2, 'price' => 1,
    ]);
    expect((float) $items[0]['base_total'])->toBe(4000.0);

    $other = packagingTestProduct();
    expect($product->getTypeInstance()->prepareForCart([
        'product_id' => $product->id, 'selected_configurable_option' => $other->variants->first()->id, 'quantity' => 1,
    ]))->toBeString();
});

it('rejects invalid custom quantities', function ($quantity) {
    $product = packagingTestProduct();
    $product->getTypeInstance()->prepareForCart([
        'product_id' => $product->id, 'selected_configurable_option' => $product->variants->first()->id,
        'quantity' => $quantity,
    ]);
})->with([0, -1, '1.5', 'abc', 1000001])->throws(ValidationException::class);

it('adds the selected custom variant to a cart with the requested number of units', function () {
    $product = packagingTestProduct();
    $variant = $product->variants->first(fn ($variant) => app(PackagingProducts::class)->multiplier($variant) === 1);

    $cart = cart()->addProduct($product, [
        'product_id' => $product->id, 'selected_configurable_option' => $variant->id, 'quantity' => 237,
    ]);

    expect($cart->items->first()->quantity)->toBe(237);
    expect((float) $cart->items->first()->base_total)->toBe(4740.0);
});
