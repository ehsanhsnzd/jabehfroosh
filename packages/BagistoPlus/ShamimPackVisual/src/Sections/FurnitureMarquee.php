<?php

namespace BagistoPlus\ShamimPackVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Sections\Block;
use BagistoPlus\Visual\Settings\Text;

class FurnitureMarquee extends BladeSection
{
    protected static string $view = 'shop::sections.furniture-marquee';
    protected static string $wrapper = 'div.marquee';
    protected static string $name = 'نوار متحرک ویژگی‌ها';
    protected static int $maxBlocks = 16;

    public static function blocks(): array
    {
        return [Block::make('item', 'عبارت')->settings([
            Text::make('text', 'متن')->default('مواد اولیه Food Grade'),
        ])];
    }
}
