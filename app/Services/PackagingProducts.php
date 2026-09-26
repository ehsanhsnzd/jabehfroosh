<?php

namespace App\Services;

use App\ProductTypes\PackagingConfigurable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Webkul\Attribute\Repositories\AttributeFamilyRepository;
use Webkul\Attribute\Repositories\AttributeOptionRepository;
use Webkul\Attribute\Repositories\AttributeRepository;
use Webkul\Product\Helpers\Indexers\Flat;

class PackagingProducts
{
    public const ATTRIBUTE = 'pack_quantity';

    public const UNIT_PRICE = 'pack_unit_price';

    public function isPackaging($product): bool
    {
        return $product->type === 'configurable'
            && $product->super_attributes->contains('code', self::ATTRIBUTE);
    }

    public function prepareCreation(array $data): array
    {
        if (! config('packaging.enabled') || ! empty($data['parent_id']) || ($data['type'] ?? 'simple') !== 'simple') {
            return $data;
        }

        Validator::make(['unit_price' => $data[self::UNIT_PRICE] ?? $data['price'] ?? 0], [
            'unit_price' => 'required|numeric|min:0|max:99999',
        ])->validate();

        $attributes = app(AttributeRepository::class);
        $pack = $attributes->findOneByField('code', self::ATTRIBUTE)
            ?? $attributes->create([
                'code' => self::ATTRIBUTE, 'admin_name' => 'تعداد در بسته',
                'type' => 'select', 'swatch_type' => 'text', 'is_configurable' => 1,
                'is_user_defined' => 0,
            ]);
        $unit = $attributes->findOneByField('code', self::UNIT_PRICE)
            ?? $attributes->create([
                'code' => self::UNIT_PRICE, 'admin_name' => 'قیمت هر عدد',
                'type' => 'price', 'is_required' => 0, 'is_user_defined' => 0,
                'value_per_channel' => 0, 'value_per_locale' => 0,
            ]);

        $family = app(AttributeFamilyRepository::class)->findOrFail($data['attribute_family_id']);
        $group = $family->attribute_groups()->firstOrCreate(['code' => 'packaging'], [
            'name' => 'بسته‌بندی', 'column' => 1, 'position' => 100, 'is_user_defined' => 0,
        ]);
        $group->custom_attributes()->syncWithoutDetaching([
            $pack->id => ['position' => 1], $unit->id => ['position' => 2],
        ]);

        $options = app(AttributeOptionRepository::class);
        $ids = [];

        foreach ([...config('packaging.quantities'), 'custom'] as $position => $count) {
            $option = $options->findOneWhere(['attribute_id' => $pack->id, 'admin_name' => (string) $count]);

            if (! $option) {
                $input = ['attribute_id' => $pack->id, 'admin_name' => (string) $count, 'sort_order' => $position];

                foreach (core()->getAllLocales() as $locale) {
                    $input[$locale->code] = ['label' => $count === 'custom'
                        ? ($locale->code === 'fa' ? 'تعداد دلخواه' : 'Custom quantity')
                        : (string) $count];
                }

                $option = $options->create($input);
            }

            $ids[] = $option->id;
        }

        $data['type'] = 'configurable';
        $data['sku'] = $data['sku'] ?? 'pack-'.Str::lower((string) Str::ulid());
        $data['super_attributes'] = [self::ATTRIBUTE => $ids];
        $data[self::UNIT_PRICE] = $data[self::UNIT_PRICE] ?? $data['price'] ?? 0;

        return $data;
    }

    public function multiplier($variant): int
    {
        $optionId = $variant->{self::ATTRIBUTE} ?: $variant->attribute_values()
            ->whereHas('attribute', fn ($query) => $query->where('code', self::ATTRIBUTE))
            ->value('integer_value');

        $option = app(AttributeOptionRepository::class)->find($optionId);

        return $option?->admin_name === 'custom' ? 1 : (int) $option?->admin_name;
    }

    public function synchronize($product): bool
    {
        $product->refresh();

        if (! $this->isPackaging($product)) {
            return false;
        }

        $product->getTypeInstance()->update([
            self::UNIT_PRICE => $product->{self::UNIT_PRICE} ?? 0,
        ], $product->id, [self::UNIT_PRICE]);

        app(Flat::class)->refresh($product->fresh());

        return true;
    }

    public function convert($product): bool
    {
        $product->refresh();

        if ($product->parent_id || $product->type !== 'simple') {
            return false;
        }

        DB::transaction(function () use ($product) {
            $data = $this->prepareCreation([
                'type' => 'simple',
                'sku' => $product->sku,
                'name' => $product->name,
                'attribute_family_id' => $product->attribute_family_id,
                self::UNIT_PRICE => $product->price ?? 0,
            ]);

            DB::table('products')
                ->where('id', $product->id)
                ->update(['type' => 'configurable']);

            $product->refresh();
            app(PackagingConfigurable::class)->initializeImportedProduct($product, $data);
            app(Flat::class)->refresh($product->fresh());
        });

        return true;
    }
}
