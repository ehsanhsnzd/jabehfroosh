<x-admin::layouts>
    <x-slot:title>@lang('admin::catalog-regions.title')</x-slot>

    <form method="POST" action="{{ route('admin.catalog.regions.update') }}">
        @csrf
        @method('PUT')

        <div class="mb-6 flex items-center justify-between gap-4">
            <h1 class="text-xl font-bold">@lang('admin::catalog-regions.title')</h1>
            <button type="submit" class="primary-button">@lang('admin::catalog-regions.save')</button>
        </div>

        <p class="mb-4 text-sm text-gray-600 dark:text-gray-300">@lang('admin::catalog-regions.settings-help')</p>

        @if ($errors->any())
            <div class="mb-4 text-red-600">{{ $errors->first() }}</div>
        @endif

        @foreach (['provinces' => config('catalog-provinces'), 'legacy' => array_diff_key(config('catalog-regions'), config('catalog-provinces'))] as $section => $options)
            <div class="box-shadow mb-5 overflow-x-auto rounded bg-white p-4 dark:bg-gray-900">
                <h2 class="mb-4 text-base font-semibold">@lang('admin::catalog-regions.'.$section)</h2>
                <table class="w-full text-sm">
                    <thead>
                        <tr class="border-b dark:border-gray-800">
                            <th class="p-3 text-start">@lang('admin::catalog-regions.province')</th>
                            <th class="p-3 text-center">@lang('admin::catalog-regions.home-visible')</th>
                            <th class="p-3 text-center">@lang('admin::catalog-regions.product-visible')</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($options as $code => $label)
                            <tr class="border-b last:border-0 dark:border-gray-800">
                                <td class="p-3">{{ $label }}</td>
                                @foreach (['home', 'product'] as $surface)
                                    <td class="p-3 text-center">
                                        @if ($surface !== 'product' || $code !== 'northwest')
                                            <input
                                                type="checkbox"
                                                name="{{ $surface }}[]"
                                                value="{{ $code }}"
                                                aria-label="{{ $label }} — {{ trans('admin::catalog-regions.'.$surface.'-visible') }}"
                                                @checked($errors->any() ? in_array($code, old($surface, [])) : $regions[$code][$surface])
                                            >
                                        @endif
                                    </td>
                                @endforeach
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        @endforeach
    </form>
</x-admin::layouts>
