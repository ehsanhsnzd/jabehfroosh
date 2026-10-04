@php
    $brandName = $section->settings->logo_text ?: config('app.name');
    $searchPlaceholder = $section->settings->search_placeholder ?: 'جستجو در محصولات...';
    $notificationUrl = auth()->guard('customer')->check()
        ? route('shop.customers.account.orders.index')
        : route('shop.customer.session.create');
    $logoUrl = core()->getCurrentChannel()->logo_url ?? asset('themes/shop/shamim-pack/images/jabehfroosh-logo-professional-v2.png');
    $isHome = request()->routeIs('shop.home.index');
    $catalogIcons = [
        '/pizza-boxes' => '🍕',
        '/burger-boxes' => '🍔',
        '/sandwich-boxes' => '🥪',
        '/fried-chicken-boxes' => '🍗',
        '/french-fries-boxes' => '🍟',
        '/takeaway-food-boxes' => '🍱',
        '/fried-chicken-buckets' => '🪣',
        '/disposable-food-containers' => '🥡',
        '/disposable-cups' => '🥤',
        '/cutlery-packs' => '🍴',
        '/disposable-tablecloths' => '🧻',
        '/pizza-boards' => '⭕',
        '/takeaway-bags' => '🛍️',
        '/sandwich-wrapping-paper' => '📜',
        '/single-serve-sachets' => '🧴',
        '/nuts-packaging' => '🥜',
        '/ice-cream-packaging' => '🍨',
    ];
@endphp

<div class="sh-digi-mobile-header" aria-label="دسترسی سریع فروشگاه">
    <nav class="sh-digi-tabs-wrap" aria-label="دسته‌بندی محصولات">
        <div class="sh-digi-tabs" role="list">
            <a href="{{ route('shop.search.index') }}" class="sh-digi-tab" aria-label="همه دسته‌بندی‌ها" role="listitem">
                <span class="sh-digi-tab__icon" aria-hidden="true">
                    <svg width="27" height="27" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
                    </svg>
                </span>
                <span class="sh-digi-tab__label">دسته‌بندی</span>
            </a>

            <a href="{{ route('shop.home.index') }}" @class(['sh-digi-tab', 'sh-digi-tab--active' => $isHome]) aria-current="{{ $isHome ? 'page' : 'false' }}" role="listitem">
                <span class="sh-digi-tab__icon"><img src="{{ $logoUrl }}" alt=""></span>
                <span class="sh-digi-tab__label">{{ $brandName }}</span>
            </a>

            @foreach ($catalogItems as $item)
                @php($isActive = request()->path() === ltrim($item['url'], '/'))
                <a href="{{ url($item['url']) }}" @class(['sh-digi-tab', 'sh-digi-tab--active' => $isActive]) aria-current="{{ $isActive ? 'page' : 'false' }}" role="listitem">
                    <span class="sh-digi-tab__icon" aria-hidden="true">{{ $catalogIcons[$item['url']] ?? '▦' }}</span>
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
