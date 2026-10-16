@php
    $brandName = $section->settings->get('logo_text') ?: ($section->settings->logo_text ?: config('app.name'));
    $searchPlaceholder = $section->settings->get('search_placeholder') ?: ($section->settings->search_placeholder ?: 'جستجو در محصولات...');
    $notificationUrl = auth()->guard('customer')->check()
        ? route('shop.customers.account.orders.index')
        : route('shop.customer.session.create');
    $logoUrl = core()->getCurrentChannel()->logo_url ?? asset('themes/shop/shamim-pack/images/jabehfroosh-logo-professional-v2.png');
    $isHome = request()->routeIs('shop.home.index');

    $resolveImageUrl = function ($img) {
        if (! $img) {
            return null;
        }
        if ($img instanceof \BagistoPlus\Visual\Settings\Support\ImageValue) {
            return (string) $img;
        }
        $str = trim((string) $img);
        if ($str === '') {
            return null;
        }
        if (str_starts_with($str, 'http://') || str_starts_with($str, 'https://')) {
            return $str;
        }
        if (str_starts_with($str, 'bagisto-visual/')) {
            return \Illuminate\Support\Facades\Storage::disk(config('bagisto_visual.images_storage', 'public'))->url($str);
        }
        return asset($str);
    };

    // First tab (Categories)
    $showCategoriesTab = true;
    $categoriesTabTitle = 'دسته‌بندی';
    $categoriesTabUrl = route('shop.search.index');
    $categoriesTabImage = null;

    // Second tab (Brand)
    $showBrandTab = true;
    $brandTabTitle = $brandName;
    $brandTabUrl = route('shop.home.index');
    $brandTabImage = $logoUrl;

    if (isset($megaMenuBlock) && $megaMenuBlock) {
        $ms = $megaMenuBlock->settings;

        $catShow = $ms->get('show_categories_tab');
        if ($catShow !== null) {
            $showCategoriesTab = (bool) $catShow;
        }
        $catTitle = $ms->get('categories_tab_title');
        if (! empty($catTitle)) {
            $categoriesTabTitle = $catTitle;
        }
        $catUrl = $ms->get('categories_tab_url');
        if (! empty($catUrl)) {
            $categoriesTabUrl = url($catUrl);
        }
        $catImg = $ms->get('categories_tab_image');
        if (! empty($catImg)) {
            $categoriesTabImage = $resolveImageUrl($catImg);
        }

        $brShow = $ms->get('show_brand_tab');
        if ($brShow !== null) {
            $showBrandTab = (bool) $brShow;
        }
        $brTitle = $ms->get('brand_tab_title');
        if (! empty($brTitle)) {
            $brandTabTitle = $brTitle;
        }
        $brUrl = $ms->get('brand_tab_url');
        if (! empty($brUrl)) {
            $brandTabUrl = url($brUrl);
        }
        $brImg = $ms->get('brand_tab_image');
        if (! empty($brImg)) {
            $resolvedBrandImg = $resolveImageUrl($brImg);
            if ($resolvedBrandImg) {
                $brandTabImage = $resolvedBrandImg;
            }
        }
    }
@endphp

<div class="sh-digi-mobile-header" aria-label="دسترسی سریع فروشگاه">
    <nav class="sh-digi-tabs-wrap" aria-label="دسته‌بندی محصولات">
        <div class="sh-digi-tabs" role="list">
            @if ($showCategoriesTab)
                <a href="{{ $categoriesTabUrl }}" class="sh-digi-tab" aria-label="{{ $categoriesTabTitle }}" role="listitem">
                    <span class="sh-digi-tab__icon" aria-hidden="true">
                        @if (!empty($categoriesTabImage))
                            <img src="{{ $categoriesTabImage }}" alt="{{ $categoriesTabTitle }}">
                        @else
                            <svg width="27" height="27" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
                            </svg>
                        @endif
                    </span>
                    <span class="sh-digi-tab__label">{{ $categoriesTabTitle }}</span>
                </a>
            @endif

            @if ($showBrandTab)
                <a href="{{ $brandTabUrl }}" @class(['sh-digi-tab', 'sh-digi-tab--active' => $isHome]) aria-current="{{ $isHome ? 'page' : 'false' }}" role="listitem">
                    <span class="sh-digi-tab__icon"><img src="{{ $brandTabImage }}" alt="{{ $brandTabTitle }}"></span>
                    <span class="sh-digi-tab__label">{{ $brandTabTitle }}</span>
                </a>
            @endif

            @foreach ($catalogItems as $item)
                @php
                    $isActive = request()->path() === ltrim($item['url'], '/');
                    $resolvedItemImg = !empty($item['image']) ? $resolveImageUrl($item['image']) : null;
                @endphp
                <a href="{{ url($item['url']) }}" @class(['sh-digi-tab', 'sh-digi-tab--active' => $isActive]) aria-current="{{ $isActive ? 'page' : 'false' }}" role="listitem">
                    <span class="sh-digi-tab__icon" aria-hidden="true">
                        @if ($resolvedItemImg)
                            <img src="{{ $resolvedItemImg }}" alt="{{ $item['title'] }}" loading="lazy">
                        @else
                            {{ $item['icon'] ?? '▦' }}
                        @endif
                    </span>
                    <span class="sh-digi-tab__label">{{ $item['title'] }}</span>
                </a>
            @endforeach
        </div>
    </nav>

    <div class="sh-digi-mobile-header__toolbar">
        <form action="{{ route('shop.search.index') }}" class="sh-digi-search" role="search">
            <label class="sr-only" for="sh-digi-mobile-search">@lang('shop::app.components.layouts.header.mobile.search')</label>
            <button type="submit" class="sh-digi-search__icon" aria-label="@lang('shop::app.components.layouts.header.mobile.search')"><span class="icon-search text-xl"></span></button>
            <input id="sh-digi-mobile-search" type="search" name="query" value="{{ request('query') }}" class="sh-digi-search__input" placeholder="{{ $searchPlaceholder }}" autocomplete="off">
        </form>

        <a href="{{ $notificationUrl }}" class="sh-digi-notify" aria-label="اعلان‌ها">
            <svg width="25" height="25" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M15 17h5l-1.4-1.4A2 2 0 0 1 18 14.2V11a6 6 0 1 0-12 0v3.2c0 .5-.2 1-.6 1.4L4 17h5m6 0a3 3 0 0 1-6 0m6 0H9"/>
            </svg>
        </a>
    </div>
</div>
