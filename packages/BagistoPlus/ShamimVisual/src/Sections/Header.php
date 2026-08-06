<?php

namespace BagistoPlus\ShamimVisual\Sections;

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

    protected static string $name = 'هدر و منوی شمیم';

    protected static string $description = 'لوگو، جستجو، منوی اصلی، مگامنو و drawerهای موبایل';

    protected static array $disabledOn = ['*'];

    public static function settings(): array
    {
        return [
            Text::make('logo_text', 'نام برند')->default('شمیم هوم'),
            Text::make('logo_subtitle', 'زیرعنوان لوگو')->default('SHAMIM LIVING'),
            Text::make('logo_mark', 'حرف لوگو')->default('ش'),
            Text::make('search_placeholder', 'متن جستجو')->default('جستجو میان بیش از ۱۲۰ محصول...'),
            Text::make('sale_text', 'پیام فروش ویژه')->default('● فروش ویژه تا ۳۰٪ تخفیف'),
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
                Text::make('title', 'عنوان منو')->default('مبلمان'),
                Text::make('group_1_title', 'عنوان ستون اول')->default('فضای نشیمن'),
                Textarea::make('group_1_links', 'لینک‌های ستون اول (هر خط: عنوان|آدرس)')->default("مبل راحتی|/search?query=مبل\nصندلی تک|/search?query=صندلی\nمیز جلو مبلی|/search?query=میز\nپاف و نیمکت|/search"),
                Text::make('group_2_title', 'عنوان ستون دوم')->default('اتاق خواب'),
                Textarea::make('group_2_links', 'لینک‌های ستون دوم')->default("تخت خواب|/search\nپاتختی|/search\nدراور|/search\nآینه|/search"),
                Text::make('group_3_title', 'عنوان ستون سوم')->default('دکوراسیون'),
                Textarea::make('group_3_links', 'لینک‌های ستون سوم')->default("نورپردازی|/search\nفرش و بافت|/search\nگلدان|/search\nاکسسوری|/search"),
                Image::make('promo_image', 'تصویر مگامنو')->default(asset('themes/shop/shamim-visual/images/shamim-hero.png')),
                Text::make('promo_text', 'متن تصویر')->default('کالکشن خانه آرام ←'),
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
                ['type' => 'menu_link', 'settings' => ['title' => 'پرفروش‌ها', 'url' => '#bestsellers']],
                ['type' => 'menu_link', 'settings' => ['title' => 'کالکشن جدید', 'url' => '#collections']],
                ['type' => 'menu_link', 'settings' => ['title' => 'مجله دکوراسیون', 'url' => '/search']],
                ['type' => 'menu_link', 'settings' => ['title' => 'درباره شمیم', 'url' => '#contact']],
            ],
        ];
    }
}
