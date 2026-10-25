<?php

namespace BagistoPlus\ShamimDigiMobile\Sections;

use BagistoPlus\Visual\Sections\BladeSection;
use BagistoPlus\Visual\Sections\Block;
use BagistoPlus\Visual\Settings\Image;
use BagistoPlus\Visual\Settings\Link;

class DualSlideshow extends BladeSection
{
    protected static string $view = 'shop::sections.dual-slideshow';

    protected static string $name = 'اسلایدر موبایل / دسکتاپ';

    protected static string $description = 'اسلایدر تمام‌عرض با تصاویر جداگانه برای موبایل و دسکتاپ – هر ۵ ثانیه خودکار تغییر می‌کند';

    public static function settings(): array
    {
        return [];
    }

    public static function blocks(): array
    {
        return [
            Block::make('slide', 'اسلاید')
                ->settings([
                    Image::make('image_desktop', 'تصویر دسکتاپ (وایدسکرین ۱۶:۵ یا ۱۶:۴)')
                        ->info('برای صفحه‌های عریض (md به بالا). نسبت پیشنهادی ۱۶:۴ یا ۱۶:۵'),
                    Image::make('image_mobile', 'تصویر موبایل (مربع یا ۴:۳)')
                        ->info('برای صفحه‌های موبایل (زیر md). نسبت پیشنهادی ۱:۱ یا ۴:۳'),
                    Link::make('link', 'لینک اسلاید (اختیاری)')
                        ->default('/'),
                ]),
        ];
    }

    /**
     * Prepare slide data to be passed to the Blade view.
     */
    public function getSlides(): array
    {
        $blocks = collect($this->section->blocks);

        if ($blocks->isEmpty()) {
            return [];
        }

        return $blocks->map(function ($block) {
            $desktopImg = $block->settings->get('image_desktop');
            $mobileImg = $block->settings->get('image_mobile');
            $link = $block->settings->get('link');

            return [
                'id' => $block->id,
                'image_desktop' => $desktopImg ? (string) $desktopImg : null,
                'image_mobile' => $mobileImg ? (string) $mobileImg : null,
                'link' => $link ? (string) $link : null,
                'liveUpdate' => [
                    'image_desktop' => $block->liveUpdate()->attr('image_desktop', 'src')->toHtml(),
                    'image_mobile' => $block->liveUpdate()->attr('image_mobile', 'src')->toHtml(),
                ],
            ];
        })->filter(fn ($s) => $s['image_desktop'] || $s['image_mobile'])->values()->toArray();
    }
}
