<?php

namespace BagistoPlus\ShamimPackVisual\Sections;

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
            Text::make('message_1', 'پیام اول')->default('ارسال مطمئن سفارش‌های عمده به سراسر ایران'),
            Text::make('message_2', 'پیام دوم')->default('مواد اولیه استاندارد و مناسب تماس با غذا'),
            Text::make('message_3', 'پیام سوم')->default('مشاوره رایگان انتخاب ابعاد، جنس و چاپ'),
            Text::make('link_1_text', 'عنوان لینک اول')->default('درخواست نمونه'),
            Link::make('link_1_url', 'آدرس لینک اول')->default('/'),
            Text::make('link_2_text', 'عنوان لینک دوم')->default('پیگیری سفارش'),
            Link::make('link_2_url', 'آدرس لینک دوم')->default('/'),
            Text::make('link_3_text', 'عنوان لینک سوم')->default('سؤالات متداول'),
            Link::make('link_3_url', 'آدرس لینک سوم')->default('/'),
        ];
    }
}
