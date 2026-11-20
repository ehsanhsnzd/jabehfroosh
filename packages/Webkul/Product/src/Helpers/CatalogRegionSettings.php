<?php

namespace Webkul\Product\Helpers;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Webkul\Core\Repositories\CoreConfigRepository;

class CatalogRegionSettings
{
    public const CUSTOM_CODE = 'catalog.regions.custom';

    public const CONFIG_CODE = 'catalog.regions.visibility';

    public static function labels(): array
    {
        return array_merge(config('catalog-provinces', []), config('catalog-regions', []), self::custom());
    }

    public static function custom(): array
    {
        $record = app(CoreConfigRepository::class)->getModel()->newQuery()
            ->where('code', self::CUSTOM_CODE)->whereNull('channel_code')->whereNull('locale_code')->first();

        return json_decode($record?->value ?? '{}', true) ?: [];
    }

    public static function add(string $name): string
    {
        $normalize = fn ($value) => preg_replace('/\s+/u', ' ', strtr(trim($value), ['ي' => 'ی', 'ك' => 'ک']));
        $name = $normalize($name);
        validator(['region_name' => $name], ['region_name' => 'required|string|min:2|max:100'])->validate();

        return DB::transaction(function () use ($name, $normalize) {
            $records = app(CoreConfigRepository::class)->getModel();
            $record = $records->newQuery()->firstOrCreate([
                'code' => self::CUSTOM_CODE, 'channel_code' => null, 'locale_code' => null,
            ], ['value' => '{}']);
            $record = $records->newQuery()->whereKey($record->id)->lockForUpdate()->firstOrFail();
            $cities = json_decode($record->value, true) ?: [];
            foreach (array_merge(config('catalog-provinces', []), config('catalog-regions', []), $cities) as $label) {
                if (mb_strtolower($normalize($label)) === mb_strtolower($name)) {
                    throw ValidationException::withMessages(['region_name' => trans('admin::catalog-regions.duplicate-city')]);
                }
            }
            $code = 'city_'.Str::uuid();
            $cities[$code] = $name;
            $record->update(['value' => json_encode($cities, JSON_THROW_ON_ERROR)]);

            return $code;
        });
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
                'product' => ! in_array($code, ['northwest', 'other']) && (bool) ($stored[$code]['product'] ?? $legacy),
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
