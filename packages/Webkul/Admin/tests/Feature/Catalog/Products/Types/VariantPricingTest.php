<?php

use Webkul\Faker\Helpers\Product as ProductFaker;

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

it('calculates prices when adding a new variant', function () {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $this->loginAsAdmin();
    $data = variantPricingForm($parent);
    $data['variants']['variant_new'] = [
        'sku' => fake()->uuid(),
        'name' => 'New pack',
        'weight' => 0,
        'price_multiplier' => 10,
    ];
    foreach ($parent->super_attributes as $attribute) {
        $data['variants']['variant_new'][$attribute->code] = $attribute->options->last()->id;
    }

    putJson(route('admin.catalog.products.update', $parent->id), $data)->assertRedirect();
    $variant = $parent->variants()->orderByDesc('id')->first();
    expect((float) $variant->price)->toBe(2000.0)
        ->and((float) $variant->special_price)->toBe(1900.0)
        ->and($variant->price_multiplier)->toBe(10);
});

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
