@php($carouselId = 'shamim-category-carousel-'.$section->id)

<div class="sc shamim-category-section">
    <div class="sh-title shamim-category-heading">
        <span {{ $section->liveUpdate()->text('eyebrow') }}>{{ $section->settings->eyebrow }}</span>
        <h2 {{ $section->liveUpdate()->text('heading') }}>{{ str_replace('شمیم پک', 'جعبه فروش', $section->settings->heading) }}</h2>
        <p {{ $section->liveUpdate()->text('description') }}>{{ $section->settings->description }}</p>
    </div>

    <div class="shamim-category-shell" id="{{ $carouselId }}">
        <button class="shamim-category-arrow shamim-category-next" type="button" aria-label="دسته‌های بعدی">‹</button>
        <div class="shamim-category-track" role="list" tabindex="0" aria-label="دسته‌بندی محصولات جعبه فروش">
            @foreach ($section->blocks as $block)
                <a class="shamim-category-card" href="{{ $block->settings->url }}" role="listitem" draggable="false" {{ $block->liveUpdate()->attr('url', 'href') }}>
                    <span class="shamim-category-image">
                        <img src="{{ $block->settings->image }}" alt="{{ $block->settings->title }}" width="180" height="180" loading="lazy" draggable="false" {{ $block->liveUpdate()->attr('image', 'src') }}>
                    </span>
                    <strong {{ $block->liveUpdate()->text('title') }}>{{ $block->settings->title }}</strong>
                    <small {{ $block->liveUpdate()->text('count') }}>{{ $block->settings->count }}</small>
                </a>
            @endforeach
        </div>
        <button class="shamim-category-arrow shamim-category-prev" type="button" aria-label="دسته‌های قبلی">›</button>
    </div>
    <div class="shamim-category-progress" aria-hidden="true"><span></span></div>
</div>

@pushOnce('styles')
<style>
.shamim-category-section{overflow:hidden}.shamim-category-heading{margin-bottom:28px}.shamim-category-shell{position:relative;padding-inline:54px}.shamim-category-track{display:flex;gap:18px;overflow-x:auto;overscroll-behavior-inline:contain;scroll-behavior:smooth;scroll-snap-type:x mandatory;scrollbar-width:none;padding:12px 14px 24px;cursor:grab;touch-action:auto;-webkit-overflow-scrolling:touch;user-select:none;-webkit-user-select:none}.shamim-category-track.is-dragging{cursor:grabbing;scroll-behavior:auto;scroll-snap-type:none}.shamim-category-track::-webkit-scrollbar{display:none}.shamim-category-card{flex:0 0 168px;scroll-snap-align:start;color:#18251d;text-align:center;border:0;border-radius:20px;background:#fff;padding:10px 10px 15px;box-shadow:0 8px 24px rgba(53,39,25,.075);transition:transform .25s ease,box-shadow .25s ease}.shamim-category-card:hover{transform:translateY(-5px);box-shadow:0 17px 38px rgba(24,37,29,.14)}.shamim-category-image{display:block;width:100%;aspect-ratio:1;overflow:hidden;border-radius:15px;background:#f8f4ed}.shamim-category-image img{width:100%;height:100%;display:block;object-fit:cover;transform:scale(1.13);transition:transform .45s cubic-bezier(.2,.8,.2,1);pointer-events:none}.shamim-category-card:hover img{transform:scale(1.18)}.shamim-category-card strong{display:block;margin-top:12px;font-size:14px;line-height:1.7;white-space:nowrap}.shamim-category-card small{display:block;color:#81776c;font-size:10px;line-height:1.7;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.shamim-category-arrow{position:absolute;z-index:2;top:78px;width:42px;height:42px;display:grid;place-items:center;border:1px solid #d7c7b0;border-radius:50%;background:#fff;color:#18251d;font:28px/1 sans-serif;box-shadow:0 8px 20px rgba(24,37,29,.1);transition:.2s ease}.shamim-category-arrow:hover{color:#fff;border-color:#18a957;background:#18a957}.shamim-category-next{right:2px}.shamim-category-prev{left:2px}.shamim-category-progress{width:min(320px,55vw);height:4px;margin:4px auto 0;overflow:hidden;border-radius:4px;background:#e8dfd2}.shamim-category-progress span{display:block;width:22%;height:100%;border-radius:inherit;background:#18a957;transform-origin:right center;transition:transform .2s ease}@media(max-width:680px){.shamim-category-heading{margin-bottom:20px;padding-inline:15px}.shamim-category-shell{padding-inline:0}.shamim-category-track{gap:12px;padding:8px 15px 20px}.shamim-category-card{flex-basis:136px;border-radius:16px;padding:8px 8px 12px}.shamim-category-card strong{font-size:12px;margin-top:8px}.shamim-category-card small{font-size:9px}.shamim-category-arrow{display:none}}
.shamim-category-card,.shamim-category-image,.shamim-category-image img{-webkit-user-drag:none}
</style>
@endPushOnce

<script>
(() => {
    const initializeCategoryCarousel = (attempt = 0) => {
    const root = document.getElementById(@js($carouselId));

    if (!root) {
        if (attempt < 20) setTimeout(() => initializeCategoryCarousel(attempt + 1), 50);
        return;
    }

    if (root.dataset.ready) return;

    root.dataset.ready = 'true';
    const track = root.querySelector('.shamim-category-track');
    const progress = root.parentElement.querySelector('.shamim-category-progress span');
    const step = () => Math.max(150, Math.round(track.clientWidth * .72));
    const isRtl = getComputedStyle(track).direction === 'rtl';
    const update = () => {
        const max = Math.max(1, track.scrollWidth - track.clientWidth);
        const value = Math.min(1, Math.abs(track.scrollLeft) / max);
        progress.style.transform = `translateX(${-value * 355}%)`;
    };
    root.querySelector('.shamim-category-next').addEventListener('click', () => track.scrollBy({left:isRtl ? -step() : step(),behavior:'smooth'}));
    root.querySelector('.shamim-category-prev').addEventListener('click', () => track.scrollBy({left:isRtl ? step() : -step(),behavior:'smooth'}));

    let dragging = false;
    let moved = false;
    let startX = 0;
    let startScroll = 0;

    track.addEventListener('mousedown', (event) => {
        if (event.button !== 0) return;
        dragging = true;
        moved = false;
        startX = event.clientX;
        startScroll = track.scrollLeft;
        track.classList.add('is-dragging');
    });

    track.addEventListener('dragstart', (event) => event.preventDefault());

    document.addEventListener('mousemove', (event) => {
        if (!dragging) return;
        const delta = event.clientX - startX;
        if (Math.abs(delta) > 5) moved = true;
        track.scrollLeft = startScroll + delta * (isRtl ? 1 : -1);
        event.preventDefault();
    });

    const stopDragging = () => {
        if (!dragging) return;
        dragging = false;
        track.classList.remove('is-dragging');
    };

    document.addEventListener('mouseup', stopDragging);
    window.addEventListener('blur', stopDragging);
    track.addEventListener('click', (event) => {
        if (!moved) return;
        event.preventDefault();
        event.stopPropagation();
        moved = false;
    }, true);
    track.addEventListener('scroll', update, {passive:true});
    update();

    };

    const boot = () => setTimeout(initializeCategoryCarousel, 50);

    if (document.readyState === 'complete') {
        boot();
    } else {
        window.addEventListener('load', boot, { once: true });
    }
})();
</script>
