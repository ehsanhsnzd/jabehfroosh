<?php

namespace BagistoPlus\ShamimPackVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Sections\Block;
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
            Text::make('sale_text', 'پیام فروش ویژه')->default('● قیمت همکاری برای سفارش‌های عمده'),
            Text::make('drawer_title', 'عنوان منوی موبایل')->default('منوی فروشگاه'),
            Text::make('cart_title', 'عنوان سبد خرید')->default('سبد خرید شما'),
            Text::make('support_phone', 'تلفن پشتیبانی')->default('۰۲۱–۸۸۷۷۶۶۵۵'),
        ];
    }

    public static function blocks(): array
    {
        return [
            Block::make('menu_link', 'لینک منو')->settings([
                Text::make('title', 'عنوان')->default('خانه'),
                Link::make('url', 'آدرس')->default('/'),
            ]),
            Block::make('mega_menu', 'مگامنو')->limit(1)->settings([
                Text::make('title', 'عنوان منو')->default('محصولات'),
                Text::make('group_1_title', 'عنوان ستون اول')->default('جعبه‌های غذا'),
                Textarea::make('group_1_links', 'لینک‌های ستون اول (هر خط: عنوان|آدرس)')->default("جعبه پیتزا|/pizza-boxes\nجعبه برگر|/burger-boxes\nجعبه ساندویچ|/sandwich-boxes\nجعبه سوخاری|/fried-chicken-boxes\nجعبه سیب‌زمینی|/french-fries-boxes\nجعبه غذا|/takeaway-food-boxes\nسطل سوخاری|/fried-chicken-buckets"),
                Text::make('group_2_title', 'عنوان ستون دوم')->default('ملزومات سرو و مصرف'),
                Textarea::make('group_2_links', 'لینک‌های ستون دوم')->default("ظروف یکبار مصرف|/disposable-food-containers\nلیوان یکبار مصرف|/disposable-cups\nپک قاشق و چنگال|/cutlery-packs\nسفره|/disposable-tablecloths\nسینگل زیر پیتزا|/pizza-boards"),
                Text::make('group_3_title', 'عنوان ستون سوم')->default('بسته‌بندی‌های تکمیلی'),
                Textarea::make('group_3_links', 'لینک‌های ستون سوم')->default("پاکت بیرون‌بر|/takeaway-bags\nکاغذ ساندویچ|/sandwich-wrapping-paper\nبسته‌بندی ساشه|/single-serve-sachets\nبسته‌بندی آجیل|/nuts-packaging\nبسته‌بندی بستنی|/ice-cream-packaging"),
                Image::make('promo_image', 'تصویر مگامنو')->default(asset('themes/shop/shamim-pack/images/pack-hero.png')),
                Text::make('promo_text', 'متن تصویر')->default('چاپ اختصاصی بسته‌بندی ←'),
                Link::make('promo_url', 'لینک تصویر')->default('/search'),
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
