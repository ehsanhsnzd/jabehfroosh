<?php

use Illuminate\Validation\ValidationException;
use Webkul\Product\Repositories\ProductRepository;

function packagingQuantityProduct(): mixed
{
    $repository = app(ProductRepository::class);
    $product = $repository->create([
        'type' => 'simple',
        'attribute_family_id' => 1,
        'sku' => 'pack-quantity-'.uniqid(),
        'name' => 'Test box',
        'price' => 20,
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
    $product = packagingQuantityProduct();

    $items = $product->getTypeInstance()->prepareForCart([
        'product_id' => $product->id,
        'packaging_selection' => '100',
        'quantity' => 1,
    ]);

    expect($items[0]['quantity'])->toBe(100);
    expect((float) $items[0]['base_total'])->toBe(2000.0);
});

it('accepts a custom quantity and calculates the total from the unit price', function () {
    $product = packagingQuantityProduct();

    $items = $product->getTypeInstance()->prepareForCart([
        'product_id' => $product->id,
        'packaging_selection' => 'custom',
        'custom_quantity' => '237',
    ]);

    expect($items[0]['quantity'])->toBe(237);
    expect((float) $items[0]['base_total'])->toBe(4740.0);
});

it('rejects invalid fixed and custom quantities', function (array $data) {
    packagingQuantityProduct()->getTypeInstance()->prepareForCart($data);
})->with([
    [['packaging_selection' => '99']],
    [['packaging_selection' => 'custom', 'custom_quantity' => 0]],
    [['packaging_selection' => 'custom', 'custom_quantity' => '1.5']],
    [['packaging_selection' => 'custom', 'custom_quantity' => 1000001]],
])->throws(ValidationException::class);
