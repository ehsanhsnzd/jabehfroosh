<?php

namespace App\ProductTypes;

use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;
use Webkul\Checkout\Contracts\CartItem;
use Webkul\Product\DataTypes\CartItemValidationResult;
use Webkul\Product\Type\Simple;

class PackagingSimple extends Simple
{
    public function create(array $data)
    {
        $product = parent::create($data);

        if (config('packaging.enabled') && ! empty($data['packaging_product']) && ! $product->parent_id) {
            $attributes = $this->attributeRepository->findWhereIn('code', ['name', 'price']);
            $this->attributeValueRepository->saveValues($data, $product, $attributes);
        }

        return $product->refresh();
    }

    public function prepareForCart($data)
    {
        if (
            config('packaging.enabled')
            && ! $this->product->parent_id
            && (isset($data['packaging_selection']) || isset($data['packaging_size']))
        ) {
            $data['quantity'] = $data['packaging_size'] = $this->resolveQuantity($data);

            Validator::make([
                'total' => (float) $this->product->price * $data['quantity'],
            ], [
                'total' => 'numeric|max:'.config('packaging.maximum_total'),
            ])->validate();

        }

        return parent::prepareForCart($data);
    }

    public function validateCartItem(CartItem $item): CartItemValidationResult
    {
        if (config('packaging.enabled') && ! empty($item->additional['packaging_size'])) {
            $packagingSize = (int) $item->additional['packaging_size'];

            Validator::make([
                'quantity' => $item->quantity,
                'packaging_size' => $packagingSize,
                'total' => (float) $this->product->price * $item->quantity,
            ], [
                'quantity' => 'required|integer|min:1|max:'.config('packaging.maximum_quantity'),
                'packaging_size' => 'required|integer|min:1|max:'.config('packaging.maximum_quantity'),
                'total' => 'numeric|max:'.config('packaging.maximum_total'),
            ])->validate();

            if ($item->quantity % $packagingSize !== 0) {
                throw ValidationException::withMessages([
                    'quantity' => 'تعداد سفارش باید مضربی از تعداد داخل بسته باشد.',
                ]);
            }

        }

        return parent::validateCartItem($item);
    }

    public function preparePackagingUpdate(CartItem $item): void
    {
        $packagingSize = (int) ($item->additional['packaging_size'] ?? 0);

        if (! $packagingSize) {
            return;
        }

        if ($item->quantity % $packagingSize !== 0) {
            throw ValidationException::withMessages([
                'quantity' => 'تعداد سفارش باید مضربی از تعداد داخل بسته باشد.',
            ]);
        }

        $additional = $item->additional;
        $additional['quantity'] = $item->quantity;
        $additional['attributes'] = $this->packagingAttributes($packagingSize, $item->quantity);
        $item->additional = $additional;
    }

    public function showQuantityBox()
    {
        if (config('packaging.enabled') && $this->product && ! $this->product->parent_id) {
            return false;
        }

        return parent::showQuantityBox();
    }

    public function getAdditionalOptions($data)
    {
        $data = parent::getAdditionalOptions($data);

        if (! empty($data['packaging_size'])) {
            $data['attributes'] = [
                ...($data['attributes'] ?? []),
                ...$this->packagingAttributes((int) $data['packaging_size'], (int) $data['quantity']),
            ];
        }

        return $data;
    }

    public function compareOptions($options1, $options2)
    {
        if (
            isset($options1['packaging_size'])
            || isset($options2['packaging_size'])
        ) {
            if (($options1['packaging_size'] ?? null) != ($options2['packaging_size'] ?? null)) {
                return false;
            }
        }

        return parent::compareOptions($options1, $options2);
    }

    protected function resolveQuantity(array $data): int
    {
        $selection = $data['packaging_selection'] ?? null;

        if ($selection === 'custom') {
            $quantity = $data['custom_quantity'] ?? null;
        } elseif ($selection !== null) {
            Validator::make(['selection' => $selection], [
                'selection' => ['required', 'integer', 'in:'.implode(',', config('packaging.quantities'))],
            ])->validate();

            $quantity = $selection;
        } else {
            $quantity = $data['quantity'] ?? 1;
        }

        Validator::make(['quantity' => $quantity], [
            'quantity' => 'required|integer|min:1|max:'.config('packaging.maximum_quantity'),
        ])->validate();

        return (int) $quantity;
    }

    protected function packagingAttributes(int $packagingSize, int $quantity): array
    {
        $packagingCount = intdiv($quantity, $packagingSize);

        return [[
            'attribute_name' => 'بسته‌بندی تولید',
            'option_label' => "{$packagingCount} بسته × {$packagingSize} عدد = {$quantity} عدد کل",
        ]];
    }
}
