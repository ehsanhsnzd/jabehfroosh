@push('meta')
    <meta name="description" content="ورود به حساب جعبه فروش با شماره موبایل یا ایمیل">
@endpush

@php
    $otpSent = (bool) session('otp_sent', false);
    $otpPhone = session('otp_phone', old('phone', ''));
    $otpFeedback = session('otp_error') ?: session('otp_message');
@endphp

<x-shop::layouts :has-header="false" :has-feature="false" :has-footer="false">
    <x-slot:title>ورود به حساب جعبه فروش</x-slot>

    <main class="otp-login" dir="rtl">
        <a class="otp-login__logo" href="{{ route('shop.home.index') }}">
            <img src="{{ asset('themes/shop/shamim-pack/images/jabehfroosh-logo.svg') }}" alt="جعبه فروش" width="520" height="120">
        </a>

        <section class="otp-login__card">
            <div class="otp-login__intro">
                <span>حساب کاربری جعبه فروش</span>
                <h1>ورود یا ثبت‌نام</h1>
                <p>با کد پیامکی سریع وارد شوید یا از ایمیل و رمز عبور استفاده کنید.</p>
            </div>

            <div class="otp-login__tabs" role="tablist">
                <button class="is-active" type="button" role="tab" data-login-tab="phone" aria-selected="true" onclick="window.shamimSwitchLoginTab('phone')">شماره موبایل و کد پیامک</button>
                <button type="button" role="tab" data-login-tab="email" aria-selected="false" onclick="window.shamimSwitchLoginTab('email')">ایمیل و رمز عبور</button>
            </div>

            <form class="otp-login__pane is-active" data-login-pane="phone" id="otpLoginForm" method="POST" action="{{ $otpSent ? route('shop.customer.otp.verify', [], false) : route('shop.customer.otp.send', [], false) }}">
                @csrf
                <input type="hidden" name="redirect_to" value="{{ $redirectTo ?? '' }}">

                <div class="otp-login__field">
                    <label for="otpPhone">شماره موبایل</label>
                    <input id="otpPhone" name="phone" type="tel" inputmode="numeric" autocomplete="tel" placeholder="۰۹۱۲۱۲۳۴۵۶۷" maxlength="11" value="{{ $otpPhone }}" @readonly($otpSent) required>
                </div>

                <div class="otp-login__field otp-login__code" @unless($otpSent) hidden @endunless>
                    <label for="otpCode">کد ۶ رقمی پیامک‌شده</label>
                    <input id="otpCode" name="code" type="text" inputmode="numeric" autocomplete="one-time-code" placeholder="— — — — — —" maxlength="6" @required($otpSent)>
                    <small id="otpTimer"></small>
                </div>

                <p class="otp-login__message {{ session('otp_error') ? 'is-error' : ($otpFeedback ? 'is-success' : '') }}" id="otpMessage" aria-live="polite">
                    @if (session('otp_debug_code'))
                        حالت آزمایشی — کد ورود: {{ session('otp_debug_code') }}
                    @else
                        {{ $otpFeedback }}
                    @endif
                </p>

                <button class="otp-login__submit" id="otpAction" type="submit">{{ $otpSent ? 'تأیید کد و ورود' : 'ارسال کد ورود' }}</button>
                <a class="otp-login__change" id="otpChange" href="{{ route('shop.customer.session.index', array_filter(['redirect_to' => $redirectTo ?? null])) }}" @unless($otpSent) hidden @endunless>اصلاح شماره موبایل</a>
            </form>

            <div class="otp-login__pane" data-login-pane="email" hidden>
                <form method="POST" action="{{ route('shop.customer.session.create') }}">
                    @csrf
                    <input type="hidden" name="redirect_to" value="{{ $redirectTo ?? '' }}">

                    <div class="otp-login__field">
                        <label for="loginEmail">ایمیل</label>
                        <input id="loginEmail" name="email" type="email" value="{{ old('email') }}" autocomplete="email" placeholder="email@example.com" required>
                        @error('email')<small class="otp-login__error">{{ $message }}</small>@enderror
                    </div>

                    <div class="otp-login__field">
                        <label for="loginPassword">رمز عبور</label>
                        <input id="loginPassword" name="password" type="password" autocomplete="current-password" placeholder="رمز عبور" minlength="6" required>
                        @error('password')<small class="otp-login__error">{{ $message }}</small>@enderror
                    </div>

                    <div class="otp-login__email-actions">
                        <label><input type="checkbox" id="showLoginPassword"> نمایش رمز</label>
                        <a href="{{ route('shop.customers.forgot_password.create') }}">رمز را فراموش کرده‌اید؟</a>
                    </div>

                    @if (core()->getConfigData('customer.captcha.credentials.status'))
                        <div class="mt-5">{!! \Webkul\Customer\Facades\Captcha::render() !!}</div>
                    @endif

                    <button class="otp-login__submit" type="submit">ورود با ایمیل</button>
                </form>
            </div>

            <p class="otp-login__register">حساب کامل می‌خواهید؟ <a href="{{ route('shop.customers.register.index') }}">ساخت حساب با ایمیل</a></p>
        </section>
    </main>

    @push('styles')
        <style>
            .otp-login{min-height:100dvh;padding:35px 18px 70px;background:linear-gradient(145deg,#f5fbf7,#fff 48%,#f7f3ed);color:#17281f}.otp-login__logo{display:block;width:105px;margin:0 auto 18px}.otp-login__logo img{width:100%;mix-blend-mode:multiply}.otp-login__card{width:min(560px,100%);margin:auto;padding:38px;border:1px solid #e1e8e3;border-radius:28px;background:#fff;box-shadow:0 24px 70px rgba(23,40,31,.1)}.otp-login__intro{text-align:center}.otp-login__intro>span{color:#00a651;font-size:12px;font-weight:900}.otp-login__intro h1{margin:6px 0;font-size:2rem;font-weight:900}.otp-login__intro p{color:#747d77;font-size:13px}.otp-login__tabs{display:grid;grid-template-columns:1fr 1fr;gap:6px;margin:28px 0 24px;padding:5px;border-radius:15px;background:#f1f4f2}.otp-login__tabs button{min-height:46px;padding:8px;border-radius:11px;color:#6f7772;font-size:12px;font-weight:800}.otp-login__tabs button.is-active{background:#fff;color:#00a651;box-shadow:0 4px 16px rgba(25,45,35,.08)}.otp-login__pane{display:none}.otp-login__pane.is-active{display:block}.otp-login__field{margin-bottom:17px}.otp-login__field label{display:block;margin-bottom:7px;font-size:12px;font-weight:800}.otp-login__field input{width:100%;height:52px;padding:0 15px;border:1px solid #dfe5e1;border-radius:13px;background:#fbfcfb;outline:0;direction:ltr;text-align:left}.otp-login__field input:focus{border-color:#00a651;box-shadow:0 0 0 3px rgba(0,166,81,.1)}.otp-login__code small{display:block;margin-top:7px;color:#7d857f;font-size:10px}.otp-login__message{min-height:22px;margin:-5px 0 8px;color:#66706a;font-size:11px}.otp-login__message.is-error,.otp-login__error{color:#c33}.otp-login__message.is-success{color:#008d45}.otp-login__submit{width:100%;min-height:50px;margin-top:5px;border-radius:13px;background:#00a651;color:#fff;font-size:13px;font-weight:900;transition:.2s}.otp-login__submit:hover{background:#008d45}.otp-login__submit:disabled{cursor:wait;opacity:.55}.otp-login__change{display:block;margin:13px auto 0;color:#171552;font-size:11px;font-weight:800}.otp-login__email-actions{display:flex;justify-content:space-between;gap:15px;margin:-3px 0 16px;color:#66706a;font-size:11px}.otp-login__email-actions label{display:flex;align-items:center;gap:6px}.otp-login__email-actions a,.otp-login__register a{color:#00a651;font-weight:800}.otp-login__register{margin-top:22px;padding-top:18px;border-top:1px solid #edf0ee;text-align:center;color:#747d77;font-size:11px}@media(max-width:560px){.otp-login{padding-top:18px}.otp-login__logo{width:82px;margin-bottom:10px}.otp-login__card{padding:24px 16px;border-radius:22px}.otp-login__intro h1{font-size:1.55rem}.otp-login__tabs button{font-size:10px}.otp-login__email-actions{align-items:flex-start;flex-direction:column}}
        </style>
    @endpush

    @push('scripts')
        {!! \Webkul\Customer\Facades\Captcha::renderJS() !!}
        <script>
            window.shamimSwitchLoginTab = function (name) {
                document.querySelectorAll('[data-login-tab]').forEach((tab) => {
                    const active = tab.dataset.loginTab === name;
                    tab.classList.toggle('is-active', active);
                    tab.setAttribute('aria-selected', active ? 'true' : 'false');
                });

                document.querySelectorAll('[data-login-pane]').forEach((pane) => {
                    const active = pane.dataset.loginPane === name;
                    pane.classList.toggle('is-active', active);
                    pane.hidden = ! active;
                });
            };

            const initializeShamimLogin = () => {
                const phone = document.getElementById('otpPhone');
                const otpForm = document.getElementById('otpLoginForm');
                const code = document.getElementById('otpCode');
                const codeWrap = document.querySelector('.otp-login__code');
                const action = document.getElementById('otpAction');
                const change = document.getElementById('otpChange');
                const message = document.getElementById('otpMessage');
                const timer = document.getElementById('otpTimer');
                const redirectTo = @json($redirectTo ?? '');
                let step = @json($otpSent ? 'verify' : 'send');
                let interval;

                if (! otpForm || ! phone || ! code || ! action || action.dataset.initialized === 'true') {
                    return;
                }

                action.dataset.initialized = 'true';

                const showMessage = (text, type = '') => { message.textContent = text; message.className = `otp-login__message ${type ? `is-${type}` : ''}`; };
                const post = async (url, payload) => {
                    const controller = new AbortController();
                    const timeout = setTimeout(() => controller.abort(), 15000);
                    let response;

                    try {
                        response = await fetch(url, { method:'POST', credentials:'same-origin', signal:controller.signal, headers:{'Content-Type':'application/json','Accept':'application/json','X-CSRF-TOKEN':@json(csrf_token())}, body:JSON.stringify(payload) });
                    } finally {
                        clearTimeout(timeout);
                    }

                    const data = await response.json().catch(() => ({}));
                    if (! response.ok) throw new Error(data.message || 'خطایی رخ داد.');
                    return data;
                };
                const startTimer = (seconds) => {
                    clearInterval(interval); let remaining = seconds;
                    interval = setInterval(() => { remaining--; timer.textContent = remaining > 0 ? `اعتبار کد: ${remaining} ثانیه` : 'کد منقضی شد؛ دوباره درخواست دهید.'; if (remaining <= 0) clearInterval(interval); }, 1000);
                };

                window.shamimHandleOtp = async (event) => {
                    event?.preventDefault();

                    if (action.disabled) return;

                    action.disabled = true; showMessage('');
                    try {
                        const submittedPhone = String(new FormData(otpForm).get('phone') || '').trim();

                        if (! submittedPhone) {
                            throw new Error('شماره موبایل را وارد کنید.');
                        }

                        if (step === 'send') {
                            const data = await post(@json(route('shop.customer.otp.send', [], false)), {phone:submittedPhone});
                            step = 'verify'; phone.readOnly = true; codeWrap.hidden = false; change.hidden = false; action.textContent = 'تأیید کد و ورود'; code.focus(); startTimer(data.expires_in || 120);
                            showMessage(data.debug_code ? `حالت آزمایشی — کد ورود: ${data.debug_code}` : data.message, 'success');
                        } else {
                            const data = await post(@json(route('shop.customer.otp.verify', [], false)), {phone:submittedPhone, code:code.value, redirect_to:redirectTo});
                            showMessage(data.message, 'success'); window.location.assign(data.redirect);
                        }
                    } catch (error) { showMessage(error.name === 'AbortError' ? 'ارتباط با سرور برقرار نشد؛ دوباره تلاش کنید.' : error.message, 'error'); }
                    finally { action.disabled = false; }
                };

                otpForm.addEventListener('submit', window.shamimHandleOtp);

                window.addEventListener('unhandledrejection', (event) => {
                    showMessage(event.reason?.message || 'خطای پیش‌بینی‌نشده‌ای رخ داد.', 'error');
                });

                window.addEventListener('error', (event) => {
                    if (event.message) showMessage(`خطای صفحه: ${event.message}`, 'error');
                });

                change.addEventListener('click', () => { step='send'; phone.readOnly=false; codeWrap.hidden=true; change.hidden=true; code.value=''; action.textContent='ارسال کد ورود'; clearInterval(interval); phone.focus(); showMessage(''); });
                document.getElementById('showLoginPassword').addEventListener('change', (event) => document.getElementById('loginPassword').type = event.target.checked ? 'text' : 'password');

                @if ($errors->any())
                    window.shamimSwitchLoginTab('email');
                @endif
            };

            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initializeShamimLogin, { once: true });
            } else {
                initializeShamimLogin();
            }
        </script>
    @endpush
</x-shop::layouts>
