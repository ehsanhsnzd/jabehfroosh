<?php

namespace BagistoPlus\ShamimPackVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Sections\Block;
use BagistoPlus\Visual\Settings\Image;
use BagistoPlus\Visual\Settings\Link;
use BagistoPlus\Visual\Settings\Text;

class FurnitureCategories extends BladeSection
{
    protected static string $view = 'shop::sections.furniture-categories';
    protected static string $wrapper = 'section#categories.sh-section.reveal';
    protected static string $name = 'دسته‌بندی محصولات شمیم پک';
    protected static string $description = 'کارت‌های تصویری قابل افزودن و مرتب‌سازی محصولات بسته‌بندی';
    protected static int $maxBlocks = 12;

    public static function settings(): array
    {
        return [
            Text::make('eyebrow', 'برچسب')->default('انتخاب سریع محصول'),
            Text::make('heading', 'عنوان')->default('محصولات بسته‌بندی شمیم پک'),
            Text::make('description', 'توضیح')->default('برای هر غذای محبوب، بسته‌بندی مناسب و حرفه‌ای'),
        ];
    }

    public static function blocks(): array
    {
        return [Block::make('category', 'دسته محصول')->settings([
            Image::make('image', 'تصویر محصول')->default(asset('themes/shop/shamim-pack/images/pack-burger.png')),
            Text::make('title', 'عنوان')->default('جعبه برگر'),
            Text::make('count', 'زیرعنوان')->default('مدل کرافت و ایندربرد'),
            Link::make('url', 'لینک')->default('/search'),
        ])];
    }
}
