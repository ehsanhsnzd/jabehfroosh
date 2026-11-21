<?php

use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Product\Repositories\ProductRepository;

use function Pest\Laravel\get;
use function Pest\Laravel\postJson;
use function Pest\Laravel\putJson;

function priorityProductData($product): array
{
    return ['sku' => $product->sku, 'url_key' => $product->url_key, 'name' => $product->name,
        'short_description' => $product->short_description, 'description' => $product->description,
        'price' => $product->price, 'weight' => $product->weight];
}

it('shows search priority in product creation and editing and saves it on creation', function () {
    $product = (new ProductFaker)->getSimpleProductFactory()->create();
    $this->loginAsAdmin();
    get(route('admin.catalog.products.index'))->assertOk()->assertSee('name="search_priority"', false);
    get(route('admin.catalog.products.edit', $product->id))->assertOk()->assertSee('name="search_priority"', false);
    $sku = 'priority-'.bin2hex(random_bytes(6));
    postJson(route('admin.catalog.products.store'), [
        'sku' => $sku, 'type' => 'simple', 'attribute_family_id' => $product->attribute_family_id, 'search_priority' => 75,
    ])->assertOk();
    expect(app(ProductRepository::class)->findOneByField('sku', $sku)->search_priority)->toBe(75)
        ->and($product->fresh()->search_priority)->toBe(0);
});

it('updates search priority permits zero and preserves it on partial updates', function () {
    $product = (new ProductFaker)->getSimpleProductFactory()->create();
    $this->loginAsAdmin();
    $data = priorityProductData($product);
    putJson(route('admin.catalog.products.update', $product->id), [...$data, 'search_priority' => 100])->assertRedirect();
    expect($product->fresh()->search_priority)->toBe(100);
    putJson(route('admin.catalog.products.update', $product->id), $data)->assertRedirect();
    expect($product->fresh()->search_priority)->toBe(100);
    putJson(route('admin.catalog.products.update', $product->id), [...$data, 'search_priority' => 0])->assertRedirect();
    expect($product->fresh()->search_priority)->toBe(0);
});

it('rejects invalid search priority in both create and update requests', function ($priority) {
    $product = (new ProductFaker)->getSimpleProductFactory()->create();
    $this->loginAsAdmin();
    postJson(route('admin.catalog.products.store'), [
        'sku' => 'priority-'.bin2hex(random_bytes(6)), 'type' => 'simple',
        'attribute_family_id' => $product->attribute_family_id, 'search_priority' => $priority,
    ])->assertUnprocessable()->assertJsonValidationErrors('search_priority');
    putJson(route('admin.catalog.products.update', $product->id), [
        ...priorityProductData($product), 'search_priority' => $priority,
    ])->assertUnprocessable()->assertJsonValidationErrors('search_priority');
})->with([-1, 1.5, 'invalid', 1000001, null]);
