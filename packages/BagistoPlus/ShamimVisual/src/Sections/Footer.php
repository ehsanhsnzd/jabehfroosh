<?php

namespace BagistoPlus\ShamimVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Sections\Block;
use BagistoPlus\Visual\Settings\Link;
use BagistoPlus\Visual\Settings\Text;
use BagistoPlus\Visual\Settings\Textarea;

class Footer extends BladeSection
{
    protected static string $view = 'shop::sections.footer';
    protected static string $wrapper = 'footer#contact.foot';

    protected static string $name = 'فوتر شمیم';

    protected static string $description = 'خبرنامه، معرفی برند، ستون لینک‌ها و اطلاعات تماس';

    protected static array $disabledOn = ['*'];

    public static function settings(): array
    {
        return [
            Text::make('newsletter_label', 'برچسب خبرنامه')->default('نامه‌های شمیم'),
            Text::make('newsletter_title', 'عنوان خبرنامه')->default('تازه‌های طراحی را از دست ندهید'),
            Text::make('newsletter_placeholder', 'متن فیلد ایمیل')->default('آدرس ایمیل شما'),
            Text::make('newsletter_button', 'متن دکمه')->default('عضویت ←'),
            Text::make('brand_name', 'نام برند')->default('شمیم هوم'),
            Textarea::make('brand_description', 'توضیح برند')->default('مبلمانی برای زندگی امروز؛ طراحی ماندگار، متریال اصیل و جزئیاتی که خانه را به جای دلخواه شما تبدیل می‌کند.'),
            Text::make('contact_title', 'عنوان تماس')->default('با ما در تماس باشید'),
            Textarea::make('address', 'آدرس و ساعات کاری')->default("تهران، خیابان ولیعصر\nشنبه تا چهارشنبه، ۹ تا ۱۸"),
            Text::make('phone', 'تلفن')->default('۰۲۱–۸۸۷۷۶۶۵۵'),
            Text::make('email', 'ایمیل')->default('hello@shamimhome.ir'),
            Text::make('copyright', 'کپی‌رایت')->default('شمیم هوم — تمامی حقوق محفوظ است.'),
            Text::make('legal_text', 'متن لینک‌های قانونی')->default('حریم خصوصی · قوانین فروشگاه · پرداخت امن'),
        ];
    }

    public static function blocks(): array
    {
        return [
            Block::make('link_group', 'ستون لینک‌ها')->settings([
                Text::make('title', 'عنوان ستون')->default('فروشگاه'),
                Textarea::make('links', 'لینک‌ها (هر خط: عنوان|آدرس)')->default("همه محصولات|/search\nمبلمان نشیمن|#categories\nاتاق خواب|#categories\nکالکشن جدید|#collections\nفروش ویژه|#bestsellers"),
            ]),
            Block::make('social_link', 'شبکه اجتماعی')->settings([
                Text::make('label', 'عنوان کوتاه')->default('in'),
                Link::make('url', 'آدرس')->default('/'),
            ]),
        ];
    }

    public static function default(): array
    {
        return [
            'blocks' => [
                ['type' => 'link_group'],
                ['type' => 'link_group', 'settings' => [
                    'title' => 'راهنمای مشتریان',
                    'links' => "ارسال و تحویل|/\nشرایط بازگشت|/\nضمانت محصولات|/\nراهنمای نگهداری|/\nسؤالات متداول|/",
                ]],
                ['type' => 'social_link', 'settings' => ['label' => 'in', 'url' => '/']],
                ['type' => 'social_link', 'settings' => ['label' => '●', 'url' => '/']],
                ['type' => 'social_link', 'settings' => ['label' => '▶', 'url' => '/']],
            ],
        ];
    }
}
