<?php

namespace BagistoPlus\ShamimVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Settings\Image;
use BagistoPlus\Visual\Settings\Link;
use BagistoPlus\Visual\Settings\Text;
use BagistoPlus\Visual\Settings\Textarea;

class FurnitureHero extends BladeSection
{
    protected static string $view = 'shop::sections.furniture-hero';
    protected static string $wrapper = 'section.hero';
    protected static string $name = 'هیرو مبلمان شمیم';
    protected static string $description = 'تصویر اصلی، تیتر، دکمه، قیمت و نشانگرهای شناور';

    public static function settings(): array
    {
        return [
            Image::make('image', 'تصویر اصلی')->default(asset('themes/shop/shamim-visual/images/shamim-hero.png')),
            Text::make('eyebrow', 'برچسب')->default('کالکشن تازه ۱۴۰۵'),
            Text::make('heading', 'عنوان')->default('زیباییِ آرام برای خانه شما'),
            Textarea::make('description', 'توضیحات')->default('مجموعه‌ای از مبلمان مدرن و دست‌ساز؛ ساخته‌شده با متریال طبیعی برای لحظه‌هایی که ماندگار می‌شوند.'),
            Text::make('button_text', 'متن دکمه')->default('مشاهده کالکشن ←'),
            Link::make('button_url', 'لینک دکمه')->default('/search'),
            Text::make('price', 'متن قیمت')->default('از ۱۲,۹۰۰,۰۰۰ تومان'),
            Text::make('badge_1_title', 'عنوان نشان اول')->default('مبل بوکله آرا'),
            Text::make('badge_1_text', 'متن نشان اول')->default('از ۳۸ میلیون تومان'),
            Text::make('badge_2_title', 'عنوان نشان دوم')->default('میز گردو نوا'),
            Text::make('badge_2_text', 'متن نشان دوم')->default('ساخت دست ایران'),
        ];
    }
}
