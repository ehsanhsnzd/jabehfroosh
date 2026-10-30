<?php

namespace Webkul\Product\Helpers;

use Illuminate\Database\Eloquent\Builder;

class CatalogRegion
{
    /**
     * Unassigned products are available everywhere; variants inherit the parent.
     */
    public static function apply(Builder $query, ?string $region): Builder
    {
        if (! $region || ! array_key_exists($region, config('catalog-regions', []))) {
            return $query;
        }

        $column = $query->getModel()->qualifyColumn('catalog_regions');
        $parentColumn = $query->getModel()->qualifyColumn('parent_id');
        $regions = $region === 'northwest' ? ['northwest', 'tabriz', 'ardabil'] : [$region];

        return $query->where(function ($query) use ($column, $parentColumn, $regions) {
            $query->where(function ($query) use ($column, $regions) {
                foreach ($regions as $region) {
                    $query->orWhereJsonContains($column, $region);
                }
            })
                ->orWhere(function ($query) use ($column, $parentColumn, $regions) {
                    $query->where(fn ($query) => $query->whereNull($column)->orWhereJsonLength($column, 0))
                        ->where(function ($query) use ($parentColumn, $regions) {
                            $query->whereNull($parentColumn)
                                ->orWhereHas('parent', function ($query) use ($regions) {
                                    $query->whereNull('catalog_regions')
                                        ->orWhereJsonLength('catalog_regions', 0);

                                    foreach ($regions as $region) {
                                        $query->orWhereJsonContains('catalog_regions', $region);
                                    }
                                });
                        });
                });
        });
    }
}
