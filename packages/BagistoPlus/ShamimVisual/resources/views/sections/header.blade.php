@php
    $parseLinks = static function ($value) {
        return collect(preg_split('/\r\n|\r|\n/', (string) $value))
            ->filter()
            ->map(function ($line) {
                [$title, $url] = array_pad(explode('|', $line, 2), 2, '/');
                return ['title' => trim($title), 'url' => trim($url) ?: '/'];
            });
    };
@endphp

<div class="sc head-main">
    <button type="button" class="head-action mobile-menu-btn" data-open="menu" aria-label="منو" aria-expanded="false">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M4 7h16M4 12h16M4 17h16"/></svg>
    </button>

    <a class="logo" href="{{ route('shop.home.index') }}">
        <span class="logo-mark"><b {{ $section->liveUpdate()->text('logo_mark') }}>{{ $section->settings->logo_mark }}</b></span>
        <span>
            <b {{ $section->liveUpdate()->text('logo_text') }}>{{ $section->settings->logo_text }}</b>
            <small {{ $section->liveUpdate()->text('logo_subtitle') }}>{{ $section->settings->logo_subtitle }}</small>
        </span>
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
        <button type="button" class="head-action" data-open="cart" aria-label="سبد" aria-expanded="false">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M3 4h2l2.2 10h10.7l2-7H6"/><circle cx="9" cy="19" r="1.5"/><circle cx="17" cy="19" r="1.5"/></svg>
            <span class="action-badge">0</span>
        </button>
    </div>
</div>

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
                            @for ($group = 1; $group <= 3; $group++)
                                <div>
                                    <h4 {{ $block->liveUpdate()->text('group_'.$group.'_title') }}>{{ $block->settings->{'group_'.$group.'_title'} }}</h4>
                                    @foreach ($parseLinks($block->settings->{'group_'.$group.'_links'}) as $link)
                                        <a href="{{ $link['url'] }}">{{ $link['title'] }}</a>
                                    @endforeach
                                </div>
                            @endfor
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
            <a class="drawer-cat" href="{{ route('shop.search.index', ['query' => 'مبل']) }}"><span>🛋</span>مبل</a>
            <a class="drawer-cat" href="{{ route('shop.search.index', ['query' => 'صندلی']) }}"><span>🪑</span>صندلی</a>
            <a class="drawer-cat" href="{{ route('shop.search.index', ['query' => 'میز']) }}"><span>▱</span>میز</a>
            <a class="drawer-cat" href="{{ route('shop.search.index', ['query' => 'دکور']) }}"><span>🏺</span>دکور</a>
        </div>
    </div>
    <div class="drawer-foot">پشتیبانی: <span {{ $section->liveUpdate()->text('support_phone') }}>{{ $section->settings->support_phone }}</span></div>
</aside>

<aside class="sh-drawer" id="cartDrawer" aria-hidden="true">
    <div class="drawer-head"><b {{ $section->liveUpdate()->text('cart_title') }}>{{ $section->settings->cart_title }}</b><button type="button" class="drawer-close" data-close>×</button></div>
    <div class="drawer-content">
        <div class="cart-empty"><i>🛒</i><h3>سبد خرید خالی است</h3><p>محصولات مورد علاقه‌تان را به سبد اضافه کنید.</p><a class="sh-btn" href="{{ route('shop.search.index') }}">شروع خرید</a></div>
    </div>
</aside>

<div class="search-layer" id="searchLayer" aria-hidden="true">
    <div class="search-wrap">
        <div class="search-top"><h3>دنبال چه چیزی هستید؟</h3><button type="button" class="drawer-close" data-close>×</button></div>
        <form class="big-search" action="{{ route('shop.search.index') }}"><input name="query" placeholder="نام محصول را بنویسید..."><button>⌕</button></form>
        <div class="search-tags"><span>جستجوهای محبوب:</span><a href="{{ route('shop.search.index', ['query' => 'مبل']) }}">مبل راحتی</a><a href="{{ route('shop.search.index', ['query' => 'میز']) }}">میز چوبی</a><a href="{{ route('shop.search.index', ['query' => 'صندلی']) }}">صندلی</a></div>
    </div>
</div>

@pushOnce('scripts')
<script>
(() => {
    if (window.__shamimVisualHeaderBound) return;
    window.__shamimVisualHeaderBound = true;
    const get = id => document.getElementById(id);
    const setPanelState = (panel, open) => {
        panel?.classList.toggle('open', open);
        panel?.setAttribute('aria-hidden', open ? 'false' : 'true');
    };
    function closeAll() {
        ['menuDrawer', 'cartDrawer'].forEach(id => setPanelState(get(id), false));
        setPanelState(get('searchLayer'), false);
        get('shBackdrop')?.classList.remove('show');
        document.body.classList.remove('sh-lock');
        document.querySelectorAll('[data-open]').forEach(item => item.setAttribute('aria-expanded', 'false'));
    }
    function openPanel(type, button) {
        closeAll();
        const panel = type === 'search' ? get('searchLayer') : get(type + 'Drawer');
        if (!panel) return;
        setPanelState(panel, true);
        if (type !== 'search') get('shBackdrop')?.classList.add('show');
        document.body.classList.add('sh-lock');
        button?.setAttribute('aria-expanded', 'true');
        if (type === 'search') setTimeout(() => panel.querySelector('input')?.focus(), 80);
    }
    document.addEventListener('click', event => {
        const opener = event.target.closest('[data-open]');
        if (opener) {
            event.preventDefault();
            openPanel(opener.dataset.open, opener);
            return;
        }
        if (event.target.closest('[data-close]') || event.target.id === 'shBackdrop') closeAll();
    });
    document.addEventListener('keydown', event => event.key === 'Escape' && closeAll());
    window.addEventListener('scroll', () => get('shHeader')?.classList.toggle('is-scrolled', scrollY > 20), { passive: true });
    let announcementIndex = 0;
    window.setInterval(() => {
        const track = get('announceTrack');
        if (!track) return;
        announcementIndex = (announcementIndex + 1) % 3;
        track.style.transform = `translateY(${-36 * announcementIndex}px)`;
    }, 3500);
    window.shamimUI = { open: openPanel, close: closeAll, isReady: true };
})();
</script>
@endPushOnce
