<?php

use Illuminate\Support\Str;
use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Product\Helpers\CatalogRegion;
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

    foreach (['tehran', 'unknown', 'other'] as $region) {
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

it('keeps other cities on the homepage and excludes it from all product forms', function () {
    CatalogRegionSettings::save(['tabriz', 'ardabil', 'other'], ['tabriz', 'ardabil', 'other']);
    expect(CatalogRegionSettings::visible('home'))->toHaveKey('other')
        ->and(CatalogRegionSettings::visible('product'))->not->toHaveKey('other');
    $this->loginAsAdmin();
    get(route('admin.catalog.products.index'))->assertOk()->assertDontSee('value="other"', false);
    $product = (new ProductFaker)->getSimpleProductFactory()->create(['catalog_regions' => ['other']]);
    get(route('admin.catalog.products.edit', $product->id))->assertOk()->assertDontSee('value="other"', false);
    putJson(route('admin.catalog.regions.update'), ['home' => ['other'], 'product' => ['other']])
        ->assertUnprocessable()->assertJsonValidationErrorFor('product.0');
});

it('adds a city to the list and uses its saved visibility in the storefront and product forms', function () {
    $this->loginAsAdmin();
    postJson(route('admin.catalog.regions.store'), ['region_name' => '  مراغه  '])->assertRedirect(route('admin.catalog.regions.index'));
    $code = array_search('مراغه', CatalogRegionSettings::custom(), true);
    expect($code)->toBeString()
        ->and(CatalogRegionSettings::labels()[$code])->toBe('مراغه')
        ->and(CatalogRegionSettings::visible('home'))->not->toHaveKey($code)
        ->and(CatalogRegionSettings::visible('product'))->not->toHaveKey($code);
    get(route('admin.catalog.regions.index'))->assertOk()->assertSee('مراغه')->assertSee('value="'.$code.'"', false);
    putJson(route('admin.catalog.regions.update'), ['home' => [$code], 'product' => [$code]])->assertRedirect();
    expect(CatalogRegionSettings::visible('home'))->toBe([$code => 'مراغه'])
        ->and(CatalogRegionSettings::visible('product'))->toBe([$code => 'مراغه']);
    get(route('admin.catalog.products.index'))->assertOk()->assertSee('value="'.$code.'"', false);
    $sku = (string) Str::uuid();
    postJson(route('admin.catalog.products.store'), ['type' => 'simple', 'attribute_family_id' => 1, 'sku' => $sku, 'catalog_regions' => [$code]])->assertOk();
    $product = app(ProductRepository::class)->findOneByField('sku', $sku);
    expect($product->catalog_regions)->toBe([$code]);
    $general = (new ProductFaker)->getSimpleProductFactory()->create();
    $query = app(ProductRepository::class)->getModel()->newQuery()->whereIn('id', [$product->id, $general->id]);
    expect(CatalogRegion::apply($query, $code)->pluck('id')->all())->toEqualCanonicalizing([$product->id, $general->id]);
    postJson(route('shop.catalog.region.store'), ['region' => $code])->assertRedirect()->assertSessionHas('catalog_region', $code);
});

it('rejects duplicate or empty city names without changing the existing list', function () {
    $this->loginAsAdmin();
    $first = CatalogRegionSettings::add('مشکین شهر');
    foreach (['مشکین شهر', '  مشكين   شهر ', 'اردبيل', '', '  ', str_repeat('ش', 101)] as $name) {
        postJson(route('admin.catalog.regions.store'), ['region_name' => $name])->assertUnprocessable()->assertJsonValidationErrorFor('region_name');
    }
    expect(CatalogRegionSettings::custom())->toBe([$first => 'مشکین شهر']);
    $second = CatalogRegionSettings::add('بناب');
    expect($second)->not->toBe($first)->and(CatalogRegionSettings::custom())->toHaveCount(2);
    CatalogRegionSettings::save([$first], [$second]);
    expect(CatalogRegionSettings::custom())->toHaveCount(2);
});
