@include('shop::checkout.credit-summary')
<div class="w-[418px] max-w-full max-md:w-full">
    {!! view_render_event('bagisto.shop.checkout.cart.summary.title.before') !!}

    <p
        class="text-2xl font-medium max-md:text-base"
        role="heading"
        aria-level="1"
    >
        @lang('shop::app.checkout.cart.summary.cart-summary')
    </p>

    {!! view_render_event('bagisto.shop.checkout.cart.summary.title.after') !!}

    <!-- Cart Totals -->
    <div class="mt-6 grid gap-4 max-md:mt-2 max-md:gap-2.5">
        <!-- Estimate Tax and Shipping -->
        @if (core()->getConfigData('sales.checkout.shopping_cart.estimate_shipping'))
            <template v-if="cart.have_stockable_items">
                @include('shop::checkout.cart.summary.estimate-shipping')
            </template>
        @endif

        <!-- Sub Total -->
        {!! view_render_event('bagisto.shop.checkout.cart.summary.sub_total.before') !!}

        <template v-if="displayTax.subtotal == 'including_tax'">
            <div class="flex justify-between text-right">
                <p class="text-base max-sm:text-sm">
                    @lang('shop::app.checkout.cart.summary.sub-total')
                </p>

                <p class="text-base font-medium max-sm:text-sm">
                    @{{ cart.formatted_sub_total_incl_tax }}
                </p>
            </div>
        </template>

        <template v-else-if="displayTax.subtotal == 'both'">
            <div class="flex justify-between text-right">
                <p class="text-base max-sm:text-sm">
                    @lang('shop::app.checkout.cart.summary.sub-total-excl-tax')
                </p>

                <p class="text-base font-medium max-sm:text-sm">
                    @{{ cart.formatted_sub_total }}
                </p>
            </div>

            <div class="flex justify-between text-right">
                <p class="text-base max-sm:text-sm">
                    @lang('shop::app.checkout.cart.summary.sub-total-incl-tax')
                </p>

                <p class="text-base font-medium max-sm:text-sm">
                    @{{ cart.formatted_sub_total_incl_tax }}
                </p>
            </div>
        </template>

        <template v-else>
            <div class="flex justify-between text-right">
                <p class="text-base max-sm:text-sm">
                    @lang('shop::app.checkout.cart.summary.sub-total')
                </p>

                <p class="text-base font-medium max-sm:text-sm">
                    @{{ cart.formatted_sub_total }}
                </p>
            </div>
        </template>

        {!! view_render_event('bagisto.shop.checkout.cart.summary.sub_total.after') !!}

        <!-- Discount -->
        {!! view_render_event('bagisto.shop.checkout.cart.summary.discount_amount.before') !!}

        <div
            class="flex justify-between text-right"
            v-if="cart.discount_amount && parseFloat(cart.discount_amount) > 0"
        >
            <p class="text-base max-sm:text-sm">
                @lang('shop::app.checkout.cart.summary.discount-amount')
            </p>

            <p class="text-base font-medium max-sm:text-sm">
                @{{ cart.formatted_discount_amount }}
            </p>
        </div>

        {!! view_render_event('bagisto.shop.checkout.cart.summary.discount_amount.after') !!}

        <!-- Apply Coupon -->
        {!! view_render_event('bagisto.shop.checkout.cart.summary.coupon.before') !!}

        @include('shop::checkout.coupon')

        {!! view_render_event('bagisto.shop.checkout.cart.summary.coupon.after') !!}

        <!-- Shipping Rates -->
        {!! view_render_event('bagisto.shop.checkout.onepage.summary.delivery_charges.before') !!}

        <template v-if="displayTax.shipping == 'including_tax'">
            <div class="flex justify-between text-right">
                <p class="text-base max-sm:text-sm">
                    @lang('shop::app.checkout.cart.summary.delivery-charges')
                </p>

                <p class="text-base font-medium max-sm:text-sm">
                    @{{ cart.formatted_shipping_amount_incl_tax }}
                </p>
            </div>
        </template>

        <template v-else-if="displayTax.shipping == 'both'">
            <div class="flex justify-between text-right">
                <p class="text-base max-sm:text-sm">
                    @lang('shop::app.checkout.cart.summary.delivery-charges-excl-tax')
                </p>

                <p class="text-base font-medium max-sm:text-sm">
                    @{{ cart.formatted_shipping_amount }}
                </p>
            </div>

            <div class="flex justify-between text-right">
                <p class="text-base max-sm:text-sm">
                    @lang('shop::app.checkout.cart.summary.delivery-charges-incl-tax')
                </p>

                <p class="text-base font-medium max-sm:text-sm">
                    @{{ cart.formatted_shipping_amount_incl_tax }}
                </p>
            </div>
        </template>

        <template v-else>
            <div class="flex justify-between text-right">
                <p class="text-base max-sm:text-sm">
                    @lang('shop::app.checkout.cart.summary.delivery-charges')
                </p>

                <p class="text-base font-medium max-sm:text-sm">
                    @{{ cart.formatted_shipping_amount }}
                </p>
            </div>
        </template>

        {!! view_render_event('bagisto.shop.checkout.onepage.summary.delivery_charges.after') !!}

        <!-- Taxes -->
        {!! view_render_event('bagisto.shop.checkout.cart.summary.tax.before') !!}

        <div
            class="flex justify-between text-right"
            v-if="! cart.tax_total"
        >
            <p class="text-base max-md:font-normal max-sm:text-sm">
                @lang('shop::app.checkout.cart.summary.tax')
            </p>

            <p class="text-lg font-semibold max-md:text-sm">
                @{{ cart.formatted_tax_total }}
            </p>
        </div>

        <div
            class="flex flex-col gap-2 border-y py-2"
            v-else
        >
            <div
                class="flex cursor-pointer justify-between text-right"
                @click="cart.show_taxes = ! cart.show_taxes"
            >
                <p class="text-base max-md:font-normal max-sm:text-sm">
                    @lang('shop::app.checkout.cart.summary.tax')
                </p>

                <p class="flex items-center gap-1 text-base font-medium max-md:font-medium max-sm:text-sm">
                    @{{ cart.formatted_tax_total }}

                    <span
                        class="text-xl"
                        :class="{'icon-arrow-up': cart.show_taxes, 'icon-arrow-down': ! cart.show_taxes}"
                    ></span>
                </p>
            </div>

            <div
                class="flex flex-col gap-1"
                v-show="cart.show_taxes"
            >
                <div
                    class="flex justify-between gap-1 text-right"
                    v-for="(amount, index) in cart.applied_taxes"
                >
                    <p class="text-sm max-md:text-sm max-md:font-normal">
                        @{{ index }}
                    </p>

                    <p class="text-sm font-medium max-md:text-sm max-md:font-medium">
                        @{{ amount }}
                    </p>
                </div>
            </div>
        </div>

        {!! view_render_event('bagisto.shop.checkout.cart.summary.tax.after') !!}

        <!-- Cart Grand Total -->
        {!! view_render_event('bagisto.shop.checkout.cart.summary.grand_total.before') !!}

        <div class="flex justify-between text-right">
            <p class="text-lg font-semibold max-md:text-base">
                @lang('shop::app.checkout.cart.summary.grand-total')
            </p>

            <p class="text-lg font-semibold max-md:text-base">
                @{{ cart.formatted_grand_total }}
            </p>
        </div>

        {!! view_render_event('bagisto.shop.checkout.cart.summary.grand_total.after') !!}

        {!! view_render_event('bagisto.shop.checkout.cart.summary.proceed_to_checkout.before') !!}

        <p v-if="hasBlockedItems" class="text-sm" role="status">@lang('shop::delivery.removed-info')</p>
        <p v-if="noDeliverableItems" class="text-sm text-red-600" role="alert">@lang('shop::delivery.none-available')</p>
        <p v-if="deliveryError" class="text-sm text-red-600" role="alert" v-text="deliveryError"></p>
        <div style="display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; margin-top: 16px;">
            <button
                type="button"
                class="secondary-button rounded-2xl max-md:rounded-lg"
                style="width: 100%; min-width: 0; max-width: 100%; min-height: 56px; padding: 12px 8px; margin: 0; font-size: 14px;"
                aria-haspopup="dialog"
                aria-controls="sh-cart-region-dialog"
                :disabled="isStoring"
                @click="openRegionDialog"
            >
                @{{ deliveryRegionLabel || @js(trans('shop::delivery.select-city')) }}
            </button>
            <button
                type="button"
                @click="proceedCheckout"
                :disabled="isStoring || noDeliverableItems"
                :style="isStoring || noDeliverableItems ? { opacity: 0.45, cursor: 'not-allowed' } : null"
                class="primary-button rounded-2xl max-md:rounded-lg"
                style="width: 100%; min-width: 0; max-width: 100%; min-height: 56px; padding: 12px 8px; margin: 0; font-size: 14px;"
            >
                @lang('shop::app.checkout.cart.summary.proceed-to-checkout')
            </button>
        </div>

        {!! view_render_event('bagisto.shop.checkout.cart.summary.proceed_to_checkout.after') !!}
    </div>
</div>
