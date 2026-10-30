<?php

namespace Webkul\Product\Helpers;

use Webkul\Product\Contracts\Product;

class VariantPrice
{
    /**
     * Derive variant prices exclusively from the configurable parent's unit price.
     */
    public function prepare(array $data, Product $parent, int $multiplier = 1): array
    {
        $multiplier = (int) ($data['price_multiplier'] ?? $multiplier);
        $price = round((float) $parent->price * $multiplier, 4);
        $discount = (float) $parent->variant_discount_percent;

        validator([
            'price_multiplier' => $multiplier,
            'price' => $price,
            'variant_discount_percent' => $discount,
        ], [
            'price_multiplier' => 'integer|min:1|max:1000000',
            'price' => 'numeric|min:0|max:99999999.9999',
            'variant_discount_percent' => 'numeric|min:0|max:99.99',
        ])->validate();

        return array_merge($data, [
            'price_multiplier' => $multiplier,
            'price' => $price,
            'special_price' => $discount > 0 ? round($price * (1 - $discount / 100), 4) : '',
            'special_price_from' => '',
            'special_price_to' => '',
        ]);
    }
}
