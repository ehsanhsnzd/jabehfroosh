@php
    $packAttribute = $product->super_attributes->firstWhere('code', \App\Services\PackagingProducts::ATTRIBUTE);
    $packChoices = $product->variants->filter(fn ($variant) => $variant->isSaleable())->map(function ($variant) use ($packAttribute) {
        $option = $packAttribute->options->firstWhere('id', $variant->pack_quantity);

        return [
            'id' => $variant->id,
            'option' => $option->id,
            'custom' => $option->admin_name === 'custom',
            'count' => $option->admin_name === 'custom' ? 1 : (int) $option->admin_name,
            'label' => $option->admin_name === 'custom' ? 'تعداد دلخواه' : $option->admin_name.' عددی',
            'price' => $variant->getTypeInstance()->getProductPrices()['final']['price'],
        ];
    })->sortBy(fn ($choice) => $choice['custom'] ? PHP_INT_MAX : $choice['count'])->values();
@endphp

<v-packaging-options :errors="errors"></v-packaging-options>

@pushOnce('scripts')
    <script type="text/x-template" id="v-packaging-options-template">
        <div class="mt-6" style="max-width: 470px">
            <label for="pack-variant" class="mb-3 block text-lg font-medium">تعداد در بسته</label>
            <v-field
                as="select"
                id="pack-variant"
                name="selected_configurable_option"
                rules="required"
                label="تعداد در بسته"
                v-model="selectedId"
                @change="quantity = '1'"
                class="w-full rounded-lg border px-4 py-3"
            >
                <option value="">انتخاب کنید</option>
                <option v-for="choice in choices" :key="choice.id" :value="String(choice.id)">@{{ choice.label }}</option>
            </v-field>
            <span class="text-sm text-red-600" role="alert">@{{ errors.selected_configurable_option }}</span>
            <input type="hidden" name="super_attribute[{{ $packAttribute->id }}]" :value="selected?.option ?? ''">

            <div v-if="selected" class="mt-4">
                <label for="pack-order-quantity" class="mb-2 block">@{{ selected.custom ? 'تعداد دلخواه (عدد)' : 'تعداد بسته' }}</label>
                <v-field name="quantity" rules="required|integer|min_value:1|max_value:1000000" label="تعداد" v-model="quantity" v-slot="{ field, handleChange }">
                    <input
                        v-bind="field"
                        id="pack-order-quantity"
                        type="text"
                        inputmode="numeric"
                        autocomplete="off"
                        @input="onQuantityInput($event, handleChange)"
                        :aria-invalid="! validQuantity"
                        class="w-full rounded-lg border px-4 py-3"
                    >
                </v-field>
                <span class="text-sm text-red-600" role="alert">@{{ errors.quantity }}</span>
                <div class="mt-4 rounded-lg border p-4" aria-live="polite" aria-atomic="true">
                    <p>@{{ selected.label }} — @{{ $shop.formatPrice(selected.price) }}</p>
                    <p class="mt-2">تعداد کل: @{{ validQuantity ? (Number(quantity) * selected.count).toLocaleString('fa-IR') : '—' }} عدد</p>
                    <p class="mt-2 text-lg font-medium">مبلغ کل: @{{ validQuantity ? $shop.formatPrice(Number(quantity) * selected.price) : '—' }}</p>
                    <p class="mt-2 text-sm">با افزودن به سبد، گزینه و تعداد بالا را تأیید می‌کنید. هزینه ارسال در تسویه‌حساب محاسبه می‌شود.</p>
                </div>
            </div>
        </div>
    </script>
    <script type="module">
        app.component('v-packaging-options', {
            template: '#v-packaging-options-template',
            props: { errors: { type: Object, default: () => ({}) } },
            data() {
                return { choices: @json($packChoices), selectedId: '', quantity: '1' };
            },
            computed: {
                selected() {
                    return this.choices.find(choice => String(choice.id) === String(this.selectedId));
                },
                validQuantity() {
                    return /^[0-9]+$/.test(this.quantity) && Number(this.quantity) >= 1 && Number(this.quantity) <= 1000000;
                },
            },
            methods: {
                onQuantityInput(event, handleChange) {
                    const value = event.target.value
                        .replace(/[۰-۹]/g, digit => String('۰۱۲۳۴۵۶۷۸۹'.indexOf(digit)))
                        .replace(/[٠-٩]/g, digit => String('٠١٢٣٤٥٦٧٨٩'.indexOf(digit)));
                    const normalized = /^[0-9]*$/.test(value) ? value : '';
                    event.target.value = normalized;
                    this.quantity = normalized;
                    handleChange(normalized);
                },
            },
        });
    </script>
@endPushOnce
