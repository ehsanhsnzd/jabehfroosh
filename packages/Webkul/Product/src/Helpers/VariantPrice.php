<?php

namespace Webkul\Product\Helpers;

use Webkul\Product\Contracts\Product;

class VariantPrice
{
    /**
     * Use an optional fixed price, otherwise derive the price from the parent.
     */
    public function prepare(array $data, Product $parent, int $multiplier = 1, $fixedPrice = null, $discountOverride = null): array
    {
        $fixedPrice = array_key_exists('variant_fixed_price', $data) ? $data['variant_fixed_price'] : $fixedPrice;
        $fixedPrice = $fixedPrice === '' ? null : $fixedPrice;
        $discountOverride = array_key_exists('variant_discount_override', $data) ? $data['variant_discount_override'] : $discountOverride;
        $discountOverride = $discountOverride === '' ? null : $discountOverride;

        validator([
            'variant_fixed_price' => $fixedPrice,
            'variant_discount_override' => $discountOverride,
        ], [
            'variant_fixed_price' => 'nullable|numeric|min:0|max:99999999.9999',
            'variant_discount_override' => 'nullable|numeric|min:0|max:99.99',
        ])->validate();

        $multiplier = (int) ($data['price_multiplier'] ?? $multiplier);
        $price = round($fixedPrice !== null ? (float) $fixedPrice : (float) $parent->price * $multiplier, 4);
        $discount = (float) $discountOverride > 0
            ? (float) $discountOverride
            : (float) $parent->variant_discount_percent;

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
            'variant_fixed_price' => $fixedPrice,
            'variant_discount_override' => $discountOverride,
            'price' => $price,
            'special_price' => $discount > 0 ? round($price * (1 - $discount / 100), 4) : '',
            'special_price_from' => '',
            'special_price_to' => '',
        ]);
    }
}
