<?php

namespace Webkul\Shop\CacheFilters;

use Illuminate\Support\Str;
use Intervention\Image\CachedImage;
use Intervention\Image\Interfaces\ImageInterface;

class Medium
{
    /**
     * Apply filter.
     *
     * @param  ImageInterface|CachedImage  $image
     * @return ImageInterface|CachedImage
     */
    public function applyFilter($image)
    {
        /**
         * If the current url is product image
         */
        if (Str::contains(url()->current(), '/product')) {
            $width = core()->getConfigData('catalog.products.cache_medium_image.width') != ''
                ? core()->getConfigData('catalog.products.cache_medium_image.width')
                : 700;

            $height = core()->getConfigData('catalog.products.cache_medium_image.height') != ''
                ? core()->getConfigData('catalog.products.cache_medium_image.height')
                : 700;

            return $image->contain((int) $width, (int) $height, 'ffffff');
        } elseif (Str::contains(url()->current(), '/category')) {
            return $image->cover(110, 110);
        } elseif (Str::contains(url()->current(), '/attribute_option')) {
            return $image->cover(210, 210);
        }

        /**
         * Slider image dimensions
         */
        return $image->cover(1024, 372);
    }
}
