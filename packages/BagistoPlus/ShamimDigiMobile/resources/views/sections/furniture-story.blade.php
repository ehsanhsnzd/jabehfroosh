<div class="sc">
    <div class="promo">
        <div class="pv"><img src="{{ $section->settings->image }}" alt="" {{ $section->liveUpdate()->attr('image', 'src') }}></div>
        <div class="pc">
            <span class="kick" {{ $section->liveUpdate()->text('eyebrow') }}>{{ $section->settings->eyebrow }}</span>
            <h2 {{ $section->liveUpdate()->text('heading') }}>{{ $section->settings->heading }}</h2>
            <p {{ $section->liveUpdate()->text('description') }}>{{ str_replace('شمیم پک', 'جعبه فروش', $section->settings->description) }}</p>
            <a class="sh-btn story-button" href="{{ $section->settings->button_url }}" {{ $section->liveUpdate()->text('button_text')->attr('button_url', 'href') }}>{{ $section->settings->button_text }}</a>
            <div class="stats">
                @foreach ($section->blocks as $block)
                    <div class="stat"><b {{ $block->liveUpdate()->text('value') }}>{{ $block->settings->value }}</b><span {{ $block->liveUpdate()->text('label') }}>{{ $block->settings->label }}</span></div>
                @endforeach
            </div>
        </div>
    </div>
</div>
