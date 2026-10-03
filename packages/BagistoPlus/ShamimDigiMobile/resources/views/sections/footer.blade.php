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
        <span class="foot-kicker" {{ $section->liveUpdate()->text('newsletter_label') }}>{{ str_replace('شمیم پک', 'جعبه فروش', $section->settings->newsletter_label) }}</span>
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
        <p class="fb" {{ $section->liveUpdate()->text('brand_name') }}>جعبه فروش</p>
        <p {{ $section->liveUpdate()->text('brand_description') }}>{{ $section->settings->brand_description }}</p>
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

<section class="sc footer-social-hub" aria-labelledby="footerSocialTitle">
    <div>
        <span>شبکه‌های اجتماعی جعبه فروش</span>
        <h3 id="footerSocialTitle">همراه ما باشید</h3>
        <p dir="ltr">@jabehfroosh</p>
    </div>

    <nav class="footer-social-list" aria-label="شبکه‌های اجتماعی">
        <a href="https://wa.me/989991240501" target="_blank" rel="noopener" aria-label="واتساپ جعبه فروش">
            <span class="footer-social-list__icon footer-social-list__icon--whatsapp"><svg aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M20 11.5a8 8 0 0 1-11.8 7L3 20l1.5-5.1A8 8 0 1 1 20 11.5Z"/><path d="M8 8.5c.7 3.2 2.3 4.8 5.5 5.5l1.5-1.5 2 .7"/></svg></span>
            <span><strong>واتساپ</strong><small dir="ltr">@jabehfroosh</small></span>
        </a>

        <a href="https://t.me/jabehfroosh" target="_blank" rel="noopener" aria-label="تلگرام جعبه فروش">
            <span class="footer-social-list__icon footer-social-list__icon--telegram"><svg aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="m3 11 18-8-5 18-5-7-4 3 1-5 8-6-10 7-3-2Z"/></svg></span>
            <span><strong>تلگرام</strong><small dir="ltr">@jabehfroosh</small></span>
        </a>

        <a href="https://instagram.com/jabehfroosh" target="_blank" rel="noopener" aria-label="اینستاگرام جعبه فروش">
            <span class="footer-social-list__icon footer-social-list__icon--instagram"><svg aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="5"/><circle cx="12" cy="12" r="4"/><path d="M17.5 6.5h.01"/></svg></span>
            <span><strong>اینستاگرام</strong><small dir="ltr">@jabehfroosh</small></span>
        </a>
    </nav>
</section>

<section class="sc footer-trust" aria-labelledby="footerTrustTitle">
    <div class="footer-trust__info">
        <span class="footer-trust__eyebrow">مرکز پاسخ‌گویی جعبه فروش</span>
        <h3 id="footerTrustTitle">اطلاعات فروشگاه</h3>

        <dl class="footer-trust__details">
            <div><dt>ساعت کاری</dt><dd>شنبه تا چهارشنبه، ۹ صبح تا ۱۸</dd></div>
            <div><dt>پنجشنبه</dt><dd>۹ صبح تا ۱۴</dd></div>
            <div><dt>تلفن</dt><dd><a dir="ltr" href="tel:+989991240501">0999 124 0501</a></dd></div>
            <div><dt>ایمیل</dt><dd><a dir="ltr" href="mailto:sales@jabehfroosh.com">sales@jabehfroosh.com</a></dd></div>
        </dl>

        <div class="footer-trust__address">
            <p>آدرس فروشگاه: تبریز / اول جاده مایان / کوی پدرام / روبروی کوچه دوم</p>
            <a href="https://www.google.com/maps/search/?api=1&query=تبریز%20اول%20جاده%20مایان%20کوی%20پدرام%20روبروی%20کوچه%20دوم" target="_blank" rel="noopener">
                <svg aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M20 10c0 5-8 12-8 12S4 15 4 10a8 8 0 1 1 16 0Z"/><circle cx="12" cy="10" r="2.5"/></svg>
                مسیریابی روی نقشه
            </a>
        </div>
    </div>

    <div class="footer-trust__badges" aria-label="مجوزها و ضمانت‌های فروشگاه">
        <article class="trust-badge trust-badge--payment">
            <span><svg aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="3"/><path d="M3 10h18M7 15h3"/></svg></span>
            <strong>پرداخت امن</strong>
            <small>درگاه بانکی</small>
        </article>
        <article class="trust-badge trust-badge--quality">
            <span><svg aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="m12 2 3 3 4 .5.5 4 2.5 3-2.5 3-.5 4-4 .5-3 3-3-3-4-.5-.5-4L2 12l2.5-3 .5-4 4-.5 3-3Z"/><path d="m8.5 12 2 2 5-5"/></svg></span>
            <strong>ضمانت کیفیت</strong>
            <small>مواد Food Grade</small>
        </article>
        <article class="trust-badge trust-badge--registered">
            <span><svg aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M5 3h14v18l-7-3-7 3V3Z"/><path d="m9 10 2 2 4-4"/></svg></span>
            <strong>فروشگاه ثبت‌شده</strong>
            <small>خرید قابل پیگیری</small>
        </article>
        <article class="trust-badge trust-badge--support">
            <span><svg aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M4 13a8 8 0 0 1 16 0v5h-4v-5h4M4 13h4v5H4v-5ZM16 20h-4"/></svg></span>
            <strong>پشتیبانی سفارش</strong>
            <small>پاسخ‌گویی مستقیم</small>
        </article>
        <p>پس از دریافت مجوزها، تصویر و لینک رسمی هر نماد از پنل قابل جایگزینی است.</p>
    </div>
</section>

<div class="copy">
    <div class="sc copy-inner">
        <span>© {{ date('Y') }} <span {{ $section->liveUpdate()->text('copyright') }}>{{ str_replace('شمیم پک', 'جعبه فروش', $section->settings->copyright) }}</span></span>
        <span {{ $section->liveUpdate()->text('legal_text') }}>{{ $section->settings->legal_text }}</span>
    </div>
</div>
