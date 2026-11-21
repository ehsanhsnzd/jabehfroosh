<?php

namespace Webkul\Shop\Helpers;

use Illuminate\Validation\ValidationException;
use Webkul\Product\Helpers\CatalogRegion;
use Webkul\Product\Helpers\CatalogRegionSettings;
use Webkul\Product\Repositories\ProductRepository;

class CartRegionAvailability
{
    public function availableItemIds($cart, ?string $region): array
    {
        if (! $region) {
            return $cart->items->pluck('id')->all();
        }

        return $this->matchingItems($cart, [$region])->pluck('id')->all();
    }

    private function matchingItems($cart, array $regions)
    {
        $items = $cart->items;
        $items->loadMissing('children');
        $productIds = $items->flatMap(fn ($item) => [$item->product_id, ...$item->children->pluck('product_id')->all()])->unique()->all();
        $query = app(ProductRepository::class)->getModel()->newQuery()->whereKey($productIds);
        $query->where(function ($query) use ($regions) {
            foreach ($regions as $region) {
                $query->orWhere(fn ($query) => CatalogRegion::apply($query, $region));
            }
        });
        $allowed = $query->pluck('id')->all();

        return $items->filter(function ($item) use ($allowed) {
            $ids = $item->type === 'configurable' && $item->children->isNotEmpty()
                ? $item->children->pluck('product_id')->all()
                : [$item->product_id, ...$item->children->pluck('product_id')->all()];

            return ! array_diff($ids, $allowed);
        });
    }

    public function validateAddress($cart, array $address): void
    {
        if (! $cart || ! $cart->haveStockableItems()) {
            return;
        }
        $normalize = fn ($value) => preg_replace('/[\s\x{200c}]+/u', '', strtr(trim((string) $value), ['ي' => 'ی', 'ك' => 'ک']));
        $regions = [];
        if (($address['country'] ?? 'IR') === 'IR') {
            foreach (CatalogRegionSettings::labels() as $code => $label) {
                if (in_array($code, ['other', 'northwest'])) {
                    continue;
                }
                $field = array_key_exists($code, config('catalog-provinces', [])) && ! array_key_exists($code, config('catalog-regions', [])) ? 'state' : 'city';
                if ($normalize($address[$field] ?? '') === $normalize($label)) {
                    $regions[] = $code;
                }
            }
        }
        $allowed = $this->matchingItems($cart, $regions ?: ['other'])->pluck('id')->all();
        $blocked = $cart->items->whereNotIn('id', $allowed);
        if ($blocked->isNotEmpty()) {
            throw ValidationException::withMessages([
                'shipping.city' => trans('shop::delivery.address-unavailable', ['products' => $blocked->pluck('name')->implode('، ')]),
            ]);
        }
    }

    public function validateSavedAddress($cart): void
    {
        if ($cart?->shipping_address) {
            $this->validateAddress($cart, $cart->shipping_address->toArray());
        }
    }
}
