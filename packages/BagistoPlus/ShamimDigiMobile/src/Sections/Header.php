<?php

namespace BagistoPlus\ShamimDigiMobile\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Sections\Block;
use BagistoPlus\Visual\Settings\Checkbox;
use BagistoPlus\Visual\Settings\Image;
use BagistoPlus\Visual\Settings\Link;
use BagistoPlus\Visual\Settings\Text;
use BagistoPlus\Visual\Settings\Textarea;

class Header extends BladeSection
{
    protected static string $view = 'shop::sections.header';

    protected static string $wrapper = 'header#shHeader.sh-head';

    protected static string $name = 'هدر و منوی جعبه فروش';

    protected static string $description = 'لوگو، جستجو، منوی اصلی، مگامنو و drawerهای موبایل';

    protected static array $disabledOn = ['*'];

    public static function settings(): array
    {
        return [
            Text::make('logo_text', 'نام برند')->default('جعبه فروش'),
            Text::make('logo_subtitle', 'زیرعنوان لوگو')->default('SHAMIM PACK'),
            Text::make('logo_mark', 'حرف لوگو')->default('ش'),
            Text::make('search_placeholder', 'متن جستجو')->default('جستجو در محصولات بسته‌بندی...'),
            Text::make('search_brand_prompt', 'متن کنار لوگوی جستجو')->default('جستجو در'),
            Image::make('search_brand_image', 'لوگوی داخل جستجو')->info('اگر خالی باشد، لوگوی سبز جعبه فروش نمایش داده می‌شود'),
            Textarea::make('quick_links', 'منوی زیر جستجو (هر خط: عنوان|لینک)')
                ->default("همه|/search\nکاغذ ساندویچ|/sandwich-wrapping-paper\nسینگل|/pizza-boards\nسطل کنتاکی|/fried-chicken-buckets\nپاکت همبرگر|/burger-boxes"),
            Text::make('sale_text', 'پیام فروش ویژه')->default('● قیمت همکاری برای سفارش‌های عمده'),
            Text::make('drawer_title', 'عنوان منوی موبایل')->default('منوی فروشگاه'),
            Text::make('cart_title', 'عنوان سبد خرید')->default('سبد خرید شما'),
            Text::make('support_phone', 'تلفن پشتیبانی')->default('۹۱۶۹۷۲۱۷-۰۲۱'),
        ];
    }

    public static function blocks(): array
    {
        return [
            Block::make('quick_link', 'لینک منوی زیر جستجو')->settings([
                Text::make('title', 'عنوان')->default('همه'),
                Link::make('url', 'آدرس لینک')->default('/search'),
            ]),
            Block::make('menu_link', 'لینک منو')->settings([
                Text::make('title', 'عنوان')->default('خانه'),
                Link::make('url', 'آدرس')->default('/'),
            ]),
            Block::make('mega_menu', 'مگامنو')->limit(1)->settings([
                Text::make('title', 'عنوان منو')->default('محصولات'),

                Checkbox::make('show_categories_tab', 'نمایش تب دسته‌بندی در نوار بالای موبایل')->default(true),
                Text::make('categories_tab_title', 'عنوان تب دسته‌بندی')->default('دسته‌بندی'),
                Link::make('categories_tab_url', 'لینک تب دسته‌بندی')->default('/search'),
                Image::make('categories_tab_image', 'تصویر تب دسته‌بندی (اختیاری)')->info('در صورت انتخاب، به جای آیکون پیش‌فرض دسته‌بندی نمایش داده می‌شود'),

                Checkbox::make('show_brand_tab', 'نمایش تب برند (لوگو) در نوار بالای موبایل')->default(true),
                Text::make('brand_tab_title', 'عنوان تب برند')->default('جعبه فروش'),
                Image::make('brand_tab_image', 'تصویر / لوگوی تب برند (اختیاری)')->info('اگر خالی باشد، لوگوی اصلی سایت قرار می‌گیرد'),
                Link::make('brand_tab_url', 'لینک تب برند')->default('/'),

                Text::make('group_1_title', 'عنوان ستون اول')->default('جعبه‌های غذا'),
                Textarea::make('group_1_links', 'لینک‌های ستون اول (هر خط: عنوان|آدرس|عکس یا آیکون)')
                    ->info('می‌توانید در بخش سوم هر خط، ایموجی (مثل 🍕) یا آدرس عکس (مثل /themes/.../pic.webp) قرار دهید')
                    ->default("جعبه پیتزا|/pizza-boxes|🍕\nجعبه برگر|/burger-boxes|🍔\nجعبه ساندویچ|/sandwich-boxes|🥪\nجعبه سوخاری|/fried-chicken-boxes|🍗\nجعبه سیب‌زمینی|/french-fries-boxes|🍟\nجعبه غذا|/takeaway-food-boxes|🍱\nسطل سوخاری|/fried-chicken-buckets|🪣"),

                Text::make('group_2_title', 'عنوان ستون دوم')->default('ملزومات سرو و مصرف'),
                Textarea::make('group_2_links', 'لینک‌های ستون دوم (هر خط: عنوان|آدرس|عکس یا آیکون)')
                    ->info('می‌توانید در بخش سوم هر خط، ایموجی یا آدرس عکس قرار دهید')
                    ->default("ظروف یکبار مصرف|/disposable-food-containers|🥡\nلیوان یکبار مصرف|/disposable-cups|🥤\nپک قاشق و چنگال|/cutlery-packs|🍴\nسفره|/disposable-tablecloths|🧻\nسینگل زیر پیتزا|/pizza-boards|⭕"),

                Text::make('group_3_title', 'عنوان ستون سوم')->default('بسته‌بندی‌های تکمیلی'),
                Textarea::make('group_3_links', 'لینک‌های ستون سوم (هر خط: عنوان|آدرس|عکس یا آیکون)')
                    ->info('می‌توانید در بخش سوم هر خط، ایموجی یا آدرس عکس قرار دهید')
                    ->default("پاکت بیرون‌بر|/takeaway-bags|🛍️\nکاغذ ساندویچ|/sandwich-wrapping-paper|📜\nبسته‌بندی ساشه|/single-serve-sachets|🧴\nبسته‌بندی آجیل|/nuts-packaging|🥜\nبسته‌بندی بستنی|/ice-cream-packaging|🍨"),

                Textarea::make('mobile_tabs', 'ترتیب و لینک‌های سفارشی بالای موبایل (اختیاری)')
                    ->info('اگر خالی باشد، لینک‌های ۳ ستون مگامنو به ترتیب بالا استفاده می‌شوند. در صورت وارد کردن، دقیقاً همین لیست با همین ترتیب در نوار موبایل نمایش داده می‌شود (هر خط: عنوان|آدرس|عکس یا آیکون).'),

                Image::make('promo_image', 'تصویر مگامنو')->default(asset('themes/shop/shamim-pack/images/pack-hero.png')),
                Text::make('promo_text', 'متن تصویر')->default('چاپ اختصاصی بسته‌بندی ←'),
                Link::make('promo_url', 'لینک تصویر')->default('/search'),
            ]),
            Block::make('header_tab', 'تب بالای هدر (موبایل)')->settings([
                Text::make('title', 'عنوان')->default('جعبه پیتزا'),
                Link::make('url', 'آدرس')->default('/pizza-boxes'),
                Image::make('image', 'تصویر تب')->info('آیکون تصویری تب'),
                Text::make('icon', 'ایموجی یا آیکون متنی')->default('🍕')->info('در صورت خالی بودن تصویر'),
            ]),
        ];
    }

    public static function default(): array
    {
        return [
            'blocks' => [
                ['type' => 'menu_link', 'settings' => ['title' => 'خانه', 'url' => '/']],
                ['type' => 'mega_menu'],
                ['type' => 'menu_link', 'settings' => ['title' => 'پرفروش‌ترین‌ها', 'url' => '#bestsellers']],
                ['type' => 'menu_link', 'settings' => ['title' => 'چاپ اختصاصی', 'url' => '#collections']],
                ['type' => 'menu_link', 'settings' => ['title' => 'مجله کاربرد کسب‌وکار', 'url' => '/blog']],
                ['type' => 'menu_link', 'settings' => ['title' => 'تماس با ما', 'url' => '#contact']],
            ],
        ];
    }
}
