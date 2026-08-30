@push('meta')
    <meta name="description" content="مجله جعبه فروش؛ راهنمای انتخاب جعبه غذا، چاپ اختصاصی و بسته‌بندی حرفه‌ای رستوران و فست‌فود.">
@endpush

<x-shop::layouts>
    <x-slot:title>مجله بسته‌بندی جعبه فروش</x-slot>

    <main class="shamim-blog" dir="rtl">
        <header class="shamim-blog__hero">
            <span>مجله جعبه فروش</span>
            <h1>راهنمای حرفه‌ای بسته‌بندی غذا</h1>
            <p>نکته‌های کاربردی برای انتخاب جعبه، حفظ کیفیت غذا و ساختن یک برند به‌یادماندنی.</p>
        </header>

        <section class="shamim-blog__grid" aria-label="مقالات بسته‌بندی">
            @forelse ($pages as $page)
                @php
                    preg_match('/<img[^>]+src=["\']([^"\']+)["\']/i', $page->html_content ?? '', $imageMatch);
                    $image = $imageMatch[1] ?? asset('themes/shop/shamim-pack/images/pack-kraft.png');
                @endphp
                <article class="shamim-blog-card">
                    <a href="{{ route('shop.blog.show', $page->url_key) }}"><img src="{{ $image }}" alt="{{ $page->page_title }}" loading="lazy"></a>
                    <div>
                        <small>راهنمای بسته‌بندی</small>
                        <h2><a href="{{ route('shop.blog.show', $page->url_key) }}">{{ $page->page_title }}</a></h2>
                        <p>{{ $page->meta_description }}</p>
                        <a class="shamim-blog-card__link" href="{{ route('shop.blog.show', $page->url_key) }}">مشاهده مطلب ←</a>
                    </div>
                </article>
            @empty
                <p>مقاله‌ها به‌زودی منتشر می‌شوند.</p>
            @endforelse
        </section>
    </main>

    @push('styles')
        <style>
            .shamim-blog{max-width:1440px;margin:auto;padding:72px 60px 110px;color:#12271d}.shamim-blog__hero{text-align:center;max-width:850px;margin:0 auto 55px}.shamim-blog__hero span,.shamim-blog-card small{color:#00a651;font-weight:700}.shamim-blog__hero h1{font-size:clamp(2rem,4vw,4rem);line-height:1.35;margin:12px 0}.shamim-blog__hero p{font-size:1.15rem;color:#66706a}.shamim-blog__grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:32px}.shamim-blog-card{overflow:hidden;border:1px solid #e4e8e5;border-radius:24px;background:#fff;box-shadow:0 14px 45px rgba(18,39,29,.07)}.shamim-blog-card img{width:100%;height:330px;object-fit:cover;transition:transform .4s}.shamim-blog-card:hover img{transform:scale(1.025)}.shamim-blog-card>div{padding:28px}.shamim-blog-card h2{font-size:1.55rem;line-height:1.55;margin:8px 0}.shamim-blog-card p{color:#657069;line-height:2;min-height:64px}.shamim-blog-card__link{display:inline-flex;margin-top:15px;color:#00a651;font-weight:800}.shamim-blog a:hover{color:#007d3e}@media(max-width:767px){.shamim-blog{padding:42px 16px 100px}.shamim-blog__hero{margin-bottom:30px}.shamim-blog__grid{grid-template-columns:1fr;gap:20px}.shamim-blog-card img{height:230px}.shamim-blog-card>div{padding:21px}.shamim-blog-card h2{font-size:1.25rem}}
        </style>
    @endpush
</x-shop::layouts>
