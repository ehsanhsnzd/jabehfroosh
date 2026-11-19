<?php

namespace Webkul\Product\Helpers;

use Webkul\Core\Repositories\CoreConfigRepository;

class CatalogRegionSettings
{
    public const CONFIG_CODE = 'catalog.regions.visibility';

    public static function labels(): array
    {
        return array_merge(config('catalog-provinces', []), config('catalog-regions', []));
    }

    public static function all(): array
    {
        $record = app(CoreConfigRepository::class)->getModel()->newQuery()
            ->where('code', self::CONFIG_CODE)->whereNull('channel_code')->whereNull('locale_code')->first();
        $stored = json_decode($record?->value ?? '{}', true) ?: [];
        $regions = [];

        foreach (self::labels() as $code => $label) {
            $legacy = array_key_exists($code, config('catalog-regions', []));
            $regions[$code] = [
                'label' => $label,
                'home' => (bool) ($stored[$code]['home'] ?? $legacy),
                'product' => $code !== 'northwest' && (bool) ($stored[$code]['product'] ?? $legacy),
            ];
        }

        return $regions;
    }

    public static function visible(string $surface): array
    {
        return collect(self::all())->filter(fn ($region) => $region[$surface])->map(fn ($region) => $region['label'])->all();
    }

    public static function save(array $home, array $product): void
    {
        $settings = [];
        foreach (self::labels() as $code => $label) {
            $settings[$code] = ['home' => in_array($code, $home, true), 'product' => in_array($code, $product, true)];
        }

        app(CoreConfigRepository::class)->getModel()->newQuery()->updateOrCreate([
            'code' => self::CONFIG_CODE, 'channel_code' => null, 'locale_code' => null,
        ], ['value' => json_encode($settings, JSON_THROW_ON_ERROR)]);
    }
}
