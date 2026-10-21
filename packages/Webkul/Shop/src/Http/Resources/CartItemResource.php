<?php

namespace Webkul\Shop\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use Webkul\Attribute\Repositories\AttributeOptionRepository;

class CartItemResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  Request
     * @return array
     */
    public function toArray($request)
    {
        $packagingSize = (int) ($this->resource->additional['packaging_size'] ?? 0);
        $saleUnit = $this->getSaleUnit();

        return [
            'id' => $this->id,
            'quantity' => $this->quantity,
            'type' => $this->type,
            'name' => $this->name,
            'price' => $this->price,
            'formatted_price' => core()->formatPrice($this->price),
            'price_incl_tax' => $this->price_incl_tax,
            'formatted_price_incl_tax' => core()->formatPrice($this->price_incl_tax),
            'total' => $this->total,
            'formatted_total' => core()->formatPrice($this->total),
            'total_incl_tax' => $this->total_incl_tax,
            'formatted_total_incl_tax' => core()->formatPrice($this->total_incl_tax),
            'discount_amount' => $this->discount_amount,
            'formatted_discount_amount' => core()->formatPrice($this->discount_amount),
            'base_image' => $this->getTypeInstance()->getBaseImage($this),
            'product_url_key' => $this->product->url_key,
            'options' => $this->formatAdditionalAttributes(),
            'can_change_qty' => $this->product ? $this->product->getTypeInstance()->showQuantityBox() : false,
            'packaging_size' => $packagingSize ?: null,
            'packaging_count' => $packagingSize ? intdiv((int) $this->quantity, $packagingSize) : null,
            'packaging_price' => $packagingSize ? (float) $this->price * $packagingSize : null,
            'formatted_packaging_price' => $packagingSize ? core()->formatPrice($this->price * $packagingSize) : null,
            'packaging_price_incl_tax' => $packagingSize ? (float) $this->price_incl_tax * $packagingSize : null,
            'formatted_packaging_price_incl_tax' => $packagingSize ? core()->formatPrice($this->price_incl_tax * $packagingSize) : null,
            'sale_unit' => $saleUnit,
            'unit_price_label' => 'قیمت هر '.$saleUnit,
        ];
    }

    /**
     * Resolve the product's manually selected sale unit for cart presentation.
     */
    protected function getSaleUnit(): string
    {
        $saleUnitOptionId = $this->resource->product?->sale_unit;

        if (! $saleUnitOptionId) {
            return 'عدد';
        }

        $option = app(AttributeOptionRepository::class)->find($saleUnitOptionId);

        return $option?->label ?: $option?->admin_name ?: 'عدد';
    }

    /**
     * Format the additional attributes.
     */
    public function formatAdditionalAttributes(): array
    {
        $attributes = $this->resource->additional['attributes'] ?? [];

        if (! empty($attributes)) {
            return collect($attributes)
                ->map(function ($attribute) {
                    if (
                        isset($attribute['attribute_type'])
                        && $attribute['attribute_type'] == 'file'
                    ) {
                        $attribute['file_name'] = File::basename($attribute['option_label']);

                        $attribute['file_url'] = Storage::url($attribute['option_label']);
                    }

                    return $attribute;
                })
                ->values()
                ->toArray();
        }

        return [];
    }
}
