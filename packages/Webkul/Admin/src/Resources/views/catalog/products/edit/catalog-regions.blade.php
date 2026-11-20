<div class="box-shadow rounded bg-white p-4 dark:bg-gray-900">
    <p class="mb-4 text-base font-semibold text-gray-800 dark:text-white">
        @lang('admin::catalog-regions.title')
    </p>

    @if (bouncer()->hasPermission('catalog.regions'))
        <a class="mb-4 inline-block text-sm text-blue-600" href="{{ route('admin.catalog.regions.index') }}">@lang('admin::catalog-regions.manage')</a>
    @endif

    <input type="hidden" name="catalog_regions_present" value="1">

    @php
        $product = $product ?? null;
        $selectedRegions = old('catalog_regions', $product?->catalog_regions ?: ($product?->parent?->catalog_regions ?? []));
        $selectedRegions = array_values(array_diff($selectedRegions, ['other']));
        $availableRegions = \Webkul\Product\Helpers\CatalogRegionSettings::visible('product');
        if (in_array('northwest', $selectedRegions)) {
            $selectedRegions = array_unique(array_merge($selectedRegions, ['tabriz', 'ardabil']));
        }
    @endphp

    @foreach (array_diff($selectedRegions, array_keys($availableRegions)) as $code)
        <input type="hidden" name="catalog_regions[]" value="{{ $code }}">
    @endforeach

    @foreach ($availableRegions as $code => $label)
        <label class="mb-3 flex cursor-pointer items-center gap-2 text-sm text-gray-600 dark:text-gray-300">
            <input
                type="checkbox"
                name="catalog_regions[]"
                value="{{ $code }}"
                @checked(in_array($code, $selectedRegions))
            >
            {{ $label }}
        </label>
    @endforeach

    <p class="text-xs text-gray-500 dark:text-gray-300">@lang('admin::catalog-regions.help')</p>
    <x-admin::form.control-group.error control-name="catalog_regions" />
</div>
