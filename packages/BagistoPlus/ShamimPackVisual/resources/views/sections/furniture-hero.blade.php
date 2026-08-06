<img class="hero-bg" src="{{ $section->settings->image }}" alt="" {{ $section->liveUpdate()->attr('image', 'src') }}>
<div class="hero-deco deco-a"><i></i><span><b {{ $section->liveUpdate()->text('badge_1_title') }}>{{ $section->settings->badge_1_title }}</b><small {{ $section->liveUpdate()->text('badge_1_text') }}>{{ $section->settings->badge_1_text }}</small></span></div>
<div class="hero-deco deco-b"><i></i><span><b {{ $section->liveUpdate()->text('badge_2_title') }}>{{ $section->settings->badge_2_title }}</b><small {{ $section->liveUpdate()->text('badge_2_text') }}>{{ $section->settings->badge_2_text }}</small></span></div>
<span class="hero-scroll">SCROLL</span>
<div class="sc hc">
    <div class="copyhero">
        <span class="kick" {{ $section->liveUpdate()->text('eyebrow') }}>{{ $section->settings->eyebrow }}</span>
        <h1 {{ $section->liveUpdate()->text('heading') }}>{{ $section->settings->heading }}</h1>
        <p {{ $section->liveUpdate()->text('description') }}>{{ $section->settings->description }}</p>
        <a class="sh-btn" href="{{ $section->settings->button_url }}" {{ $section->liveUpdate()->text('button_text')->attr('button_url', 'href') }}>{{ $section->settings->button_text }}</a>
        <span class="price" {{ $section->liveUpdate()->text('price') }}>{{ $section->settings->price }}</span>
    </div>
</div>

@pushOnce('scripts')
<script>
(() => {
    const revealAll = () => document.querySelectorAll('.reveal, .cat').forEach(item => item.classList.add('in'));
    const isDesignMode = new URLSearchParams(window.location.search).has('_designMode');
    const reducedMotion = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches;

    function initShamimPackVisualHome() {
        const items = [...document.querySelectorAll('.reveal:not(.in), .cat:not(.in)')];

        if (!items.length || isDesignMode || reducedMotion || !('IntersectionObserver' in window)) {
            revealAll();
            return;
        }

        document.documentElement.classList.add('sh-effects-ready');

        const observer = new IntersectionObserver(entries => entries.forEach(entry => {
            if (!entry.isIntersecting) return;
            entry.target.classList.add('in');
            observer.unobserve(entry.target);
        }), { threshold: .01, rootMargin: '0px 0px 5% 0px' });

        items.forEach(item => {
            const rect = item.getBoundingClientRect();
            if (rect.top < window.innerHeight * 1.05) item.classList.add('in');
            else observer.observe(item);
        });

        window.setTimeout(revealAll, 1800);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initShamimPackVisualHome, { once: true });
    } else {
        initShamimPackVisualHome();
    }

    window.addEventListener('pageshow', event => event.persisted && revealAll());
    window.addEventListener('scroll', () => {
        const image = document.querySelector('.hero-bg');
        if (image && scrollY < 800 && !reducedMotion) image.style.transform = `translateY(${scrollY * .025}%) scale(1.03)`;
    }, { passive: true });
})();
</script>
@endPushOnce
