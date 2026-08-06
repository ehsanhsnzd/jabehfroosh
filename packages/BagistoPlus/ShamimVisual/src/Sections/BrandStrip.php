<?php

namespace BagistoPlus\ShamimVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Sections\Block;
use BagistoPlus\Visual\Settings\Text;

class BrandStrip extends BladeSection
{
    protected static string $view = 'shop::sections.brand-strip';
    protected static string $wrapper = 'section.sh-section.reveal';
    protected static string $name = 'برندهای منتخب';

    public static function settings(): array
    {
        return [
            Text::make('eyebrow', 'برچسب')->default('همراه بهترین‌ها'),
            Text::make('heading', 'عنوان')->default('برندهای منتخب'),
        ];
    }

    public static function blocks(): array
    {
        return [Block::make('brand', 'برند')->settings([
            Text::make('name', 'نام برند')->default('NOVA'),
        ])];
    }
}
