<div class="marquee-track">
    @for ($copy = 0; $copy < 2; $copy++)
        @foreach ($section->blocks as $block)
            <span><i>✦</i> <b {{ $block->liveUpdate()->text('text') }}>{{ $block->settings->text }}</b></span>
        @endforeach
    @endfor
</div>
