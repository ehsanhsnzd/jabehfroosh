@php
    $brandName = $section->settings->logo_text ?: config('app.name');
    $searchPlaceholder = $section->settings->search_placeholder ?: 'جستجو در محصولات...';
    $notificationUrl = auth()->guard('customer')->check()
        ? route('shop.customers.account.orders.index')
        : route('shop.customer.session.create');
    $logoUrl = core()->getCurrentChannel()->logo_url ?? asset('themes/shop/shamim-pack/images/jabehfroosh-logo-professional-v2.png');
    $isHome = request()->routeIs('shop.home.index');
@endphp

<div class="sh-digi-mobile-header">
    <v-sh-digi-catalog-tabs
        home-url="{{ route('shop.home.index') }}"
        brand-name="{{ $brandName }}"
        logo-url="{{ $logoUrl }}"
        :is-home-active="{{ $isHome ? 'true' : 'false' }}"
    ></v-sh-digi-catalog-tabs>

    <div class="sh-digi-mobile-header__toolbar px-4 pt-1 pb-2">
        <div class="flex items-center gap-3">
            <form
                action="{{ route('shop.search.index') }}"
                class="sh-digi-search flex min-w-0 flex-1 items-center"
                role="search"
            >
                <label class="sr-only" for="sh-digi-mobile-search">@lang('shop::app.components.layouts.header.mobile.search')</label>

                <button type="submit" class="sh-digi-search__icon shrink-0" aria-label="@lang('shop::app.components.layouts.header.mobile.search')">
                    <span class="icon-search text-xl text-on-background/45"></span>
                </button>

                <input
                    id="sh-digi-mobile-search"
                    type="search"
                    name="query"
                    value="{{ request('query') }}"
                    class="sh-digi-search__input min-w-0 flex-1 bg-transparent text-sm outline-none"
                    placeholder="{{ $searchPlaceholder }}"
                    autocomplete="off"
                >

                <span class="sh-digi-search__brand hidden min-w-0 items-center gap-1 text-xs text-on-background/50 sm:flex">
                    <span>جستجو در</span>
                    <img
                        src="{{ $logoUrl }}"
                        alt="{{ $brandName }}"
                        class="h-4 w-auto max-w-[72px] object-contain"
                        width="72"
                        height="16"
                    >
                </span>
            </form>

            <a
                href="{{ $notificationUrl }}"
                class="sh-digi-notify flex h-11 w-11 shrink-0 items-center justify-center rounded-full border border-neutral-200 bg-white"
                aria-label="اعلان‌ها"
            >
                <svg class="h-6 w-6 text-on-background/85" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.6" d="M15 17h5l-1.4-1.4A2 2 0 0 1 18 14.2V11a6 6 0 1 0-12 0v3.2c0 .5-.2 1-.6 1.4L4 17h5m6 0a3 3 0 0 1-6 0m6 0H9"/>
                </svg>
            </a>
        </div>
    </div>
</div>

@pushOnce('scripts')
    <script type="text/x-template" id="v-sh-digi-catalog-tabs-template">
        <div class="sh-digi-tabs-wrap">
            <div
                class="sh-digi-tabs"
                role="tablist"
                aria-label="دسته‌بندی"
                ref="tabs"
            >
                <button
                    type="button"
                    class="sh-digi-tab sh-digi-tab--menu"
                    data-open="menu"
                    aria-label="دسته‌بندی"
                    aria-expanded="false"
                >
                    <span class="sh-digi-tab__icon sh-digi-tab__icon--grid" aria-hidden="true">
                        <svg width="36" height="36" viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <rect x="23.625" y="6.011" width="9" height="9" rx="2" transform="rotate(45 23.625 6.011)" fill="#848484"/>
                            <rect x="19.125" y="19.125" width="9" height="9" rx="2" fill="#18251d"/>
                            <rect x="7.875" y="7.875" width="9" height="9" rx="2" fill="#18251d"/>
                            <rect x="7.875" y="19.125" width="9" height="9" rx="2" fill="#18251d"/>
                        </svg>
                    </span>
                    <span class="sh-digi-tab__label">دسته‌بندی</span>
                </button>

                <a
                    :href="homeUrl"
                    class="sh-digi-tab"
                    :class="{ 'sh-digi-tab--active': isHomeActive }"
                    role="tab"
                    :aria-selected="isHomeActive ? 'true' : 'false'"
                >
                    <span class="sh-digi-tab__icon sh-digi-tab__icon--brand">
                        <img :src="logoUrl" :alt="brandName" width="32" height="32">
                    </span>
                    <span class="sh-digi-tab__label">@{{ brandName }}</span>
                </a>

                <a
                    v-for="category in categories"
                    :key="category.id"
                    :href="category.url"
                    class="sh-digi-tab"
                    :class="{ 'sh-digi-tab--active': isCategoryActive(category.url) }"
                    role="tab"
                    :aria-selected="isCategoryActive(category.url) ? 'true' : 'false'"
                >
                    <span class="sh-digi-tab__icon sh-digi-tab__icon--letter" aria-hidden="true">
                        @{{ categoryInitial(category.name) }}
                    </span>
                    <span class="sh-digi-tab__label">@{{ category.name }}</span>
                </a>
            </div>
        </div>
    </script>

    <script type="module">
        app.component('v-sh-digi-catalog-tabs', {
            template: '#v-sh-digi-catalog-tabs-template',

            props: {
                homeUrl: { type: String, required: true },
                brandName: { type: String, required: true },
                logoUrl: { type: String, required: true },
                isHomeActive: { type: Boolean, default: false },
            },

            data() {
                return {
                    categories: [],
                    currentPath: window.location.pathname,
                };
            },

            mounted() {
                this.loadCategories();
            },

            methods: {
                loadCategories() {
                    this.$axios.get("{{ route('shop.api.categories.tree') }}")
                        .then(response => {
                            this.categories = response.data.data ?? [];
                        })
                        .catch(() => {
                            this.categories = [];
                        });
                },

                categoryInitial(name) {
                    if (! name) {
                        return '•';
                    }

                    return name.trim().charAt(0);
                },

                isCategoryActive(url) {
                    if (! url) {
                        return false;
                    }

                    try {
                        const path = new URL(url, window.location.origin).pathname;

                        return this.currentPath === path || this.currentPath.startsWith(path + '/');
                    } catch {
                        return false;
                    }
                },
            },
        });
    </script>
@endPushOnce
