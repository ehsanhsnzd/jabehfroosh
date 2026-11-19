<?php

use Illuminate\Support\Str;
use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Product\Helpers\CatalogRegionSettings;
use Webkul\Product\Repositories\ProductRepository;

use function Pest\Laravel\get;
use function Pest\Laravel\postJson;
use function Pest\Laravel\putJson;

it('lists all 31 provinces and independently saves homepage and product form visibility', function () {
    $this->loginAsAdmin();
    expect(config('catalog-provinces'))->toHaveCount(31);
    $response = get(route('admin.catalog.regions.index'))->assertOk();
    foreach (config('catalog-provinces') as $label) {
        $response->assertSee($label);
    }

    putJson(route('admin.catalog.regions.update'), ['home' => ['tehran'], 'product' => ['isfahan']])->assertRedirect();
    expect(CatalogRegionSettings::visible('home'))->toBe(['tehran' => 'تهران'])
        ->and(CatalogRegionSettings::visible('product'))->toBe(['isfahan' => 'اصفهان']);

    get(route('admin.catalog.products.index'))->assertOk()
        ->assertSee('value="isfahan"', false)
        ->assertDontSee('value="tehran"', false);

    putJson(route('admin.catalog.regions.update'), [])->assertRedirect();
    expect(CatalogRegionSettings::visible('home'))->toBe([])
        ->and(CatalogRegionSettings::visible('product'))->toBe([]);
});

it('saves enabled provinces when creating a product and rejects hidden or unknown options', function () {
    $this->loginAsAdmin();
    CatalogRegionSettings::save(['tehran'], ['isfahan']);
    $data = ['type' => 'simple', 'attribute_family_id' => 1, 'sku' => (string) Str::uuid(), 'catalog_regions' => ['isfahan']];

    postJson(route('admin.catalog.products.store'), $data)->assertOk();
    $product = app(ProductRepository::class)->findOneByField('sku', $data['sku']);
    expect($product->catalog_regions)->toBe(['isfahan']);

    foreach (['tehran', 'unknown'] as $region) {
        $data['sku'] = (string) Str::uuid();
        $data['catalog_regions'] = [$region];
        postJson(route('admin.catalog.products.store'), $data)->assertUnprocessable()->assertJsonValidationErrorFor('catalog_regions.0');
    }
});

it('preserves existing assignments when an option is hidden from product forms', function () {
    $product = (new ProductFaker)->getSimpleProductFactory()->create(['catalog_regions' => ['tabriz']]);
    $this->loginAsAdmin();
    CatalogRegionSettings::save(['tehran'], ['isfahan']);

    get(route('admin.catalog.products.edit', $product->id))->assertOk()
        ->assertSee('type="hidden" name="catalog_regions[]" value="tabriz"', false)
        ->assertSee('value="isfahan"', false);

    putJson(route('admin.catalog.products.update', $product->id), [
        'sku' => $product->sku,
        'url_key' => $product->url_key,
        'name' => $product->name,
        'short_description' => $product->short_description,
        'description' => $product->description,
        'price' => $product->price,
        'weight' => $product->weight,
        'catalog_regions_present' => 1,
        'catalog_regions' => ['tabriz', 'isfahan'],
    ])->assertRedirect();
    expect($product->refresh()->catalog_regions)->toBe(['tabriz', 'isfahan']);
});

it('rejects invalid visibility settings without changing the previous configuration', function () {
    $this->loginAsAdmin();
    CatalogRegionSettings::save(['tehran'], ['isfahan']);
    putJson(route('admin.catalog.regions.update'), ['home' => ['unknown'], 'product' => ['northwest']])
        ->assertUnprocessable()->assertJsonValidationErrorFor('home.0')->assertJsonValidationErrorFor('product.0');
    expect(CatalogRegionSettings::visible('home'))->toBe(['tehran' => 'تهران']);
});
