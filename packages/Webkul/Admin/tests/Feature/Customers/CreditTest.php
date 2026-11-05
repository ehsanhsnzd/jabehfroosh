<?php

use Illuminate\Support\Str;
use Webkul\Customer\Helpers\CreditIdentity;
use Webkul\Customer\Repositories\CreditAccountRepository;
use Webkul\User\Models\Admin;
use Webkul\User\Models\Role;

use function Pest\Laravel\get;
use function Pest\Laravel\post;
use function Pest\Laravel\postJson;
use function Pest\Laravel\put;

function creditAdminProfile(array $overrides = []): array
{
    return array_merge(['phone' => '0912'.random_int(1000000, 9999999), 'holder_name' => 'Credit Test', 'opening_amount' => '1000', 'is_active' => 1, 'request_key' => (string) Str::uuid()], $overrides);
}

it('creates credit for an unregistered phone and audits increases and decreases exactly once', function () {
    $admin = $this->loginAsAdmin();
    $data = creditAdminProfile(['phone' => '+98 912 '.random_int(1000000, 9999999)]);
    post(route('admin.customers.credit.store'), $data)->assertRedirect();
    $account = app(CreditAccountRepository::class)->findOneByField('phone', CreditIdentity::phone($data['phone']));
    expect($account->balance_rial)->toBe(10000)->and($account->customer_id)->toBeNull();
    post(route('admin.customers.credit.store'), $data)->assertRedirect();
    expect($account->fresh()->balance_rial)->toBe(10000);

    $change = ['direction' => 'increase', 'amount' => '۲٬۰۰۰', 'reason' => 'Manual test credit', 'reference' => 'REF-100', 'request_key' => (string) Str::uuid()];
    post(route('admin.customers.credit.adjust', $account->id), $change)->assertRedirect();
    post(route('admin.customers.credit.adjust', $account->id), $change)->assertRedirect();
    expect($account->fresh()->balance_rial)->toBe(30000);
    $change = ['direction' => 'decrease', 'amount' => 500, 'reason' => 'Correction test', 'request_key' => (string) Str::uuid()];
    post(route('admin.customers.credit.adjust', $account->id), $change)->assertRedirect();
    expect($account->fresh()->balance_rial)->toBe(25000)
        ->and($account->transactions()->sum('amount_rial'))->toBe('25000')
        ->and($account->transactions()->where('admin_id', $admin->id)->count())->toBe(3);
});

it('rejects overdrafts, invalid amounts and reused keys for different operations', function () {
    $admin = $this->loginAsAdmin();
    $account = app(CreditAccountRepository::class)->open(creditAdminProfile(), 1000, (string) Str::uuid(), $admin->id);
    $key = (string) Str::uuid();
    $data = ['direction' => 'decrease', 'amount' => 1001, 'reason' => 'Too much debit', 'request_key' => $key];
    postJson(route('admin.customers.credit.adjust', $account->id), $data)->assertUnprocessable()->assertJsonValidationErrorFor('credit');
    expect($account->fresh()->balance_rial)->toBe(10000);
    $data['amount'] = -1;
    postJson(route('admin.customers.credit.adjust', $account->id), $data)->assertUnprocessable()->assertJsonValidationErrorFor('amount');
    $data['amount'] = 500;
    postJson(route('admin.customers.credit.adjust', $account->id), $data)->assertRedirect();
    $data['amount'] = 400;
    postJson(route('admin.customers.credit.adjust', $account->id), $data)->assertUnprocessable()->assertJsonValidationErrorFor('credit');
    expect($account->fresh()->balance_rial)->toBe(5000);
});

it('validates and encrypts IBANs and prevents direct balance or phone editing', function () {
    $admin = $this->loginAsAdmin();
    $data = creditAdminProfile(['iban' => 'IR820540102680020817909002']);
    expect(CreditIdentity::validIban($data['iban']))->toBeTrue();
    post(route('admin.customers.credit.store'), $data)->assertRedirect();
    $account = app(CreditAccountRepository::class)->findOneByField('phone', $data['phone']);
    expect($account->iban)->toBe($data['iban'])->and($account->getRawOriginal('iban'))->not->toBe($data['iban']);
    put(route('admin.customers.credit.update', $account->id), ['holder_name' => 'Edited', 'iban' => $data['iban'], 'is_active' => 0, 'balance_rial' => 999999, 'phone' => '09999999999'])->assertRedirect();
    $account->refresh();
    expect($account->balance_rial)->toBe(10000)->and($account->phone)->toBe($data['phone'])->and($account->is_active)->toBeFalse();
    $data['iban'] = 'IR000000000000000000000000';
    postJson(route('admin.customers.credit.store'), $data)->assertUnprocessable()->assertJsonValidationErrorFor('iban');
});

it('shows searchable accounts and reports and exports spreadsheet-safe ledger records', function () {
    $admin = $this->loginAsAdmin();
    $account = app(CreditAccountRepository::class)->open(creditAdminProfile(), 1000, (string) Str::uuid(), $admin->id);
    app(CreditAccountRepository::class)->adjust($account->id, 20, 'increase', (string) Str::uuid(), '=HYPERLINK("https://example.com")', 'REPORT-TEST', $admin->id);
    get(route('admin.customers.credit.index', ['q' => $account->phone]))->assertOk()->assertSeeText($account->phone);
    get(route('admin.customers.credit.show', $account->id))->assertOk()->assertSeeText('REPORT-TEST');
    get(route('admin.customers.credit.report', ['account' => $account->id]))->assertOk()->assertSeeText('REPORT-TEST');
    $export = get(route('admin.customers.credit.export', ['account' => $account->id]))->assertOk();
    expect($export->streamedContent())->toContain("'=HYPERLINK");
});

it('requires admin authorization for credit operations', function () {
    get(route('admin.customers.credit.index'))->assertRedirect();
    $role = Role::factory()->create(['permission_type' => 'custom', 'permissions' => ['dashboard']]);
    $this->loginAsAdmin(Admin::factory()->create(['role_id' => $role->id]));
    postJson(route('admin.customers.credit.store'), creditAdminProfile())->assertUnauthorized();
});
