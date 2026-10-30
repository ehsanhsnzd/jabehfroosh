<?php

use Illuminate\Support\Str;
use Webkul\Faker\Helpers\Category as CategoryFaker;
use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Product\Helpers\CatalogRegion;
use Webkul\Product\Repositories\ProductRepository;

use function Pest\Laravel\getJson;
use function Pest\Laravel\post;

it('stores a supported city in the session and varies browser cache cookies', function ($region) {
    post(route('shop.catalog.region.store'), ['region' => $region])
        ->assertRedirect()
        ->assertSessionHas('catalog_region', $region)
        ->assertCookie('catalog_region', $region);
})->with(['tabriz', 'ardabil', 'northwest', 'other']);

it('rejects unsupported cities and keeps the previously selected city', function () {
    $this->withSession(['catalog_region' => 'tabriz']);

    post(route('shop.catalog.region.store'), ['region' => 'invalid'])
        ->assertSessionHasErrors('region')
        ->assertSessionHas('catalog_region', 'tabriz');
});

it('filters cached listings by the selected city while keeping unassigned products visible', function () {
    $category = (new CategoryFaker)->factory()->create();
    $tabriz = (new ProductFaker)->getSimpleProductFactory()->create(['catalog_regions' => ['tabriz']]);
    $ardabil = (new ProductFaker)->getSimpleProductFactory()->create(['catalog_regions' => ['ardabil']]);
    $northwest = (new ProductFaker)->getSimpleProductFactory()->create(['catalog_regions' => ['northwest']]);
    $other = (new ProductFaker)->getSimpleProductFactory()->create(['catalog_regions' => ['other']]);
    $everywhere = (new ProductFaker)->getSimpleProductFactory()->create();
    foreach ([$tabriz, $ardabil, $northwest, $other, $everywhere] as $product) {
        $product->categories()->sync([$category->id]);
    }
    $url = route('shop.api.products.index', ['category_id' => $category->id]);

    $all = getJson($url)->assertOk()->json('data');
    expect(collect($all)->pluck('id')->all())->toEqualCanonicalizing([$tabriz->id, $ardabil->id, $northwest->id, $other->id, $everywhere->id]);

    post(route('shop.catalog.region.store'), ['region' => 'tabriz'])->assertRedirect();
    $first = getJson($url)->assertOk()->json('data');
    expect(collect($first)->pluck('id')->all())->toEqualCanonicalizing([$tabriz->id, $everywhere->id]);

    post(route('shop.catalog.region.store'), ['region' => 'ardabil'])->assertRedirect();
    $second = getJson($url)->assertOk()->json('data');
    expect(collect($second)->pluck('id')->all())->toEqualCanonicalizing([$ardabil->id, $everywhere->id]);

    $spoofed = getJson($url.'&catalog_region=tabriz')->assertOk()->json('data');
    expect(collect($spoofed)->pluck('id')->all())->toEqualCanonicalizing([$ardabil->id, $everywhere->id]);

    post(route('shop.catalog.region.store'), ['region' => 'northwest'])->assertRedirect();
    $regional = getJson($url)->assertOk()->json('data');
    expect(collect($regional)->pluck('id')->all())->toEqualCanonicalizing([$tabriz->id, $ardabil->id, $northwest->id, $everywhere->id]);
});

it('inherits parent cities for variants and allows an explicit variant override', function () {
    $parent = (new ProductFaker)->getConfigurableProductFactory()->create(['catalog_regions' => ['tabriz']]);
    $variants = $parent->variants;
    $override = $variants->first();
    $override->update(['catalog_regions' => ['ardabil']]);

    $query = fn () => app(ProductRepository::class)->getModel()->newQuery()->whereIn('id', $variants->pluck('id'));
    expect(CatalogRegion::apply($query(), 'tabriz')->pluck('id')->all())
        ->toEqualCanonicalizing($variants->pluck('id')->reject(fn ($id) => $id === $override->id)->values()->all());
    expect(CatalogRegion::apply($query(), 'ardabil')->pluck('id')->all())->toBe([$override->id]);
    expect(CatalogRegion::apply($query(), 'northwest')->pluck('id')->all())->toEqualCanonicalizing($variants->pluck('id')->all());
});

it('filters search results and recommendations by city', function () {
    $name = 'region'.strtolower(Str::random(12));
    $faker = new ProductFaker(['attribute_value' => ['name' => ['text_value' => $name, 'locale' => app()->getLocale()]]]);
    $tabriz = $faker->getSimpleProductFactory()->create(['catalog_regions' => ['tabriz']]);
    $ardabil = $faker->getSimpleProductFactory()->create(['catalog_regions' => ['ardabil']]);
    $tabriz->related_products()->attach($ardabil->id);
    $tabriz->up_sells()->attach($ardabil->id);
    $this->withSession(['catalog_region' => 'tabriz']);

    $data = getJson(route('shop.api.products.index', ['query' => $name, 'suggest' => '0']))->assertOk()->json('data');
    expect(collect($data)->pluck('id')->all())->toBe([$tabriz->id]);
    getJson(route('shop.api.products.related.index', $tabriz->id))->assertOk()->assertJsonCount(0, 'data');
    getJson(route('shop.api.products.up-sell.index', $tabriz->id))->assertOk()->assertJsonCount(0, 'data');
});
