<div class="sc">
    <div class="sh-title">
        <span {{ $section->liveUpdate()->text('eyebrow') }}>{{ $section->settings->eyebrow }}</span>
        <h2 {{ $section->liveUpdate()->text('heading') }}>{{ $section->settings->heading }}</h2>
        <p {{ $section->liveUpdate()->text('description') }}>{{ $section->settings->description }}</p>
    </div>
    <div class="cats pack-cats">
        @foreach ($section->blocks as $block)
            <a class="cat pack-cat" href="{{ $block->settings->url }}" {{ $block->liveUpdate()->attr('url', 'href') }}>
                <div class="pack-cat-image">
                    <img src="{{ $block->settings->image }}" alt="{{ $block->settings->title }}" loading="lazy" {{ $block->liveUpdate()->attr('image', 'src') }}>
                </div>
                <div class="pack-cat-copy">
                    <h3 {{ $block->liveUpdate()->text('title') }}>{{ $block->settings->title }}</h3>
                    <small {{ $block->liveUpdate()->text('count') }}>{{ $block->settings->count }}</small>
                    <b aria-hidden="true">←</b>
                </div>
            </a>
        @endforeach
    </div>
</div>
