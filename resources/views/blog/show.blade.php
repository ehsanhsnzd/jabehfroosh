@push('meta')
    <meta name="description" content="{{ $page->meta_description }}">
    <meta name="keywords" content="{{ $page->meta_keywords }}">
@endpush

<x-shop::layouts>
    <x-slot:title>{{ $page->meta_title ?: $page->page_title }}</x-slot>
    <main class="shamim-article" dir="rtl">
        <nav aria-label="مسیر صفحه"><a href="{{ route('shop.blog.index') }}">مجله جعبه فروش</a><span> / </span><span>{{ $page->page_title }}</span></nav>
        <article>
            <h1>{{ $page->page_title }}</h1>
            <p class="shamim-article__lead">{{ $page->meta_description }}</p>
            <div class="shamim-article__content">{!! $page->html_content !!}</div>
        </article>
        <a class="shamim-article__back" href="{{ route('shop.blog.index') }}">بازگشت به همه مقاله‌ها ←</a>
    </main>
    @push('styles')
        <style>
            .shamim-article{max-width:1000px;margin:auto;padding:55px 60px 120px;color:#17281f}.shamim-article nav{color:#78817c;margin-bottom:42px}.shamim-article nav a,.shamim-article__back{color:#00a651;font-weight:700}.shamim-article h1{font-size:clamp(2rem,4vw,3.6rem);line-height:1.45;margin-bottom:15px}.shamim-article__lead{font-size:1.2rem;line-height:2;color:#69726d;margin-bottom:35px}.shamim-article__content{font-size:1.08rem;line-height:2.15}.shamim-article__content>img:first-child{width:100%;max-height:560px;object-fit:cover;border-radius:28px;margin-bottom:35px}.shamim-article__content h2{font-size:1.75rem;margin:42px 0 12px}.shamim-article__content ul{list-style:disc;padding-right:25px;margin:15px 0}.shamim-article__content li,.shamim-article__content p{margin:9px 0}.shamim-article__back{display:inline-flex;margin-top:45px;border:1px solid #00a651;border-radius:99px;padding:12px 22px}@media(max-width:767px){.shamim-article{padding:35px 16px 105px}.shamim-article nav{margin-bottom:26px}.shamim-article__lead,.shamim-article__content{font-size:1rem}.shamim-article__content>img:first-child{border-radius:18px}}
        </style>
    @endpush
</x-shop::layouts>
