<?php

namespace BagistoPlus\ShamimVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Settings\Link;
use BagistoPlus\Visual\Settings\Text;

class TopBar extends BladeSection
{
    protected static string $view = 'shop::sections.top-bar';
    protected static string $wrapper = 'div.sh-announce';

    protected static string $name = 'نوار اعلان شمیم';

    protected static string $description = 'پیام‌های چرخشی و لینک‌های بالای سایت';

    protected static array $disabledOn = ['*'];

    public static function settings(): array
    {
        return [
            Text::make('message_1', 'پیام اول')->default('ارسال رایگان برای خریدهای بالای ۳ میلیون تومان'),
            Text::make('message_2', 'پیام دوم')->default('۷ روز ضمانت بازگشت بدون قید و شرط'),
            Text::make('message_3', 'پیام سوم')->default('مشاوره رایگان چیدمان با کارشناسان شمیم'),
            Text::make('link_1_text', 'عنوان لینک اول')->default('شعب فروشگاه'),
            Link::make('link_1_url', 'آدرس لینک اول')->default('/'),
            Text::make('link_2_text', 'عنوان لینک دوم')->default('پیگیری سفارش'),
            Link::make('link_2_url', 'آدرس لینک دوم')->default('/'),
            Text::make('link_3_text', 'عنوان لینک سوم')->default('سؤالات متداول'),
            Link::make('link_3_url', 'آدرس لینک سوم')->default('/'),
        ];
    }
}
