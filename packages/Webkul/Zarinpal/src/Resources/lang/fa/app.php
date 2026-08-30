<?php

return [
    'zarinpal' => [
        'admin' => [
            'title'          => 'زرین‌پال',
            'description'    => 'درگاه پرداخت اینترنتی زرین‌پال',
            'payment_config' => [
                'title'             => 'شناسه پذیرنده (Merchant ID)',
                'title_description' => 'شناسه پذیرنده دریافت‌شده از پنل زرین‌پال',
                'api_base_url'      => 'آدرس وب‌سرویس اصلی',
                'sandbox_base_url'  => 'آدرس وب‌سرویس آزمایشی',
                'request_url'       => 'مسیر درخواست پرداخت',
                'redirect_url'      => 'مسیر انتقال به درگاه',
                'callback_url'      => 'آدرس بازگشت پرداخت',
                'verify_url'        => 'مسیر تأیید پرداخت',
            ],
        ],
        'front' => [
            'failure-get-code'      => 'مشکل در برقراری ارتباط با بانک لطفاْ با مدیر سایت تماس بگیرید',
            'duplicate-transaction' => 'تراکنش تکراری می باشد',
            'failure-message'       => 'تراکنش ناموفق . لطفاْ مجدداْ امتحان نمایید',
            'invalid-configuration' => 'تنظیمات زرین‌پال کامل نیست. لطفاً با مدیر فروشگاه تماس بگیرید.',
            'payment'               => [
                'title'       => 'پرداخت امن زرین پال',
                'description' => 'پرداخت توسط کلیه کارت های عضو شبکه شتاب',
            ],
        ],
    ],
];
