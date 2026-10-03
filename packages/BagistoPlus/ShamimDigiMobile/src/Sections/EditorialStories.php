<?php

namespace BagistoPlus\ShamimDigiMobile\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Sections\Block;
use BagistoPlus\Visual\Settings\Image;
use BagistoPlus\Visual\Settings\Link;
use BagistoPlus\Visual\Settings\Text;

class EditorialStories extends BladeSection
{
    protected static string $view = 'shop::sections.editorial-stories';

    protected static string $wrapper = 'section.sh-section.reveal';

    protected static string $name = 'راهنمای بسته‌بندی جعبه فروش';

    protected static string $description = 'کارت‌های تصویری آموزش انتخاب بسته‌بندی و چاپ';

    public static function settings(): array
    {
        return [
            Text::make('eyebrow', 'برچسب')->default('انتخاب آگاهانه'),
            Text::make('heading', 'عنوان')->default('راهنمای بسته‌بندی جعبه فروش'),
        ];
    }

    public static function blocks(): array
    {
        return [Block::make('story', 'داستان')->settings([
            Image::make('image', 'تصویر')->default(asset('themes/shop/shamim-pack/images/pack-burger.png')),
            Text::make('category', 'دسته')->default('راهنمای انتخاب'),
            Text::make('title', 'عنوان')->default('برای غذای گرم چه جعبه‌ای مناسب‌تر است؟'),
            Text::make('link_text', 'متن لینک')->default('مطالعه مقاله ←'),
            Link::make('url', 'لینک')->default('/'),
        ])];
    }
}
