<?php

namespace BagistoPlus\ShamimVisual;

if (! function_exists('_t')) {
    /**
     * A short for sections string localization
     *
     * @param string $key
     * @param array $replace
     * @param string|null $locale
     * @return string
     */
    function _t(string $key, array $replace = [], ?string $locale = null): string
    {
        return __("shamim-visual::sections.$key", $replace, $locale);
    }
}
