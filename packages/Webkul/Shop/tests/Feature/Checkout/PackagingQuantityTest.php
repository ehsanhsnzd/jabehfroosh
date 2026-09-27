<?php

use Illuminate\Validation\ValidationException;
use Webkul\Checkout\Models\Cart;
use Webkul\Product\Repositories\ProductRepository;
use Webkul\Shop\Http\Resources\CartItemResource;

function packagingQuantityProduct(): mixed
{
    $repository = app(ProductRepository::class);
    $product = $repository->create([
        'type' => 'simple',
        'attribute_family_id' => 1,
        'sku' => 'pack-quantity-'.uniqid(),
        'name' => 'Test box',
        'price' => 20,
        'packaging_product' => 1,
    ]);

    return $repository->update([
        'name' => 'Test box',
        'price' => 20,
        'status' => 1,
        'guest_checkout' => 1,
        'url_key' => $product->sku,
        'manage_stock' => 0,
    ], $product->id);
}

it('keeps packaging products simple and creates no variant rows', function () {
    $product = packagingQuantityProduct();

    expect($product->type)->toBe('simple');
    expect($product->name)->toBe('Test box');
    expect((float) $product->price)->toBe(20.0);
    expect($product->variants)->toHaveCount(0);
});

it('uses a fixed global quantity and ignores a manipulated request quantity', function () {
    cart()->setCart(Cart::factory()->create());
    $product = packagingQuantityProduct();

    $items = $product->getTypeInstance()->prepareForCart([
        'product_id' => $product->id,
        'packaging_selection' => '100',
        'quantity' => 1,
    ]);

    expect($items[0]['quantity'])->toBe(100);
    expect((float) $items[0]['base_total'])->toBe(2000.0);
    expect($items[0]['additional']['packaging_size'])->toBe(100);
    expect($items[0]['additional']['attributes'][0]['option_label'])->toBe('1 بسته × 100 عدد = 100 عدد کل');
});

it('accepts a custom quantity and calculates the total from the unit price', function () {
    cart()->setCart(Cart::factory()->create());
    $product = packagingQuantityProduct();

    $items = $product->getTypeInstance()->prepareForCart([
        'product_id' => $product->id,
        'packaging_selection' => 'custom',
        'custom_quantity' => '237',
    ]);

    expect($items[0]['quantity'])->toBe(237);
    expect((float) $items[0]['base_total'])->toBe(4740.0);
    expect($items[0]['additional']['packaging_size'])->toBe(237);
    expect($items[0]['additional']['attributes'][0]['option_label'])->toBe('1 بسته × 237 عدد = 237 عدد کل');
});

it('merges equal package sizes and keeps different package sizes on separate cart rows', function () {
    cart()->setCart(Cart::factory()->create());
    $product = packagingQuantityProduct();

    foreach ([25, 25, 40] as $size) {
        cart()->addProduct($product, [
            'product_id' => $product->id,
            'packaging_selection' => 'custom',
            'custom_quantity' => $size,
        ]);
    }

    $items = cart()->getCart()->items->sortBy('quantity')->values();

    expect($items)->toHaveCount(2);
    expect($items[0]->quantity)->toBe(40);
    expect($items[0]->additional['packaging_size'])->toBe(40);
    expect($items[1]->quantity)->toBe(50);
    expect($items[1]->additional['packaging_size'])->toBe(25);
    expect($items[1]->additional['attributes'][0]['option_label'])->toBe('2 بسته × 25 عدد = 50 عدد کل');

    cart()->updateItems(['qty' => [$items[1]->id => 75]]);

    $updatedItem = $items[1]->fresh();
    $resource = (new CartItemResource($updatedItem))->resolve();

    expect($updatedItem->additional['attributes'][0]['option_label'])->toBe('3 بسته × 25 عدد = 75 عدد کل');
    expect($resource['packaging_size'])->toBe(25);
    expect($resource['packaging_count'])->toBe(3);
    expect($resource['packaging_price'])->toBe(500.0);
});

it('rejects a cart quantity that is not a complete package', function () {
    cart()->setCart(Cart::factory()->create());
    $product = packagingQuantityProduct();

    cart()->addProduct($product, [
        'product_id' => $product->id,
        'packaging_selection' => 'custom',
        'custom_quantity' => 25,
    ]);

    $item = cart()->getCart()->items->first();
    $item->quantity = 26;
    $item->getTypeInstance()->validateCartItem($item);
})->throws(ValidationException::class);

it('rejects invalid fixed and custom quantities', function (array $data) {
    packagingQuantityProduct()->getTypeInstance()->prepareForCart($data);
})->with([
    [['packaging_selection' => '99']],
    [['packaging_selection' => 'custom', 'custom_quantity' => 0]],
    [['packaging_selection' => 'custom', 'custom_quantity' => '1.5']],
    [['packaging_selection' => 'custom', 'custom_quantity' => 1000001]],
])->throws(ValidationException::class);
