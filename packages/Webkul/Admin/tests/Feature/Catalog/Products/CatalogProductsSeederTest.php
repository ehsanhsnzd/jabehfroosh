<?php

use Database\Seeders\ShamimCatalogProductsSeeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Event;
use Webkul\Product\Repositories\ProductRepository;

it('seeds catalog products without changing attributes, themes or global settings', function () {
    Event::fake(['catalog.product.create.before', 'catalog.product.create.after', 'catalog.product.update.before', 'catalog.product.update.after']);

    $tables = [
        'attributes',
        'attribute_translations',
        'attribute_options',
        'attribute_option_translations',
        'category_filterable_attributes',
        'core_config',
        'theme_customizations',
        'theme_customization_translations',
    ];
    $snapshots = collect($tables)->mapWithKeys(fn ($table) => [$table => DB::table($table)->get()->toJson()]);
    $updates = 0;

    // Exercise the real seeder while keeping uploaded files and live products untouched.
    $this->mock(ProductRepository::class, function ($mock) use (&$updates) {
        $mock->shouldReceive('findOneByField')->andReturn((object) ['id' => 999999]);
        $mock->shouldReceive('update')->andReturnUsing(function ($data, $id) use (&$updates) {
            expect($data['images']['files'])->not->toBeEmpty()
                ->and($data['categories'])->not->toBeEmpty();
            $updates++;

            return (object) ['id' => $id];
        });
    });

    (new ShamimCatalogProductsSeeder)->run();

    expect($updates)->toBeGreaterThan(0);
    foreach ($snapshots as $table => $snapshot) {
        expect(DB::table($table)->get()->toJson())->toBe($snapshot);
    }
});
