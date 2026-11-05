<?php

use Illuminate\Support\Facades\Mail;
use Illuminate\Validation\ValidationException;
use Webkul\Checkout\Models\Cart;
use Webkul\Customer\Models\Customer;
use Webkul\Faker\Helpers\Product as ProductFaker;
use Webkul\Shop\Helpers\IranAddress;
use Webkul\Shop\Http\Requests\CartAddressRequest;

use function Pest\Laravel\postJson;
use function Pest\Laravel\putJson;

function iranCheckoutAddress(): array
{
    return [
        'first_name' => 'علی', 'last_name' => 'رضایی',
        'address' => ['خیابان آزادی پلاک ۱۲'],
        'state' => 'آذربایجان شرقی', 'city' => 'تبریز',
        'postcode' => '5136812345', 'use_for_shipping' => true,
    ];
}

it('ships a local dataset covering all provinces with their own cities', function () {
    expect(IranAddress::provinces())->toHaveCount(31)
        ->and(array_sum(array_map(fn ($province) => count($province['cities']), IranAddress::provinces())))->toBeGreaterThan(1400)
        ->and(IranAddress::cities('آذربایجان شرقی'))->toContain('تبریز')
        ->and(IranAddress::cities('اردبیل'))->toContain('اردبیل')
        ->and(IranAddress::cities('تهران'))->toContain('تهران')
        ->and(IranAddress::cities('اردبیل'))->not->toContain('تبریز');
});

it('saves checkout without company tax email and phone fields and uses customer contact details', function () {
    Mail::fake();
    $customer = Customer::factory()->create(['phone' => '09123456789']);
    $this->loginAsCustomer($customer);
    $product = (new ProductFaker)->getVirtualProductFactory()->create();
    $cart = Cart::factory()->create(['customer_id' => $customer->id, 'is_guest' => 0, 'is_active' => 1]);
    cart()->setCart($cart);
    cart()->addProduct($product, ['product_id' => $product->id, 'quantity' => 1]);

    postJson(route('shop.checkout.onepage.addresses.store'), ['billing' => iranCheckoutAddress()])->assertOk();

    $billing = cart()->getCart()->billing_address;
    expect($billing->country)->toBe('IR')
        ->and($billing->state)->toBe('آذربایجان شرقی')
        ->and($billing->city)->toBe('تبریز')
        ->and($billing->email)->toBe($customer->email)
        ->and($billing->phone)->toBe($customer->phone)
        ->and($billing->company_name)->toBeNull()
        ->and($billing->vat_id)->toBeNull();
});

it('accepts guest addresses without contact fields and defaults the country to Iran', function () {
    $request = CartAddressRequest::create('/', 'POST', ['billing' => iranCheckoutAddress()]);
    $request->setContainer(app())->setRedirector(app('redirect'));
    $request->validateResolved();

    expect($request->validated('billing.country'))->toBe('IR')
        ->and($request->validated('billing.email'))->toBeNull()
        ->and($request->validated('billing.phone'))->toBeNull();
});

it('creates and edits a saved checkout address without contact fields', function ($hasContactDetails) {
    $customer = Customer::factory()->create([
        'phone' => $hasContactDetails ? '09123456789' : null,
        ...($hasContactDetails ? [] : ['email' => null]),
    ]);
    $this->loginAsCustomer($customer);

    $created = postJson(route('shop.api.customers.account.addresses.store'), iranCheckoutAddress())
        ->assertOk()->json('data');

    expect($created['email'])->toBe($customer->email)
        ->and($created['phone'])->toBe($customer->phone)
        ->and($created['country'])->toBe('IR');

    $updated = putJson(route('shop.api.customers.account.addresses.update', ['id' => $created['id']]), [
        ...iranCheckoutAddress(),
        'id' => $created['id'],
        'address' => ['خیابان جدید پلاک ۳'],
    ])->assertOk()->json('data');

    expect($updated['address'])->toBe(['خیابان جدید پلاک ۳'])
        ->and($updated['email'])->toBe($customer->email)
        ->and($updated['phone'])->toBe($customer->phone);
})->with([true, false]);

it('rejects cities from another province and malformed province input', function ($state, $city) {
    $address = array_replace(iranCheckoutAddress(), ['state' => $state, 'city' => $city]);
    $request = CartAddressRequest::create('/', 'POST', ['billing' => $address]);
    $request->setContainer(app())->setRedirector(app('redirect'));

    expect(fn () => $request->validateResolved())->toThrow(ValidationException::class);
})->with([
    ['اردبیل', 'تبریز'],
    ['استان نامعتبر', 'تبریز'],
    [['اردبیل'], 'تبریز'],
]);
