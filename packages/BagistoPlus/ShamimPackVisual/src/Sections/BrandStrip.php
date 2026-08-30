<?php

namespace BagistoPlus\ShamimPackVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Sections\Block;
use BagistoPlus\Visual\Settings\Text;

class BrandStrip extends BladeSection
{
    protected static string $view = 'shop::sections.brand-strip';
    protected static string $wrapper = 'section.sh-section.reveal';
    protected static string $name = 'کاربردهای جعبه فروش';

    public static function settings(): array
    {
        return [
            Text::make('eyebrow', 'برچسب')->default('برای کسب‌وکار شما'),
            Text::make('heading', 'عنوان')->default('کاربردهای جعبه فروش'),
        ];
    }

    public static function blocks(): array
    {
        return [Block::make('brand', 'برند')->settings([
            Text::make('name', 'نام برند')->default('رستوران'),
        ])];
    }
}
