<?php

namespace Webkul\Shop\Helpers;

class StorefrontRegion
{
    public static function selected(): ?string
    {
        $region = request()->hasSession() ? request()->session()->get('catalog_region') : null;

        return is_string($region) && array_key_exists($region, config('catalog-regions', [])) ? $region : null;
    }
}
