<?php

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Webkul\Checkout\Models\Cart;
use Webkul\Checkout\Models\CartAddress;
use Webkul\Core\Models\CoreConfig;
use Webkul\Customer\Helpers\CreditCheckout;
use Webkul\Customer\Helpers\CreditIdentity;
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

it('verifies the logged-in customer phone without creating a duplicate account for international formatting', function () {
    $customer = creditCustomer(false);
    $phone = $customer->phone;
    $customer->update(['phone' => '+98'.substr($phone, 1)]);
    $this->loginAsCustomer($customer);
    $account = app(CreditAccountRepository::class)->open(['phone' => $phone], 1000, (string) Str::uuid(), null);
    Cache::put('customer-otp:'.$phone, Hash::make('123456'), 120);
    Cache::put('customer-otp:'.$phone.':attempts', 0, 120);
    postJson(route('shop.customer.otp.verify'), ['phone' => '09999999999', 'code' => '123456', 'credit_verification' => 1])->assertOk();
    expect(auth()->guard('customer')->id())->toBe($customer->id)
        ->and($account->fresh()->customer_id)->toBe($customer->id);
});
