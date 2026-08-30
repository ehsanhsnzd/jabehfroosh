<blockquote {{ $section->liveUpdate()->text('quote') }}>«{{ $section->settings->quote }}»</blockquote>
        <cite {{ $section->liveUpdate()->text('cite') }}>{{ str_replace('شمیم پک', 'جعبه فروش', $section->settings->cite) }}</cite>
