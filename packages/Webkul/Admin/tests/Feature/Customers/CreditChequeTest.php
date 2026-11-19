<?php

use Illuminate\Support\Str;
use Webkul\Customer\Models\Customer;
use Webkul\Customer\Repositories\CreditAccountRepository;
use Webkul\Customer\Repositories\CreditChequeRepository;
use Webkul\Customer\Repositories\PurchaseCreditApplicationRepository;
use Webkul\User\Models\Admin;
use Webkul\User\Models\Role;

use function Pest\Laravel\get;
use function Pest\Laravel\getJson;
use function Pest\Laravel\postJson;
use function Pest\Laravel\putJson;

function chequeCustomer()
{
    return Customer::factory()->create(['phone' => '0912'.random_int(1000000, 9999999), 'status' => 1, 'is_suspended' => 0, 'credit_verified_phone' => null, 'credit_phone_verified_at' => null]);
}
function chequeData($customer, array $overrides = []): array
{
    return array_merge(['customer_id' => $customer->id, 'request_key' => (string) Str::uuid(), 'reference' => 'CHEQUE-'.Str::random(10), 'due_date' => now()->addMonth()->format('Y-m-d'), 'amount_toman' => 50000000, 'company_name' => 'Accounting Company', 'bank_name' => 'Test bank', 'sayad_confirmed' => 1, 'status' => 'received', 'allocate' => 1, 'credit_amount' => 20000000], $overrides);
}

it('allows accounting to grant cheque-backed credit without identity approval or purchase eligibility exactly once', function () {
    $admin = $this->loginAsAdmin();
    $customer = chequeCustomer();
    $data = chequeData($customer);
    postJson(route('admin.customers.cheques.store'), $data)->assertRedirect();
    postJson(route('admin.customers.cheques.store'), $data)->assertRedirect();
    $account = app(CreditAccountRepository::class)->getModel()->newQuery()->where('phone', $customer->phone)->firstOrFail();
    $application = app(PurchaseCreditApplicationRepository::class)->findOneByField('customer_id', $customer->id);
    expect($account->balance_rial)->toBe(200000000)->and($account->customer_id)->toBeNull()
        ->and($application->status)->toBe('active')->and($application->identity_bypassed)->toBeTrue()
        ->and($application->approved_toman)->toBe(20000000);
    $cheque = app(CreditChequeRepository::class)->findOneByField('request_key', $data['request_key']);
    expect($cheque->getRawOriginal('reference'))->not->toBe($data['reference']);
    postJson(route('admin.customers.cheques.allocate', $cheque->id), ['credit_amount' => 20000000])->assertRedirect();
    expect($account->fresh()->balance_rial)->toBe(200000000);
});

it('rejects allocation before Sayad confirmation or cheque receipt and rejects excess amounts', function (array $override) {
    $this->loginAsAdmin();
    $customer = chequeCustomer();
    postJson(route('admin.customers.cheques.store'), chequeData($customer, $override))->assertUnprocessable();
    expect(app(CreditAccountRepository::class)->getModel()->newQuery()->where('phone', $customer->phone)->exists())->toBeFalse();
})->with([[['sayad_confirmed' => 0]], [['status' => 'registered']], [['status' => 'returned']], [['credit_amount' => 60000000]]]);

it('prevents the same physical cheque or Sayad ID from being credited twice with different request keys', function () {
    $this->loginAsAdmin();
    $customer = chequeCustomer();
    $data = chequeData($customer, ['sayad_id' => '1234567890123456']);
    postJson(route('admin.customers.cheques.store'), $data)->assertRedirect();
    postJson(route('admin.customers.cheques.store'), array_merge($data, ['request_key' => (string) Str::uuid()]))->assertUnprocessable();
    $other = chequeCustomer();
    postJson(route('admin.customers.cheques.store'), chequeData($other, ['sayad_id' => '1234567890123456']))->assertUnprocessable();
});

it('searches and filters accounting cheques by customer, company, dates, amount and Sayad confirmation', function () {
    $this->loginAsAdmin();
    $customer = chequeCustomer();
    $data = chequeData($customer, ['allocate' => 0]);
    postJson(route('admin.customers.cheques.store'), $data)->assertRedirect();
    get(route('admin.customers.cheques.index', ['q' => $customer->first_name.' '.$customer->last_name, 'company' => 'Accounting', 'from' => today()->format('Y-m-d'), 'to' => now()->addMonths(2)->format('Y-m-d'), 'min' => 40000000, 'max' => 60000000, 'sayad' => '1']))->assertOk()->assertSeeText($data['reference']);
    get(route('admin.customers.cheques.index', ['sayad' => '0']))->assertOk()->assertDontSeeText($data['reference']);
    get(route('admin.customers.cheques.create'))->assertOk()->assertSee('name="due_date"', false);
    getJson(route('admin.customers.cheques.customers', ['q' => $customer->first_name.' '.$customer->last_name]))->assertOk()->assertJsonFragment(['id' => $customer->id]);
    $export = get(route('admin.customers.cheques.export', ['q' => $customer->phone]))->assertOk();
    expect($export->streamedContent())->toContain('Accounting Company');
});

it('audits accounting status updates while keeping allocated cheque amounts immutable', function () {
    $admin = $this->loginAsAdmin();
    $customer = chequeCustomer();
    $data = chequeData($customer);
    postJson(route('admin.customers.cheques.store'), $data)->assertRedirect();
    $cheque = app(CreditChequeRepository::class)->findOneByField('request_key', $data['request_key']);
    $update = collect($data)->only(['due_date', 'amount_toman', 'company_name', 'bank_name', 'sayad_confirmed', 'status'])->all();
    putJson(route('admin.customers.cheques.update', $cheque->id), array_merge($update, ['amount_toman' => 10000000]))->assertUnprocessable();
    putJson(route('admin.customers.cheques.update', $cheque->id), array_merge($update, ['status' => 'cleared']))->assertRedirect();
    expect($cheque->fresh()->status)->toBe('cleared')->and($cheque->fresh()->history)->toHaveCount(3);
    get(route('admin.customers.cheques.show', $cheque->id))->assertOk()->assertSeeText($data['reference']);
});

it('requires distinct permissions to allocate or export accounting cheques', function () {
    $role = Role::factory()->create(['permission_type' => 'custom', 'permissions' => ['customers.credit_cheques', 'customers.credit_cheques.manage']]);
    $this->loginAsAdmin(Admin::factory()->create(['role_id' => $role->id]));
    $customer = chequeCustomer();
    postJson(route('admin.customers.cheques.store'), chequeData($customer))->assertUnauthorized();
    get(route('admin.customers.cheques.export'))->assertUnauthorized();
});
