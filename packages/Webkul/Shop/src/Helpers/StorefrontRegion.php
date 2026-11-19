<?php

namespace Webkul\Shop\Helpers;

use Webkul\Product\Helpers\CatalogRegionSettings;

class StorefrontRegion
{
    public static function selected(): ?string
    {
        $region = request()->hasSession() ? request()->session()->get('catalog_region') : null;

        return is_string($region) && array_key_exists($region, CatalogRegionSettings::visible('home')) ? $region : null;
    }
}
