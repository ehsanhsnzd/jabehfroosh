<?php

namespace BagistoPlus\ShamimVisual\Sections;

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
            Textarea::make('quote', 'متن نقل‌قول')->default('خانه فقط مجموعه‌ای از اشیا نیست؛ روایتی است از چیزهایی که دوست داریم و لحظه‌هایی که می‌خواهیم نگه داریم.'),
            Text::make('cite', 'منبع')->default('— استودیوی طراحی شمیم'),
        ];
    }
}
