<?php

namespace BagistoPlus\ShamimVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Sections\Block;
use BagistoPlus\Visual\Settings\Image;
use BagistoPlus\Visual\Settings\Link;
use BagistoPlus\Visual\Settings\Text;

class EditorialStories extends BladeSection
{
    protected static string $view = 'shop::sections.editorial-stories';
    protected static string $wrapper = 'section.sh-section.reveal';
    protected static string $name = 'داستان‌های شمیم';
    protected static string $description = 'کارت‌های تصویری مجله و راهنمای چیدمان';

    public static function settings(): array
    {
        return [
            Text::make('eyebrow', 'برچسب')->default('ایده‌هایی برای خانه'),
            Text::make('heading', 'عنوان')->default('داستان‌های شمیم'),
        ];
    }

    public static function blocks(): array
    {
        return [Block::make('story', 'داستان')->settings([
            Image::make('image', 'تصویر')->default(asset('themes/shop/shamim-visual/images/shamim-hero.png')),
            Text::make('category', 'دسته')->default('راهنمای چیدمان'),
            Text::make('title', 'عنوان')->default('چطور مبل مناسب فضای کوچک انتخاب کنیم؟'),
            Text::make('link_text', 'متن لینک')->default('مطالعه مقاله ←'),
            Link::make('url', 'لینک')->default('/'),
        ])];
    }
}
