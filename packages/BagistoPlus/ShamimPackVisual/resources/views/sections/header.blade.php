@php
    $productCategoryGroups = [
        'جعبه‌های غذا' => [
            ['title' => 'جعبه پیتزا', 'url' => '/pizza-boxes'],
            ['title' => 'جعبه برگر', 'url' => '/burger-boxes'],
            ['title' => 'جعبه ساندویچ', 'url' => '/sandwich-boxes'],
            ['title' => 'جعبه سوخاری', 'url' => '/fried-chicken-boxes'],
            ['title' => 'جعبه سیب‌زمینی', 'url' => '/french-fries-boxes'],
            ['title' => 'جعبه غذا', 'url' => '/takeaway-food-boxes'],
            ['title' => 'سطل سوخاری', 'url' => '/fried-chicken-buckets'],
        ],
        'ملزومات سرو و مصرف' => [
            ['title' => 'ظروف یکبار مصرف', 'url' => '/disposable-food-containers'],
            ['title' => 'لیوان یکبار مصرف', 'url' => '/disposable-cups'],
            ['title' => 'پک قاشق و چنگال', 'url' => '/cutlery-packs'],
            ['title' => 'سفره', 'url' => '/disposable-tablecloths'],
            ['title' => 'سینگل زیر پیتزا', 'url' => '/pizza-boards'],
        ],
        'بسته‌بندی‌های تکمیلی' => [
            ['title' => 'پاکت بیرون‌بر', 'url' => '/takeaway-bags'],
            ['title' => 'کاغذ ساندویچ', 'url' => '/sandwich-wrapping-paper'],
            ['title' => 'بسته‌بندی ساشه', 'url' => '/single-serve-sachets'],
            ['title' => 'بسته‌بندی آجیل', 'url' => '/nuts-packaging'],
            ['title' => 'بسته‌بندی بستنی', 'url' => '/ice-cream-packaging'],
        ],
    ];
@endphp

<div class="sc head-main">
    <button type="button" class="head-action mobile-menu-btn" data-open="menu" aria-label="منو" aria-expanded="false">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M4 7h16M4 12h16M4 17h16"/></svg>
    </button>

    <a
        class="logo logo--image"
        href="{{ route('shop.home.index') }}"
        aria-label="جعبه فروش - صفحه اصلی"
        style="display: flex; height: 82px; align-items: center"
    >
        <img
            src="{{ asset('themes/shop/shamim-pack/images/jabehfroosh-logo-professional-v2.png') }}"
            alt="جعبه فروش"
            width="230"
            height="82"
            style="width: 230px; height: 82px; object-fit: contain"
        >
    </a>

    <form class="head-search" action="{{ route('shop.search.index') }}">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m20 20-4-4"/></svg>
        <input
            name="query"
            placeholder="{{ $section->settings->search_placeholder }}"
            {{ $section->liveUpdate()->attr('search_placeholder', 'placeholder') }}
        >
    </form>

    <div class="head-actions">
        <button type="button" class="head-action sh-desktop-only" data-open="search" aria-label="جستجو" aria-expanded="false">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m20 20-4-4"/></svg>
        </button>
        <a class="head-action sh-desktop-only" href="{{ route('shop.compare.index') }}" aria-label="مقایسه">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M8 7h12m0 0-3-3m3 3-3 3M16 17H4m0 0 3-3m-3 3 3 3"/></svg>
        </a>
        <a class="head-action sh-desktop-only" href="{{ route('shop.customer.session.index') }}" aria-label="حساب">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 21a7.5 7.5 0 0 1 15 0"/></svg>
        </a>
        <v-shamim-cart></v-shamim-cart>
    </div>
</div>

<a class="mobile-order-tracking" href="{{ auth()->guard('customer')->check() ? route('shop.customers.account.orders.index') : route('shop.customer.session.index', ['redirect_to' => '/customer/account/orders']) }}" aria-label="پیگیری سفارش">
    <svg aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path d="M3 6h11v10H3zM14 9h4l3 3v4h-7zM7 19a2 2 0 1 0 0-4 2 2 0 0 0 0 4ZM17 19a2 2 0 1 0 0-4 2 2 0 0 0 0 4Z"/>
    </svg>

    <span>پیگیری سفارش</span>
    <span aria-hidden="true">←</span>
</a>

<nav class="main-nav">
    <div class="sc nav-inner">
        <div class="nav-list">
            @foreach ($section->blocks as $block)
                @if ($block->type === 'menu_link')
                    <div class="nav-item">
                        <a href="{{ $block->settings->url }}" {{ $block->liveUpdate()->text('title')->attr('url', 'href') }}>{{ $block->settings->title }}</a>
                    </div>
                @elseif ($block->type === 'mega_menu')
                    <div class="nav-item">
                        <a href="#categories"><span {{ $block->liveUpdate()->text('title') }}>{{ $block->settings->title }}</span>⌄</a>
                        <div class="mega">
                            @foreach ($productCategoryGroups as $groupTitle => $groupLinks)
                                <div>
                                    <h4>{{ $groupTitle }}</h4>
                                    @foreach ($groupLinks as $link)
                                        <a href="{{ $link['url'] }}">{{ $link['title'] }}</a>
                                    @endforeach
                                </div>
                            @endforeach
                            <a class="mega-promo" href="{{ $block->settings->promo_url }}" {{ $block->liveUpdate()->attr('promo_url', 'href') }}>
                                <img src="{{ $block->settings->promo_image }}" alt="" {{ $block->liveUpdate()->attr('promo_image', 'src') }}>
                                <b {{ $block->liveUpdate()->text('promo_text') }}>{{ $block->settings->promo_text }}</b>
                            </a>
                        </div>
                    </div>
                @endif
            @endforeach
        </div>

        <span class="nav-sale" {{ $section->liveUpdate()->text('sale_text') }}>{{ $section->settings->sale_text }}</span>
    </div>
</nav>

<div class="sh-backdrop" id="shBackdrop"></div>

<aside class="sh-drawer" id="menuDrawer" aria-hidden="true">
    <div class="drawer-head"><b {{ $section->liveUpdate()->text('drawer_title') }}>{{ $section->settings->drawer_title }}</b><button type="button" class="drawer-close" data-close>×</button></div>
    <div class="drawer-content">
        <div class="drawer-menu">
            @foreach ($section->blocks as $block)
                <a href="{{ $block->type === 'menu_link' ? $block->settings->url : '#categories' }}">
                    <span>{{ $block->settings->title }}</span><span>←</span>
                </a>
            @endforeach
            <a href="{{ route('shop.customer.session.index') }}"><span>حساب کاربری</span><span>←</span></a>
        </div>
        <div class="drawer-cats">
            <a class="drawer-cat" href="{{ route('shop.search.index', ['query' => 'جعبه برگر']) }}"><span>▣</span>جعبه برگر</a>
            <a class="drawer-cat" href="{{ route('shop.search.index', ['query' => 'جعبه ساندویچ']) }}"><span>▤</span>جعبه ساندویچ</a>
            <a class="drawer-cat" href="{{ route('shop.search.index', ['query' => 'جعبه سوخاری']) }}"><span>◫</span>جعبه سوخاری</a>
            <a class="drawer-cat" href="{{ route('shop.search.index', ['query' => 'کاغذ کرافت']) }}"><span>◎</span>کاغذ کرافت</a>
        </div>
    </div>
    <div class="drawer-foot">پشتیبانی: <span {{ $section->liveUpdate()->text('support_phone') }}>{{ $section->settings->support_phone }}</span></div>
</aside>

<div class="search-layer" id="searchLayer" aria-hidden="true">
    <div class="search-wrap">
        <div class="search-top"><h3>دنبال چه چیزی هستید؟</h3><button type="button" class="drawer-close" data-close>×</button></div>
        <form class="big-search" action="{{ route('shop.search.index') }}"><input name="query" placeholder="نام محصول را بنویسید..."><button>⌕</button></form>
        <div class="search-tags"><span>جستجوهای محبوب:</span><a href="{{ route('shop.search.index', ['query' => 'جعبه برگر']) }}">جعبه برگر کرافت</a><a href="{{ route('shop.search.index', ['query' => 'جعبه سوخاری']) }}">جعبه سیب زمینی</a><a href="{{ route('shop.search.index', ['query' => 'جعبه ساندویچ']) }}">جعبه ساندویچ</a></div>
    </div>
</div>

@pushOnce('scripts')
<script type="text/x-template" id="v-shamim-cart-template">
    <div class="flex">
        <button
            ref="toggle"
            type="button"
            class="head-action"
            data-open="cart"
            aria-label="سبد"
            aria-expanded="false"
        >
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M3 4h2l2.2 10h10.7l2-7H6"/><circle cx="9" cy="19" r="1.5"/><circle cx="17" cy="19" r="1.5"/></svg>

            <span v-if="cart?.items_qty" class="action-badge">@{{ cart.items_qty }}</span>
        </button>

        <aside class="sh-drawer" id="cartDrawer" aria-hidden="true">
            <div class="drawer-head">
                <b {{ $section->liveUpdate()->text('cart_title') }}>{{ $section->settings->cart_title }}</b>

                <button type="button" class="drawer-close" data-close aria-label="بستن">×</button>
            </div>

            <div class="drawer-content">
                <div v-if="isLoading" class="cart-empty">
                    <p>در حال دریافت سبد خرید...</p>
                </div>

                <div v-else-if="cart?.items?.length" class="grid gap-5">
                    <article
                        v-for="item in cart.items"
                        :key="item.id"
                        class="flex gap-4 border-b border-[#ead8bd] pb-5"
                    >
                        <a :href="`{{ url('/') }}/${item.product_url_key}`" class="shrink-0">
                            <img
                                :src="item.base_image.small_image_url"
                                :alt="item.name"
                                class="h-20 w-20 rounded-lg object-cover"
                            >
                        </a>

                        <div class="min-w-0 flex-1">
                            <a
                                :href="`{{ url('/') }}/${item.product_url_key}`"
                                class="block truncate font-bold text-on-background"
                            >
                                @{{ item.name }}
                            </a>

                            <p class="mt-2 text-xs text-on-background/60">
                                تعداد: @{{ item.quantity }}
                            </p>

                            <p class="mt-1 text-sm font-bold text-primary">
                                @{{ item.formatted_total }}
                            </p>
                        </div>
                    </article>

                    <div class="mt-2 border-t border-[#ead8bd] pt-5">
                        <div class="mb-5 flex items-center justify-between font-bold">
                            <span>جمع سبد</span>
                            <span>@{{ cart.formatted_sub_total }}</span>
                        </div>

                        <a class="sh-btn w-full" href="{{ route('shop.checkout.cart.index') }}">
                            مشاهده و تکمیل سبد خرید
                        </a>
                    </div>
                </div>

                <div v-else class="cart-empty">
                    <i>🛒</i>
                    <h3>سبد خرید خالی است</h3>
                    <p>بسته‌بندی موردنیازتان را به سبد اضافه کنید.</p>
                    <a class="sh-btn" href="{{ route('shop.search.index') }}">شروع خرید</a>
                </div>
            </div>
        </aside>
    </div>
</script>

<script type="module">
    app.component('v-shamim-cart', {
        template: '#v-shamim-cart-template',

        data() {
            return {
                cart: null,
                isLoading: true,
            };
        },

        mounted() {
            this.getCart();

            this.$emitter.on('update-mini-cart', this.updateCart);
        },

        beforeUnmount() {
            this.$emitter.off('update-mini-cart', this.updateCart);
        },

        methods: {
            updateCart(cart) {
                this.cart = cart?.data ?? cart;
                this.isLoading = false;
            },

            getCart() {
                this.isLoading = true;

                this.$axios.get('{{ route('shop.api.checkout.cart.index') }}')
                    .then(response => {
                        this.cart = response.data.data;
                    })
                    .catch(() => {
                        this.cart = null;
                    })
                    .finally(() => {
                        this.isLoading = false;
                    });
            },
        },
    });
</script>

<script>
(() => {
    if (window.__shamimPackHeaderBound) return;
    window.__shamimPackHeaderBound = true;

    const get = id => document.getElementById(id);
    const setPanelState = (panel, open) => {
        if (!panel) return;
        panel.classList.toggle('open', open);
        panel.setAttribute('aria-hidden', open ? 'false' : 'true');
    };

    function closeAll() {
        ['menuDrawer', 'cartDrawer', 'searchLayer'].forEach(id => setPanelState(get(id), false));
        get('shBackdrop')?.classList.remove('show');
        document.body.classList.remove('sh-lock');
        document.querySelectorAll('#shHeader [data-open]').forEach(item => item.setAttribute('aria-expanded', 'false'));
    }

    function openPanel(type, button) {
        const panelId = type === 'search' ? 'searchLayer' : `${type}Drawer`;
        const panel = get(panelId);
        closeAll();
        if (!panel) return;

        setPanelState(panel, true);
        get('shBackdrop')?.classList.add('show');
        document.body.classList.add('sh-lock');
        button?.setAttribute('aria-expanded', 'true');

        if (type === 'search') window.setTimeout(() => panel.querySelector('input')?.focus(), 120);
    }

    document.addEventListener('click', event => {
        const opener = event.target.closest('#shHeader [data-open]');
        if (opener) {
            event.preventDefault();
            event.stopPropagation();
            openPanel(opener.dataset.open, opener);
            return;
        }

        if (event.target.closest('[data-close]') || event.target.id === 'shBackdrop') closeAll();
    });

    document.addEventListener('keydown', event => event.key === 'Escape' && closeAll());
    window.addEventListener('pageshow', closeAll);
    window.addEventListener('scroll', () => get('shHeader')?.classList.toggle('is-scrolled', scrollY > 20), { passive: true });

    let announcementIndex = 0;
    window.setInterval(() => {
        const track = get('announceTrack');
        if (!track) return;
        announcementIndex = (announcementIndex + 1) % 3;
        track.style.transform = `translateY(${-36 * announcementIndex}px)`;
    }, 3500);

    closeAll();
    window.shamimPackUI = { open: openPanel, close: closeAll, isReady: true };
})();
</script>
@endPushOnce
