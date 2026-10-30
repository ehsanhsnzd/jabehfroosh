<?php

use Webkul\Faker\Helpers\Product as ProductFaker;

use function Pest\Laravel\get;
use function Pest\Laravel\putJson;

it('edits product cities and clears them to make the product available everywhere', function () {
    $product = (new ProductFaker)->getSimpleProductFactory()->create();
    $this->loginAsAdmin();
    get(route('admin.catalog.products.edit', $product->id))->assertOk()
        ->assertSee('name="catalog_regions[]"', false)
        ->assertDontSee('value="northwest"', false);
    $data = [
        'sku' => $product->sku,
        'url_key' => $product->url_key,
        'name' => $product->name,
        'short_description' => $product->short_description,
        'description' => $product->description,
        'price' => $product->price,
        'weight' => $product->weight,
        'catalog_regions_present' => 1,
        'catalog_regions' => ['tabriz', 'ardabil'],
    ];

    putJson(route('admin.catalog.products.update', $product->id), $data)->assertRedirect();
    expect($product->refresh()->catalog_regions)->toBe(['tabriz', 'ardabil']);

    $data['catalog_regions'] = ['invalid'];
    putJson(route('admin.catalog.products.update', $product->id), $data)->assertUnprocessable()->assertJsonValidationErrorFor('catalog_regions.0');

    unset($data['catalog_regions']);
    putJson(route('admin.catalog.products.update', $product->id), $data)->assertRedirect();
    expect($product->refresh()->catalog_regions)->toBe([]);
});

it('copies configurable cities to all existing and newly added variants', function () {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create();
    $parent->variants->first()->update(['catalog_regions' => ['other']]);
    $this->loginAsAdmin();
    $data = [
        'sku' => $parent->sku,
        'url_key' => $parent->url_key,
        'name' => $parent->name,
        'short_description' => $parent->short_description,
        'description' => $parent->description,
        'price' => 200,
        'catalog_regions_present' => 1,
        'catalog_regions' => ['tabriz', 'ardabil'],
        'variants' => $parent->variants->mapWithKeys(fn ($variant) => [$variant->id => [
            'sku' => $variant->sku,
            'name' => $variant->name,
            'weight' => $variant->weight,
            'price_multiplier' => $variant->price_multiplier ?? 1,
        ]])->all(),
    ];
    $data['variants']['variant_new'] = [
        'sku' => fake()->uuid(),
        'name' => 'New regional variant',
        'weight' => 0,
        'price_multiplier' => 5,
    ];
    foreach ($parent->super_attributes as $attribute) {
        $data['variants']['variant_new'][$attribute->code] = $attribute->options->last()->id;
    }

    putJson(route('admin.catalog.products.update', $parent->id), $data)->assertRedirect();
    $variants = $parent->variants()->get();
    expect($variants)->toHaveCount(5);
    foreach ($variants as $variant) {
        expect($variant->catalog_regions)->toBe(['tabriz', 'ardabil']);
    }

    unset($data['catalog_regions'], $data['variants']['variant_new']);
    $newVariant = $variants->last();
    $data['variants'][$newVariant->id] = [
        'sku' => $newVariant->sku,
        'name' => $newVariant->name,
        'weight' => $newVariant->weight,
        'price_multiplier' => $newVariant->price_multiplier,
    ];
    putJson(route('admin.catalog.products.update', $parent->id), $data)->assertRedirect();
    foreach ($parent->variants()->get() as $variant) {
        expect($variant->catalog_regions)->toBe([]);
    }
});
