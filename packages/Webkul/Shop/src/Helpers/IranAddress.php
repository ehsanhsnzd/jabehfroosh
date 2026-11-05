<?php

namespace Webkul\Shop\Helpers;

class IranAddress
{
    public static function provinces(): array
    {
        static $provinces;

        return $provinces ??= json_decode(file_get_contents(__DIR__.'/../Resources/data/iran-addresses.json'), true, flags: JSON_THROW_ON_ERROR)['provinces'];
    }

    public static function cities(?string $province): array
    {
        foreach (static::provinces() as $entry) {
            if ($entry['name'] === $province) {
                return $entry['cities'];
            }
        }

        return [];
    }
}
