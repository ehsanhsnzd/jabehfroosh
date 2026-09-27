<v-shamim-mobile-bottom-nav></v-shamim-mobile-bottom-nav>

@pushOnce('scripts')
    <script type="text/x-template" id="v-shamim-mobile-bottom-nav-template">
        <nav class="sh-mobile-bottom-nav" aria-label="دسترسی سریع موبایل">
            <a
                href="{{ route('shop.home.index') }}"
                class="sh-mobile-bottom-nav__item {{ request()->routeIs('shop.home.index') ? 'is-active' : '' }}"
                aria-label="خانه"
            >
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true"><path d="M3 10.5 12 3l9 7.5v8a2 2 0 0 1-2 2h-5v-6h-4v6H5a2 2 0 0 1-2-2z" stroke-linecap="round" stroke-linejoin="round"/></svg>
                <span>خانه</span>
            </a>

            <a
                href="{{ route('shop.home.contact_us') }}"
                class="sh-mobile-bottom-nav__item {{ request()->routeIs('shop.home.contact_us') ? 'is-active' : '' }}"
                aria-label="پشتیبانی"
            >
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true"><path d="M20 11.5a8 8 0 0 1-8 8 8.8 8.8 0 0 1-3.4-.7L4 20l1.2-4A8 8 0 1 1 20 11.5Z" stroke-linecap="round" stroke-linejoin="round"/><path d="M8.5 11.5h.01M12 11.5h.01M15.5 11.5h.01" stroke-linecap="round"/></svg>
                <span>پشتیبانی</span>
            </a>

            <a
                href="{{ route('shop.checkout.cart.index') }}"
                class="sh-mobile-bottom-nav__item {{ request()->routeIs('shop.checkout.cart.index') ? 'is-active' : '' }}"
                aria-label="سبد خرید"
            >
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true"><path d="M3 4h2l2 11h10.5l2-8H6" stroke-linecap="round" stroke-linejoin="round"/><circle cx="9" cy="19" r="1.4"/><circle cx="17" cy="19" r="1.4"/></svg>
                <span v-if="itemsQty" class="sh-mobile-bottom-nav__badge">@{{ itemsQty }}</span>
                <span>سبد خرید</span>
            </a>

            <a
                href="{{ route('shop.search.index') }}"
                class="sh-mobile-bottom-nav__item {{ request()->routeIs('shop.search.index', 'shop.product_or_category.index') ? 'is-active' : '' }}"
                aria-label="محصولات"
            >
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true"><path d="M4 10v10h16V10M3 4h18l-1 6a3 3 0 0 1-5 1 3 3 0 0 1-6 0 3 3 0 0 1-5-1zM9 20v-5h6v5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                <span>محصولات</span>
            </a>
        </nav>
    </script>

    <script type="module">
        app.component('v-shamim-mobile-bottom-nav', {
            template: '#v-shamim-mobile-bottom-nav-template',

            data() {
                return { itemsQty: 0 };
            },

            mounted() {
                this.getCart();
                this.$emitter.on('update-mini-cart', this.updateCart);
            },

            beforeUnmount() {
                this.$emitter.off('update-mini-cart', this.updateCart);
            },

            methods: {
                updateCart(cart) {
                    const currentCart = cart?.data ?? cart;
                    this.itemsQty = Number(currentCart?.items_count ?? 0);
                },

                getCart() {
                    this.$axios.get('{{ route('shop.api.checkout.cart.index') }}')
                        .then(response => this.updateCart(response.data.data))
                        .catch(() => this.itemsQty = 0);
                },
            },
        });
    </script>
@endPushOnce
