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
</style>
