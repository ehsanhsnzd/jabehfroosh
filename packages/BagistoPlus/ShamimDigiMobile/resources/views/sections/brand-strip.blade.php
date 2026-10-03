<div class="sc">
    <div class="sh-title"><span {{ $section->liveUpdate()->text('eyebrow') }}>{{ $section->settings->eyebrow }}</span><h2 {{ $section->liveUpdate()->text('heading') }}>{{ $section->settings->heading }}</h2></div>
    <div class="brands">
        @foreach ($section->blocks as $block)
            <div class="brand" {{ $block->liveUpdate()->text('name') }}>{{ $block->settings->name }}</div>
        @endforeach
    </div>
</div>
