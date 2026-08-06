<div class="sc">
    <div class="sh-title"><span {{ $section->liveUpdate()->text('eyebrow') }}>{{ $section->settings->eyebrow }}</span><h2 {{ $section->liveUpdate()->text('heading') }}>{{ $section->settings->heading }}</h2></div>
    <div class="editorial">
        @foreach ($section->blocks as $block)
            <a class="editorial-card" href="{{ $block->settings->url }}" {{ $block->liveUpdate()->attr('url', 'href') }}>
                <img src="{{ $block->settings->image }}" alt="{{ $block->settings->title }}" {{ $block->liveUpdate()->attr('image', 'src')->attr('title', 'alt') }}>
                <div class="editorial-copy"><small {{ $block->liveUpdate()->text('category') }}>{{ $block->settings->category }}</small><h3 {{ $block->liveUpdate()->text('title') }}>{{ $block->settings->title }}</h3><span {{ $block->liveUpdate()->text('link_text') }}>{{ $block->settings->link_text }}</span></div>
            </a>
        @endforeach
    </div>
</div>
