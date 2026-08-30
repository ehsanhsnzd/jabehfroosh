<?php

namespace BagistoPlus\ShamimPackVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Settings\Image;
use BagistoPlus\Visual\Settings\Link;
use BagistoPlus\Visual\Settings\Text;
use BagistoPlus\Visual\Settings\Textarea;

class FurnitureHero extends BladeSection
{
    protected static string $view = 'shop::sections.furniture-hero';
    protected static string $wrapper = 'section.hero';
    protected static string $name = 'هیرو فروشگاه جعبه فروش';
    protected static string $description = 'تصویر اصلی، تیتر، دکمه، قیمت و نشانگرهای شناور';

    public static function settings(): array
    {
        return [
            Image::make('image', 'تصویر اصلی')->default(asset('themes/shop/shamim-pack/images/pack-hero.png')),
            Text::make('eyebrow', 'برچسب')->default('تولید و فروش تخصصی بسته‌بندی غذا'),
            Text::make('heading', 'عنوان')->default('بسته‌بندی حرفه‌ای برای طعم‌های ماندگار'),
            Textarea::make('description', 'توضیحات')->default('جعبه و کاغذ استاندارد غذایی با قیمت همکاری و امکان چاپ اختصاصی برای رستوران، فست‌فود و کافه.'),
            Text::make('button_text', 'متن دکمه')->default('مشاهده محصولات ←'),
            Link::make('button_url', 'لینک دکمه')->default('/search'),
            Text::make('price', 'متن قیمت')->default('قیمت ویژه سفارش عمده'),
            Text::make('badge_1_title', 'عنوان نشان اول')->default('بسته‌بندی Food Grade'),
            Text::make('badge_1_text', 'متن نشان اول')->default('ایمن و مناسب تماس با غذا'),
            Text::make('badge_2_title', 'عنوان نشان دوم')->default('چاپ اختصاصی برند'),
            Text::make('badge_2_text', 'متن نشان دوم')->default('از طراحی تا تولید'),
        ];
    }
}
