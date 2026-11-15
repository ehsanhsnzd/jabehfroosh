<?php

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Event;
use Webkul\Admin\DataGrids\Catalog\ProductDataGrid;
use Webkul\Attribute\Models\Attribute;
use Webkul\Attribute\Models\AttributeFamily;
use Webkul\Core\Models\CoreConfig;
use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Product\Models\Product;
use Webkul\Shop\Helpers\CatalogApiCache;

use function Pest\Laravel\deleteJson;
use function Pest\Laravel\getJson;
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

it('lists and deletes products even when their localized index is missing', function (bool $otherLocaleExists) {
    $product = (new ProductFaker)->getSimpleProductFactory()->create();
    $name = $product->name;
    $this->loginAsAdmin();

    if ($otherLocaleExists) {
        DB::table('product_flat')->where('product_id', $product->id)->update(['locale' => 'unindexed-locale']);
    } else {
        DB::table('product_flat')->where('product_id', $product->id)->delete();
    }

    $response = getJson(route('admin.catalog.products.index'), ['X-Requested-With' => 'XMLHttpRequest'])
        ->assertOk();
    $row = collect($response->json('records'))->firstWhere('product_id', $product->id);

    expect($row)->not->toBeNull()
        ->and($row['sku'])->toBe($product->sku)
        ->and($row['name'])->toBe($name);

    postJson(route('admin.catalog.products.mass_delete'), ['indices' => [$row['product_id']]])->assertOk();

    $this->assertDatabaseMissing('products', ['id' => $product->id]);
})->with([true, false]);

it('searches products by sku when the index is missing and elastic search is configured', function () {
    $product = Product::factory()->simple()->create();
    $this->loginAsAdmin();
    foreach (['engine', 'admin_mode'] as $field) {
        CoreConfig::updateOrCreate([
            'code' => 'catalog.products.search.'.$field,
            'channel_code' => null,
            'locale_code' => null,
        ], ['value' => 'elastic']);
    }

    getJson(route('admin.catalog.products.index', ['filters' => ['sku' => [$product->sku]]]), [
        'X-Requested-With' => 'XMLHttpRequest',
    ])->assertOk()
        ->assertJsonPath('meta.total', 1)
        ->assertJsonPath('records.0.product_id', $product->id)
        ->assertJsonPath('records.0.name', $product->sku);
});

it('shows the Persian product name when only the English flat index exists', function () {
    $product = (new ProductFaker)->getSimpleProductFactory()->create();
    DB::table('product_flat')->where('product_id', $product->id)->update(['locale' => 'en']);
    $nameAttribute = Attribute::where('code', 'name')->firstOrFail();
    DB::table('product_attribute_values')
        ->where('product_id', $product->id)->where('attribute_id', $nameAttribute->id)
        ->update(['locale' => 'fa', 'text_value' => 'محصول فارسی بدون ایندکس']);
    app()->setLocale('fa');

    $rows = app(ProductDataGrid::class)->prepareQueryBuilder()
        ->where('product_flat.product_id', $product->id)->get();

    expect($rows)->toHaveCount(1)
        ->and($rows->first()->name)->toBe('محصول فارسی بدون ایندکس');
});
