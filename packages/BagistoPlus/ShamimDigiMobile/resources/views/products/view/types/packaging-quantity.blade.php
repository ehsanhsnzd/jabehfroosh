@php
    $unitPrice = (float) $product->getTypeInstance()->getFinalPrice();
    $maximumQuantity = min(
        (int) config('packaging.maximum_quantity'),
        max(1, (int) floor(config('packaging.maximum_total') / max($unitPrice, 1)))
    );
@endphp

<v-packaging-quantity :errors="errors"></v-packaging-quantity>

@pushOnce('scripts')
    <script type="text/x-template" id="v-packaging-quantity-template">
        <div class="mt-6 max-w-[470px]">
            <label for="packaging-selection" class="mb-3 block text-lg font-medium">تعداد سفارش</label>

            <v-field
                as="select"
                id="packaging-selection"
                name="packaging_selection"
                rules="required"
                label="تعداد سفارش"
                v-model="selection"
                class="w-full rounded-lg border px-4 py-3"
            >
                <option value="">انتخاب کنید</option>
                @foreach (config('packaging.quantities') as $quantity)
                    <option value="{{ $quantity }}">{{ $quantity }} عدد</option>
                @endforeach
                <option value="custom">تعداد دلخواه</option>
            </v-field>

            <span class="text-sm text-red-600" role="alert">@{{ errors.packaging_selection }}</span>

            <div v-if="selection === 'custom'" class="mt-4">
                <label for="custom-quantity" class="mb-2 block">تعداد دلخواه</label>

                <v-field
                    name="custom_quantity"
                    rules="required|integer|min_value:1|max_value:{{ $maximumQuantity }}"
                    label="تعداد دلخواه"
                    v-model="customQuantity"
                    v-slot="{ field, handleChange }"
                >
                    <input
                        v-bind="field"
                        id="custom-quantity"
                        type="text"
                        inputmode="numeric"
                        autocomplete="off"
                        @input="normalizeNumber($event, handleChange)"
                        class="w-full rounded-lg border px-4 py-3"
                    >
                </v-field>

                <span class="text-sm text-red-600" role="alert">@{{ errors.custom_quantity }}</span>
            </div>

            <div v-if="validQuantity" class="mt-4 rounded-lg border p-4" aria-live="polite">
                <p>قیمت هر عدد: @{{ $shop.formatPrice(unitPrice) }}</p>
                <p class="mt-2">تعداد کل: @{{ quantity.toLocaleString('fa-IR') }} عدد</p>
                <p class="mt-2 text-lg font-medium">مبلغ کل: @{{ $shop.formatPrice(quantity * unitPrice) }}</p>
            </div>
        </div>
    </script>

    <script type="module">
        app.component('v-packaging-quantity', {
            template: '#v-packaging-quantity-template',

            props: {
                errors: {
                    type: Object,
                    default: () => ({}),
                },
            },

            data() {
                return {
                    selection: '',
                    customQuantity: '',
                    unitPrice: @json($unitPrice),
                    maximumQuantity: @json($maximumQuantity),
                };
            },

            computed: {
                quantity() {
                    return this.selection === 'custom'
                        ? Number(this.customQuantity)
                        : Number(this.selection);
                },

                validQuantity() {
                    return Number.isInteger(this.quantity)
                        && this.quantity >= 1
                        && this.quantity <= this.maximumQuantity;
                },
            },

            methods: {
                normalizeNumber(event, handleChange) {
                    const value = event.target.value
                        .replace(/[۰-۹]/g, digit => String('۰۱۲۳۴۵۶۷۸۹'.indexOf(digit)))
                        .replace(/[٠-٩]/g, digit => String('٠١٢٣٤٥٦٧٨٩'.indexOf(digit)));
                    const normalized = /^[0-9]*$/.test(value) ? value : '';

                    event.target.value = normalized;
                    this.customQuantity = normalized;
                    handleChange(normalized);
                },
            },
        });
    </script>
@endPushOnce
