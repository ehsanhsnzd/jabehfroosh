<?php

use Illuminate\Support\Facades\Event;
use Webkul\Attribute\Models\Attribute;
use Webkul\Attribute\Models\AttributeFamily;
use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Product\Models\Product;
use Webkul\Shop\Helpers\CatalogApiCache;

use function Pest\Laravel\deleteJson;
use function Pest\Laravel\postJson;

it('removes listings cached during product deletion after deletion completes', function () {
    $product = (new ProductFaker)->getSimpleProductFactory()->create();
    $this->loginAsAdmin();
    $cache = app(CatalogApiCache::class);

    // A concurrent listing can repopulate the cache after the before-delete flush.
    Event::listen('catalog.product.delete.before', function () use ($cache, $product) {
        $cache->remember('deletion-test', [], fn () => Product::whereKey($product->id)->exists());
    });

    deleteJson(route('admin.catalog.products.delete', $product->id))->assertOk();

    expect($cache->remember('deletion-test', [], fn () => Product::whereKey($product->id)->exists()))
        ->toBeFalse();
});

it('offers new configurable select attributes only after they belong to the selected family', function () {
    $family = AttributeFamily::findOrFail(1);
    $attribute = Attribute::factory()->create([
        'type' => 'select',
        'is_configurable' => true,
    ]);
    $this->loginAsAdmin();
    $data = [
        'type' => 'configurable',
        'attribute_family_id' => $family->id,
        'sku' => fake()->uuid(),
    ];

    postJson(route('admin.catalog.products.store'), $data)
        ->assertOk()
        ->assertJsonMissing(['code' => $attribute->code]);

    $family->attribute_groups()->firstOrFail()->custom_attributes()->attach($attribute->id);

    postJson(route('admin.catalog.products.store'), $data)
        ->assertOk()
        ->assertJsonFragment(['code' => $attribute->code]);
});
