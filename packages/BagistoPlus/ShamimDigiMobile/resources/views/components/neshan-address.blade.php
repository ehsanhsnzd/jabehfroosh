@pushOnce('scripts')
    <script type="text/x-template" id="v-neshan-address-template">
        <div class="my-4">
            <v-field type="hidden" :name="fieldName('latitude')" :model-value="confirmed.latitude" />
            <v-field type="hidden" :name="fieldName('longitude')" :model-value="confirmed.longitude" />
            <button v-if="configured" type="button" class="secondary-button" @click="openMap" :disabled="loading">@lang('shop::delivery.map-pick')</button>
            <div v-show="opened" class="mt-3 rounded-lg border p-3">
                <p class="mb-2 text-sm">@lang('shop::delivery.map-hint')</p>
                <div ref="mapCanvas" style="height: 300px; width: 100%; position: relative; z-index: 0" aria-label="@lang('shop::delivery.map-pick')"></div>
                <div class="mt-3 flex flex-wrap gap-3">
                    <button type="button" class="secondary-button" @click="locate" :disabled="loading">@lang('shop::delivery.map-locate')</button>
                    <button type="button" class="primary-button" @click="confirmLocation" :disabled="loading || !mapReady">@lang('shop::delivery.map-confirm')</button>
                </div>
            </div>
            <p v-if="error" role="alert" class="mt-2 text-sm text-red-600" v-text="error"></p>
        </div>
    </script>
    <script type="module">
        app.component('v-neshan-address', {
            template: '#v-neshan-address-template',
            props: {
                controlName: { type: String, default: '' },
                latitude: { default: null },
                longitude: { default: null },
            },
            emits: ['selected'],
            data() {
                return {
                    configured: @json((bool) core()->getConfigData('customer.address.neshan.web_key') && (bool) core()->getConfigData('customer.address.neshan.service_key')),
                    webKey: @json(core()->getConfigData('customer.address.neshan.web_key')),
                    opened: false, loading: false, error: '', mapReady: false,
                    confirmed: { latitude: this.latitude, longitude: this.longitude },
                };
            },
            beforeUnmount() {
                this.neshanMap?.remove();
            },
            methods: {
                fieldName(field) { return this.controlName ? this.controlName + '.' + field : field; },
                async openMap() {
                    this.opened = true;
                    this.loading = true;
                    this.error = '';
                    try {
                        if (!window.shNeshanLoader) {
                            window.shNeshanLoader = new Promise((resolve, reject) => {
                                const css = document.createElement('link');
                                css.rel = 'stylesheet';
                                css.href = 'https://static.neshan.org/sdk/leaflet/1.4.0/leaflet.css';
                                document.head.appendChild(css);
                                const script = document.createElement('script');
                                script.src = 'https://static.neshan.org/sdk/leaflet/1.4.0/leaflet.js';
                                script.onload = resolve;
                                script.onerror = () => { window.shNeshanLoader = null; reject(new Error('map_load_failed')); };
                                document.head.appendChild(script);
                            });
                        }
                        await window.shNeshanLoader;
                        await this.$nextTick();
                        if (!this.neshanMap) {
                            const center = this.confirmed.latitude && this.confirmed.longitude
                                ? [Number(this.confirmed.latitude), Number(this.confirmed.longitude)] : [35.699739, 51.338097];
                            this.neshanMap = new window.L.Map(this.$refs.mapCanvas, { key: this.webKey, maptype: 'dreamy', poi: true, traffic: false, center, zoom: 14 });
                            this.marker = window.L.marker(center, { draggable: true }).addTo(this.neshanMap);
                            this.neshanMap.on('click', event => this.marker.setLatLng(event.latlng));
                            this.mapReady = true;
                        }
                        this.neshanMap.invalidateSize();
                    } catch (error) {
                        this.error = @js(trans('shop::delivery.map-error'));
                    } finally { this.loading = false; }
                },
                locate() {
                    if (!navigator.geolocation) { this.error = @js(trans('shop::delivery.map-error')); return; }
                    navigator.geolocation.getCurrentPosition(position => {
                        const point = [position.coords.latitude, position.coords.longitude];
                        this.marker.setLatLng(point);
                        this.neshanMap.setView(point, 16);
                    }, () => { this.error = @js(trans('shop::delivery.map-error')); }, { timeout: 10000 });
                },
                async confirmLocation() {
                    this.loading = true;
                    this.error = '';
                    try {
                        const point = this.marker.getLatLng();
                        const response = await this.$axios.get(@js(route('shop.address.neshan.reverse')), { params: { lat: point.lat, lng: point.lng } });
                        this.confirmed = response.data;
                        this.$emit('selected', response.data);
                        this.opened = false;
                    } catch (error) {
                        this.error = error.response?.data?.message || @js(trans('shop::delivery.map-error'));
                    } finally { this.loading = false; }
                },
            },
        });
    </script>
@endPushOnce
