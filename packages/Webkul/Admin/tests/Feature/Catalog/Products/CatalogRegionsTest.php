<?php

use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Product\Helpers\CatalogRegion;
use Webkul\Product\Helpers\CatalogRegionSettings;
use Webkul\Product\Repositories\ProductRepository;

use function Pest\Laravel\get;
use function Pest\Laravel\putJson;

beforeEach(fn () => CatalogRegionSettings::save(['tabriz', 'ardabil', 'northwest', 'other'], ['tabriz', 'ardabil']));

it('edits product cities and clears them to make the product available everywhere', function () {
    $product = (new ProductFaker)->getSimpleProductFactory()->create();
    $this->loginAsAdmin();
    get(route('admin.catalog.products.edit', $product->id))->assertOk()
        ->assertSee('name="catalog_regions[]"', false)
        ->assertDontSee('value="northwest"', false)->assertDontSee('value="other"', false);
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

it('shows general products in every city and only general products for other cities', function () {
    $faker = new ProductFaker;
    $general = $faker->getSimpleProductFactory()->create(['catalog_regions' => null]);
    $empty = $faker->getSimpleProductFactory()->create(['catalog_regions' => []]);
    $legacy = $faker->getSimpleProductFactory()->create(['catalog_regions' => ['other']]);
    $tabriz = $faker->getSimpleProductFactory()->create(['catalog_regions' => ['tabriz']]);
    $ardabil = $faker->getSimpleProductFactory()->create(['catalog_regions' => ['ardabil']]);
    $tehran = $faker->getSimpleProductFactory()->create(['catalog_regions' => ['tehran']]);
    $products = collect([$general, $empty, $legacy, $tabriz, $ardabil, $tehran]);
    foreach (['tabriz' => $tabriz, 'ardabil' => $ardabil, 'tehran' => $tehran, 'other' => null] as $region => $specific) {
        $query = app(ProductRepository::class)->getModel()->newQuery()->whereIn('id', $products->pluck('id'));
        $expected = [$general->id, $empty->id, $legacy->id];
        if ($specific) {
            $expected[] = $specific->id;
        }
        expect(CatalogRegion::apply($query, $region)->pluck('id')->all())->toEqualCanonicalizing($expected);
    }
});

it('keeps variants of a regional parent out of other cities and includes public variants everywhere', function () {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create(['catalog_regions' => ['tabriz']]);
    $ids = $parent->variants->pluck('id');
    $query = fn () => app(ProductRepository::class)->getModel()->newQuery()->whereIn('id', $ids);
    expect(CatalogRegion::apply($query(), 'other')->count())->toBe(0);
    $parent->refresh()->update(['catalog_regions' => []]);
    foreach (['tabriz', 'ardabil', 'other'] as $region) {
        expect(CatalogRegion::apply($query(), $region)->pluck('id')->all())->toEqualCanonicalizing($ids->all());
    }
});
