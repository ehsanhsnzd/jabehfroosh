<div class="sc">
    <div class="sh-title">
        <span {{ $section->liveUpdate()->text('eyebrow') }}>{{ $section->settings->eyebrow }}</span>
        <h2 {{ $section->liveUpdate()->text('heading') }}>{{ $section->settings->heading }}</h2>
        <p {{ $section->liveUpdate()->text('description') }}>{{ $section->settings->description }}</p>
    </div>
    <div class="cats">
        @foreach ($section->blocks as $block)
            <a class="cat" href="{{ $block->settings->url }}" {{ $block->liveUpdate()->attr('url', 'href') }}>
                <div class="ci" {{ $block->liveUpdate()->text('icon') }}>{{ $block->settings->icon }}</div>
                <h3 {{ $block->liveUpdate()->text('title') }}>{{ $block->settings->title }}</h3>
                <small {{ $block->liveUpdate()->text('count') }}>{{ $block->settings->count }}</small>
            </a>
        @endforeach
    </div>
</div>
