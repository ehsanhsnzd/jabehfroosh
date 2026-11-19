<?php

use Webkul\Checkout\Models\Cart;
use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Product\Helpers\ConfigurableOption;

use function Pest\Laravel\get;
use function Pest\Laravel\putJson;

function variantPricingForm($product, array $overrides = []): array
{
    return array_merge([
        'sku' => $product->sku,
        'url_key' => $product->url_key,
        'name' => $product->name,
        'short_description' => $product->short_description,
        'description' => $product->description,
        'channel' => core()->getCurrentChannelCode(),
        'locale' => app()->getLocale(),
        'price' => 200,
        'variant_discount_percent' => 5,
        'variants' => $product->variants->mapWithKeys(fn ($variant, $index) => [
            $variant->id => [
                'sku' => $variant->sku,
                'name' => $variant->name,
                'weight' => $variant->weight,
                'status' => 1,
                'price_multiplier' => ($index + 1) * 5,
                // Submitted manual prices must never override the calculation.
                'price' => 99999,
                'special_price' => 88888,
            ],
        ])->all(),
    ], $overrides);
}

it('calculates and recalculates all variant prices and discounts when saving the parent', function () {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $this->loginAsAdmin();

    $data = variantPricingForm($parent);
    putJson(route('admin.catalog.products.update', $parent->id), $data)->assertRedirect();

    foreach ($parent->variants as $index => $variant) {
        $variant->refresh();
        $price = 200 * (($index + 1) * 5);
        expect((float) $variant->price)->toBe((float) $price)
            ->and((float) $variant->special_price)->toBe($price * 0.95)
            ->and((float) $variant->getTypeInstance()->getMinimalPrice())->toBe($price * 0.95)
            ->and($variant->special_price_from)->toBeNull()
            ->and($variant->special_price_to)->toBeNull();
    }

    $data['price'] = 300;
    $data['variant_discount_percent'] = 0;
    putJson(route('admin.catalog.products.update', $parent->id), $data)->assertRedirect();

    foreach ($parent->variants as $index => $variant) {
        $variant->refresh();
        expect((float) $variant->price)->toBe((float) (300 * (($index + 1) * 5)))
            ->and($variant->special_price)->toBeNull();
    }
});

it('edits a variant through its multiplier and ignores manual prices', function () {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $this->loginAsAdmin();
    putJson(route('admin.catalog.products.update', $parent->id), variantPricingForm($parent))->assertRedirect();

    $variant = $parent->variants->first()->refresh();
    get(route('admin.catalog.products.edit', $variant->id))->assertOk()
        ->assertSee('name="price_multiplier"', false)
        ->assertSee('name="variant_fixed_price"', false)
        ->assertSee('name="variant_discount_override"', false)
        ->assertDontSee('name="price"', false)
        ->assertDontSee('name="special_price"', false);

    putJson(route('admin.catalog.products.update', $variant->id), [
        'sku' => $variant->sku,
        'name' => $variant->name,
        'url_key' => $variant->url_key,
        'short_description' => $variant->short_description,
        'description' => $variant->description,
        'price_multiplier' => 10,
        'weight' => $variant->weight,
        'price' => 1,
        'channel' => core()->getCurrentChannelCode(),
        'locale' => app()->getLocale(),
    ])->assertRedirect();

    $variant->refresh();
    expect((float) $variant->price)->toBe(2000.0)
        ->and((float) $variant->special_price)->toBe(1900.0)
        ->and($variant->price_multiplier)->toBe(10);
});

it('rejects invalid multipliers and percentages without changing saved prices', function () {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $this->loginAsAdmin();
    $data = variantPricingForm($parent);
    $variantId = array_key_first($data['variants']);
    $data['variants'][$variantId]['price_multiplier'] = 1.5;
    $data['variant_discount_percent'] = 101;

    putJson(route('admin.catalog.products.update', $parent->id), $data)
        ->assertUnprocessable()
        ->assertJsonValidationErrorFor('variants.'.$variantId.'.price_multiplier')
        ->assertJsonValidationErrorFor('variant_discount_percent');
});

it('calculates prices when adding a new variant', function ($fixedPrice, $discount, $expectedPrice, $expectedSpecialPrice) {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $this->loginAsAdmin();
    $data = variantPricingForm($parent);
    $data['variants']['variant_new'] = [
        'sku' => fake()->uuid(),
        'name' => 'New pack',
        'variant_fixed_price' => $fixedPrice,
        'variant_discount_override' => $discount,
        'weight' => 0,
        'price_multiplier' => 10,
    ];
    foreach ($parent->super_attributes as $attribute) {
        $data['variants']['variant_new'][$attribute->code] = $attribute->options->last()->id;
    }

    putJson(route('admin.catalog.products.update', $parent->id), $data)->assertRedirect();
    $variant = $parent->variants()->orderByDesc('id')->first();
    expect((float) $variant->price)->toBe((float) $expectedPrice)
        ->and($variant->special_price === null ? null : (float) $variant->special_price)->toBe($expectedSpecialPrice)
        ->and($variant->price_multiplier)->toBe(10);
})->with([
    [null, null, 2000, 1900.0],
    [777, 0, 777, 738.15],
    [777, 10, 777, 699.3],
]);

it('rolls back the parent and variants if a calculated price exceeds database precision', function () {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $this->loginAsAdmin();
    $price = $parent->price;
    $data = variantPricingForm($parent, ['price' => 99999999]);

    putJson(route('admin.catalog.products.update', $parent->id), $data)
        ->assertUnprocessable()
        ->assertJsonValidationErrorFor('price');

    expect($parent->refresh()->price)->toBe($price);
});

it('keeps a fixed variant price when changing the parent price or multiplier and restores calculation when cleared', function () {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $this->loginAsAdmin();
    $data = variantPricingForm($parent);
    $variantId = array_key_first($data['variants']);
    $data['variants'][$variantId]['variant_fixed_price'] = 1234.5;
    $data['variants'][$variantId]['variant_discount_override'] = 0;

    putJson(route('admin.catalog.products.update', $parent->id), $data)->assertRedirect();
    $variant = $parent->variants->find($variantId)->refresh();
    expect((float) $variant->variant_fixed_price)->toBe(1234.5)
        ->and((float) $variant->price)->toBe(1234.5)
        ->and((float) $variant->special_price)->toBe(1172.775)
        ->and((float) $variant->getTypeInstance()->getMinimalPrice())->toBe(1172.775);

    get(route('admin.catalog.products.edit', $parent->id))->assertOk()
        ->assertSee("'× ' + variant.price_multiplier", false)
        ->assertSee('name="price_multiplier"', false)
        ->assertSee('name="price"', false);

    $data['price'] = 300;
    $data['variants'][$variantId]['price_multiplier'] = 100;
    unset($data['variants'][$variantId]['variant_fixed_price'], $data['variants'][$variantId]['variant_discount_override']);
    putJson(route('admin.catalog.products.update', $parent->id), $data)->assertRedirect();
    expect((float) $variant->refresh()->price)->toBe(1234.5);

    $data['variants'][$variantId]['variant_fixed_price'] = '';
    $data['variants'][$variantId]['variant_discount_override'] = '';
    putJson(route('admin.catalog.products.update', $parent->id), $data)->assertRedirect();
    expect($variant->refresh()->variant_fixed_price)->toBeNull()
        ->and((float) $variant->price)->toBe(30000.0)
        ->and((float) $variant->special_price)->toBe(28500.0);
});

it('sets and clears a fixed price from the standalone variant edit form', function () {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $this->loginAsAdmin();
    putJson(route('admin.catalog.products.update', $parent->id), variantPricingForm($parent))->assertRedirect();
    $variant = $parent->variants->first()->refresh();
    $data = [
        'sku' => $variant->sku,
        'name' => $variant->name,
        'url_key' => $variant->url_key,
        'short_description' => $variant->short_description,
        'description' => $variant->description,
        'weight' => $variant->weight,
        'price_multiplier' => 10,
        'variant_fixed_price' => 777,
        'variant_discount_override' => 0,
        'channel' => core()->getCurrentChannelCode(),
        'locale' => app()->getLocale(),
    ];

    putJson(route('admin.catalog.products.update', $variant->id), $data)->assertRedirect();
    expect((float) $variant->refresh()->price)->toBe(777.0)
        ->and((float) $variant->variant_fixed_price)->toBe(777.0)
        ->and((float) $variant->special_price)->toBe(738.15);
    get(route('admin.catalog.products.edit', $variant->id))->assertOk()
        ->assertSee('name="price_multiplier"', false)
        ->assertSee('name="variant_fixed_price"', false)
        ->assertSee('name="variant_discount_override"', false)
        ->assertSee('777.0000');

    $data['variant_fixed_price'] = null;
    $data['variant_discount_override'] = null;
    putJson(route('admin.catalog.products.update', $variant->id), $data)->assertRedirect();
    expect($variant->refresh()->variant_fixed_price)->toBeNull()
        ->and((float) $variant->price)->toBe(2000.0)
        ->and((float) $variant->special_price)->toBe(1900.0);
});

it('validates fixed prices before changing saved variants', function ($price) {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $this->loginAsAdmin();
    $data = variantPricingForm($parent);
    $variantId = array_key_first($data['variants']);
    $data['variants'][$variantId]['variant_fixed_price'] = $price;

    putJson(route('admin.catalog.products.update', $parent->id), $data)
        ->assertUnprocessable()
        ->assertJsonValidationErrorFor('variants.'.$variantId.'.variant_fixed_price');
    expect($parent->variants->find($variantId)->refresh()->variant_fixed_price)->toBeNull();
})->with([-1, 'invalid', 100000000]);

it('accepts zero as an explicit fixed price', function () {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $this->loginAsAdmin();
    $data = variantPricingForm($parent);
    $variantId = array_key_first($data['variants']);
    $data['variants'][$variantId]['variant_fixed_price'] = 0;
    $data['variants'][$variantId]['variant_discount_override'] = 0;
    putJson(route('admin.catalog.products.update', $parent->id), $data)->assertRedirect();

    $variant = $parent->variants->find($variantId)->refresh();
    expect((float) $variant->variant_fixed_price)->toBe(0.0)
        ->and((float) $variant->price)->toBe(0.0)
        ->and((float) $variant->special_price)->toBe(0.0);
});

it('uses an optional variant discount with fixed or quantity based prices', function ($fixedPrice, $override, $discount) {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $this->loginAsAdmin();
    $data = variantPricingForm($parent);
    $variantId = array_key_first($data['variants']);
    $data['variants'][$variantId]['variant_fixed_price'] = $fixedPrice;
    $data['variants'][$variantId]['variant_discount_override'] = $override;
    putJson(route('admin.catalog.products.update', $parent->id), $data)->assertRedirect();

    $variant = $parent->variants->find($variantId)->refresh();
    $basePrice = $fixedPrice ?? 1000;
    $finalPrice = round($basePrice * (1 - $discount / 100), 4);
    expect((float) $variant->price)->toBe((float) $basePrice)
        ->and((float) $variant->getTypeInstance()->getFinalPrice())->toBe($finalPrice);

    if ($override === null || $override === '') {
        expect($variant->variant_discount_override)->toBeNull();
    } else {
        expect((float) $variant->variant_discount_override)->toBe((float) $override);
    }

    $data['variant_discount_percent'] = 20;
    unset($data['variants'][$variantId]['variant_discount_override']);
    putJson(route('admin.catalog.products.update', $parent->id), $data)->assertRedirect();
    $inheritedDiscount = (float) $override > 0 ? $discount : 20;
    expect((float) $variant->refresh()->getTypeInstance()->getFinalPrice())
        ->toBe(round($basePrice * (1 - $inheritedDiscount / 100), 4));
})->with([null, 500])->with([
    [null, 5],
    ['', 5],
    [0, 5],
    [10, 10],
]);

it('rejects invalid variant discounts', function ($discount) {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $this->loginAsAdmin();
    $data = variantPricingForm($parent);
    $variantId = array_key_first($data['variants']);
    $data['variants'][$variantId]['variant_discount_override'] = $discount;

    putJson(route('admin.catalog.products.update', $parent->id), $data)
        ->assertUnprocessable()
        ->assertJsonValidationErrorFor('variants.'.$variantId.'.variant_discount_override');
})->with([-1, 'invalid', 100]);

it('uses the saved fixed price and variant discount in storefront options and cart totals', function () {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $this->loginAsAdmin();
    $data = variantPricingForm($parent);
    $variantId = array_key_first($data['variants']);
    $data['variants'][$variantId]['variant_fixed_price'] = 1000;
    $data['variants'][$variantId]['variant_discount_override'] = 10;
    putJson(route('admin.catalog.products.update', $parent->id), $data)->assertRedirect();

    $variant = $parent->variants->find($variantId)->refresh();
    $options = $parent->super_attributes->mapWithKeys(fn ($attribute) => [$attribute->id => $variant->{$attribute->code}])->all();
    cart()->setCart(Cart::factory()->create());
    $items = $parent->refresh()->getTypeInstance()->prepareForCart([
        'product_id' => $parent->id,
        'selected_configurable_option' => $variantId,
        'super_attribute' => $options,
        'quantity' => 2,
    ]);
    expect((float) $items[0]['base_price'])->toBe(900.0)
        ->and((float) $items[0]['base_total'])->toBe(1800.0);

    $configuration = app(ConfigurableOption::class)->getConfigurationConfig($parent);
    expect((float) $configuration['variant_prices'][$variantId]['regular']['price'])->toBe(1000.0)
        ->and((float) $configuration['variant_prices'][$variantId]['final']['price'])->toBe(900.0);
});
