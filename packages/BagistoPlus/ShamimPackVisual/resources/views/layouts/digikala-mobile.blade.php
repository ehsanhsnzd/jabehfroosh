@php
    $hasHeader = $hasHeader ?? true;
    $hasFooter = $hasFooter ?? true;
@endphp

<!DOCTYPE html>

<html lang="{{ app()->getLocale() }}" dir="{{ core()->getCurrentLocale()->direction }}">
    <head>
        {!! view_render_event('bagisto.shop.layout.head.before') !!}

        <title>@yield('page_title', config('app.name'))</title>

        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta http-equiv="content-language" content="{{ app()->getLocale() }}">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="base-url" content="{{ url()->to('/') }}">
        <meta name="currency" content="{{ core()->getCurrentCurrency()->toJson() }}">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        @stack('meta')

        <link
            rel="icon"
            sizes="any"
            href="{{ core()->getCurrentChannel()->favicon_url ?? bagisto_asset('images/favicon.ico') }}"
        >

        <link
            rel="icon"
            type="image/png"
            sizes="32x32"
            href="{{ bagisto_asset('images/favicon-32.png') }}"
        >

        <link
            rel="apple-touch-icon"
            sizes="180x180"
            href="{{ bagisto_asset('images/apple-touch-icon.png') }}"
        >

        @includeIf('shop::partials.tokens')

        @bagistoVite(['resources/assets/css/shop.css', 'resources/assets/js/shop.js'])

        @stack('styles')

        <style>
            {!! core()->getConfigData('general.content.custom_scripts.custom_css') !!}
        </style>

        {!! view_render_event('bagisto.shop.layout.head.after') !!}
    </head>

    <body class="bg-background text-on-background shamim-pack-theme">
        {!! view_render_event('bagisto.shop.layout.body.before') !!}

        <a href="#main" class="skip-to-main-content-link">
            Skip to main content
        </a>

        <div id="app">
            @if ($hasHeader)
                <visual:section name="shamim-pack::top-bar" />
                <visual:section name="shamim-pack::header" />
            @endif

            @if (core()->getConfigData('general.gdpr.settings.enabled') && core()->getConfigData('general.gdpr.cookie.enabled'))
                <x-shop::layouts.cookie />
            @endif

            {!! view_render_event('bagisto.shop.layout.content.before') !!}

            <main id="main" @class(['shamim-main-with-footer' => $hasFooter])>
                @visual_layout_content
            </main>

            {!! view_render_event('bagisto.shop.layout.content.after') !!}

            @if ($hasFooter)
                <visual:section name="shamim-pack::footer" />
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
            window.addEventListener('load', () => window.setupApp());
        </script>

        {!! view_render_event('bagisto.shop.layout.vue-app-mount.after') !!}

        <script type="text/javascript">
            {!! core()->getConfigData('general.content.custom_scripts.custom_javascript') !!}
        </script>
    </body>
</html>
