@if ($product->type === 'configurable' || $product->parent_id)
    <div class="box-shadow rounded bg-white p-4 dark:bg-gray-900">
        <p class="mb-4 text-base font-semibold text-gray-800 dark:text-white">
            @lang('admin::app.variant-pricing.title')
        </p>

        <x-admin::form.control-group>
            @if ($product->type === 'configurable')
                <x-admin::form.control-group.label>
                    @lang('admin::app.variant-pricing.discount')
                </x-admin::form.control-group.label>

                <x-admin::form.control-group.control
                    type="text"
                    inputmode="decimal"
                    name="variant_discount_percent"
                    rules="decimal|min_value:0|max_value:99.99"
                    :value="old('variant_discount_percent', $product->variant_discount_percent ?? 0)"
                    :label="trans('admin::app.variant-pricing.discount')"
                />

                <x-admin::form.control-group.error control-name="variant_discount_percent" />
            @else
                <x-admin::form.control-group.label class="required">
                    @lang('admin::app.variant-pricing.multiplier')
                </x-admin::form.control-group.label>

                <x-admin::form.control-group.control
                    type="number"
                    name="price_multiplier"
                    rules="required|integer|min_value:1|max_value:1000000"
                    min="1"
                    max="1000000"
                    step="1"
                    :value="old('price_multiplier', $product->price_multiplier ?? 1)"
                    :label="trans('admin::app.variant-pricing.multiplier')"
                />

                <x-admin::form.control-group.error control-name="price_multiplier" />
            @endif
        </x-admin::form.control-group>

        <p class="text-xs text-gray-500 dark:text-gray-300">
            @lang('admin::app.variant-pricing.info')
        </p>
    </div>
@endif
