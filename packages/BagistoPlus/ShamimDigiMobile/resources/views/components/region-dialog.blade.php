    <dialog id="{{ ($checkout ?? false) ? 'sh-cart-region-dialog' : 'sh-digi-region-dialog' }}" class="sh-digi-region-dialog" aria-labelledby="{{ ($checkout ?? false) ? 'sh-cart-region-title' : 'sh-digi-region-title' }}">
        <div class="sh-digi-region-dialog__heading">
            <h2 id="{{ ($checkout ?? false) ? 'sh-cart-region-title' : 'sh-digi-region-title' }}">انتخاب شهر</h2>
            <button type="button" @if($checkout ?? false) @click="closeRegionDialog" @endif data-region-close aria-label="بستن">×</button>
        </div>
        <p>محصولات متناسب با شهر انتخابی شما نمایش داده می‌شوند.</p>
        @if ($checkout ?? false)
            <div class="sh-digi-region-options">
                @foreach ($availableRegions as $code => $label)
                    <button type="button" class="sh-digi-region-option" :class="{ 'is-selected': cart.delivery_region === @js($code) }" :disabled="isStoring" @click="selectDeliveryRegion(@js($code))">{{ $label }}</button>
                @endforeach
            </div>
        @else
        <form action="{{ route('shop.catalog.region.store') }}" method="POST">
            @csrf
            @foreach ($availableRegions as $code => $label)
                <button type="submit" name="region" value="{{ $code }}" @class(['sh-digi-region-option', 'is-selected' => $selectedRegion === $code])>
                    {{ $label }}
                    @if ($selectedRegion === $code)<span aria-hidden="true">✓</span>@endif
                </button>
            @endforeach
        </form>
        @endif
    </dialog>
