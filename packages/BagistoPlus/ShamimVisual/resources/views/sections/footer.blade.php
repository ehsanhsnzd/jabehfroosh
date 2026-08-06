@php
    $parseLinks = static function ($value) {
        return collect(preg_split('/\r\n|\r|\n/', (string) $value))
            ->filter()
            ->map(function ($line) {
                [$title, $url] = array_pad(explode('|', $line, 2), 2, '/');
                return ['title' => trim($title), 'url' => trim($url) ?: '/'];
            });
    };
    $groups = collect($section->blocks)->where('type', 'link_group');
    $socials = collect($section->blocks)->where('type', 'social_link');
@endphp

<div class="sc foot-newsletter">
    <div>
        <span class="foot-kicker" {{ $section->liveUpdate()->text('newsletter_label') }}>{{ $section->settings->newsletter_label }}</span>
        <h2 {{ $section->liveUpdate()->text('newsletter_title') }}>{{ $section->settings->newsletter_title }}</h2>
    </div>
    <form action="{{ route('shop.subscription.store') }}" method="POST" class="newsletter-form">
        @csrf
        <input type="email" name="email" required placeholder="{{ $section->settings->newsletter_placeholder }}" {{ $section->liveUpdate()->attr('newsletter_placeholder', 'placeholder') }}>
        <button {{ $section->liveUpdate()->text('newsletter_button') }}>{{ $section->settings->newsletter_button }}</button>
    </form>
</div>

<div class="sc fg">
    <div>
        <p class="fb" {{ $section->liveUpdate()->text('brand_name') }}>{{ $section->settings->brand_name }}</p>
        <p {{ $section->liveUpdate()->text('brand_description') }}>{{ $section->settings->brand_description }}</p>
        <div class="social-links">
            @foreach ($socials as $block)
                <a href="{{ $block->settings->url }}" {{ $block->liveUpdate()->text('label')->attr('url', 'href') }}>{{ $block->settings->label }}</a>
            @endforeach
        </div>
    </div>

    @foreach ($groups as $block)
        <div>
            <h3 {{ $block->liveUpdate()->text('title') }}>{{ $block->settings->title }}</h3>
            <ul>
                @foreach ($parseLinks($block->settings->links) as $link)
                    <li><a href="{{ $link['url'] }}">{{ $link['title'] }}</a></li>
                @endforeach
            </ul>
        </div>
    @endforeach

    <div>
        <h3 {{ $section->liveUpdate()->text('contact_title') }}>{{ $section->settings->contact_title }}</h3>
        <p class="whitespace-pre-line" {{ $section->liveUpdate()->text('address') }}>{{ $section->settings->address }}</p>
        <p class="foot-phone" {{ $section->liveUpdate()->text('phone') }}>{{ $section->settings->phone }}</p>
        <p {{ $section->liveUpdate()->text('email') }}>{{ $section->settings->email }}</p>
    </div>
</div>

<div class="copy">
    <div class="sc copy-inner">
        <span>© {{ date('Y') }} <span {{ $section->liveUpdate()->text('copyright') }}>{{ $section->settings->copyright }}</span></span>
        <span {{ $section->liveUpdate()->text('legal_text') }}>{{ $section->settings->legal_text }}</span>
    </div>
</div>
