<?php

namespace Webkul\Zarinpal\Http\Controllers;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Session;
use Webkul\Checkout\Facades\Cart;
use Webkul\Sales\Repositories\OrderRepository;
use Webkul\Sales\Repositories\InvoiceRepository;
use Webkul\Sales\Repositories\OrderItemRepository;
use Webkul\Sales\Repositories\RefundRepository;
use Webkul\Sales\Transformers\OrderResource;
use Webkul\Zarinpal\Models\Zarinpal;
use Webkul\Zarinpal\Repositories\ZarinpalRepository;

class ZarinpalController extends Controller
{

    const PAYMENT_OK = 'OK';

    const REFERER_ID = "02RL0ss";

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
        $this->orderRepository     = $orderRepository;
        $this->invoiceRepository   = $invoiceRepository;
        $this->orderItemRepository = $orderItemRepository;
        $this->refundRepository    = $refundRepository;
        $this->zarinpalRepository  = $zarinpalRepository;
        $this->apiBaseUrl          = $this->configValue('api_base_url');
        $this->sandboxBaseUrl      = $this->configValue('sandbox_base_url');
        $this->active              = (bool) $this->configValue('active');
        $this->isSandboxEnable     = (bool) $this->configValue('sandbox');
        $this->merchantId          = $this->configValue('merchant_id');
        $this->baseUrl             = $this->setBaseUrl();
        $this->requestUrl          = $this->setFullUrl($this->configValue('request_url'));
        $this->verifyUrl           = $this->setFullUrl($this->configValue('verify_url'));
        $this->redirectUrl         = $this->setFullUrl($this->configValue('redirect_url'));
        $this->callbackUrl         = $this->configValue('callback_url') ?: route('zarinpal.payment.callback');

        $this->client = Http::acceptJson()->asJson()->timeout(20);

        $this->_config = request('_config');
    }

    public function redirect()
    {
        if (! $this->active || empty($this->merchantId)) {
            session()->flash('error', trans('zarinpal::app.zarinpal.front.invalid-configuration'));

            return redirect()->route('shop.checkout.cart.index');
        }

        try {
            $code = $this->getTransactionCode();
            if ($code) {
                $url = sprintf($this->redirectUrl . $code);
                return \Redirect::to($url);
            } else {
                session()->flash('error', trans('zarinpal::app.zarinpal.front.failure-get-code', [], 'fa'));
                return redirect()->back();
            }
        } catch (\Exception $e) {
            $error    = explode(PHP_EOL, preg_replace("/[^a-zA-Z0-9\s]/", "", $e->getMessage()));
            $errorMsg = current($error) . '.' . next($error);
            session()->flash('error', trans($errorMsg));
            return redirect()->back();
        }
    }

    private function getTransactionCode(): string|bool
    {
        $cart                        = Cart::getCart();
        $userEmail                   = $cart->shipping_address->email;
        $sendDataForGetAuthorityCode = [
             "merchant_id"  => $this->merchantId,
             "amount"       => $this->getGatewayAmount($cart->base_grand_total),
             "callback_url" => $this->callbackUrl,
             "description"  => self::DESCRIPTION_CONTENT . $userEmail,
             "referer_id"   => self::REFERER_ID,
             "metadata"     => [
                  "mobile" => $cart->shipping_address->phone,
                  "email"  => $cart->shipping_address->email,
             ],
        ];

        $response = $this->client->post($this->requestUrl, $sendDataForGetAuthorityCode);
        $response = json_decode($response->getBody(), true);

        if (
            is_array($response['data'])
            && $response['data']['code'] === 100
            && $response['data']['message'] === "Success"
        ) {
            $this->setHashedCode($sendDataForGetAuthorityCode);
            return $response['data']['authority'];
        }
        return false;
    }

    public function callback()
    {
        $authorityCode = request()->input('Authority');
        $status        = request()->input('Status');
        $securityAlert = [];

        if (
            $authorityCode &&
            $status == self::PAYMENT_OK
        ) {
            $cart              = Cart::getCart();
            $verifyTransaction = $this->verify($authorityCode);
            try {
                if (
                    isset($verifyTransaction['data']['code'])
                    && in_array($verifyTransaction['data']['code'], [100, 101])
                    && in_array($verifyTransaction['data']['message'], ["Verified", "Paid"])
                ) {
                    $findTransaction = Zarinpal::where('transaction_id', $verifyTransaction['data']['ref_id'])->first();
                    if ($findTransaction) {
                        session()->flash('error',
                            trans('zarinpal::app.zarinpal.front.duplicate-transaction', [], 'fa'));
                        $securityAlert['data']['message'] = "Security problem in part 2";
                        $securityAlert['data']['ref_id']  = $verifyTransaction['data']['ref_id'];
                        $securityAlert['data']['email']   = $cart->shipping_address->email;
                        Log::warning('security', $securityAlert);
                        return redirect()->route('shop.checkout.onepage.index');
                    }

                    $data = (new OrderResource($cart))->jsonSerialize();

                    $order = $this->orderRepository->create($data);

                    $params = [
                        'code'           => $verifyTransaction['data']['code'],
                        'message'        => $verifyTransaction['data']['message'],
                        'card_hash'      => $verifyTransaction['data']['card_hash'],
                        'card_pan'       => $verifyTransaction['data']['card_pan'],
                        'transaction_id' => $verifyTransaction['data']['ref_id'],
                        'fee_type'       => $verifyTransaction['data']['fee_type'],
                        'fee'            => $verifyTransaction['data']['fee'],
                        'order_id'       => $order->id,
                        'amount'         => $this->getGatewayAmount($cart->base_grand_total),
                        'status'         => 'success',
                    ];
                    $this->zarinpalRepository->create($params);
                    Cart::deActivateCart();
                    $this->orderRepository->update(['status' => 'processing'], $order->id);
                    if ($order->canInvoice()) {
                        $this->invoiceRepository->create($this->prepareInvoiceData($order));
                    }
                    session()->flash('order_id', $order->id);

                    return redirect()->route('shop.checkout.onepage.success');
                } else {
                    session()->flash('error', trans('zarinpal::app.zarinpal.front.failure-message', [], 'fa'));
                    return redirect()->route('shop.checkout.onepage.index');
                }
            } catch (\Exception $e) {
                Log::warning('security', [$e->getMessage()]);
                session()->flash('error', trans('zarinpal::app.zarinpal.front.failure-message', [], 'fa'));
                return redirect()->route('shop.checkout.onepage.index');
            }

        } else {
            session()->flash('error', trans('zarinpal::app.zarinpal.front.failure-message', [], 'fa'));
            return redirect()->route('shop.checkout.onepage.index');
        }
    }

    protected function verify(string $authorityCode): array
    {
        $cart              = Cart::getCart();

        if(!$cart){
            $response['data']['message']   = "Security problem in part 0";
            $response['data']['authority'] = $authorityCode;
            Log::warning('security', $response);
            return $response;
        }

        $sendDataForVerify = [
            "merchant_id" => $this->merchantId,
            "amount"      => $this->getGatewayAmount($cart->base_grand_total),
            "authority"   => $authorityCode,
        ];

        if (!$this->checkHashedCode($cart)) {
            $response['data']['message']   = "Security problem in part 1";
            $response['data']['authority'] = $authorityCode;
            $response['data']['email']     = $cart->shipping_address->email;
            Log::warning('security', $response);
            return $response;
        }

        $response = $this->client->post($this->verifyUrl, $sendDataForVerify);
        return json_decode($response->getBody(), true);
    }

    protected function setHashedCode(array $sendDataForGetAuthorityCode): void
    {
        session([
            $sendDataForGetAuthorityCode['metadata']['email'] => sha1(
                $sendDataForGetAuthorityCode['amount'] .
                $sendDataForGetAuthorityCode['description'] .
                date('H')
            ),
        ]);
    }

    protected function checkHashedCode($cart): bool
    {
        $userEmail     = $cart->shipping_address->email;
        $description   = self::DESCRIPTION_CONTENT . $userEmail;
        $amount        = $this->getGatewayAmount($cart->base_grand_total);
        $getHashedData = Session::get($userEmail);
        $wanted        = sha1($amount . $description . date('H'));
        //Session::forget($userEmail);
        if ($getHashedData === $wanted) {
            return true;
        } else {
            return false;
        }
    }

    protected function prepareInvoiceData($order): array
    {
        $invoiceData = [
            "order_id" => $order->id,
        ];

        foreach ($order->items as $item) {
            $invoiceData['invoice']['items'][$item->id] = $item->qty_to_invoice;
        }

        return $invoiceData;
    }

    protected function setBaseUrl(): string
    {
        if ($this->isSandboxEnable) {
            $this->baseUrl = $this->sandboxBaseUrl;
        } else {
            $this->baseUrl = $this->apiBaseUrl;
        }
        return $this->baseUrl;
    }

    protected function setFullUrl(string $url): string
    {
        return trim($this->baseUrl, '/ ') . '/' . trim($url, '/ ');
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
