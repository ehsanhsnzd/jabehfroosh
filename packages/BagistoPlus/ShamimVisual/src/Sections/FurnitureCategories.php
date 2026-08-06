<?php

namespace BagistoPlus\ShamimVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Sections\Block;
use BagistoPlus\Visual\Settings\Link;
use BagistoPlus\Visual\Settings\Text;

class FurnitureCategories extends BladeSection
{
    protected static string $view = 'shop::sections.furniture-categories';
    protected static string $wrapper = 'section#categories.sh-section.reveal';
    protected static string $name = 'دسته‌بندی‌های شمیم';
    protected static string $description = 'کارت‌های قابل افزودن و مرتب‌سازی دسته‌بندی مبلمان';
    protected static int $maxBlocks = 12;

    public static function settings(): array
    {
        return [
            Text::make('eyebrow', 'برچسب')->default('انتخاب بر اساس فضا'),
            Text::make('heading', 'عنوان')->default('دسته‌بندی‌های محبوب'),
            Text::make('description', 'توضیح')->default('هر گوشه از خانه، داستان خودش را دارد'),
        ];
    }

    public static function blocks(): array
    {
        return [Block::make('category', 'دسته‌بندی')->settings([
            Text::make('icon', 'آیکن یا ایموجی')->default('🛋️'),
            Text::make('title', 'عنوان')->default('مبل راحتی'),
            Text::make('count', 'تعداد/زیرعنوان')->default('۲۴ محصول'),
            Link::make('url', 'لینک')->default('/search'),
        ])];
    }
}
