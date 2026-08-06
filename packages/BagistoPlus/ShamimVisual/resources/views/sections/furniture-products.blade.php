<div class="sc">
    <div class="sh-title">
        <span {{ $section->liveUpdate()->text('eyebrow') }}>{{ $section->settings->eyebrow }}</span>
        <h2 {{ $section->liveUpdate()->text('heading') }}>{{ $section->settings->heading }}</h2>
    </div>
    <x-shop::products.carousel
        title=""
        :src="route('shop.api.products.index', ['limit' => (int) $section->settings->limit])"
        :navigation-link="route('shop.search.index')"
    />
</div>
