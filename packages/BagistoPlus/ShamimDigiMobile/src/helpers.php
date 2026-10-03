<?php

namespace BagistoPlus\ShamimDigiMobile;

if (! function_exists('_t')) {
    /**
     * A short for sections string localization
     */
    function _t(string $key, array $replace = [], ?string $locale = null): string
    {
        return __("shamim-digi-mobile::sections.$key", $replace, $locale);
    }
}
