@php
    $slides = $getSlides();
@endphp

@if (!empty($slides))
    {{-- Dual Slideshow: separate desktop / mobile images, auto-plays every 5 s, no dots --}}
    <div
        class="sh-dual-slider"
        data-section-id="{{ $section->id }}"
        aria-label="اسلایدر تصاویر"
    >
        {{-- Desktop slider (hidden on mobile) --}}
        <div class="sh-dual-slider__track sh-dual-slider__track--desktop" aria-hidden="true">
            <div class="sh-dual-slider__inner" id="sh-ds-desktop-{{ $section->id }}">
                @foreach ($slides as $slide)
                    <div
                        class="sh-dual-slider__slide"
                        data-slide-id="{{ $slide['id'] }}"
                        @if (!empty($slide['link']))
                            role="link"
                            tabindex="0"
                            data-href="{{ $slide['link'] }}"
                        @endif
                    >
                        @if (!empty($slide['image_desktop']))
                            <img
                                class="sh-dual-slider__img"
                                src="{{ $slide['image_desktop'] }}"
                                alt=""
                                draggable="false"
                                @if ($loop->first) fetchpriority="high" loading="eager" @else loading="lazy" @endif
                            >
                        @elseif (!empty($slide['image_mobile']))
                            <img
                                class="sh-dual-slider__img"
                                src="{{ $slide['image_mobile'] }}"
                                alt=""
                                draggable="false"
                                @if ($loop->first) fetchpriority="high" loading="eager" @else loading="lazy" @endif
                            >
                        @endif
                    </div>
                @endforeach
            </div>
        </div>

        {{-- Mobile slider (hidden on desktop) --}}
        <div class="sh-dual-slider__track sh-dual-slider__track--mobile" aria-hidden="false">
            <div class="sh-dual-slider__inner" id="sh-ds-mobile-{{ $section->id }}">
                @foreach ($slides as $slide)
                    <div
                        class="sh-dual-slider__slide"
                        data-slide-id="{{ $slide['id'] }}"
                        @if (!empty($slide['link']))
                            role="link"
                            tabindex="0"
                            data-href="{{ $slide['link'] }}"
                        @endif
                    >
                        @if (!empty($slide['image_mobile']))
                            <img
                                class="sh-dual-slider__img"
                                src="{{ $slide['image_mobile'] }}"
                                alt=""
                                draggable="false"
                                @if ($loop->first) fetchpriority="high" loading="eager" @else loading="lazy" @endif
                            >
                        @elseif (!empty($slide['image_desktop']))
                            <img
                                class="sh-dual-slider__img"
                                src="{{ $slide['image_desktop'] }}"
                                alt=""
                                draggable="false"
                                @if ($loop->first) fetchpriority="high" loading="eager" @else loading="lazy" @endif
                            >
                        @endif
                    </div>
                @endforeach
            </div>
        </div>
    </div>

    @pushOnce('scripts')
    <script>
    (() => {
        'use strict';

        /**
         * Minimal, dependency-free slider that:
         *  - auto-plays every 5 s (loops around)
         *  - supports touch/mouse swipe
         *  - has no dots / pagination
         *  - integrates with Bagisto Visual design-mode events
         */
        class ShamimDualSlider {
            constructor(trackEl, sectionId) {
                this.track     = trackEl;
                this.inner     = trackEl.querySelector('.sh-dual-slider__inner');
                this.slides    = Array.from(trackEl.querySelectorAll('.sh-dual-slider__slide'));
                this.sectionId = sectionId;
                this.current   = 0;
                this.timer     = null;
                this.isRTL     = document.documentElement.dir === 'rtl';

                // drag state
                this.dragStart = null;
                this.dragging  = false;

                if (this.slides.length <= 1) return;

                this._bindSlideClicks();
                this._bindDrag();
                this._start();
                this._bindVisualEvents();
            }

            _go(index) {
                const len = this.slides.length;
                this.current = ((index % len) + len) % len;
                // With inner container set to direction: ltr, moving to subsequent slides is always -index * 100%
                const offset = this.current * -100;
                this.inner.style.transform = `translateX(${offset}%)`;
            }

            _next() {
                this._go(this.current + 1); }



            _prev() { this._go(this.current - 1); }

            _start() {
                this._stop();
                this.timer = setInterval(() => this._next(), 5000);
            }

            _stop() { clearInterval(this.timer); this.timer = null; }

            _bindSlideClicks() {
                this.slides.forEach(slide => {
                    slide.addEventListener('click', () => {
                        if (!this.dragging && slide.dataset.href) {
                            window.location.href = slide.dataset.href;
                        }
                    });
                    slide.addEventListener('keydown', e => {
                        if ((e.key === 'Enter' || e.key === ' ') && slide.dataset.href) {
                            window.location.href = slide.dataset.href;
                        }
                    });
                });
            }

            _bindDrag() {
                const el = this.track;

                const startDrag = (x) => {
                    this.dragStart = x;
                    this.dragging  = false;
                    this._stop();
                };
                const moveDrag = (x) => {
                    if (this.dragStart === null) return;
                    if (Math.abs(x - this.dragStart) > 5) this.dragging = true;
                };
                const endDrag = (x) => {
                    if (this.dragStart === null) return;
                    const diff = x - this.dragStart;
                    this.dragStart = null;
                    if (Math.abs(diff) > 40) {
                        // Dragging left (diff < 0) = next in LTR, prev in RTL
                        const swipeNext = this.isRTL ? (diff > 0) : (diff < 0);
                        swipeNext ? this._next() : this._prev();
                    }
                    this._start();
                    setTimeout(() => { this.dragging = false; }, 0);
                };

                el.addEventListener('mousedown',  e => startDrag(e.clientX));
                el.addEventListener('mousemove',  e => moveDrag(e.clientX));
                el.addEventListener('mouseup',    e => endDrag(e.clientX));
                el.addEventListener('mouseleave', e => { if (this.dragStart !== null) endDrag(e.clientX); });

                el.addEventListener('touchstart', e => startDrag(e.touches[0].clientX), { passive: true });
                el.addEventListener('touchmove',  e => moveDrag(e.touches[0].clientX), { passive: true });
                el.addEventListener('touchend',   e => endDrag(e.changedTouches[0].clientX), { passive: true });

                // Prevent image drag
                el.querySelectorAll('img').forEach(img => img.addEventListener('dragstart', e => e.preventDefault()));
            }

            _bindVisualEvents() {
                document.addEventListener('visual:block:select', e => {
                    if (e.detail.sectionId !== this.sectionId) return;
                    const idx = this.slides.findIndex(s => s.dataset.slideId === e.detail.blockId);
                    if (idx >= 0) { this._go(idx); this._stop(); }
                });
                document.addEventListener('visual:block:deselect', e => {
                    if (e.detail.sectionId !== this.sectionId) return;
                    this._start();
                });
            }
        }


        const sliderInstances = new WeakMap();

        function init() {
            document.querySelectorAll('.sh-dual-slider').forEach(wrapper => {
                const sectionId = wrapper.dataset.sectionId;

                wrapper.querySelectorAll('.sh-dual-slider__track').forEach(track => {
                    const inner = track.querySelector('.sh-dual-slider__inner');
                    const existing = sliderInstances.get(track);

                    // Element is unchanged and already initialized.
                    if (existing && existing.inner === inner) {
                        return;
                    }

                    // If the inner element was replaced, stop the old timer.
                    if (existing) {
                        existing.instance._stop();
                    }

                    if (!inner) return;

                    const instance = new ShamimDualSlider(track, sectionId);

                    sliderInstances.set(track, {
                        inner,
                        instance
                    });
                });
            });
        }

        function bootSlider() {
            init();

            // Re-initialize if Bagisto replaces the slider DOM.
            const observer = new MutationObserver(() => {
                init();
            });

            observer.observe(document.body, {
                childList: true,
                subtree: true
            });
        }

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', bootSlider, {
                once: true
            });
        } else {
            bootSlider();
        }


        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init, { once: true });
        } else {
            init();
        }
    })();
    </script>

    <style>
    /* ── Dual Slider ─────────────────────────────── */
    .sh-dual-slider {
        position: relative;
        width: 100%;
        overflow: hidden;
        line-height: 0; /* remove inline-block gap */
    }

    .sh-dual-slider__track {
        width: 100%;
        overflow: hidden;
    }

    /* Desktop track: visible on md+ */
    .sh-dual-slider__track--desktop {
        display: none;
    }
    @media (min-width: 768px) {
        .sh-dual-slider__track--desktop { display: block; }
        .sh-dual-slider__track--mobile  { display: none;  }
    }

    /* Inner strip: side-by-side slides */
    .sh-dual-slider__inner {
        display: flex;
        flex-direction: row;
        direction: ltr !important; /* Forces uniform left-to-right DOM ordering for reliable slide offsets */
        will-change: transform;
        transition: transform 0.65s cubic-bezier(.4,0,.2,1);
    }

    .sh-dual-slider__slide {
        flex: 0 0 100%;
        width: 100%;
        direction: rtl; /* restore RTL for slide contents if any */
        cursor: pointer;
        position: relative;
        overflow: hidden;
        line-height: 0;
    }

    .sh-dual-slider__img {
        display: block;
        width: 100%;
        height: auto;
        max-height: 80vh;
        object-fit: cover;
        object-position: center;
        user-select: none;
        -webkit-user-drag: none;
    }
    @media (min-width: 768px) {
        .sh-dual-slider__img {
            max-height: 55vh;
        }
    }
    </style>
    @endpushOnce
@endif
