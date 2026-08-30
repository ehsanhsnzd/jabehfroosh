<?php

namespace BagistoPlus\ShamimPackVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Sections\Block;
use BagistoPlus\Visual\Settings\Image;
use BagistoPlus\Visual\Settings\Link;
use BagistoPlus\Visual\Settings\Text;
use BagistoPlus\Visual\Settings\Textarea;

class FurnitureStory extends BladeSection
{
    protected static string $view = 'shop::sections.furniture-story';
    protected static string $wrapper = 'section#collections.sh-section.reveal';
    protected static string $name = 'چاپ اختصاصی جعبه فروش';
    protected static string $description = 'تصویر، داستان برند، دکمه و آمارهای قابل ویرایش';

    public static function settings(): array
    {
        return [
            Image::make('image', 'تصویر')->default(asset('themes/shop/shamim-pack/images/pack-kraft.png')),
            Text::make('eyebrow', 'برچسب')->default('هویت برند شما روی بسته‌بندی'),
            Text::make('heading', 'عنوان')->default('چاپ اختصاصی، از ایده تا تحویل'),
            Textarea::make('description', 'توضیح')->default('از انتخاب جنس و ابعاد تا طراحی قالب و چاپ، کارشناسان جعبه فروش کنار شما هستند تا بسته‌بندی نهایی کاربردی، ایمن و هماهنگ با هویت برندتان باشد.'),
            Text::make('button_text', 'متن دکمه')->default('دریافت مشاوره چاپ ←'),
            Link::make('button_url', 'لینک دکمه')->default('/search'),
        ];
    }

    public static function blocks(): array
    {
        return [Block::make('stat', 'آمار')->settings([
            Text::make('value', 'مقدار')->default('۱۰+ سال'),
            Text::make('label', 'عنوان')->default('تجربه تولید'),
        ])];
    }
}
