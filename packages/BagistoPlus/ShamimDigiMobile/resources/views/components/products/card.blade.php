<v-product-card {{ $attributes }} :product="product">
</v-product-card>

@pushOnce('scripts')
    <script
        type="text/x-template"
        id="v-product-card-template"
    >
        {{-- Grid Card --}}
        <article class="sh-digi-product-card" v-if="mode != 'list'">
            <a class="sh-digi-product-card__image" :href="productUrl" :aria-label="product.name + ' '">
                <x-shop::media.images.lazy
                    ::src="product.base_image.medium_image_url"
                    ::key="product.id"
                    ::index="product.id"
                    width="291"
                    height="291"
                    ::alt="product.name"
                />
            </a>

            <div class="sh-digi-product-card__body">
                <div class="sh-digi-product-card__facts">
                    <div class="sh-digi-product-card__rating" aria-label="امتیاز محصول">
                        <span>@{{ product.ratings.average }}</span>
                        <span class="icon-star-fill" aria-hidden="true"></span>
                    </div>

                    <div class="sh-digi-product-card__colors" v-if="product.print_colors.length" aria-label="رنگ‌های چاپ">
                        <span
                            v-for="(color, index) in product.print_colors"
                            :key="index"
                            class="sh-digi-product-card__color"
                            :style="{ backgroundColor: color }"
                        ></span>
                    </div>
                </div>

                <p class="sh-digi-product-card__paper" v-if="product.paper_type" v-text="product.paper_type"></p>

                <a class="sh-digi-product-card__name" :href="productUrl" v-text="formatProductName(product.name)"></a>

                <p class="sh-digi-product-card__inquiry" v-if="isCatalogInquiry">استعلام قیمت</p>

                <template v-else>
                    <p class="sh-digi-product-card__unit-price">قیمت هر @{{ product.sale_unit }}</p>

                    <div class="sh-digi-product-card__price" v-html="product.price_html"></div>
                </template>

                <span class="sh-digi-product-card__discount" v-if="product.discount_percent">@{{ product.discount_percent }}٪</span>
            </div>
        </article>

        {{-- List Card --}}
        <div
            class="relative flex max-w-max grid-cols-2 gap-4 overflow-hidden rounded max-sm:flex-wrap"
            v-else
        >
            <div class="group relative max-h-[258px] max-w-[250px] overflow-hidden rounded-[18px] border-2 border-[#0f5132]">

                {!! view_render_event('bagisto.shop.components.products.card.image.before') !!}

                <a
                    class="relative block"
                    :href="productUrl"
                >
                    <x-shop::media.images.lazy
                        class="after:content-[' '] relative min-w-[250px]  transition-all duration-300 after:block after:pb-[calc(100%+9px)] group-hover:scale-105"
                        ::src="product.base_image.medium_image_url + '?frame-clean=20260831'"
                        ::key="product.id"
                        ::index="product.id"
                        width="291"
                        height="300"
                        ::alt="product.name"
                    />

                    <img
                        class="pointer-events-none absolute inset-0 z-30 h-full w-full select-none object-fill"
                        src="{{ bagisto_asset('images/product-overlays/leaves-top-transparent.png') }}"
                        alt=""
                        aria-hidden="true"
                        draggable="false"
                    >
                </a>

                {!! view_render_event('bagisto.shop.components.products.card.image.after') !!}

                <div class="action-items bg-background">
                    <p
                        class="absolute top-5 inline-block rounded-[44px] bg-danger px-2.5 text-sm text-on-danger ltr:left-5 max-sm:ltr:left-2 rtl:right-5"
                        v-if="product.on_sale"
                    >
                        @lang('shop::app.components.products.card.sale')
                    </p>

                    <p
                        class="absolute top-5 inline-block rounded-[44px] bg-primary px-2.5 text-sm text-on-primary ltr:left-5 max-sm:ltr:left-2 rtl:right-5"
                        v-else-if="product.is_new"
                    >
                        @lang('shop::app.components.products.card.new')
                    </p>

                    <div class="opacity-0 transition-all duration-300 group-hover:bottom-0 group-hover:opacity-100 max-sm:opacity-100">

                        {!! view_render_event('bagisto.shop.components.products.card.wishlist_option.before') !!}

                        @if (core()->getConfigData('customer.settings.wishlist.wishlist_option'))
                            <span
                                class="absolute top-5 flex h-[30px] w-[30px] cursor-pointer items-center justify-center rounded-md bg-background text-2xl ltr:right-5 rtl:left-5"
                                role="button"
                                aria-label="@lang('shop::app.components.products.card.add-to-wishlist')"
                                tabindex="0"
                                :class="product.is_wishlist ? 'icon-heart-fill text-danger' : 'icon-heart'"
                                @click="addToWishlist()"
                            >
                            </span>
                        @endif

                        {!! view_render_event('bagisto.shop.components.products.card.wishlist_option.after') !!}

                        {!! view_render_event('bagisto.shop.components.products.card.compare_option.before') !!}

                        @if (core()->getConfigData('catalog.products.settings.compare_option'))
                            <span
                                class="icon-compare absolute top-16 flex h-[30px] w-[30px] cursor-pointer items-center justify-center rounded-md bg-background text-2xl ltr:right-5 rtl:left-5"
                                role="button"
                                aria-label="@lang('shop::app.components.products.card.add-to-compare')"
                                tabindex="0"
                                @click="addToCompare(product.id)"
                            >
                            </span>
                        @endif

                        {!! view_render_event('bagisto.shop.components.products.card.compare_option.after') !!}
                    </div>
                </div>
            </div>

            <div class="grid content-start gap-4">

                {!! view_render_event('bagisto.shop.components.products.card.name.before') !!}

                <p
                    class="break-words whitespace-normal text-base [word-break:normal]"
                    v-text="formatProductName(product.name)"
                ></p>

                {!! view_render_event('bagisto.shop.components.products.card.name.after') !!}

                {!! view_render_event('bagisto.shop.components.products.card.price.before') !!}

                <div
                    class="flex gap-2.5 text-lg font-semibold text-primary"
                    v-if="isCatalogInquiry"
                >
                    استعلام قیمت
                </div>

                <div
                    class="flex gap-2.5 text-lg font-semibold"
                    v-html="product.price_html"
                    v-else
                >
                </div>

                {!! view_render_event('bagisto.shop.components.products.card.price.after') !!}

                <!-- Needs to implement that in future -->
                <div class="flex hidden gap-4">
                    <span class="block h-[30px] w-[30px] rounded-full bg-[#B5DCB4]">
                    </span>

                    <span class="block h-[30px] w-[30px] rounded-full bg-zinc-500">
                    </span>
                </div>

                {!! view_render_event('bagisto.shop.components.products.card.average_ratings.before') !!}

                <p class="text-sm text-on-background/70">
                    <template  v-if="! product.ratings.total">
                        <p class="text-sm text-on-background/70">
                            @lang('shop::app.components.products.card.review-description')
                        </p>
                    </template>

                    <template v-else>
                        @if (core()->getConfigData('catalog.products.review.summary') == 'star_counts')
                            <x-shop::products.ratings
                                ::average="product.ratings.average"
                                ::total="product.ratings.total"
                                ::rating="false"
                            />
                        @else
                            <x-shop::products.ratings
                                ::average="product.ratings.average"
                                ::total="product.reviews.total"
                                ::rating="false"
                            />
                        @endif
                    </template>
                </p>

                {!! view_render_event('bagisto.shop.components.products.card.average_ratings.after') !!}

                @if (core()->getConfigData('sales.checkout.shopping_cart.cart_page'))

                    {!! view_render_event('bagisto.shop.components.products.card.add_to_cart.before') !!}

                    <a
                        class="primary-button whitespace-nowrap px-8 py-2.5 text-center"
                        :href="productUrl"
                        v-if="isCatalogInquiry"
                    >
                        مشاهده و استعلام
                    </a>

                    <template v-else>
                        <x-shop::button
                            class="primary-button whitespace-nowrap px-8 py-2.5"
                            :title="trans('shop::app.components.products.card.add-to-cart')"
                            ::loading="isAddingToCart"
                            ::disabled="! product.is_saleable || isAddingToCart"
                            @click="addToCart()"
                        />
                    </template>

                    {!! view_render_event('bagisto.shop.components.products.card.add_to_cart.after') !!}

                @endif
            </div>
        </div>
    </script>

    <script type="module">
        app.component('v-product-card', {
            template: '#v-product-card-template',

            props: ['mode', 'product'],

            data() {
                return {
                    isCustomer: '{{ auth()->guard('customer')->check() }}',

                    isAddingToCart: false,
                }
            },

            computed: {
                isCatalogInquiry() {
                    return Boolean(this.product.is_catalog_inquiry);
                },

                productUrl() {
                    const url = new URL("{{ route('shop.product_or_category.index', ':slug') }}");
                    url.pathname = this.product.url_key;
                    return url.href;
                }
            },

            methods: {
                formatProductName(name) {
                    return String(name ?? '')
                        .replace(/([0-9۰-۹٠-٩])\s+(گرم|کیلوگرم|عدد|عددی|تکه|سانتی(?:‌|\s)?متر|میلی(?:‌|\s)?متر|CM)(?=\s|$|[،,.؛)])/giu, '$1\u00a0$2');
                },

                addToWishlist() {
                    if (this.isCustomer) {
                        this.$axios.post(`{{ route('shop.api.customers.account.wishlist.store') }}`, {
                                product_id: this.product.id
                            })
                            .then(response => {
                                this.product.is_wishlist = !this.product.is_wishlist;

                                this.$emitter.emit('add-flash', {
                                    type: 'success',
                                    message: response.data.data.message
                                });
                            })
                            .catch(error => {});
                    } else {
                        window.location.href = "{{ route('shop.customer.session.index') }}";
                    }
                },

                addToCompare(productId) {
                    /**
                     * This will handle for customers.
                     */
                    if (this.isCustomer) {
                        this.$axios.post('{{ route('shop.api.compare.store') }}', {
                                'product_id': productId
                            })
                            .then(response => {
                                this.$emitter.emit('add-flash', {
                                    type: 'success',
                                    message: response.data.data.message
                                });
                            })
                            .catch(error => {
                                if ([400, 422].includes(error.response.status)) {
                                    this.$emitter.emit('add-flash', {
                                        type: 'warning',
                                        message: error.response.data.data.message
                                    });

                                    return;
                                }

                                this.$emitter.emit('add-flash', {
                                    type: 'error',
                                    message: error.response.data.message
                                });
                            });

                        return;
                    }

                    /**
                     * This will handle for guests.
                     */
                    let items = this.getStorageValue() ?? [];

                    if (items.length) {
                        if (!items.includes(productId)) {
                            items.push(productId);

                            localStorage.setItem('compare_items', JSON.stringify(items));

                            this.$emitter.emit('add-flash', {
                                type: 'success',
                                message: "@lang('shop::app.components.products.card.add-to-compare-success')"
                            });
                        } else {
                            this.$emitter.emit('add-flash', {
                                type: 'warning',
                                message: "@lang('shop::app.components.products.card.already-in-compare')"
                            });
                        }
                    } else {
                        localStorage.setItem('compare_items', JSON.stringify([productId]));

                        this.$emitter.emit('add-flash', {
                            type: 'success',
                            message: "@lang('shop::app.components.products.card.add-to-compare-success')"
                        });

                    }
                },

                getStorageValue(key) {
                    let value = localStorage.getItem('compare_items');

                    if (!value) {
                        return [];
                    }

                    return JSON.parse(value);
                },

                addToCart() {
                    this.isAddingToCart = true;

                    this.$axios.post('{{ route('shop.api.checkout.cart.store') }}', {
                            'quantity': 1,
                            'product_id': this.product.id,
                        })
                        .then(response => {
                            if (response.data.message) {
                                this.$emitter.emit('update-mini-cart', response.data.data);

                                this.$emitter.emit('add-flash', {
                                    type: 'success',
                                    message: response.data.message
                                });
                            } else {
                                this.$emitter.emit('add-flash', {
                                    type: 'warning',
                                    message: response.data.data.message
                                });
                            }

                            this.isAddingToCart = false;
                        })
                        .catch(error => {
                            this.$emitter.emit('add-flash', {
                                type: 'error',
                                message: error.response.data.message
                            });

                            if (error.response.data.redirect_uri) {
                                window.location.href = error.response.data.redirect_uri;
                            }

                            this.isAddingToCart = false;
                        });
                },
            },
        });
    </script>
@endpushOnce
