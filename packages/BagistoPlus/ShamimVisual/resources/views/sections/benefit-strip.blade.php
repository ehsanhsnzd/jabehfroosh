<div class="sc bg">
    @foreach ($section->blocks as $block)
        <div class="benefit"><i {{ $block->liveUpdate()->text('icon') }}>{{ $block->settings->icon }}</i><div><b {{ $block->liveUpdate()->text('title') }}>{{ $block->settings->title }}</b><span {{ $block->liveUpdate()->text('description') }}>{{ $block->settings->description }}</span></div></div>
    @endforeach
</div>
