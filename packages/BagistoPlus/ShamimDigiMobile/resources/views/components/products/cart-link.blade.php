@props(['productId'])

<v-product-cart-link product-id="{{ $productId }}">
    {{ $slot }}
</v-product-cart-link>

@pushOnce('scripts')
    <script type="text/x-template" id="v-product-cart-link-template">
        <div class="sh-digi-cart-link" @keyup.esc="isVisible = false" @click="isVisible = false">
            <div v-if="isVisible" class="sh-digi-cart-link__popup" role="status" aria-live="polite">
                <a href="{{ route('shop.checkout.cart.index') }}" class="sh-digi-cart-link__action">
                    <span class="icon-cart" aria-hidden="true"></span>
                    رفتن به سبد خرید
                    <span aria-hidden="true">←</span>
                </a>
            </div>

            <slot></slot>
        </div>
    </script>

    <script type="module">
        app.component('v-product-cart-link', {
            template: '#v-product-cart-link-template',

            props: ['productId'],

            data() {
                return { isVisible: false };
            },

            mounted() {
                this.$emitter.on('shamim-product-added-to-cart', this.showCartLink);
                document.addEventListener('click', this.dismissOutside);
            },

            beforeUnmount() {
                this.$emitter.off('shamim-product-added-to-cart', this.showCartLink);
                document.removeEventListener('click', this.dismissOutside);
            },

            methods: {
                showCartLink(productId) {
                    if (String(productId) === String(this.productId)) {
                        this.isVisible = true;
                    }
                },

                dismissOutside(event) {
                    if (! this.$el.contains(event.target)) {
                        this.isVisible = false;
                    }
                },
            },
        });
    </script>
@endPushOnce
