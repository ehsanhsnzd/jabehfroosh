@php
    $brandName = $section->settings->get('logo_text') ?: ($section->settings->logo_text ?: config('app.name'));
    $searchPlaceholder = $section->settings->get('search_placeholder') ?: ($section->settings->search_placeholder ?: 'جستجو در محصولات...');
    $notificationUrl = auth()->guard('customer')->check()
        ? route('shop.customers.account.orders.index')
        : route('shop.customer.session.create');
    $logoUrl = core()->getCurrentChannel()->logo_url ?? asset('themes/shop/shamim-pack/images/jabehfroosh-logo-professional-v2.png');
    $isHome = request()->routeIs('shop.home.index');
    $selectedRegion = \Webkul\Shop\Helpers\StorefrontRegion::selected();
    $quickLinks = collect($section->blocks)->where('type', 'quick_link')->map(fn ($block) => [
        'title' => $block->settings->get('title'),
        'url' => $block->settings->get('url') ?: '/search',
    ])->filter(fn ($link) => filled($link['title']))->values()->all();

    if (! $quickLinks) {
        $quickLinkLines = $section->settings->get('quick_links')
            ?? "همه|/search\nکاغذ ساندویچ|/sandwich-wrapping-paper\nسینگل|/pizza-boards\nسطل کنتاکی|/fried-chicken-buckets\nپاکت همبرگر|/burger-boxes";
        $quickLinks = collect(preg_split('/\r\n|\r|\n/', $quickLinkLines))->map(function ($line) {
            [$title, $url] = array_pad(explode('|', $line, 2), 2, '/search');
            return ['title' => trim($title), 'url' => trim($url)];
        })->filter(fn ($link) => filled($link['title']))->values()->all();
    }

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
    $searchBrandImage = $resolveImageUrl($section->settings->get('search_brand_image'))
        ?: bagisto_asset('images/search-brand-green.webp');
    $searchBrandPrompt = $section->settings->get('search_brand_prompt') ?: 'جستجو در';

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
            <input id="sh-digi-mobile-search" type="search" name="query" value="{{ request('query') }}" class="sh-digi-search__input" placeholder=" " aria-label="{{ $searchPlaceholder }}" autocomplete="off">
            <span class="sh-digi-search__brand" aria-hidden="true">
                <span>{{ $searchBrandPrompt }}</span>
                <img src="{{ $searchBrandImage }}" alt="" width="100" height="36">
            </span>
        </form>

        <a href="{{ $notificationUrl }}" class="sh-digi-notify" aria-label="اعلان‌ها">
            <svg width="25" height="25" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M15 17h5l-1.4-1.4A2 2 0 0 1 18 14.2V11a6 6 0 1 0-12 0v3.2c0 .5-.2 1-.6 1.4L4 17h5m6 0a3 3 0 0 1-6 0m6 0H9"/>
            </svg>
        </a>
    </div>

    <div class="sh-digi-local-nav">
        <button type="button" class="sh-digi-region-trigger" data-region-open aria-haspopup="dialog" aria-controls="sh-digi-region-dialog">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" aria-hidden="true"><path d="M20 10c0 6-8 12-8 12S4 16 4 10a8 8 0 1 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
            <span>{{ config('catalog-regions.'.$selectedRegion) ?: 'انتخاب آدرس' }}</span>
            <span aria-hidden="true">⌄</span>
        </button>

        <nav class="sh-digi-quick-links" aria-label="منوی محصولات">
            @foreach ($quickLinks as $link)
                <a href="{{ url($link['url']) }}" @class(['sh-digi-quick-link', 'is-active' => request()->url() === url($link['url']) || ($loop->first && request()->routeIs('shop.home.index'))])>{{ $link['title'] }}</a>
            @endforeach
        </nav>
    </div>

    <dialog id="sh-digi-region-dialog" class="sh-digi-region-dialog" aria-labelledby="sh-digi-region-title">
        <div class="sh-digi-region-dialog__heading">
            <h2 id="sh-digi-region-title">انتخاب شهر</h2>
            <button type="button" data-region-close aria-label="بستن">×</button>
        </div>
        <p>محصولات متناسب با شهر انتخابی شما نمایش داده می‌شوند.</p>
        <form action="{{ route('shop.catalog.region.store') }}" method="POST">
            @csrf
            @foreach (config('catalog-regions') as $code => $label)
                <button type="submit" name="region" value="{{ $code }}" @class(['sh-digi-region-option', 'is-selected' => $selectedRegion === $code])>
                    {{ $label }}
                    @if ($selectedRegion === $code)<span aria-hidden="true">✓</span>@endif
                </button>
            @endforeach
        </form>
    </dialog>
</div>

@pushOnce('scripts')
    <script>
        (() => {
            let framePending = false;

            const updateHeader = () => {
                const scrollTop = Math.max(0, window.scrollY);
                const progress = Math.min(1, Math.max(0, (scrollTop - 16) / 180));

                document.querySelectorAll('.sh-digi-mobile-header').forEach(header => {
                    header.style.setProperty('--sh-digi-tab-expanded', (1 - progress).toFixed(4));
                });

                framePending = false;
            };

            const scheduleUpdate = () => {
                if (! framePending) {
                    framePending = true;
                    window.requestAnimationFrame(updateHeader);
                }
            };

            window.addEventListener('scroll', scheduleUpdate, { passive: true });
            window.addEventListener('resize', scheduleUpdate);
            window.addEventListener('pageshow', scheduleUpdate);
            document.addEventListener('visual:section:load', scheduleUpdate);
            document.addEventListener('visual:page:load', scheduleUpdate);

            scheduleUpdate();

            document.addEventListener('click', event => {
                const dialog = document.getElementById('sh-digi-region-dialog');
                if (! dialog) return;

                if (event.target.closest('[data-region-open]')) {
                    dialog.showModal();
                } else if (event.target.closest('[data-region-close]')) {
                    dialog.close();
                } else if (event.target === dialog) {
                    const bounds = dialog.getBoundingClientRect();
                    if (event.clientX < bounds.left || event.clientX > bounds.right || event.clientY < bounds.top || event.clientY > bounds.bottom) {
                        dialog.close();
                    }
                }
            });
        })();
    </script>
@endPushOnce
