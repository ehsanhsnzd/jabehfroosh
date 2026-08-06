<?php

namespace BagistoPlus\ShamimPackVisual\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Settings\Text;
use BagistoPlus\Visual\Settings\Textarea;

class QuoteBanner extends BladeSection
{
    protected static string $view = 'shop::sections.quote-banner';
    protected static string $wrapper = 'section.quote.reveal';
    protected static string $name = 'نقل‌قول شمیم';

    public static function settings(): array
    {
        return [
            Textarea::make('quote', 'متن نقل‌قول')->default('مشتری قبل از چشیدن غذا، کیفیت برند شما را از بسته‌بندی آن قضاوت می‌کند.'),
            Text::make('cite', 'منبع')->default('— شمیم پک، همراه برندهای خوش‌طعم'),
        ];
    }
}
