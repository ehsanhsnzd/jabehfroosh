<details class="support-widget" data-support-widget>
    <summary class="support-widget__trigger" aria-controls="supportPanel">
        <span class="support-widget__label">ارتباط با پشتیبانی</span>
        <span class="support-widget__bubble">
            <svg aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M20 11.5a8 8 0 0 1-8 8H5l-3 2v-10a9 9 0 1 1 18 0Z"/><path d="M8 12h.01M12 12h.01M16 12h.01"/></svg>
        </span>
    </summary>

    <div class="support-widget__panel" id="supportPanel">
        <div class="support-widget__heading">
            <div>
                <strong>ارتباط با پشتیبانی</strong>
                <small>شنبه تا پنجشنبه، پاسخ‌گوی شما هستیم</small>
            </div>

            <small class="support-widget__close-hint">برای بستن، بیرون پنجره کلیک کنید یا Escape را بزنید</small>
        </div>

        <div class="support-widget__options">
            <a class="support-option support-option--phone" href="tel:+989991240501">
                <span class="support-option__icon">
                    <svg aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M7 3H4a1 1 0 0 0-1 1c0 9.4 7.6 17 17 17a1 1 0 0 0 1-1v-3l-4-1-1.5 2a15 15 0 0 1-9.5-9.5L8 7 7 3Z"/></svg>
                </span>
                <span><strong>تماس تلفنی</strong><small dir="ltr">0999 124 0501</small></span>
                <b aria-hidden="true">←</b>
            </a>

            <a class="support-option support-option--bale" href="https://ble.ir/09991240501" target="_blank" rel="noopener">
                <span class="support-option__icon">
                    <svg aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M20 11.4a8 8 0 0 1-8 8H5l-3 2v-10a9 9 0 1 1 18 0Z"/><path d="m8.5 11.5 2.2 2.1 4.8-5"/></svg>
                </span>
                <span><strong>ارتباط از طریق بله</strong><small>پاسخ‌گویی آنلاین</small></span>
                <b aria-hidden="true">←</b>
            </a>

            <a class="support-option support-option--rubika" href="https://rubika.ir/09991240501" target="_blank" rel="noopener">
                <span class="support-option__icon">
                    <svg aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="m12 2 8.7 5v10L12 22l-8.7-5V7L12 2Z"/><path d="m8 9 4-2 4 2v6l-4 2-4-2V9Z"/></svg>
                </span>
                <span><strong>ارتباط از طریق روبیکا</strong><small>ارسال پیام به پشتیبانی</small></span>
                <b aria-hidden="true">←</b>
            </a>
        </div>
    </div>

</details>

@pushOnce('scripts')
    <script>
        (() => {
            document.addEventListener('click', event => {
                document.querySelectorAll('[data-support-widget][open]').forEach(widget => {
                    if (! widget.contains(event.target)) {
                        widget.open = false;
                    }
                });
            });

            document.addEventListener('keydown', event => {
                if (event.key !== 'Escape') {
                    return;
                }

                document.querySelectorAll('[data-support-widget][open]').forEach(widget => {
                    widget.open = false;
                    widget.querySelector('summary')?.focus({ preventScroll: true });
                });
            });
        })();
    </script>
@endPushOnce
