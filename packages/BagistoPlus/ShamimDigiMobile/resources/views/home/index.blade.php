@php
    $channel = core()->getCurrentChannel();
@endphp

@push('meta')
    <meta name="title" content="جعبه فروش | فروش تخصصی بسته‌بندی غذا">
    <meta name="description" content="فروشگاه فارسی جعبه غذا، کاغذ کرافت و بسته‌بندی اختصاصی جعبه فروش">
@endPush

<x-shop::layouts :has-feature="false">
    <x-slot:title>جعبه فروش | فروش تخصصی بسته‌بندی غذا</x-slot>

    @includeIf('shop::templates.index')
</x-shop::layouts>
