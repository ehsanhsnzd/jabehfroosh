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
        if (! $region || ! array_key_exists($region, CatalogRegionSettings::labels())) {
            return $query;
        }

        $column = $query->getModel()->qualifyColumn('catalog_regions');
        $parentColumn = $query->getModel()->qualifyColumn('parent_id');
        $regions = match ($region) {
            'northwest' => ['northwest', 'tabriz', 'ardabil'],
            'other' => [],
            default => [$region],
        };
        $unassigned = fn ($query, $field) => $query->whereNull($field)->orWhereJsonLength($field, 0)
            ->orWhere(fn ($query) => $query->whereJsonLength($field, 1)->whereJsonContains($field, 'other'));

        return $query->where(function ($query) use ($column, $parentColumn, $regions, $unassigned) {
            foreach ($regions as $region) {
                $query->orWhereJsonContains($column, $region);
            }
            $query->orWhere(function ($query) use ($column, $parentColumn, $regions, $unassigned) {
                $query->where(fn ($query) => $unassigned($query, $column))
                    ->where(function ($query) use ($parentColumn, $regions, $unassigned) {
                        $query->whereNull($parentColumn)
                            ->orWhereHas('parent', function ($query) use ($regions, $unassigned) {
                                $unassigned($query, 'catalog_regions');
                                foreach ($regions as $region) {
                                    $query->orWhereJsonContains('catalog_regions', $region);
                                }
                            });
                    });
            });
        });
    }
}
