<?php

use Webkul\Attribute\Models\Attribute;
use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Product\Repositories\ElasticSearchRepository;
use Webkul\Product\Repositories\ProductRepository;

use function Pest\Laravel\getJson;

it('searches product names and descriptions without requiring a name match', function (string $field) {
    $needle = 'searchneedle'.bin2hex(random_bytes(6));
    $options = ['attribute_value' => [$field => [
        'text_value' => '<p>Packaging '.$needle.' for restaurants</p>',
        'locale' => app()->getLocale(),
    ]]];
    $product = (new ProductFaker($options))->getSimpleProductFactory()->create();
    $hidden = (new ProductFaker($options))->getSimpleProductFactory()->create();
    $status = Attribute::where('code', 'status')->firstOrFail();
    $hidden->attribute_values()->where('attribute_id', $status->id)->update(['boolean_value' => false]);

    getJson(route('shop.api.products.index', ['query' => $needle]))
        ->assertOk()
        ->assertJsonPath('meta.total', 1)
        ->assertJsonPath('data.0.id', $product->id);
})->with(['name', 'short_description', 'description']);

it('does not search description translations from another locale', function () {
    $needle = 'foreignneedle'.bin2hex(random_bytes(6));
    (new ProductFaker(['attribute_value' => ['description' => [
        'text_value' => $needle,
        'locale' => 'another-locale',
    ]]]))->getSimpleProductFactory()->create();

    getJson(route('shop.api.products.index', ['query' => $needle]))
        ->assertOk()
        ->assertJsonPath('meta.total', 0);
});

it('keeps explicit name filters limited to product names', function () {
    $needle = 'descriptiononly'.bin2hex(random_bytes(6));
    $product = (new ProductFaker(['attribute_value' => ['description' => [
        'text_value' => $needle,
        'locale' => app()->getLocale(),
    ]]]))->getSimpleProductFactory()->create();

    $results = app(ProductRepository::class)->setSearchEngine('database')->getAll(['name' => $needle]);

    expect($results->pluck('id'))->not->toContain($product->id);
});

it('includes both descriptions in elastic storefront search and preserves explicit name filters', function () {
    $repository = app(ElasticSearchRepository::class);
    $filters = $repository->getFilters(['query' => 'piza']);
    expect(data_get($filters, 'filter.0.query_string.fields'))
        ->toBe(['name^3', 'short_description^2', 'description']);

    $filters = $repository->getFilters(['name' => 'piza']);
    expect(data_get($filters, 'filter.0.query_string.default_field'))->toBe('name');
});
