@if ($purchaseSettings['enabled'])
@php
    $identityApproved = $application?->identityApproved() ?? false;
    $chequeApproved = $application?->chequeApproved() ?? false;
    $bothApproved = $identityApproved && $chequeApproved;
    $canUploadCheque = $application && in_array($application->status, ['documents_pending', 'cheque_pending']) && ! $chequeApproved && app(\Webkul\Customer\Helpers\PurchaseCreditWorkflow::class)->verified($customer);
    $allocated = $application?->status === 'active';
    $minimumAmount = (int) $purchaseSettings['minimum_amount'];
    $amountStep = (int) $purchaseSettings['amount_step'];
    $canApply = $eligibility['ceiling'] >= $minimumAmount && app(\Webkul\Customer\Helpers\PurchaseCreditWorkflow::class)->verified($customer) && (! $application || in_array($application->status, ['documents_pending', 'rejected']));
    $maximumAmount = $canApply ? $minimumAmount + intdiv($eligibility['ceiling'] - $minimumAmount, $amountStep) * $amountStep : 0;
    $initialAmount = $canApply ? $minimumAmount + intdiv(max(0, min($application?->requested_toman ?? $maximumAmount, $maximumAmount) - $minimumAmount), $amountStep) * $amountStep : 0;
    $identityFiles = collect($application?->documents ?? [])->filter(fn ($file) => ($file['type'] ?? 'national_id') !== 'cheque');
    $chequeFiles = collect($application?->documents ?? [])->filter(fn ($file) => ($file['type'] ?? '') === 'cheque');
    $wizardState = ['start' => $bothApproved ? 4 : ($identityApproved || ($canUploadCheque && request()->integer('step') === 3) ? 3 : ($application || $errors->any() ? 2 : 1)), 'maximumStep' => $bothApproved ? 4 : ($application && $application->status !== 'rejected' ? 3 : 2), 'accepted' => (bool) $application, 'identityApproved' => $identityApproved, 'chequeApproved' => $chequeApproved, 'allocated' => $allocated];
@endphp
<v-purchase-credit-wizard :state='@json($wizardState)'></v-purchase-credit-wizard>
@pushOnce('scripts')
<script type="text/x-template" id="v-purchase-credit-wizard-template">
<section class="pc-wizard" aria-labelledby="pc-wizard-title">
    <header class="pc-wizard__header">
        <div><span class="pc-wizard__eyebrow">@lang('customer::purchase-credit.wizardEyebrow')</span><h2 id="pc-wizard-title">@lang('customer::purchase-credit.wizardTitle')</h2><p>@lang('customer::purchase-credit.wizardIntro')</p></div>
        <div class="pc-wizard__ceiling"><span>{{ trans('customer::purchase-credit.'.($allocated ? 'allocatedAmount' : ($application ? 'amount' : 'ceiling'))) }}</span>@if ($canApply && $application)<strong v-text="new Intl.NumberFormat('en-US').format(draftAmount)"></strong>@else<strong>{{ number_format($allocated ? $application->approved_toman : ($application ? $application->netAmount() : $eligibility['ceiling'])) }}</strong>@endif<small>@lang('customer::credit.toman')</small></div>
    </header>
    @if ($errors->any())<ul role="alert" class="pc-wizard__alert">@foreach ($errors->all() as $error)<li>{{ $error }}</li>@endforeach</ul>@endif
    @if ($application?->rejection_reason)<div class="pc-wizard__alert" role="alert">{{ $application->rejection_reason }}</div>@endif
    <div class="pc-wizard__body">
        <nav class="pc-wizard__rail" aria-label="{{ trans('customer::purchase-credit.wizardTitle') }}">
            <ol>
            @foreach (['wizardTerms','wizardIdentity','wizardCheque','wizardAllocated'] as $index => $label)
                <li :class="{ 'is-current': step === {{ $index + 1 }}, 'is-complete': complete({{ $index + 1 }}) }">
                    <button type="button" @click="go({{ $index + 1 }})" :disabled="{{ $index + 1 }} > state.maximumStep" :aria-current="step === {{ $index + 1 }} ? 'step' : undefined" aria-label="{{ ($index + 1).' — '.trans('customer::purchase-credit.'.$label) }}" aria-controls="pc-wizard-panel">
                        <span class="pc-wizard__dot"><span v-if="complete({{ $index + 1 }})" aria-hidden="true">✓</span><span v-else>{{ $index + 1 }}</span></span>
                        <span class="pc-wizard__step-name">@lang('customer::purchase-credit.'.$label)<small v-if="complete({{ $index + 1 }})">{{ $index === 1 && $application?->identity_bypassed ? trans('customer::cheques.identityWaived') : trans('customer::purchase-credit.approved') }}</small></span>
                    </button>
                </li>
            @endforeach
            </ol>
        </nav>
        <div id="pc-wizard-panel" class="pc-wizard__panel" ref="panel" tabindex="-1">
            <span class="pc-wizard__step-count">@{{ stepLabel }}</span>
            @if ($canApply)<form id="pc-national-form" method="POST" enctype="multipart/form-data" action="{{ route('shop.customers.account.credit.apply') }}">@csrf @else<div>@endif
                <div v-show="step === 1">
                    <h3>@lang('customer::purchase-credit.wizardTerms')</h3>
                    @if ($application && ! $canApply)<div class="pc-wizard__summary"><span>@lang('customer::purchase-credit.repaymentMonths'): {{ $application->repayment_months }} @lang('customer::purchase-credit.monthUnit') — @lang('customer::purchase-credit.durationDeduction'): {{ $application->deductionPercent() }}٪</span><strong>@lang('customer::purchase-credit.netCredit'): {{ number_format($application->netAmount()) }} @lang('customer::credit.toman')</strong></div>@endif
                    <p class="pc-wizard__prose">{{ $purchaseSettings['instructions'] }}</p>
                    <div class="pc-wizard__summary"><span>@lang('customer::purchase-credit.total')</span><strong>{{ number_format($eligibility['total']) }} @lang('customer::credit.toman')</strong></div>
                    @if ($canApply)
                        <v-purchase-credit-amount @selection-change="draftAmount = $event" :maximum="{{ $maximumAmount }}" :minimum="{{ $minimumAmount }}" :initial="{{ $initialAmount }}" :initial-months="{{ max(1, min(4, (int) old('repayment_months', $application?->repayment_months ?? 1))) }}"></v-purchase-credit-amount>
                        <label class="pc-wizard__checkbox"><input type="checkbox" name="accept_terms" value="1" v-model="accepted" required> <span>@lang('customer::purchase-credit.accept')</span></label>
                    @elseif ($application)<div class="pc-wizard__summary"><span>@lang('customer::purchase-credit.amount')</span><strong>{{ number_format($application->requested_toman) }} @lang('customer::credit.toman')</strong></div>
                    @else<div class="pc-wizard__notice">{{ trans('customer::purchase-credit.notEligible', ['amount' => number_format($minimumAmount)]) }}</div>
                        @if (! app(\Webkul\Customer\Helpers\PurchaseCreditWorkflow::class)->verified($customer))<a class="pc-wizard__link" href="{{ route('shop.customers.account.credit.verify') }}">@lang('customer::purchase-credit.verify')</a>@endif
                    @endif
                </div>
                <div v-show="step === 2">
                    <h3>@lang('customer::purchase-credit.identityUpload')</h3>
                    @if ($application?->identity_bypassed)<div class="pc-wizard__notice pc-wizard__notice--success">@lang('customer::cheques.identityWaivedHelp')</div>
                    @elseif ($identityApproved)<div class="pc-wizard__notice pc-wizard__notice--success">✓ @lang('customer::purchase-credit.identityApproved')</div>
                    @elseif ($application && $application->status !== 'rejected')<div class="pc-wizard__notice">@lang('customer::purchase-credit.identityWaiting')</div>@endif
                    <p>@lang('customer::purchase-credit.identityHelp')</p>
                    @if ($canApply)
                        @foreach (['front', 'back'] as $side)
                            <label class="pc-wizard__upload" :class="{ 'is-uploaded': identityNames.{{ $side }} }">
                                <span class="pc-wizard__upload-icon" aria-hidden="true"><span v-if="identityNames.{{ $side }}">✓</span><span v-else>↑</span></span>
                                <strong>@lang('customer::purchase-credit.identity'.ucfirst($side))</strong>
                                <span v-if="identityNames.{{ $side }}" class="pc-wizard__upload-status" role="status">@lang('customer::purchase-credit.uploaded')</span>
                                <small v-if="identityNames.{{ $side }}" v-text="identityNames.{{ $side }}"></small>
                                <small v-else>JPG · PNG · PDF</small>
                                <input type="file" name="national_id_{{ $side }}" accept=".pdf,.jpg,.jpeg,.png" required @change="prepareIdentity($event, '{{ $side }}')">
                            </label>
                            <p role="alert" class="pc-wizard__alert" v-if="uploadErrors.{{ $side }}" v-text="uploadErrors.{{ $side }}"></p>
                        @endforeach
                        <p v-if="processingUploads" role="status">@lang('customer::purchase-credit.compressing')</p>
                    @elseif (! $application)<div class="pc-wizard__notice">{{ trans('customer::purchase-credit.notEligible', ['amount' => number_format($minimumAmount)]) }}</div>@endif
                    <ul class="pc-wizard__files">@foreach ($identityFiles as $index => $file)<li><a href="{{ route('shop.customers.account.credit.document', [$application->id, $index]) }}">@if (in_array($file['type'] ?? '', ['national_id_front', 'national_id_back'])){{ trans('customer::purchase-credit.'.($file['type'] === 'national_id_front' ? 'identityFront' : 'identityBack')) }}: @endif{{ $file['name'] }} ↗</a></li>@endforeach</ul>
                    <small class="pc-wizard__privacy">@lang('customer::purchase-credit.secureDocuments')</small>
                </div>
            @if ($canApply)</form>@else</div>@endif
            <div v-show="step === 3">
                <h3>@lang('customer::purchase-credit.wizardCheque')</h3>
                @if ($chequeApproved)<div class="pc-wizard__notice pc-wizard__notice--success">✓ @lang('customer::purchase-credit.chequeApproved')</div>@endif
                <p>@lang('customer::purchase-credit.chequeHelp')</p>
                <address class="pc-wizard__address"><small>@lang('customer::purchase-credit.accounting_address')</small>{{ $purchaseSettings['accounting_address'] }}</address>
                <ul class="pc-wizard__files">@foreach ($chequeFiles as $index => $file)<li><a href="{{ route('shop.customers.account.credit.document', [$application->id, $index]) }}">@if (in_array($file['type'] ?? '', ['national_id_front', 'national_id_back'])){{ trans('customer::purchase-credit.'.($file['type'] === 'national_id_front' ? 'identityFront' : 'identityBack')) }}: @endif{{ $file['name'] }} ↗</a></li>@endforeach</ul>
                @if ($canUploadCheque)
                    @if ($chequeFiles->isNotEmpty())<div class="pc-wizard__notice">@lang('customer::purchase-credit.chequeWaiting')</div>@endif
                    <form id="pc-cheque-form" method="POST" enctype="multipart/form-data" action="{{ route('shop.customers.account.credit.cheque', $application->id) }}">@csrf
                        <label class="pc-wizard__upload" :class="{ 'is-uploaded': chequeName }">
                            <span class="pc-wizard__upload-icon" aria-hidden="true"><span v-if="chequeName">✓</span><span v-else>↑</span></span>
                            <strong>@lang('customer::purchase-credit.chooseCheque')</strong>
                            <span v-if="chequeName" class="pc-wizard__upload-status" role="status">@lang('customer::purchase-credit.uploaded')</span>
                            <small v-if="chequeName" v-text="chequeName"></small><small v-else>JPG · PNG · PDF</small>
                            <input type="file" name="cheque" accept=".pdf,.jpg,.jpeg,.png" required @change="chequeName = $event.target.files[0]?.name || ''">
                        </label>
                        <label class="pc-wizard__checkbox"><input type="checkbox" name="cheque_sent" value="1" required> <span>@lang('customer::purchase-credit.chequeSent')</span></label>
                    </form>
                @endif
            </div>
            <div v-show="step === 4" class="pc-wizard__allocation">
                <div class="pc-wizard__seal" :class="{ 'is-allocated': state.allocated }" aria-hidden="true">{{ $allocated ? '✓' : '◷' }}</div>
                <h3>{{ $allocated ? trans('customer::purchase-credit.allocated') : trans('customer::purchase-credit.wizardAllocated') }}</h3>
                <div class="pc-wizard__approval-pair"><span>✓ {{ $application?->identity_bypassed ? trans('customer::cheques.identityWaived') : trans('customer::purchase-credit.wizardIdentity') }}</span><span>✓ @lang('customer::purchase-credit.wizardCheque')</span></div>
                @if ($allocated)<strong class="pc-wizard__allocated-amount">{{ number_format($application->approved_toman) }} <small>@lang('customer::credit.toman')</small></strong><p>@lang('customer::purchase-credit.allocatedHelp')</p>
                @else<p>@lang('customer::purchase-credit.allocationWaiting')</p>@endif
            </div>
            <footer ref="actions" class="pc-wizard__footer" style="flex-wrap:wrap">
                <p v-if="error" ref="actionError" role="alert" tabindex="-1" class="pc-wizard__alert" style="margin:0;flex:1 1 220px;color:#a03c3c">@{{ error }}</p>
                <button v-if="step > 1" type="button" class="pc-wizard__previous" @click="go(step - 1)">@lang('customer::purchase-credit.previous')</button>
                @if ($canApply && $application)
                <button v-if="step === 1" type="submit" form="pc-national-form" formnovalidate formaction="{{ route('shop.customers.account.credit.revise', $application->id) }}" class="pc-wizard__next">@lang('customer::purchase-credit.next') <span aria-hidden="true">←</span></button>
                @else
                <button v-if="step === 1" type="button" class="pc-wizard__next" @click="next()">@lang('customer::purchase-credit.next') <span aria-hidden="true">←</span></button>
                @endif
                @if ($application && $application->status !== 'rejected')<button v-if="step === 2" type="button" class="pc-wizard__next" @click="go(3)">@lang('customer::purchase-credit.next') <span aria-hidden="true">←</span></button>@endif
                @if ($canApply)<button v-if="step === 2" type="submit" form="pc-national-form" :disabled="processingUploads > 0" class="pc-wizard__next">@lang('customer::purchase-credit.sendIdentity')</button>
                @else<span v-if="step === 2" class="pc-wizard__pending">@lang('customer::purchase-credit.pendingReview')</span>@endif
                @if ($canUploadCheque)<button v-if="step === 3" type="submit" form="pc-cheque-form" class="pc-wizard__next">@lang('customer::purchase-credit.sendCheque')</button>
                @else<button v-if="step === 3 && state.chequeApproved && state.identityApproved" type="button" class="pc-wizard__next" @click="go(4)">@lang('customer::purchase-credit.next') <span aria-hidden="true">←</span></button>@endif
                @if ($allocated)<a v-if="step === 4" class="pc-wizard__next" href="{{ route('shop.customers.account.credit.index', ['new' => 1]) }}">@lang('customer::purchase-credit.newRequest')</a><a v-if="step === 4" class="pc-wizard__next" href="{{ route('shop.checkout.cart.index') }}">@lang('shop::app.checkout.cart.index.cart')</a>@endif
            </footer>
        </div>
    </div>
</section>
</script>
<script type="text/x-template" id="v-purchase-credit-amount-template">
    <div class="pc-amount">
        <label for="purchase-credit-months" class="block">@lang('customer::purchase-credit.repaymentMonths'): @{{ new Intl.NumberFormat('fa-IR').format(months) }} @lang('customer::purchase-credit.monthUnit')</label>
        <input id="purchase-credit-months" type="range" name="repayment_months" min="1" max="4" step="1" v-model="months" dir="ltr">
        <div style="display:flex;justify-content:space-between" dir="ltr"><span v-for="month in 4" v-text="new Intl.NumberFormat('fa-IR').format(month)"></span></div>
        <p>@lang('customer::purchase-credit.durationDeduction'): @{{ new Intl.NumberFormat('fa-IR').format(deduction) }}٪</p>
        <label for="purchase-credit-amount">@lang('customer::purchase-credit.netCredit')</label>
        <div class="pc-amount__controls" dir="ltr">
            <button type="button" :disabled="! effectiveMaximum || amount <= minimum" @click="amount = Math.max(minimum, Number(amount) - step)" aria-label="{{ trans('customer::purchase-credit.decrease') }}">−</button>
            <output aria-live="polite">@{{ new Intl.NumberFormat('fa-IR').format(amount) }}</output>
            <button type="button" :disabled="! effectiveMaximum || amount >= effectiveMaximum" @click="amount = Math.min(effectiveMaximum, Number(amount) + step)" aria-label="{{ trans('customer::purchase-credit.increase') }}">+</button>
        </div>
        <input v-if="effectiveMaximum" :key="effectiveMaximum" id="purchase-credit-amount" type="range" name="amount" :min="minimum" :max="effectiveMaximum" :step="step" v-model="amount" dir="ltr">
        <input v-else type="hidden" name="amount" value="0">
        <p v-if="! effectiveMaximum" role="alert">{{ trans('customer::purchase-credit.notEligible', ['amount' => number_format($minimumAmount)]) }}</p>
        <p>{{ trans('customer::purchase-credit.stepHelp', ['minimum' => number_format($minimumAmount), 'step' => number_format($amountStep)]) }}</p>
    </div>
</script>
<script type="module">
app.component('v-purchase-credit-amount', {
    template: '#v-purchase-credit-amount-template', props: ['maximum', 'minimum', 'initial', 'initialMonths'],
    data() { return { amount: this.initial, months: this.initialMonths || 1, step: @json($amountStep) }; },
    computed: {
        deduction() { return Math.min(100, (Number(this.months) - 1) * @json($purchaseSettings['monthly_deduction_percent'])); },
        effectiveMaximum() { const net=Math.floor(Number(this.maximum)*(100-this.deduction)/100); return net < this.minimum ? 0 : Number(this.minimum)+Math.floor((net-this.minimum)/this.step)*this.step; },
    },
    watch: { months() { this.amount=this.effectiveMaximum; }, amount(value) { this.$emit('selection-change', Number(value)); } },
    mounted() { this.amount=Math.min(this.effectiveMaximum, Math.max(this.minimum, Number(this.initial))); this.$emit('selection-change', Number(this.amount)); },
});
app.component('v-purchase-credit-wizard', {
    template: '#v-purchase-credit-wizard-template', props: ['state'],
    data() { return { draftAmount: @json($application ? $application->netAmount() : $initialAmount), step: this.state.start, accepted: this.state.accepted, identityNames: {front: '', back: ''}, uploadErrors: {front: '', back: ''}, processingUploads: 0, chequeName: '', error: '' }; },
    watch: { accepted(value) { if (value) this.error = ''; } },
    computed: { stepLabel() { return @json(trans('customer::purchase-credit.stepOf')).replace(':step', new Intl.NumberFormat('fa-IR').format(this.step)); } },
    methods: {
        async prepareIdentity(event, side) {
            const input = event.target;
            const original = input.files[0];
            this.identityNames[side] = '';
            this.uploadErrors[side] = '';
            if (!original) return;
            this.processingUploads++;
            try {
                let file = original;
                if (['image/jpeg', 'image/png'].includes(file.type)) {
                    if (file.size > 20 * 1024 * 1024) throw new Error(@json(trans('customer::purchase-credit.imageResizeFailed')));
                    const bitmap = await createImageBitmap(file);
                    try {
                        const ratio = Math.min(1, 1600 / Math.max(bitmap.width, bitmap.height));
                        const canvas = document.createElement('canvas');
                        canvas.width = Math.max(1, Math.round(bitmap.width * ratio));
                        canvas.height = Math.max(1, Math.round(bitmap.height * ratio));
                        const context = canvas.getContext('2d');
                        context.fillStyle = '#ffffff';
                        context.fillRect(0, 0, canvas.width, canvas.height);
                        context.drawImage(bitmap, 0, 0, canvas.width, canvas.height);
                        const blob = await new Promise(resolve => canvas.toBlob(resolve, 'image/jpeg', 0.85));
                        if (!blob) throw new Error(@json(trans('customer::purchase-credit.imageResizeFailed')));
                        file = new File([blob], original.name.replace(/\.[^.]*$/, '') + '.jpg', {type: 'image/jpeg'});
                    } finally {
                        bitmap.close();
                    }
                }
                if (file.size >= 5 * 1024 * 1024) throw new Error(@json(trans('customer::purchase-credit.fileTooLarge')));
                const transfer = new DataTransfer();
                transfer.items.add(file);
                input.files = transfer.files;
                this.identityNames[side] = file.name;
            } catch (error) {
                input.value = '';
                this.uploadErrors[side] = error.message || @json(trans('customer::purchase-credit.imageResizeFailed'));
            } finally {
                this.processingUploads--;
            }
        },
        complete(step) { return [false, this.accepted, this.state.identityApproved, this.state.chequeApproved, this.state.allocated][step]; },
        go(step) {
            if (step < 1 || step > this.state.maximumStep) return;
            @if ($canApply)
            if (step > 1 && !this.accepted) { this.error = @json(trans('customer::purchase-credit.acceptFirst')); this.$nextTick(() => { this.$refs.actionError?.focus({preventScroll:true}); this.$refs.actions.scrollIntoView({behavior:'smooth',block:'nearest'}); }); return; }
            @endif
            this.error = ''; this.step = step;
            this.$nextTick(() => { this.$refs.panel.focus({ preventScroll: true }); this.$refs.panel.scrollIntoView({ behavior: 'smooth', block: 'nearest' }); });
        },
        next() { this.go(this.step + 1); },
    },
});
</script>
@endPushOnce
@endif
