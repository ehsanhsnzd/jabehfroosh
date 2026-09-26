<?php

namespace App\ProductTypes;

use App\Services\PackagingProducts;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Webkul\Product\Type\Configurable;

class PackagingConfigurable extends Configurable
{
    public function initializeImportedProduct($product, array $data): void
    {
        $this->setProduct($product);
        $this->fillableVariantAttributes = $this->attributeRepository->findWhereIn('code', $this->fillableVariantAttributeCodes);

        foreach ($data['super_attributes'] as $code => $options) {
            $attribute = $this->attributeRepository->findOneByField('code', $code);
            $product->super_attributes()->syncWithoutDetaching([$attribute->id]);
            $this->fillableVariantAttributes->push($attribute);

            foreach ($options as $option) {
                $this->createVariant($product, [$code => $option]);
            }
        }

        $this->attributeValueRepository->saveValues($data, $product, $this->attributeRepository->findWhereIn('code', [PackagingProducts::UNIT_PRICE]));
        $product->refresh();
        $this->synchronizeVariants($product, $data);
    }

    public function create(array $data)
    {
        $product = parent::create($data);

        if (app(PackagingProducts::class)->isPackaging($product)) {
            $this->setProduct($product);
            $this->attributeValueRepository->saveValues($data, $product, $this->attributeRepository->findWhereIn('code', [PackagingProducts::UNIT_PRICE, 'name']));
            $product->refresh();
            $this->synchronizeVariants($product, $data);
        }

        return $product;
    }

    public function update(array $data, $id, $attributes = [])
    {
        $product = $this->productRepository->findOrFail($id);

        if (! app(PackagingProducts::class)->isPackaging($product)) {
            return parent::update($data, $id, $attributes);
        }

        return DB::transaction(function () use ($product, $data, $id, $attributes) {
            $unit = $data[PackagingProducts::UNIT_PRICE] ?? $product->{PackagingProducts::UNIT_PRICE} ?? 0;
            Validator::make(['unit_price' => $unit], ['unit_price' => 'required|numeric|min:0|max:99999'])->validate();
            $data[PackagingProducts::UNIT_PRICE] = $unit;
            // Generated variants cannot be deleted or repriced through an edited request.
            $data['variants'] = $this->variantData($product, $data);
            $result = parent::update($data, $id, $attributes);

            if ($attributes) {
                $this->synchronizeVariants($result->fresh(), $data);
            }

            return $result;
        });
    }

    protected function variantData($product, array $data): array
    {
        $service = app(PackagingProducts::class);
        $unit = (float) ($data[PackagingProducts::UNIT_PRICE] ?? $product->{PackagingProducts::UNIT_PRICE} ?? 0);
        $result = [];

        foreach ($product->variants as $variant) {
            $count = $service->multiplier($variant);
            $label = $count === 1 ? 'تعداد دلخواه' : $count.' عددی';
            $result[$variant->id] = array_merge($data['variants'][$variant->id] ?? [], [
                'sku' => $variant->sku,
                'name' => ($data['name'] ?? $product->name ?? $product->sku).' - '.$label,
                'price' => round($unit * $count, 4),
                'weight' => $data['variants'][$variant->id]['weight'] ?? $variant->weight ?? 0,
                'status' => (int) ($data['status'] ?? $product->status ?? 0),
                'manage_stock' => 0,
                'tax_category_id' => $data['tax_category_id'] ?? $product->tax_category_id,
            ]);
        }

        return $result;
    }

    protected function synchronizeVariants($product, array $data): void
    {
        $this->fillableVariantAttributes = $this->attributeRepository->findWhereIn('code', [...$this->fillableVariantAttributeCodes, 'manage_stock']);

        foreach ($this->variantData($product, $data) as $id => $variant) {
            $this->updateVariant($variant, $id);
        }
    }

    public function updateVariant(array $data, $id)
    {
        if (app(PackagingProducts::class)->isPackaging($this->product)) {
            $this->fillableVariantAttributes = $this->attributeRepository->findWhereIn('code', [...$this->fillableVariantAttributeCodes, 'manage_stock']);
        }

        return parent::updateVariant($data, $id);
    }

    public function prepareForCart($data)
    {
        if (app(PackagingProducts::class)->isPackaging($this->product)) {
            Validator::make($data, [
                'quantity' => 'required|integer|min:1|max:1000000',
                'selected_configurable_option' => 'required|integer',
            ])->validate();

            if (! $this->product->variants()->where('id', $data['selected_configurable_option'])->whereHas('attribute_values', fn ($query) => $query->whereHas('attribute', fn ($attribute) => $attribute->where('code', 'status'))->where('boolean_value', 1))->exists()) {
                return trans('product::app.checkout.cart.missing-options');
            }

            $variant = $this->product->variants->firstWhere('id', $data['selected_configurable_option']);
            Validator::make(['total' => $variant->price * $data['quantity']], ['total' => 'numeric|max:99999999'])->validate();
        }

        return parent::prepareForCart($data);
    }

    public function getTypeValidationRules()
    {
        return app(PackagingProducts::class)->isPackaging($this->product)
            ? [PackagingProducts::UNIT_PRICE => 'required|numeric|min:0|max:99999']
            : parent::getTypeValidationRules();
    }
}
