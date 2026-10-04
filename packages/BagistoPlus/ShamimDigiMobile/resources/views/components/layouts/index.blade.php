@props([
    'hasHeader' => true,
    'hasFeature' => true,
    'hasFooter' => true,
])

@php
    view()->share('shamimDigikalaMobileLayout', true);
@endphp

<!DOCTYPE html>

<html lang="{{ app()->getLocale() }}" dir="{{ core()->getCurrentLocale()->direction }}">

    <head>

        {!! view_render_event('bagisto.shop.layout.head.before') !!}

        <title>{{ $title ?? '' }}</title>

        <meta charset="UTF-8">

        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta http-equiv="content-language" content="{{ app()->getLocale() }}">

        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="base-url" content="{{ url()->to('/') }}">
        <meta name="currency" content="{{ core()->getCurrentCurrency()->toJson() }}">

        @stack('meta')

        <link
            rel="icon"
            sizes="any"
            href="{{ core()->getCurrentChannel()->favicon_url ?? bagisto_asset('images/favicon.ico') }}"
        />

        <link
            rel="icon"
            type="image/png"
            sizes="32x32"
            href="{{ bagisto_asset('images/favicon-32.png') }}"
        />

        <link
            rel="apple-touch-icon"
            sizes="180x180"
            href="{{ bagisto_asset('images/apple-touch-icon.png') }}"
        />

        @includeIf('shop::partials.tokens')

        @bagistoVite(['resources/assets/css/shop.css', 'resources/assets/js/shop.js'])

        @include('shop::components.layouts.header.mobile-digikala-styles')

        @stack('styles')

        @include('shamim-digi-mobile::partials.canva-font')

        <style>
            {!! core()->getConfigData('general.content.custom_scripts.custom_css') !!}
        </style>

        @if (core()->getConfigData('general.content.speculation_rules.enabled'))
            <script type="speculationrules">
                @json(core()->getSpeculationRules(), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE)
            </script>
        @endif

        {!! view_render_event('bagisto.shop.layout.head.after') !!}

    </head>

    <body class="bg-background text-on-background shamim-pack-theme shamim-digi-mobile-layout">
        {!! view_render_event('bagisto.shop.layout.body.before') !!}

        <a href="#main" class="skip-to-main-content-link">
            Skip to main content
        </a>

        <div id="app">
            @if ($hasHeader)
                <visual:section name="shamim-digi-mobile::top-bar" />
                <visual:section name="shamim-digi-mobile::header" />
            @endif

            @if (core()->getConfigData('general.gdpr.settings.enabled') && core()->getConfigData('general.gdpr.cookie.enabled'))
                <x-shop::layouts.cookie />
            @endif

            {!! view_render_event('bagisto.shop.layout.content.before') !!}

            <main
                id="main"
                @class(['shamim-main-with-footer' => $hasFooter])
            >
                <x-visual::layout-content>
                    {{ $slot }}
                </x-visual::layout-content>
            </main>

            {!! view_render_event('bagisto.shop.layout.content.after') !!}

            @if ($hasFeature)
            @endif

            @if ($hasFooter)
                <visual:section name="shamim-digi-mobile::footer" />
            @endif

            @if ($hasHeader)
                @include('shop::components.layouts.mobile-bottom-nav')
            @endif

            @include('shop::components.layouts.support-widget')

            <x-shop::flash-group />

            <x-shop::modal.confirm />
        </div>

        {!! view_render_event('bagisto.shop.layout.body.after') !!}

        @stack('scripts')

        {!! view_render_event('bagisto.shop.layout.vue-app-mount.before') !!}
        <script>
            window.addEventListener("load", function(event) {
                window.setupApp();
            });
        </script>

        {!! view_render_event('bagisto.shop.layout.vue-app-mount.after') !!}

        <script type="text/javascript">
            {!! core()->getConfigData('general.content.custom_scripts.custom_javascript') !!}
        </script>
    </body>

</html>
