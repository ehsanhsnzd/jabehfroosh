@php
    $channel = core()->getCurrentChannel();
@endphp

@push('meta')
    <meta name="title" content="شمیم هوم | مبلمان مدرن برای خانه شما">
    <meta name="description" content="فروشگاه مبلمان و دکوراسیون شمیم هوم">
@endPush

<x-shop::layouts :has-feature="false">
    <x-slot:title>شمیم هوم | مبلمان مدرن برای خانه شما</x-slot>

    @includeIf('shop::templates.index')
</x-shop::layouts>
