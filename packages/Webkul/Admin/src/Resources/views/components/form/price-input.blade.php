<v-price-input {{ $attributes }}></v-price-input>

@pushOnce('scripts')
    <script type="text/x-template" id="v-price-input-template">
        <input type="hidden" :name="name" :value="modelValue ?? ''" :disabled="$attrs.disabled">
        <input
            v-bind="$attrs"
            type="text"
            inputmode="decimal"
            :value="format(modelValue)"
            @input="onInput"
            @blur="$emit('blur', $event)"
        >
    </script>

    <script type="module">
        app.component('v-price-input', {
            template: '#v-price-input-template',

            inheritAttrs: false,

            props: {
                name: String,
                modelValue: {
                    type: [String, Number],
                    default: '',
                },
            },

            emits: ['update:modelValue', 'blur'],

            methods: {
                normalize(value) {
                    return String(value ?? '')
                        .replace(/[۰-۹]/g, digit => String('۰۱۲۳۴۵۶۷۸۹'.indexOf(digit)))
                        .replace(/[٠-٩]/g, digit => String('٠١٢٣٤٥٦٧٨٩'.indexOf(digit)))
                        .replace(/[,٬]/g, '')
                        .replace(/٫/g, '.');
                },

                format(value) {
                    const normalized = this.normalize(value);

                    if (! /^-?\d*(\.\d*)?$/.test(normalized)) {
                        return normalized;
                    }

                    const [integer, fraction] = normalized.split('.');
                    const grouped = integer.replace(/\B(?=(\d{3})+(?!\d))/g, ',');

                    return fraction === undefined ? grouped : `${grouped}.${fraction}`;
                },

                onInput(event) {
                    const input = event.target;
                    const position = this.normalize(input.value.slice(0, input.selectionStart)).length;
                    const value = this.normalize(input.value);
                    const formatted = this.format(value);

                    this.$emit('update:modelValue', value);
                    input.value = formatted;

                    this.$nextTick(() => {
                        let caret = 0;
                        let characters = 0;

                        while (caret < formatted.length && characters < position) {
                            if (formatted[caret] !== ',') {
                                characters++;
                            }

                            caret++;
                        }

                        input.setSelectionRange(caret, caret);
                    });
                },
            },
        });
    </script>
@endpushOnce
