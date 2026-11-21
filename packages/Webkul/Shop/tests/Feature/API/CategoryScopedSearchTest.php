<?php

use Illuminate\Http\Request;
use Illuminate\Support\Fluent;
use Webkul\Faker\Helpers\Category as CategoryFaker;
use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Shop\Http\Controllers\ProductsCategoriesProxyController;

use function Pest\Laravel\getJson;

it('keeps category header search on the current category path including Persian slugs', function (string $slug) {
    $category = (new CategoryFaker)->factory()->create();
    $category->translations()->update(['slug' => $slug]);
    $request = Request::create('http://localhost/'.$slug.'?query=large');
    app()->instance('request', $request);
    $view = app(ProductsCategoriesProxyController::class)->index($request);
    expect($view->getData()['category']->id)->toBe($category->id)
        ->and($request->attributes->get('shop.current_category')->id)->toBe($category->id);

    view()->replaceNamespace('shop', [
        base_path('packages/BagistoPlus/ShamimDigiMobile/resources/views'),
        base_path('packages/Webkul/Shop/src/Resources/views'),
    ]);
    $html = view('shop::components.layouts.header.mobile-digikala', [
        'section' => (object) ['settings' => new Fluent(['logo_text' => 'Test', 'search_brand_image' => '/brand.png']), 'blocks' => []],
        'catalogItems' => [],
    ])->render();
    expect($html)->toContain('action="http://localhost/'.$slug.'"')
        ->toContain('name="query" value="large"');
})->with(['category-search-example', 'کاغذ-آزمایشی']);

it('keeps header search global outside a category page', function () {
    $request = Request::create('http://localhost/');
    app()->instance('request', $request);
    view()->replaceNamespace('shop', [
        base_path('packages/BagistoPlus/ShamimDigiMobile/resources/views'),
        base_path('packages/Webkul/Shop/src/Resources/views'),
    ]);
    $html = view('shop::components.layouts.header.mobile-digikala', [
        'section' => (object) ['settings' => new Fluent(['logo_text' => 'Test', 'search_brand_image' => '/brand.png']), 'blocks' => []],
        'catalogItems' => [],
    ])->render();
    expect($html)->toContain('action="'.route('shop.search.index').'"');
});

it('returns search matches only from the requested category and keeps global search available', function () {
    $needle = 'categoryneedle'.bin2hex(random_bytes(5));
    $pizza = (new CategoryFaker)->factory()->create();
    $paper = (new CategoryFaker)->factory()->create();
    $factory = (new ProductFaker(['attribute_value' => ['name' => [
        'text_value' => $needle.' Large', 'locale' => app()->getLocale(),
    ]]]))->getSimpleProductFactory();
    $pizzaProduct = $factory->hasAttached($pizza)->create();
    $paperProduct = $factory->hasAttached($paper)->create();
    (new ProductFaker)->getSimpleProductFactory()->hasAttached($pizza)->create();

    getJson(route('shop.api.products.index', ['category_id' => $pizza->id, 'query' => $needle, 'sort' => 'name-asc', 'suggest' => '0']))
        ->assertOk()->assertJsonPath('meta.total', 1)->assertJsonPath('data.0.id', $pizzaProduct->id);
    getJson(route('shop.api.products.index', ['query' => $needle, 'suggest' => '0']))
        ->assertOk()->assertJsonPath('meta.total', 2);
});

it('keeps paginated category search restricted to matching products in that category', function () {
    $needle = 'categorypages'.bin2hex(random_bytes(5));
    $category = (new CategoryFaker)->factory()->create();
    $otherCategory = (new CategoryFaker)->factory()->create();
    $factory = (new ProductFaker(['attribute_value' => ['name' => [
        'text_value' => $needle.' Large', 'locale' => app()->getLocale(),
    ]]]))->getSimpleProductFactory();
    $products = $factory->hasAttached($category)->count(13)->create();
    $factory->hasAttached($otherCategory)->create();
    foreach ([1 => 12, 2 => 1] as $page => $count) {
        $result = getJson(route('shop.api.products.index', [
            'category_id' => $category->id, 'query' => $needle, 'sort' => 'name-asc', 'limit' => 12, 'page' => $page, 'suggest' => '0',
        ]))->assertOk()->assertJsonPath('meta.total', 13)->assertJsonCount($count, 'data');
        expect(array_diff(array_column($result->json('data'), 'id'), $products->pluck('id')->all()))->toBe([]);
    }
});
