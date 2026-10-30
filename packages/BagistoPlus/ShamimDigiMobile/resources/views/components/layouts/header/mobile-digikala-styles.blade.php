<style>
    .sh-digi-mobile-header { display: none; }

    @media (max-width: 2400px) {
        .shamim-digi-mobile-layout > .sc,
        .shamim-digi-mobile-layout .sh-header-desktop--digi-mobile {
            display: none !important;
        }

        .shamim-digi-mobile-layout .sh-digi-mobile-header {
            --sh-digi-tab-expanded: 1;
            position: sticky;
            top: 0;
            z-index: 50;
            display: block;
            overflow: hidden;
            background: #f1f2f4;
            border-bottom: 1px solid #e0e0e2;
        }

        .shamim-digi-mobile-layout .sh-digi-tabs-wrap {
            overflow-x: auto;
            overscroll-behavior-inline: contain;
            scrollbar-width: none;
            direction: rtl;
        }

        .shamim-digi-mobile-layout .sh-digi-tabs-wrap::-webkit-scrollbar { display: none; }

        .shamim-digi-mobile-layout .sh-digi-tabs {
            display: flex;
            gap: 8px;
            width: max-content;
            min-width: 100%;
            padding: 10px 12px 12px;
        }

        .shamim-digi-mobile-layout .sh-digi-tab {
            display: flex;
            flex: 0 0 82px;
            min-height: 44px;
            height: calc(44px + 44px * var(--sh-digi-tab-expanded));
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: calc(5px * var(--sh-digi-tab-expanded));
            overflow: hidden;
            padding: 6px 4px;
            color: #23254e;
            border: 1px solid #dedfe0;
            border-radius: 15px;
            background: #fff;
            box-shadow: 0 1px 1px rgb(0 0 0 / 4%);
            text-decoration: none;
            transition: background .18s ease, border-color .18s ease, color .18s ease, transform .18s ease;
            -webkit-tap-highlight-color: transparent;
        }

        .shamim-digi-mobile-layout .sh-digi-tab:hover,
        .shamim-digi-mobile-layout .sh-digi-tab:focus-visible,
        .shamim-digi-mobile-layout .sh-digi-tab--active {
            color: #fff;
            border-color: #e2e2e2;
            background: #9f17f4;
            outline: 0;
        }

        .shamim-digi-mobile-layout .sh-digi-tab:active { transform: scale(.97); }

        .shamim-digi-mobile-layout .sh-digi-tab__icon {
            display: grid;
            width: calc(39px * var(--sh-digi-tab-expanded));
            height: calc(39px * var(--sh-digi-tab-expanded));
            flex-shrink: 0;
            place-items: center;
            overflow: hidden;
            border-radius: 11px;
            /*background: #f4f5f7;*/
            color: #5f6470;
            font-size: calc(18px * var(--sh-digi-tab-expanded));
            font-weight: 800;
            line-height: 1;
            opacity: var(--sh-digi-tab-expanded);
        }

        .shamim-digi-mobile-layout .sh-digi-tab__icon svg { max-width: 100%; max-height: 100%; }

        .shamim-digi-mobile-layout .sh-digi-tab--active .sh-digi-tab__icon,
        .shamim-digi-mobile-layout .sh-digi-tab:hover .sh-digi-tab__icon,
        .shamim-digi-mobile-layout .sh-digi-tab:focus-visible .sh-digi-tab__icon {
            /*background: rgb(255 255 255 / 17%);*/
            color: #fff; }

        .shamim-digi-mobile-layout .sh-digi-tab__icon img { width: 100%; height: 100%; object-fit: contain; }

        .shamim-digi-mobile-layout .sh-digi-tab__label {
            display: -webkit-box;
            overflow: hidden;
            max-width: 100%;
            font-size: 11px;
            font-weight: 750;
            line-height: 1.45;
            text-align: center;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 2;
        }

        .shamim-digi-mobile-layout .sh-digi-mobile-header__toolbar { display: flex; gap: 12px; padding: 0 16px 14px; }

        .shamim-digi-mobile-layout .sh-digi-search {
            position: relative;
            display: flex;
            min-width: 0;
            height: 48px;
            flex: 1;
            align-items: center;
            padding: 0 14px;
            border: 1px solid #d9dce1;
            border-radius: 999px;
            background: #fff;
        }

        .shamim-digi-mobile-layout .sh-digi-search:focus-within { border-color: #ef4056; box-shadow: 0 0 0 3px rgb(239 64 86 / 12%); }
        .shamim-digi-mobile-layout .sh-digi-search__icon { display: grid; width: 26px; place-items: center; color: #81858b; }
        .shamim-digi-mobile-layout .sh-digi-search__input { min-width: 0; height: 46px; flex: 1; padding: 0 8px; color: #23254e; background: transparent; font-size: 13px; outline: 0; }
        .shamim-digi-mobile-layout .sh-digi-search__input::placeholder { color: #81858b; opacity: 1; }

        .sh-digi-search__brand {
            position: absolute;
            right: 48px;
            top: 50%;
            display: flex;
            align-items: center;
            gap: 7px;
            max-width: calc(100% - 62px);
            color: #9f17f4;
            font-size: 13px;
            white-space: nowrap;
            pointer-events: none;
            transform: translateY(-50%);
        }
        .sh-digi-search__brand img { width: 100px; height: 36px; object-fit: contain; }
        .sh-digi-search:focus-within .sh-digi-search__brand,
        .sh-digi-search__input:not(:placeholder-shown) + .sh-digi-search__brand { display: none; }

        .sh-digi-local-nav { display: flex; align-items: center; gap: 16px; padding: 0 16px 10px; }
        .sh-digi-region-trigger { display: flex; flex: none; align-items: center; gap: 5px; min-height: 38px; color: #a98460; font-size: 12px; font-weight: 650; white-space: nowrap; }
        .sh-digi-quick-links { display: flex; flex: 1; align-items: center; gap: 18px; min-width: 0; overflow-x: auto; scrollbar-width: none; }
        .sh-digi-quick-links::-webkit-scrollbar { display: none; }
        .sh-digi-quick-link { position: relative; display: flex; min-height: 38px; flex: none; align-items: center; color: #757575; font-size: 12px; font-weight: 600; white-space: nowrap; }
        .sh-digi-quick-link:hover, .sh-digi-quick-link.is-active { color: #23254e; }
        .sh-digi-quick-link.is-active::after { position: absolute; right: 0; bottom: 0; left: 0; height: 3px; border-radius: 3px; background: currentColor; content: ''; }

        .shamim-digi-mobile-layout .sh-digi-notify {
            display: grid;
            width: 48px;
            height: 48px;
            flex: none;
            place-items: center;
            color: #424750;
            border: 1px solid #d9dce1;
            border-radius: 50%;
            background: #fff;
        }

        .shamim-digi-mobile-layout .sh-digi-notify:active { transform: scale(.96); }
    }

    .sh-digi-region-dialog {
        width: min(420px, calc(100vw - 32px));
        max-height: calc(100dvh - 48px);
        margin: auto;
        padding: 22px;
        overflow-y: auto;
        border: 1px solid #e2e2e7;
        border-radius: 20px;
        background: #fff;
        color: #23254e;
        box-shadow: 0 16px 70px rgb(0 0 0 / 20%);
        direction: rtl;
    }
    .sh-digi-region-dialog::backdrop { background: rgb(23 21 52 / 45%); }
    .sh-digi-region-dialog__heading { display: flex; align-items: center; justify-content: space-between; gap: 20px; }
    .sh-digi-region-dialog__heading h2 { margin: 0; font-size: 19px; font-weight: 750; }
    .sh-digi-region-dialog__heading button { width: 36px; height: 36px; border-radius: 50%; background: #f1f2f4; font-size: 25px; line-height: 1; }
    .sh-digi-region-dialog > p { margin: 12px 0 20px; color: #81858b; font-size: 12px; }
    .sh-digi-region-dialog form { display: grid; gap: 10px; }
    .sh-digi-region-option { display: flex; width: 100%; min-height: 48px; align-items: center; justify-content: space-between; padding: 12px 16px; border: 1px solid #e4e4e8; border-radius: 12px; background: #f8f8fa; text-align: right; }
    .sh-digi-region-option:hover, .sh-digi-region-option.is-selected { border-color: #9f17f4; background: #f7edff; color: #9f17f4; }
</style>
