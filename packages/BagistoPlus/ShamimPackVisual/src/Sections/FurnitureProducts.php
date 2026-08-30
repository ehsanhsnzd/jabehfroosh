<?php

namespace BagistoPlus\ShamimPackVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Settings\Number;
use BagistoPlus\Visual\Settings\Text;

class FurnitureProducts extends BladeSection
{
    protected static string $view = 'shop::sections.furniture-products';
    protected static string $wrapper = 'section#bestsellers.products.reveal';
    protected static string $name = 'محصولات منتخب جعبه فروش';
    protected static string $description = 'کاروسل محصولات واقعی فروشگاه';

    public static function settings(): array
    {
        return [
            Text::make('eyebrow', 'برچسب')->default('انتخاب حرفه‌ای‌ها'),
            Text::make('heading', 'عنوان')->default('پرفروش‌ترین بسته‌بندی‌ها'),
            Number::make('limit', 'تعداد محصولات')->default(10)->min(1)->max(20),
        ];
    }
}
