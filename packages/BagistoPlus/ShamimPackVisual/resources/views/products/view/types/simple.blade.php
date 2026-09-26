@if (config('packaging.enabled') && $product->type === 'simple' && (float) $product->price > 0)
    @include('shop::products.view.types.packaging-quantity')
@endif

@include('shop::products.view.customizable-options')
