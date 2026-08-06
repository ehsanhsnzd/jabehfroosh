<?php

namespace BagistoPlus\ShamimVisual\Sections;

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
    protected static string $name = 'داستان طراحی شمیم';
    protected static string $description = 'تصویر، داستان برند، دکمه و آمارهای قابل ویرایش';

    public static function settings(): array
    {
        return [
            Image::make('image', 'تصویر')->default(asset('themes/shop/shamim-visual/images/shamim-hero.png')),
            Text::make('eyebrow', 'برچسب')->default('طراحی مسئولانه'),
            Text::make('heading', 'عنوان')->default('زیبایی که نسل‌ها می‌ماند'),
            Textarea::make('description', 'توضیح')->default('از انتخاب چوب تا آخرین دوخت، هر قطعه با دقت و احترام به طبیعت ساخته می‌شود. طراحی ساده، کیفیت بالا و آسایشی که هر روز حس می‌کنید.'),
            Text::make('button_text', 'متن دکمه')->default('داستان محصولات ما'),
            Link::make('button_url', 'لینک دکمه')->default('/search'),
        ];
    }

    public static function blocks(): array
    {
        return [Block::make('stat', 'آمار')->settings([
            Text::make('value', 'مقدار')->default('۱۰ سال'),
            Text::make('label', 'عنوان')->default('ضمانت سازه'),
        ])];
    }
}
