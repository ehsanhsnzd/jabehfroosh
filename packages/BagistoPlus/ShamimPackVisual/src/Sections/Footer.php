<?php

namespace BagistoPlus\ShamimPackVisual\Sections;

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
            Text::make('newsletter_label', 'برچسب خبرنامه')->default('خبرنامه شمیم پک'),
            Text::make('newsletter_title', 'عنوان خبرنامه')->default('قیمت‌های همکاری و محصولات تازه را دریافت کنید'),
            Text::make('newsletter_placeholder', 'متن فیلد ایمیل')->default('آدرس ایمیل شما'),
            Text::make('newsletter_button', 'متن دکمه')->default('عضویت ←'),
            Text::make('brand_name', 'نام برند')->default('شمیم پک'),
            Textarea::make('brand_description', 'توضیح برند')->default('تولید و فروش تخصصی بسته‌بندی غذا؛ از انتخاب جعبه استاندارد تا طراحی و چاپ اختصاصی برند شما.'),
            Text::make('contact_title', 'عنوان تماس')->default('با ما در تماس باشید'),
            Textarea::make('address', 'آدرس و ساعات کاری')->default("تبریز / اول جاده مایان / کوی بهرام / روبروی کوچه دوم\nشنبه تا چهارشنبه، ۹ تا ۱۸"),
            Text::make('phone', 'تلفن')->default('۰۲۱–۸۸۷۷۶۶۵۵'),
            Text::make('email', 'ایمیل')->default('sales@shamimpack.ir'),
            Text::make('copyright', 'کپی‌رایت')->default('شمیم پک — تمامی حقوق محفوظ است.'),
            Text::make('legal_text', 'متن لینک‌های قانونی')->default('حریم خصوصی · قوانین فروشگاه · پرداخت امن'),
        ];
    }

    public static function blocks(): array
    {
        return [
            Block::make('link_group', 'ستون لینک‌ها')->settings([
                Text::make('title', 'عنوان ستون')->default('فروشگاه'),
                Textarea::make('links', 'لینک‌ها (هر خط: عنوان|آدرس)')->default("همه محصولات|/search\nجعبه‌های غذا|#categories\nکاغذ کرافت|#categories\nچاپ اختصاصی|#collections\nپرفروش‌ها|#bestsellers"),
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
                    'links' => "ارسال و تحویل|/\nشرایط بازگشت|/\nشرایط سفارش عمده|/\nراهنمای انتخاب بسته‌بندی|/\nسؤالات متداول|/",
                ]],
                ['type' => 'social_link', 'settings' => ['label' => 'in', 'url' => '/']],
                ['type' => 'social_link', 'settings' => ['label' => '●', 'url' => '/']],
                ['type' => 'social_link', 'settings' => ['label' => '▶', 'url' => '/']],
            ],
        ];
    }
}
