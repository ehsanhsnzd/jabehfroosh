<?php

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Webkul\Checkout\Models\Cart;
use Webkul\Checkout\Models\CartAddress;
use Webkul\Core\Models\CoreConfig;
use Webkul\Customer\Helpers\CreditCheckout;
use Webkul\Customer\Helpers\CreditIdentity;
use Webkul\Customer\Helpers\CreditSplitCheckout;
use Webkul\Customer\Helpers\PurchaseCreditEligibility;
use Webkul\Customer\Models\Customer;
use Webkul\Customer\Payment\CustomerCredit;
use Webkul\Customer\Repositories\CreditAccountRepository;
use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Sales\Repositories\OrderRepository;
use Webkul\Sales\Repositories\RefundRepository;
use Webkul\Sales\Transformers\OrderResource;

use function Pest\Laravel\get;
use function Pest\Laravel\postJson;

function creditCustomer(bool $verified = true)
{
    $phone = '0912'.random_int(1000000, 9999999);
    $customer = Customer::factory()->create(['phone' => $phone, 'status' => 1, 'is_suspended' => 0]);
    if ($verified) {
        $customer->forceFill(['credit_verified_phone' => $phone, 'credit_phone_verified_at' => now()])->save();
    }

    return $customer;
}

function creditCheckoutCart($customer)
{
    $product = (new ProductFaker(['attribute_value' => [
        'price' => ['float_value' => 100000],
        'special_price' => ['float_value' => null],
    ]]))->getVirtualProductFactory()->create();
    $cart = Cart::factory()->create(['customer_id' => $customer->id, 'is_guest' => 0, 'customer_email' => $customer->email, 'is_active' => 1]);
    cart()->setCart($cart);
    cart()->addProduct($product, ['product_id' => $product->id, 'quantity' => 2]);
    $cart = cart()->getCart();
    CartAddress::factory()->create(['cart_id' => $cart->id, 'customer_id' => $customer->id, 'country' => 'IR']);
    $cart->refresh();
    cart()->setCart($cart);
    cart()->collectTotals();

    return cart()->getCart();
}

it('claims pre-registration credit only after the phone is verified by OTP', function () {
    Mail::fake();
    $phone = '0912'.random_int(1000000, 9999999);
    $account = app(CreditAccountRepository::class)->open(['phone' => $phone, 'is_active' => true], 5000, (string) Str::uuid(), null);
    $unverified = Customer::factory()->create(['phone' => $phone]);
    expect(app(CreditAccountRepository::class)->forCustomer($unverified))->toBeNull();
    Cache::put('customer-otp:'.$phone, Hash::make('123456'), 120);
    Cache::put('customer-otp:'.$phone.':attempts', 0, 120);
    postJson(route('shop.customer.otp.verify'), ['phone' => $phone, 'code' => '123456'])->assertOk();
    expect($account->fresh()->customer_id)->toBe($unverified->id)
        ->and($account->fresh()->balance_rial)->toBe(50000)
        ->and($unverified->fresh()->credit_verified_phone)->toBe($phone);
});

it('supports first-time registration by OTP and does not transfer claimed credit to another account', function () {
    $phone = '0912'.random_int(1000000, 9999999);
    $account = app(CreditAccountRepository::class)->open(['phone' => $phone], 4000, (string) Str::uuid(), null);
    Cache::put('customer-otp:'.$phone, Hash::make('123456'), 120);
    Cache::put('customer-otp:'.$phone.':attempts', 0, 120);
    postJson(route('shop.customer.otp.verify'), ['phone' => $phone, 'code' => '123456'])->assertOk();
    $customer = auth()->guard('customer')->user();
    expect($account->fresh()->customer_id)->toBe($customer->id);
    $customer->update(['phone' => '0998'.random_int(1000000, 9999999)]);
    expect(app(CreditAccountRepository::class)->forCustomer($customer))->toBeNull();
    $impostor = creditCustomer();
    $impostor->forceFill(['phone' => $phone, 'credit_verified_phone' => $phone])->save();
    expect(app(CreditAccountRepository::class)->forCustomer($impostor))->toBeNull();
});

it('pays the full order exactly once and returns partial and full refunds to credit', function () {
    Mail::fake();
    $customer = creditCustomer();
    $this->loginAsCustomer($customer);
    $accounts = app(CreditAccountRepository::class);
    $account = $accounts->open(['phone' => $customer->phone], 1000000, (string) Str::uuid(), null);
    $cart = creditCheckoutCart($customer);
    postJson(route('shop.checkout.onepage.payment_methods.store'), ['payment' => ['method' => 'customer_credit']])->assertOk();
    $cart = cart()->getCart()->fresh();
    cart()->setCart($cart);
    $data = (new OrderResource($cart))->jsonSerialize();
    postJson(route('shop.checkout.onepage.orders.store'))->assertOk()->assertJsonPath('data.redirect', true);
    $order = app(OrderRepository::class)->findOneByField('cart_id', $cart->id);
    expect($order)->not->toBeNull();
    $charged = CreditIdentity::orderRial($order->base_grand_total, $order->base_currency_code);
    expect($account->fresh()->balance_rial)->toBe(10000000 - $charged)
        ->and($order->invoices()->count())->toBe(1)
        ->and($account->transactions()->where('kind', 'purchase')->count())->toBe(1);
    app(CreditCheckout::class)->place($cart, $data);
    expect($account->fresh()->balance_rial)->toBe(10000000 - $charged);
    $item = $order->items->first();
    $refund = app(RefundRepository::class)->create(['order_id' => $order->id, 'refund' => ['items' => [$item->id => 1], 'adjustment_refund' => 0, 'adjustment_fee' => 0, 'shipping' => 0]]);
    $afterFirst = $account->fresh()->balance_rial;
    expect($afterFirst)->toBeGreaterThan(10000000 - $charged)->toBeLessThan(10000000);
    Event::dispatch('sales.refund.save.after', $refund);
    expect($account->fresh()->balance_rial)->toBe($afterFirst);
    app(RefundRepository::class)->create(['order_id' => $order->id, 'refund' => ['items' => [$item->id => 1], 'adjustment_refund' => 0, 'adjustment_fee' => 0, 'shipping' => 0]]);
    expect($account->fresh()->balance_rial)->toBe(10000000);
    $accounts->returnOrderCredit($order, PHP_INT_MAX, 'extra-cancel', 'cancel');
    expect($account->fresh()->balance_rial)->toBe(10000000);
});

it('rolls back credit, invoices and the order if checkout fails after the debit', function () {
    Mail::fake();
    $customer = creditCustomer();
    $this->loginAsCustomer($customer);
    $account = app(CreditAccountRepository::class)->open(['phone' => $customer->phone], 1000000, (string) Str::uuid(), null);
    $cart = creditCheckoutCart($customer);
    cart()->savePaymentMethod(['method' => 'customer_credit']);
    $cart->refresh();
    Event::listen('checkout.order.save.after', function ($order) {
        if ($order->payment->method === 'customer_credit') {
            throw new RuntimeException('Simulated failure after credit debit');
        }
    });
    expect(fn () => app(CreditCheckout::class)->place($cart, (new OrderResource($cart))->jsonSerialize()))->toThrow(RuntimeException::class);
    expect($account->fresh()->balance_rial)->toBe(10000000)
        ->and($account->transactions()->where('kind', 'purchase')->count())->toBe(0)
        ->and(app(OrderRepository::class)->getModel()->newQuery()->where('cart_id', $cart->id)->count())->toBe(0)
        ->and($cart->fresh()->is_active)->toBe(1);
});

it('rejects unverified, insufficient and frozen credit payments server-side', function () {
    CoreConfig::query()->updateOrCreate(['code' => 'sales.payment_methods.zarinpal.active', 'channel_code' => core()->getCurrentChannel()->code, 'locale_code' => null], ['value' => '0']);
    $customer = creditCustomer(false);
    $this->loginAsCustomer($customer);
    $account = app(CreditAccountRepository::class)->open(['phone' => $customer->phone], 1, (string) Str::uuid(), null);
    creditCheckoutCart($customer);
    expect(app(CustomerCredit::class)->isAvailable())->toBeFalse();
    postJson(route('shop.checkout.onepage.payment_methods.store'), ['payment' => ['method' => 'customer_credit']])->assertForbidden();
    $customer->forceFill(['credit_verified_phone' => $customer->phone, 'credit_phone_verified_at' => now()])->save();
    expect(app(CustomerCredit::class)->isAvailable())->toBeFalse();
    app(CreditAccountRepository::class)->adjust($account->id, 1000000, 'increase', (string) Str::uuid(), 'Enough funds', null, 1);
    expect((bool) app(CustomerCredit::class)->isAvailable())->toBeTrue();
    $account->update(['is_active' => false]);
    expect((bool) app(CustomerCredit::class)->isAvailable())->toBeFalse();
});

it('shows customer credit history without exposing another phone account', function () {
    $customer = creditCustomer();
    $this->loginAsCustomer($customer);
    app(CreditAccountRepository::class)->open(['phone' => $customer->phone], 12345, (string) Str::uuid(), null);
    get(route('shop.customers.account.credit.index'))->assertOk()->assertSeeText('12,345');
    get(route('shop.customers.account.credit.verify'))->assertOk();
});

it('keeps ordinary payment methods independent from customer credit', function () {
    Mail::fake();
    $customer = creditCustomer();
    $this->loginAsCustomer($customer);
    $account = app(CreditAccountRepository::class)->open(['phone' => $customer->phone], 500000, (string) Str::uuid(), null);
    $cart = creditCheckoutCart($customer);
    CoreConfig::query()->updateOrCreate([
        'code' => 'sales.payment_methods.moneytransfer.active',
        'channel_code' => core()->getCurrentChannel()->code,
        'locale_code' => null,
    ], ['value' => '1']);
    postJson(route('shop.checkout.onepage.payment_methods.store'), ['payment' => ['method' => 'moneytransfer']])->assertOk();
    postJson(route('shop.checkout.onepage.orders.store'))->assertOk();
    expect($account->fresh()->balance_rial)->toBe(5000000)
        ->and($account->transactions()->where('kind', 'purchase')->count())->toBe(0);
});

it('verifies the logged-in customer phone without creating a duplicate account for international formatting', function ($prefix) {
    $customer = creditCustomer(false);
    $phone = $customer->phone;
    $customer->update(['phone' => $prefix.substr($phone, 1)]);
    $this->loginAsCustomer($customer);
    $account = app(CreditAccountRepository::class)->open(['phone' => $phone], 1000, (string) Str::uuid(), null);
    Cache::put('customer-otp:'.$phone, Hash::make('123456'), 120);
    Cache::put('customer-otp:'.$phone.':attempts', 0, 120);
    postJson(route('shop.customer.otp.verify'), ['phone' => '09999999999', 'code' => '123456', 'credit_verification' => 1])->assertOk();
    expect(auth()->guard('customer')->id())->toBe($customer->id)
        ->and($account->fresh()->customer_id)->toBe($customer->id);
})->with(['+98', '0098', '98']);

it('requires a valid profile phone before opening credit verification', function ($phone) {
    $customer = Customer::factory()->create(['phone' => $phone]);
    $this->loginAsCustomer($customer);

    get(route('shop.customers.account.credit.verify'))
        ->assertRedirect(route('shop.customers.account.profile.edit'))
        ->assertSessionHas('error', trans('customer::credit.completePhone'));
})->with([null, '123']);

function enableCreditSplitGateway(): void
{
    foreach (['active' => '1', 'sandbox' => '1', 'merchant_id' => '00000000-0000-0000-0000-000000000000'] as $key => $value) {
        CoreConfig::query()->updateOrCreate(['code' => 'sales.payment_methods.zarinpal.'.$key, 'channel_code' => core()->getCurrentChannel()->code, 'locale_code' => null], ['value' => $value]);
    }
    Http::preventStrayRequests();
    Mail::fake();
}

it('reserves partial credit and confirms the order only after the gateway verifies the remainder', function (string $currency) {
    enableCreditSplitGateway();
    $customer = creditCustomer();
    $this->loginAsCustomer($customer);
    $cart = creditCheckoutCart($customer);
    $cart->update(['base_currency_code' => $currency]);
    cart()->setCart($cart->fresh());
    $accounts = app(CreditAccountRepository::class);
    $balance = $currency === 'IRR' ? 10000 : 100000;
    $account = $accounts->open(['phone' => $customer->phone], $balance, (string) Str::uuid(), null);
    Http::fake([
        '*payment/request.json' => Http::response(['data' => ['code' => 100, 'authority' => 'SPLIT-'.$currency]]),
        '*payment/verify.json' => Http::response(['data' => ['code' => 100, 'ref_id' => 'REF-'.$currency]]),
    ]);
    postJson(route('shop.checkout.onepage.payment_methods.store'), ['payment' => ['method' => 'customer_credit']])->assertOk();
    postJson(route('shop.checkout.onepage.orders.store'))->assertOk()->assertJsonPath('data.redirect_url', route('shop.customers.account.credit.payment.redirect'));
    get(route('shop.customers.account.credit.payment.redirect'))->assertRedirect();
    $order = app(OrderRepository::class)->findOneByField('cart_id', $cart->id);
    $split = $order->payment->additional['credit_split'];
    expect($order->status)->toBe('pending')->and($order->invoices()->count())->toBe(0)
        ->and($account->fresh()->balance_rial)->toBe($balance * 10)->and($split['credit_rial'])->toBe($balance * 10)
        ->and($account->transactions()->where('kind', 'purchase')->count())->toBe(0);
    Http::assertSent(fn ($request) => str_ends_with($request->url(), '/payment/request.json')
        && $request['amount'] === (int) round($order->base_grand_total) - intdiv($balance * 10, CreditIdentity::orderRial(1, $currency))
        && $request['currency'] === ($currency === 'IRR' ? 'IRR' : 'IRT'));
    get(route('shop.customers.account.credit.payment.redirect'))->assertRedirect();
    Http::assertSentCount(1);
    $callback = route('shop.customers.account.credit.payment.callback', ['order' => $order->id, 'token' => $split['token'], 'Authority' => $split['authority'], 'Status' => 'OK']);
    get($callback)->assertRedirect(route('shop.checkout.onepage.success'));
    get($callback)->assertRedirect(route('shop.checkout.onepage.success'));
    Http::assertSentCount(2);
    expect($account->fresh()->balance_rial)->toBe(0);
    expect($order->fresh()->status)->toBe('processing')->and($order->invoices()->count())->toBe(1)
        ->and($order->invoices()->first()->state)->toBe('paid')
        ->and($account->fresh()->balance_rial)->toBe(0)
        ->and($cart->fresh()->is_active)->toBe(0)
        ->and($account->transactions()->where('kind', 'purchase')->count())->toBe(1);
    Http::assertSent(fn ($request) => str_ends_with($request->url(), '/payment/verify.json') && $request['amount'] === $split['gateway_amount']);
    expect(app(PurchaseCreditEligibility::class)->orders($customer->id)->whereKey($order->id)->exists())->toBeTrue();
    $accounts->returnOrderCredit($order, PHP_INT_MAX, 'split-refund-'.$order->id, 'refund');
    $accounts->returnOrderCredit($order, PHP_INT_MAX, 'split-refund-'.$order->id, 'refund');
    expect($account->fresh()->balance_rial)->toBe($balance * 10);
})->with(['TMN', 'IRR']);

it('releases reserved credit once on cancellation failed verification or expired unpaid attempts', function (string $failure) {
    enableCreditSplitGateway();
    $customer = creditCustomer();
    $this->loginAsCustomer($customer);
    $account = app(CreditAccountRepository::class)->open(['phone' => $customer->phone], 1, (string) Str::uuid(), null);
    $cart = creditCheckoutCart($customer);
    cart()->savePaymentMethod(['method' => 'customer_credit']);
    Http::fake([
        '*payment/request.json' => Http::response(['data' => ['code' => 100, 'authority' => 'CANCEL-'.$failure]]),
        '*payment/verify.json' => Http::response(['errors' => ['code' => -51]]),
    ]);
    get(route('shop.customers.account.credit.payment.redirect'))->assertRedirect();
    $order = app(OrderRepository::class)->findOneByField('cart_id', $cart->id);
    $split = $order->payment->additional['credit_split'];
    expect($account->fresh()->balance_rial)->toBe(10);
    expect(app(CreditAccountRepository::class)->availableBalance($account->fresh()))->toBe(0);
    if ($failure === 'expired') {
        $this->travel(31)->minutes();
        $this->artisan('credit:expire-payments')->assertSuccessful();
    } else {
        get(route('shop.customers.account.credit.payment.callback', ['order' => $order->id, 'token' => $split['token'], 'Authority' => $split['authority'], 'Status' => $failure === 'cancel' ? 'NOK' : 'OK']))->assertRedirect(route('shop.checkout.onepage.index'));
    }
    app(CreditSplitCheckout::class)->cancel($order->id);
    expect($account->fresh()->balance_rial)->toBe(10)->and($order->fresh()->status)->toBe('canceled')
        ->and($order->invoices()->count())->toBe(0)->and($cart->fresh()->is_active)->toBe(1)
        ->and($account->transactions()->whereIn('kind', ['purchase', 'cancel'])->count())->toBe(0);
})->with(['cancel', 'failed', 'expired']);

it('restores credit if the gateway rejects creating a partial payment', function () {
    enableCreditSplitGateway();
    $customer = creditCustomer();
    $this->loginAsCustomer($customer);
    $account = app(CreditAccountRepository::class)->open(['phone' => $customer->phone], 1, (string) Str::uuid(), null);
    $cart = creditCheckoutCart($customer);
    cart()->savePaymentMethod(['method' => 'customer_credit']);
    Http::fake(['*payment/request.json' => Http::response(['errors' => ['code' => -9]])]);
    get(route('shop.customers.account.credit.payment.redirect'))->assertRedirect(route('shop.checkout.onepage.index'));
    expect($account->fresh()->balance_rial)->toBe(10)
        ->and(app(OrderRepository::class)->findOneByField('cart_id', $cart->id)->status)->toBe('canceled');
});

it('cannot spend reserved credit in another cart and rejects forged callback identities', function () {
    enableCreditSplitGateway();
    $customer = creditCustomer();
    $this->loginAsCustomer($customer);
    $account = app(CreditAccountRepository::class)->open(['phone' => $customer->phone], 1, (string) Str::uuid(), null);
    $cart = creditCheckoutCart($customer);
    cart()->savePaymentMethod(['method' => 'customer_credit']);
    Http::fake(['*payment/request.json' => Http::response(['data' => ['code' => 100, 'authority' => 'SECURITY']])]);
    get(route('shop.customers.account.credit.payment.redirect'))->assertRedirect();
    $order = app(OrderRepository::class)->findOneByField('cart_id', $cart->id);
    $split = $order->payment->additional['credit_split'];
    get(route('shop.customers.account.credit.payment.callback', ['order' => $order->id, 'token' => 'forged', 'Authority' => $split['authority'], 'Status' => 'OK']))->assertForbidden();
    $otherCart = creditCheckoutCart($customer);
    cart()->savePaymentMethod(['method' => 'customer_credit']);
    expect(fn () => app(CreditSplitCheckout::class)->reserve($otherCart))->toThrow(ValidationException::class);
    expect($account->fresh()->balance_rial)->toBe(10);
    expect(app(CreditAccountRepository::class)->availableBalance($account->fresh()))->toBe(0);
    expect(fn () => app(CreditAccountRepository::class)->adjust($account->id, 1, 'decrease', (string) Str::uuid(), 'Reserved funds', null, 1))->toThrow(ValidationException::class);
    $this->loginAsCustomer(creditCustomer());
    get(route('shop.customers.account.credit.payment.callback', ['order' => $order->id, 'token' => $split['token'], 'Authority' => $split['authority'], 'Status' => 'OK']))->assertNotFound();
});

it('keeps ambiguous payments reserved and reconciles a verified payment after expiry without refunding it', function () {
    enableCreditSplitGateway();
    $customer = creditCustomer();
    $this->loginAsCustomer($customer);
    $account = app(CreditAccountRepository::class)->open(['phone' => $customer->phone], 1, (string) Str::uuid(), null);
    $cart = creditCheckoutCart($customer);
    cart()->savePaymentMethod(['method' => 'customer_credit']);
    Http::fake([
        '*payment/request.json' => Http::response(['data' => ['code' => 100, 'authority' => 'AMBIGUOUS']]),
        '*payment/verify.json' => Http::sequence()->push([], 503)->push([], 503)->push(['data' => ['code' => 101, 'ref_id' => 'ALREADY-PAID']]),
    ]);
    get(route('shop.customers.account.credit.payment.redirect'))->assertRedirect();
    $order = app(OrderRepository::class)->findOneByField('cart_id', $cart->id);
    $split = $order->payment->additional['credit_split'];
    get(route('shop.customers.account.credit.payment.callback', ['order' => $order->id, 'token' => $split['token'], 'Authority' => $split['authority'], 'Status' => 'OK']))->assertRedirect(route('shop.checkout.onepage.index'));
    expect($account->fresh()->balance_rial)->toBe(10)->and($order->fresh()->status)->toBe('pending')->and($cart->fresh()->is_active)->toBe(0);
    $this->travel(31)->minutes();
    $this->artisan('credit:expire-payments')->assertSuccessful();
    expect($account->fresh()->balance_rial)->toBe(10)->and($order->fresh()->status)->toBe('pending');
    $this->artisan('credit:expire-payments')->assertSuccessful();
    expect($account->fresh()->balance_rial)->toBe(0);
    expect($order->fresh()->status)->toBe('processing')->and($order->invoices()->count())->toBe(1)
        ->and($account->fresh()->balance_rial)->toBe(0)
        ->and($account->transactions()->where('kind', 'cancel')->count())->toBe(0);
});

it('ignores client supplied split metadata in a fully funded credit checkout', function () {
    Mail::fake();
    $customer = creditCustomer();
    $this->loginAsCustomer($customer);
    $account = app(CreditAccountRepository::class)->open(['phone' => $customer->phone], 1000000, (string) Str::uuid(), null);
    $cart = creditCheckoutCart($customer);
    cart()->savePaymentMethod(['method' => 'customer_credit']);
    $cart = $cart->fresh();
    cart()->setCart($cart);
    $data = (new OrderResource($cart))->jsonSerialize();
    $data['payment']['additional'] = ['credit_split' => ['credit_rial' => 1, 'state' => 'paid']];
    $order = app(CreditCheckout::class)->place($cart, $data);
    expect($account->fresh()->balance_rial)->toBe(10000000 - CreditIdentity::orderRial($order->base_grand_total, $order->base_currency_code))
        ->and($order->payment->additional)->toBeNull();
});
