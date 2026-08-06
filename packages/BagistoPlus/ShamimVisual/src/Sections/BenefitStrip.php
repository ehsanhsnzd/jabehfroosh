<?php

namespace BagistoPlus\ShamimVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Sections\Block;
use BagistoPlus\Visual\Settings\Text;

class BenefitStrip extends BladeSection
{
    protected static string $view = 'shop::sections.benefit-strip';
    protected static string $wrapper = 'section.benefits';
    protected static string $name = 'مزیت‌های فروشگاه شمیم';
    protected static int $maxBlocks = 8;

    public static function blocks(): array
    {
        return [Block::make('benefit', 'مزیت')->settings([
            Text::make('icon', 'آیکن یا ایموجی')->default('🚚'),
            Text::make('title', 'عنوان')->default('ارسال مطمئن'),
            Text::make('description', 'توضیح')->default('به سراسر ایران'),
        ])];
    }
}
