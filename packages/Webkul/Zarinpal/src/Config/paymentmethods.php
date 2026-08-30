<?php

return [
    'zarinpal' => [
        'code'        => 'zarinpal',
        'title'       => 'پرداخت امن زرین پال',
        'description' => 'پرداخت توسط کلیه کارتهای عضو شبکه شتاب با پرداخت امن زرین پال',
        'class'       => 'Webkul\Zarinpal\Payment\ZarinpalPayment',
        'merchant_id' => '',
        'api_base_url' => 'https://payment.zarinpal.com',
        'sandbox_base_url' => 'https://sandbox.zarinpal.com',
        'request_url' => 'pg/v4/payment/request.json',
        'verify_url' => 'pg/v4/payment/verify.json',
        'redirect_url' => 'pg/StartPay/',
        'callback_url' => '',
        'sandbox'     => false,
        'active'      => false,
        'sort'        => 1,
    ],
];
