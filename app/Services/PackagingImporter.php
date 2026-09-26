<?php

namespace App\Services;

use App\ProductTypes\PackagingConfigurable;
use Illuminate\Support\Facades\DB;
use Webkul\DataTransfer\Contracts\ImportBatch;
use Webkul\DataTransfer\Helpers\Import;
use Webkul\DataTransfer\Helpers\Importers\Product\Importer;
use Webkul\Product\Helpers\Indexers\Flat;

class PackagingImporter extends Importer
{
    public function importBatch(ImportBatch $batch): bool
    {
        if (config('packaging.enabled') && $batch->import->action !== Import::ACTION_DELETE) {
            $existing = $this->productRepository->findWhereIn('sku', array_column($batch->data, 'sku'))->pluck('sku')->all();
            $rows = $batch->data;

            foreach ($rows as &$row) {
                $row['_packaging_new'] = $row['_packaging_new'] ?? ! in_array($row['sku'], $existing, true);
            }
            unset($row);

            $batch = $this->importBatchRepository->update(['data' => $rows], $batch->id);
        }

        return parent::importBatch($batch);
    }

    public function indexBatch(ImportBatch $batch): bool
    {
        // Linking is complete by this stage: configurable children stay children.
        if (config('packaging.enabled')) {
            foreach ($batch->data as $row) {
                $product = $this->productRepository->findOneByField('sku', $row['sku']);

                if (! $product || $product->parent_id) {
                    continue;
                }

                $service = app(PackagingProducts::class);

                if (! empty($row['_packaging_new']) && $product->type === 'simple') {
                    DB::transaction(function () use ($product, $row, $service) {
                        $data = $service->prepareCreation([
                            'type' => 'simple', 'sku' => $product->sku,
                            'attribute_family_id' => $product->attribute_family_id,
                            'pack_unit_price' => $row['pack_unit_price'] ?? $product->price ?? 0,
                        ]);
                        DB::table('products')
                            ->where('id', $product->id)
                            ->update(['type' => 'configurable']);

                        $product->refresh();
                        app(PackagingConfigurable::class)->initializeImportedProduct($product, $data);
                        app(Flat::class)->refresh($product->fresh());
                    });
                } elseif ($service->isPackaging($product)) {
                    $product->getTypeInstance()->update([
                        'pack_unit_price' => $row['pack_unit_price'] ?? $row['price'] ?? $product->pack_unit_price,
                    ], $product->id, ['pack_unit_price']);
                    app(Flat::class)->refresh($product->fresh());
                }
            }
        }

        return parent::indexBatch($batch);
    }
}
