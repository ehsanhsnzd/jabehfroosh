<?php

namespace Webkul\Zarinpal\Http\Controllers;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Session;
use Webkul\Checkout\Facades\Cart;
use Webkul\Sales\Repositories\InvoiceRepository;
use Webkul\Sales\Repositories\OrderItemRepository;
use Webkul\Sales\Repositories\OrderRepository;
use Webkul\Sales\Repositories\RefundRepository;
use Webkul\Sales\Transformers\OrderResource;
use Webkul\Zarinpal\Models\Zarinpal;
use Webkul\Zarinpal\Repositories\ZarinpalRepository;

class ZarinpalController extends Controller
{
    const PAYMENT_OK = 'OK';

    const DESCRIPTION_CONTENT = 'User-';

    protected $_config;

    protected $orderRepository;

    protected $invoiceRepository;

    protected $orderItemRepository;

    protected $refundRepository;

    protected $zarinpalRepository;

    protected $client;

    protected $merchantId = null;

    protected $apiBaseUrl = null;

    protected $requestUrl = null;

    protected $sandboxBaseUrl = null;

    protected $redirectUrl = null;

    protected $callbackUrl = null;

    protected $verifyUrl = null;

    protected $active = false;

    protected $isSandboxEnable = false;

    protected $baseUrl = null;

    public function __construct(
        OrderRepository $orderRepository,
        InvoiceRepository $invoiceRepository,
        OrderItemRepository $orderItemRepository,
        RefundRepository $refundRepository,
        ZarinpalRepository $zarinpalRepository
    ) {
        $this->orderRepository = $orderRepository;
        $this->invoiceRepository = $invoiceRepository;
        $this->orderItemRepository = $orderItemRepository;
        $this->refundRepository = $refundRepository;
        $this->zarinpalRepository = $zarinpalRepository;
        $this->apiBaseUrl = $this->configValue('api_base_url') ?: 'https://payment.zarinpal.com';
        $this->sandboxBaseUrl = $this->configValue('sandbox_base_url') ?: 'https://sandbox.zarinpal.com';
        $this->active = (bool) $this->configValue('active');
        $this->isSandboxEnable = (bool) $this->configValue('sandbox');
        $this->merchantId = trim((string) $this->configValue('merchant_id'));
        $this->baseUrl = $this->setBaseUrl();
        $this->requestUrl = $this->setFullUrl($this->configValue('request_url') ?: 'pg/v4/payment/request.json');
        $this->verifyUrl = $this->setFullUrl($this->configValue('verify_url') ?: 'pg/v4/payment/verify.json');
        $this->redirectUrl = $this->setFullUrl($this->configValue('redirect_url') ?: 'pg/StartPay/');
        $this->callbackUrl = $this->configValue('callback_url') ?: route('zarinpal.payment.callback');

        $client = Http::acceptJson()->asJson()->timeout(25);
        if (app()->isLocal() || $this->isSandboxEnable) {
            $client = $client->withoutVerifying();
        }
        $this->client = $client;

        $this->_config = request('_config');
    }

    public function redirect()
    {
        if (! $this->active) {
            session()->flash('error', trans('zarinpal::app.zarinpal.front.invalid-configuration'));

            return redirect()->route('shop.checkout.cart.index');
        }

        if (! $this->isSandboxEnable && empty($this->merchantId)) {
            session()->flash('error', trans('zarinpal::app.zarinpal.front.invalid-configuration'));

            return redirect()->route('shop.checkout.cart.index');
        }

        try {
            $code = $this->getTransactionCode();

            if ($code) {
                // Ensure there is always a slash between StartPay and the authority code
                $url = rtrim($this->redirectUrl, '/').'/'.ltrim($code, '/');

                return redirect()->to($url);
            }

            $errorMessage = session('zarinpal_error') ?: trans('zarinpal::app.zarinpal.front.failure-get-code', [], 'fa');
            session()->flash('error', $errorMessage);

            return redirect()->route('shop.checkout.onepage.index');
        } catch (\Exception $e) {
            Log::error('Zarinpal redirect exception: '.$e->getMessage(), [
                'exception' => $e,
            ]);

            session()->flash('error', $e->getMessage() ?: trans('zarinpal::app.zarinpal.front.failure-get-code', [], 'fa'));

            return redirect()->route('shop.checkout.onepage.index');
        }
    }

    private function getTransactionCode(): string|bool
    {
        $cart = Cart::getCart();

        if (! $cart) {
            session()->flash('zarinpal_error', 'سبد خرید یافت نشد.');

            return false;
        }

        $shippingAddress = $cart->shipping_address ?: $cart->billing_address;
        $userEmail = $shippingAddress?->email ?: ($cart->customer_email ?: null);
        $userPhone = $shippingAddress?->phone;

        // Currency handling (IRR vs IRT)
        $cartCurrency = strtoupper($cart->base_currency_code ?? core()->getBaseCurrencyCode() ?? 'IRR');
        $currency = in_array($cartCurrency, ['IRT', 'TOMAN']) ? 'IRT' : 'IRR';
        $amount = $this->getGatewayAmount($cart->base_grand_total);

        // Merchant ID handling
        $merchantId = $this->merchantId;
        if ($this->isSandboxEnable && empty($merchantId)) {
            $merchantId = '00000000-0000-0000-0000-000000000000';
        }

        $description = mb_substr('خرید سفارش #'.$cart->id.($userEmail ? ' ('.$userEmail.')' : ''), 0, 250);

        $metadata = array_filter([
            'mobile' => $userPhone,
            'email' => $userEmail,
            'order_id' => (string) $cart->id,
        ]);

        $sendDataForGetAuthorityCode = [
            'merchant_id' => $merchantId,
            'amount' => $amount,
            'currency' => $currency,
            'callback_url' => $this->callbackUrl,
            'description' => $description,
            'metadata' => (object) $metadata,
        ];

        try {
            $response = $this->client->post($this->requestUrl, $sendDataForGetAuthorityCode);
            dd($response->json());
            $result = $response->json();
        } catch (\Exception $e) {
            Log::error('Zarinpal API connection failed', [
                'url' => $this->requestUrl,
                'error' => $e->getMessage(),
                'exception' => $e,
            ]);

            session()->flash('zarinpal_error', 'خطا در ارتباط با زرین‌پال: '.$e->getMessage());

            return false;
        }

        if (! is_array($result)) {
            Log::error('Zarinpal API returned non-JSON response', [
                'url' => $this->requestUrl,
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            session()->flash('zarinpal_error', 'پاسخ دریافتی از درگاه زرین‌پال معتبر نیست (کد وضعیت '.$response->status().').');

            return false;
        }

        // Official Zarinpal v4 success condition
        if (
            isset($result['data'])
            && is_array($result['data'])
            && isset($result['data']['code'])
            && (int) $result['data']['code'] === 100
            && ! empty($result['data']['authority'])
        ) {
            $authority = $result['data']['authority'];
            $this->setHashedCode($sendDataForGetAuthorityCode, $authority);

            return $authority;
        }

        // Error handling
        $errorCode = $result['errors']['code'] ?? null;
        $errorMessage = $result['errors']['message'] ?? null;
        $validations = $result['errors']['validations'] ?? [];

        Log::error('Zarinpal payment request rejected', [
            'url' => $this->requestUrl,
            'request' => $sendDataForGetAuthorityCode,
            'response' => $result,
            'error_code' => $errorCode,
            'error_msg' => $errorMessage,
            'validations' => $validations,
        ]);

        $friendlyMessage = $this->getFriendlyErrorMessage($errorCode, $errorMessage, $validations);
        session()->flash('zarinpal_error', $friendlyMessage);

        return false;
    }

    public function callback()
    {
        $authorityCode = request()->input('Authority');
        $status = request()->input('Status');

        if (! $authorityCode || $status !== self::PAYMENT_OK) {
            Log::info('Zarinpal callback canceled or not OK', [
                'authority' => $authorityCode,
                'status' => $status,
            ]);

            session()->flash('error', trans('zarinpal::app.zarinpal.front.failure-message', [], 'fa'));

            return redirect()->route('shop.checkout.onepage.index');
        }

        $cart = Cart::getCart();
        if (! $cart) {
            Log::warning('Zarinpal callback: cart not found in session', [
                'authority' => $authorityCode,
            ]);

            session()->flash('error', 'سبد خرید یافت نشد.');

            return redirect()->route('shop.checkout.cart.index');
        }

        $verifyTransaction = $this->verify($authorityCode);

        try {
            $verifyCode = $verifyTransaction['data']['code'] ?? null;
            $refId = $verifyTransaction['data']['ref_id'] ?? null;

            if (in_array((int) $verifyCode, [100, 101])) {
                if ($refId) {
                    $findTransaction = Zarinpal::where('transaction_id', (string) $refId)->first();
                    if ($findTransaction) {
                        session()->flash('error', trans('zarinpal::app.zarinpal.front.duplicate-transaction', [], 'fa'));
                        Log::warning('Zarinpal callback: duplicate transaction ref_id', ['ref_id' => $refId]);

                        return redirect()->route('shop.checkout.onepage.index');
                    }
                }

                $data = (new OrderResource($cart))->jsonSerialize();

                $order = $this->orderRepository->create($data);

                $params = [
                    'code' => (int) $verifyCode,
                    'message' => $verifyTransaction['data']['message'] ?? 'Verified',
                    'card_hash' => $verifyTransaction['data']['card_hash'] ?? '',
                    'card_pan' => $verifyTransaction['data']['card_pan'] ?? '',
                    'transaction_id' => (string) ($refId ?? $authorityCode),
                    'fee_type' => $verifyTransaction['data']['fee_type'] ?? 'Merchant',
                    'fee' => (int) ($verifyTransaction['data']['fee'] ?? 0),
                    'order_id' => $order->id,
                    'amount' => $this->getGatewayAmount($cart->base_grand_total),
                    'status' => 'success',
                ];

                $this->zarinpalRepository->create($params);
                Cart::deActivateCart();
                $this->orderRepository->update(['status' => 'processing'], $order->id);

                if ($order->canInvoice()) {
                    $this->invoiceRepository->create($this->prepareInvoiceData($order));
                }

                session()->flash('order_id', $order->id);

                return redirect()->route('shop.checkout.onepage.success');
            }

            $errCode = $verifyTransaction['errors']['code'] ?? null;
            $errMsg = $verifyTransaction['errors']['message'] ?? null;
            $friendly = $this->getFriendlyErrorMessage($errCode, $errMsg);

            Log::error('Zarinpal verify returned failure', [
                'authority' => $authorityCode,
                'response' => $verifyTransaction,
            ]);

            session()->flash('error', $friendly ?: trans('zarinpal::app.zarinpal.front.failure-message', [], 'fa'));

            return redirect()->route('shop.checkout.onepage.index');
        } catch (\Exception $e) {
            Log::error('Zarinpal callback processing exception', [
                'message' => $e->getMessage(),
                'exception' => $e,
            ]);

            session()->flash('error', trans('zarinpal::app.zarinpal.front.failure-message', [], 'fa'));

            return redirect()->route('shop.checkout.onepage.index');
        }
    }

    protected function verify(string $authorityCode): array
    {
        $cart = Cart::getCart();

        if (! $cart) {
            Log::warning('Zarinpal verify: Cart not found for authority '.$authorityCode);

            return [
                'errors' => [
                    'code' => -1,
                    'message' => 'سبد خرید یافت نشد',
                ],
            ];
        }

        $merchantId = $this->merchantId;
        if ($this->isSandboxEnable && empty($merchantId)) {
            $merchantId = '00000000-0000-0000-0000-000000000000';
        }

        $sendDataForVerify = [
            'merchant_id' => $merchantId,
            'amount' => $this->getGatewayAmount($cart->base_grand_total),
            'authority' => $authorityCode,
        ];

        if (! $this->checkHashedCode($cart, $authorityCode)) {
            Log::warning('Zarinpal verify: security check hash warning', [
                'authority' => $authorityCode,
                'cart_id' => $cart->id,
            ]);
        }

        try {
            $response = $this->client->post($this->verifyUrl, $sendDataForVerify);
            $result = $response->json();
        } catch (\Exception $e) {
            Log::error('Zarinpal verify connection failed', [
                'url' => $this->verifyUrl,
                'exception' => $e->getMessage(),
            ]);

            return [
                'errors' => [
                    'code' => -52,
                    'message' => 'خطا در ارتباط با سرور تایید پرداخت: '.$e->getMessage(),
                ],
            ];
        }

        return is_array($result) ? $result : [];
    }

    protected function getFriendlyErrorMessage(?int $code, ?string $rawMessage, array $validations = []): string
    {
        $messages = [
            -9 => 'خطای اعتبارسنجی مقادیر (کد ۹-): مقادیر ارسالی به درگاه پرداخت معتبر نیستند.',
            -10 => 'ترمینال یا آی‌پی نامعتبر است (کد ۱۰-): شناسه پذیرنده (Merchant ID) یا آی‌پی درگاه در زرین‌پال تأیید نشد.',
            -11 => 'ترمینال غیرفعال است (کد ۱۱-): درگاه پرداخت در زرین‌پال فعال نشده است.',
            -12 => 'تلاش بیش از حد مجاز (کد ۱۲-): تعداد درخواست‌ها بیش از حد مجاز است. لطفاً کمی بعد دوباره تلاش فرمایید.',
            -14 => 'عدم تطابق دامنه (کد ۱۴-): دامنه آدرس بازگشت (Callback URL) با دامنه ثبت‌شده در پنل زرین‌پال برای این کد پذیرنده مطابقت ندارد. در صورت آزمایش روی لوکال‌هاست، گزینه «محیط آزمایشی (سندباکس)» را فعال کنید یا از آدرس دامنه‌ی ثبت‌شده استفاده نمایید.',
            -15 => 'ترمینال توسط شاپرک تعلیق شده است (کد ۱۵-).',
            -16 => 'سطح تایید پذیرنده پایین‌تر از سطح نقره‌ای است (کد ۱۶-).',
            -30 => 'پذیرنده اجازه دسترسی به تسویه اشتراکی شناور را ندارد (کد ۳۰-).',
            -31 => 'حساب بانکی تسویه به پذیرنده متصل نیست (کد ۳۱-).',
            -40 => 'پارامترهای اضافی نامعتبر هستند (کد ۴۰-).',
            -50 => 'مبلغ پرداخت‌شده با مقدار تایید مغایرت دارد (کد ۵۰-).',
            -51 => 'تراکنش ناموفق بود (کد ۵۱-): پرداخت لغو شد یا در بانک انجام نشد.',
            -52 => 'خطای غیرمنتظره در زرین‌پال رخ داده است (کد ۵۲-).',
            -53 => 'شناسه پرداخت (Authority) برای این مرچنت‌کد نیست (کد ۵۳-).',
            -54 => 'شناسه پرداخت (Authority) منقضی شده است (کد ۵۴-).',
        ];

        $message = $messages[$code] ?? ($rawMessage ?: 'خطای نامشخص در ارتباط با زرین‌پال');

        if (! empty($validations)) {
            $validationDetails = [];
            foreach ($validations as $field => $errs) {
                if (is_array($errs)) {
                    $validationDetails[] = implode(', ', $errs);
                } elseif (is_string($errs)) {
                    $validationDetails[] = $errs;
                }
            }
            if (! empty($validationDetails)) {
                $message .= ' ('.implode(' | ', $validationDetails).')';
            }
        }

        return $message;
    }

    protected function setHashedCode(array $sendDataForGetAuthorityCode, ?string $authority = null): void
    {
        $cart = Cart::getCart();
        $userEmail = $cart?->shipping_address?->email ?? $cart?->billing_address?->email ?? $cart?->customer_email;

        if ($authority) {
            session([
                'zarinpal_payment_'.$authority => [
                    'cart_id' => $cart?->id,
                    'amount' => $sendDataForGetAuthorityCode['amount'],
                    'timestamp' => time(),
                ],
            ]);
        }

        if ($userEmail) {
            session([
                $userEmail => sha1(
                    $sendDataForGetAuthorityCode['amount'].
                    $sendDataForGetAuthorityCode['description'].
                    date('H')
                ),
            ]);
        }
    }

    protected function checkHashedCode($cart, ?string $authority = null): bool
    {
        if ($authority && session()->has('zarinpal_payment_'.$authority)) {
            $data = session('zarinpal_payment_'.$authority);
            if ($data['cart_id'] == $cart->id && (int) $data['amount'] === $this->getGatewayAmount($cart->base_grand_total)) {
                return true;
            }
        }

        $userEmail = $cart->shipping_address?->email ?? $cart->billing_address?->email ?? $cart->customer_email;
        if (! $userEmail) {
            return true;
        }

        $description = mb_substr('خرید سفارش #'.$cart->id.($userEmail ? ' ('.$userEmail.')' : ''), 0, 250);
        $amount = $this->getGatewayAmount($cart->base_grand_total);
        $getHashed = Session::get($userEmail);

        if (! $getHashed) {
            return true;
        }

        $validHashes = [
            sha1($amount.$description.date('H')),
            sha1($amount.$description.date('H', strtotime('-1 hour'))),
            sha1($amount.self::DESCRIPTION_CONTENT.$userEmail.date('H')),
            sha1($amount.self::DESCRIPTION_CONTENT.$userEmail.date('H', strtotime('-1 hour'))),
        ];

        return in_array($getHashed, $validHashes, true);
    }

    protected function prepareInvoiceData($order): array
    {
        $invoiceData = [
            'order_id' => $order->id,
        ];

        foreach ($order->items as $item) {
            $invoiceData['invoice']['items'][$item->id] = $item->qty_to_invoice;
        }

        return $invoiceData;
    }

    protected function setBaseUrl(): string
    {
        if ($this->isSandboxEnable) {
            $this->baseUrl = $this->sandboxBaseUrl ?: 'https://sandbox.zarinpal.com';
        } else {
            $this->baseUrl = $this->apiBaseUrl ?: 'https://payment.zarinpal.com';
        }

        return rtrim($this->baseUrl, '/');
    }

    protected function setFullUrl(string $url): string
    {
        if (str_starts_with($url, 'http://') || str_starts_with($url, 'https://')) {
            return $url;
        }

        return rtrim($this->baseUrl, '/').'/'.ltrim($url, '/');
    }

    protected function configValue(string $key): mixed
    {
        $value = core()->getConfigData("sales.payment_methods.zarinpal.{$key}");

        return filled($value) || in_array($value, [0, false], true)
            ? $value
            : config("payment_methods.zarinpal.{$key}");
    }

    protected function getGatewayAmount(float|int|string $amount): int
    {
        return (int) round((float) $amount);
    }
}
