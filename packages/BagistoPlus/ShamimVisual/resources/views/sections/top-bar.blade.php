<div class="sc">
    <div class="announce-items">
        <div class="announce-track" id="announceTrack">
            @foreach (['message_1', 'message_2', 'message_3'] as $message)
                <span><i class="announce-dot"></i><b {{ $section->liveUpdate()->text($message) }}>{{ $section->settings->{$message} }}</b></span>
            @endforeach
        </div>
    </div>

    <div class="announce-links">
        @for ($i = 1; $i <= 3; $i++)
            <a
                href="{{ $section->settings->{'link_'.$i.'_url'} }}"
                @class(['announce-link', 'announce-link--tracking' => $i === 2])
                {{ $section->liveUpdate()->text('link_'.$i.'_text')->attr('link_'.$i.'_url', 'href') }}
            >{{ $section->settings->{'link_'.$i.'_text'} }}</a>
        @endfor
    </div>
</div>
