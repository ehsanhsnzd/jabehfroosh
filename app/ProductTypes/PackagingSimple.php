<?php

namespace App\ProductTypes;

use Illuminate\Support\Facades\Validator;
use Webkul\Checkout\Contracts\CartItem;
use Webkul\Product\DataTypes\CartItemValidationResult;
use Webkul\Product\Type\Simple;

class PackagingSimple extends Simple
{
    protected $showQuantityBox = false;

    public function create(array $data)
    {
        $product = parent::create($data);

        if (config('packaging.enabled') && ! $product->parent_id) {
            $attributes = $this->attributeRepository->findWhereIn('code', ['name', 'price']);
            $this->attributeValueRepository->saveValues($data, $product, $attributes);
        }

        return $product->refresh();
    }

    public function prepareForCart($data)
    {
        if (config('packaging.enabled') && ! $this->product->parent_id) {
            $data['quantity'] = $this->resolveQuantity($data);

            Validator::make([
                'total' => (float) $this->product->price * $data['quantity'],
            ], [
                'total' => 'numeric|max:'.config('packaging.maximum_total'),
            ])->validate();

            $data['packaging_quantity'] = $data['quantity'];
        }

        return parent::prepareForCart($data);
    }

    public function validateCartItem(CartItem $item): CartItemValidationResult
    {
        if (config('packaging.enabled') && ! $this->product->parent_id) {
            Validator::make([
                'quantity' => $item->quantity,
                'total' => (float) $this->product->price * $item->quantity,
            ], [
                'quantity' => 'required|integer|min:1|max:'.config('packaging.maximum_quantity'),
                'total' => 'numeric|max:'.config('packaging.maximum_total'),
            ])->validate();
        }

        return parent::validateCartItem($item);
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
}
