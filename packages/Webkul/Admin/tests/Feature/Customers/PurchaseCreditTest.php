<?php

use App\Services\CustomerOtpSms;
use Carbon\Carbon;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Bus;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;
use Webkul\Core\Models\CoreConfig;
use Webkul\Customer\Helpers\CreditIdentity;
use Webkul\Customer\Helpers\PurchaseCreditEligibility;
use Webkul\Customer\Helpers\PurchaseCreditSettings;
use Webkul\Customer\Helpers\PurchaseCreditWorkflow;
use Webkul\Customer\Jobs\SendPurchaseCreditNotice;
use Webkul\Customer\Models\Customer;
use Webkul\Customer\Repositories\CreditAccountRepository;
use Webkul\Customer\Repositories\CreditChequeRepository;
use Webkul\Customer\Repositories\PurchaseCreditApplicationRepository;
use Webkul\Customer\Repositories\PurchaseCreditNoticeRepository;
use Webkul\Sales\Models\Invoice;
use Webkul\Sales\Models\Order;
use Webkul\Sales\Models\OrderPayment;
use Webkul\Sales\Models\Refund;
use Webkul\Theme\Themes;
use Webkul\User\Models\Admin;
use Webkul\User\Models\Role;

use function Pest\Laravel\get;
use function Pest\Laravel\post;
use function Pest\Laravel\postJson;

function purchaseCreditSettings(array $values = []): void
{
    foreach (array_merge(PurchaseCreditSettings::defaults(), ['enabled' => true, 'marketing_enabled' => true], $values) as $key => $value) {
        CoreConfig::updateOrCreate(['code' => 'customer.purchase_credit.'.$key, 'channel_code' => null, 'locale_code' => null], ['value' => is_bool($value) ? (int) $value : $value]);
    }
}

function purchaseCreditCustomer()
{
    $phone = '0912'.random_int(1000000, 9999999);

    return Customer::factory()->create(['phone' => $phone, 'status' => 1, 'is_suspended' => 0, 'credit_verified_phone' => $phone, 'credit_phone_verified_at' => now()]);
}

function purchaseCreditOrder($customer, int $toman = 50000000, $date = null, string $method = 'moneytransfer', string $status = 'completed')
{
    $order = Order::factory()->create(['customer_id' => $customer->id, 'base_currency_code' => 'IRT', 'base_grand_total' => $toman, 'grand_total' => $toman, 'status' => $status]);
    OrderPayment::factory()->create(['order_id' => $order->id, 'method' => $method]);
    Invoice::factory()->create(['order_id' => $order->id, 'state' => 'paid', 'base_grand_total' => $toman, 'created_at' => $date ?? now(), 'purchase_credit_paid_at' => $date ?? now()]);

    return $order;
}

beforeEach(function () {
    Http::preventStrayRequests();
    purchaseCreditSettings();
});

it('uses the sum of purchases anchored at the last paid purchase, not a monthly average', function () {
    $customer = purchaseCreditCustomer();
    $last = now()->subMonths(4);
    for ($i = 0; $i < 8; $i++) {
        purchaseCreditOrder($customer, 50000000, $last->copy()->subDays($i));
    }
    purchaseCreditOrder($customer, 50000000, $last->copy()->subMonths(3));
    $result = app(PurchaseCreditEligibility::class)->calculate($customer);
    expect($result['total'])->toBe(400000000)->and($result['ceiling'])->toBe(200000000);
});

it('excludes unpaid, canceled, refunded and credit-funded purchases', function () {
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer, 50000000);
    purchaseCreditOrder($customer, 50000000, null, 'customer_credit');
    purchaseCreditOrder($customer, 50000000, null, 'moneytransfer', 'canceled');
    $refunded = purchaseCreditOrder($customer);
    Refund::factory()->create(['order_id' => $refunded->id]);
    $unpaid = purchaseCreditOrder($customer);
    $unpaid->invoices()->update(['state' => 'pending']);
    expect(app(PurchaseCreditEligibility::class)->calculate($customer)['ceiling'])->toBe(25000000);
});

it('accepts only five-million steps under the current maximum', function (int $amount) {
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    expect(fn () => app(PurchaseCreditWorkflow::class)->submit($customer, $amount, [['path' => 'private.pdf', 'name' => 'document.pdf']]))->toThrow(ValidationException::class);
})->with([0, 4999999, 11000000, 30000000]);

it('requires documents approval and cheque receipt before granting credit exactly once', function () {
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $workflow = app(PurchaseCreditWorkflow::class);
    $application = $workflow->submit($customer, 20000000, [['path' => 'private.pdf', 'name' => 'document.pdf']]);
    $admin = $this->loginAsAdmin();
    $accounts = app(CreditAccountRepository::class);
    expect($accounts->forCustomer($customer))->toBeNull();
    expect(fn () => $workflow->review($application->id, 'activate', ['amount' => 20000000, 'cheque_reference' => 'ABC'], $admin->id))->toThrow(ValidationException::class);
    $workflow->review($application->id, 'documents', [], $admin->id);
    $workflow->submitCheque($customer, $application->id, ['path' => 'cheque.pdf', 'name' => 'cheque.pdf']);
    $workflow->review($application->id, 'cheque', ['cheque_reference' => 'REF-'.$application->id, 'due_date' => now()->addMonth()->format('Y-m-d'), 'cheque_amount' => $application->requested_toman, 'sayad_confirmed' => 1], $admin->id);
    expect($accounts->forCustomer($customer))->toBeNull();
    $workflow->review($application->id, 'activate', ['amount' => 20000000, 'cheque_reference' => 'ABC'], $admin->id);
    $workflow->review($application->id, 'activate', ['amount' => 20000000, 'cheque_reference' => 'ABC'], $admin->id);
    $account = $accounts->forCustomer($customer);
    expect($account->balance_rial)->toBe(200000000)
        ->and($account->transactions()->where('kind', 'manual_credit')->count())->toBe(1)
        ->and($application->fresh()->status)->toBe('active');
});

it('accepts the cheque before identity approval and supports either approval order', function (string $first) {
    Storage::fake('private');
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $admin = $this->loginAsAdmin();
    $this->actingAs($customer, 'customer');
    post(route('shop.customers.account.credit.apply'), [
        'amount' => 10000000, 'accept_terms' => 1,
        'national_id_front' => UploadedFile::fake()->create('front.pdf', 10, 'application/pdf'),
        'national_id_back' => UploadedFile::fake()->create('back.pdf', 10, 'application/pdf'),
    ])->assertRedirect(route('shop.customers.account.credit.index', ['step' => 3]));
    $application = app(PurchaseCreditApplicationRepository::class)->findOneByField('customer_id', $customer->id);
    get(route('shop.customers.account.credit.index', ['step' => 3]))->assertOk()
        ->assertSee('"start":3', false)->assertSee('"maximumStep":3', false)
        ->assertSee('name="cheque"', false);
    post(route('shop.customers.account.credit.cheque', $application->id), [
        'cheque_sent' => 1, 'cheque' => UploadedFile::fake()->create('cheque.pdf', 10, 'application/pdf'),
    ])->assertRedirect(route('shop.customers.account.credit.index', ['step' => 3]));
    expect($application->fresh()->documents)->toHaveCount(3)
        ->and($application->fresh()->identityApproved())->toBeFalse();
    Webkul\Theme\Facades\Themes::clearResolvedInstance(Themes::class);
    get(route('admin.customers.credit.applications'))->assertOk()
        ->assertSee('value="documents"', false)->assertSee('value="cheque"', false);
    $workflow = app(PurchaseCreditWorkflow::class);
    $chequeData = ['cheque_reference' => 'INDEPENDENT-'.$application->id, 'due_date' => now()->addMonth()->format('Y-m-d'), 'cheque_amount' => 10000000, 'sayad_confirmed' => 1];
    $workflow->review($application->id, $first, $first === 'cheque' ? $chequeData : [], $admin->id);
    expect(fn () => $workflow->review($application->id, 'activate', ['amount' => 10000000], $admin->id))->toThrow(ValidationException::class);
    expect(app(CreditAccountRepository::class)->forCustomer($customer))->toBeNull();
    if ($first === 'cheque') {
        expect($application->fresh()->chequeApproved())->toBeTrue()
            ->and($application->fresh()->identityApproved())->toBeFalse();
        expect(fn () => $workflow->submitCheque($customer, $application->id, ['path' => 'replace.pdf', 'name' => 'replace.pdf']))->toThrow(ValidationException::class);
        $workflow->submit($customer, 10000000, array_values(array_filter($application->fresh()->documents, fn ($file) => $file['type'] !== 'cheque')));
        expect($application->fresh()->chequeApproved())->toBeTrue()->and($application->fresh()->documents)->toHaveCount(3);
    }
    $second = $first === 'cheque' ? 'documents' : 'cheque';
    $workflow->review($application->id, $second, $second === 'cheque' ? $chequeData : [], $admin->id);
    expect($application->fresh()->identity_approved_at)->not->toBeNull()
        ->and($application->fresh()->cheque_approved_at)->not->toBeNull()
        ->and($application->fresh()->status)->toBe('allocation_pending');
    $workflow->review($application->id, 'activate', ['amount' => 10000000], $admin->id);
    expect(app(CreditAccountRepository::class)->forCustomer($customer)->balance_rial)->toBe(100000000);
})->with(['documents', 'cheque']);

it('starts a new application after allocation while preserving previous grants and reviews', function () {
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $workflow = app(PurchaseCreditWorkflow::class);
    $admin = $this->loginAsAdmin();
    $this->actingAs($customer, 'customer');
    $accounts = app(CreditAccountRepository::class);
    $repository = app(PurchaseCreditApplicationRepository::class);
    $previous = null;

    for ($cycle = 1; $cycle <= 2; $cycle++) {
        if ($cycle === 2) {
            $this->travel(1)->seconds();
            purchaseCreditOrder($customer);
        }
        $application = $workflow->submit($customer, 10000000, [['path' => "identity-$cycle.pdf", 'name' => "identity-$cycle.pdf"]]);
        if ($previous) {
            expect($application->id)->not->toBe($previous->id)
                ->and($previous->fresh()->status)->toBe('active')
                ->and($previous->fresh()->documents)->toBe($previous->documents)
                ->and($previous->fresh()->history)->toBe($previous->history)
                ->and($accounts->forCustomer($customer)->balance_rial)->toBe(100000000);
        }
        if ($cycle === 2) {
            get(route('shop.customers.account.credit.index'))->assertOk()->assertViewHas('application', fn ($current) => $current->id === $application->id);
            get(route('shop.customers.account.credit.index', ['new' => 1]))->assertOk()->assertViewHas('application', fn ($current) => $current->id === $application->id);
        }
        $workflow->review($application->id, 'documents', [], $admin->id);
        expect(fn () => $workflow->submit($customer, 10000000, [['path' => 'other.pdf', 'name' => 'other.pdf']]))->toThrow(ValidationException::class);
        $workflow->submitCheque($customer, $application->id, ['path' => "cheque-$cycle.pdf", 'name' => "cheque-$cycle.pdf"]);
        $workflow->review($application->id, 'cheque', ['cheque_reference' => 'REPEAT-'.$application->id, 'due_date' => now()->addMonth()->format('Y-m-d'), 'cheque_amount' => 10000000, 'sayad_confirmed' => 1], $admin->id);
        $workflow->review($application->id, 'activate', ['amount' => 10000000], $admin->id);
        $workflow->review($application->id, 'activate', ['amount' => 10000000], $admin->id);
        if ($cycle === 1) {
            get(route('shop.customers.account.credit.index'))->assertOk()
                ->assertSee(trans('customer::purchase-credit.newRequest'))
                ->assertSee(route('shop.customers.account.credit.index', ['new' => 1]), false);
            get(route('shop.customers.account.credit.index', ['new' => 1]))->assertOk()
                ->assertViewHas('application', null)
                ->assertViewHas('eligibility', fn ($value) => $value['total'] === 0 && $value['ceiling'] === 0)
                ->assertDontSee(':initial="', false);
        }
        expect($repository->getModel()->newQuery()->where('customer_id', $customer->id)->count())->toBe($cycle)
            ->and($accounts->forCustomer($customer)->balance_rial)->toBe($cycle * 100000000);
        $previous = $application->fresh();
    }
    expect($accounts->forCustomer($customer)->transactions()->where('kind', 'manual_credit')->count())->toBe(2);
});

it('uses only cash purchases paid after the last allocation in the form dispatcher and SMS job', function () {
    Bus::fake([SendPurchaseCreditNotice::class]);
    $customer = purchaseCreditCustomer();
    $allocatedAt = now()->startOfSecond();
    $this->travelTo($allocatedAt);
    purchaseCreditOrder($customer, 50000000, $allocatedAt->copy()->subMonth());
    purchaseCreditOrder($customer, 50000000, $allocatedAt);
    $application = app(PurchaseCreditApplicationRepository::class)->create([
        'customer_id' => $customer->id, 'requested_toman' => 10000000, 'ceiling_toman' => 25000000,
        'approved_toman' => 10000000, 'status' => 'active', 'activated_at' => $allocatedAt,
        'documents' => [], 'history' => [],
    ]);
    $eligibility = app(PurchaseCreditEligibility::class);
    expect($eligibility->calculate($customer)['ceiling'])->toBe(0);
    expect(fn () => app(PurchaseCreditWorkflow::class)->submit($customer, 5000000, [['path' => 'id.pdf', 'name' => 'id.pdf']]))->toThrow(ValidationException::class);
    $this->artisan('credit:dispatch-notices', ['--now' => true])->assertSuccessful();
    Bus::assertNotDispatched(SendPurchaseCreditNotice::class, fn ($job) => $job->customerId === $customer->id);
    (new SendPurchaseCreditNotice($customer->id))->handle();
    expect(app(PurchaseCreditNoticeRepository::class)->getModel()->newQuery()->where('customer_id', $customer->id)->count())->toBe(0);

    $this->travel(1)->days();
    purchaseCreditOrder($customer, 50000000, null, 'customer_credit');
    expect($eligibility->calculate($customer)['total'])->toBe(0);
    $newOrder = purchaseCreditOrder($customer, 12000000);
    expect($eligibility->calculate($customer)['total'])->toBe(12000000)
        ->and($eligibility->calculate($customer)['ceiling'])->toBe(5000000);
    $this->actingAs($customer, 'customer');
    get(route('shop.customers.account.credit.index', ['new' => 1]))->assertOk()
        ->assertViewHas('eligibility', fn ($value) => $value['total'] === 12000000 && $value['ceiling'] === 5000000)
        ->assertSee(':initial="5000000"', false);
    $this->artisan('credit:dispatch-notices', ['--now' => true])->assertSuccessful();
    Bus::assertDispatched(SendPurchaseCreditNotice::class, fn ($job) => $job->customerId === $customer->id);
    (new SendPurchaseCreditNotice($customer->id))->handle();
    $notice = app(PurchaseCreditNoticeRepository::class)->findOneByField('customer_id', $customer->id);
    expect($notice->order_id)->toBe($newOrder->id)->and($notice->amount_toman)->toBe(5000000)
        ->and($application->fresh()->activated_at->equalTo($allocatedAt))->toBeTrue();
});

it('rechecks the ceiling after a refund before granting credit', function () {
    $customer = purchaseCreditCustomer();
    $order = purchaseCreditOrder($customer);
    $workflow = app(PurchaseCreditWorkflow::class);
    $application = $workflow->submit($customer, 25000000, [['path' => 'private.pdf', 'name' => 'document.pdf']]);
    $admin = $this->loginAsAdmin();
    $workflow->review($application->id, 'documents', [], $admin->id);
    $workflow->submitCheque($customer, $application->id, ['path' => 'cheque.pdf', 'name' => 'cheque.pdf']);
    $workflow->review($application->id, 'cheque', ['cheque_reference' => 'REF-'.$application->id, 'due_date' => now()->addMonth()->format('Y-m-d'), 'cheque_amount' => $application->requested_toman, 'sayad_confirmed' => 1], $admin->id);
    Refund::factory()->create(['order_id' => $order->id]);
    expect(fn () => $workflow->review($application->id, 'activate', ['amount' => 25000000, 'cheque_reference' => 'ABC'], $admin->id))->toThrow(ValidationException::class);
    expect(app(CreditAccountRepository::class)->forCustomer($customer))->toBeNull();
});

it('uploads private documents and blocks downloads by other customers', function () {
    Storage::fake('private');
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $this->actingAs($customer, 'customer');
    post(route('shop.customers.account.credit.apply'), ['amount' => 20000000, 'accept_terms' => 1, 'national_id_front' => UploadedFile::fake()->create('front.pdf', 10, 'application/pdf'), 'national_id_back' => UploadedFile::fake()->create('back.pdf', 10, 'application/pdf')])->assertRedirect();
    $application = app(PurchaseCreditApplicationRepository::class)->findOneByField('customer_id', $customer->id);
    Storage::disk('private')->assertExists($application->documents[0]['path']);
    get(route('shop.customers.account.credit.document', [$application->id, 0]))->assertOk();
    $this->actingAs(purchaseCreditCustomer(), 'customer');
    get(route('shop.customers.account.credit.document', [$application->id, 0]))->assertNotFound();
});

it('shows the customer purchase credit screen', function () {
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $this->actingAs($customer, 'customer');
    get(route('shop.customers.account.credit.index'))->assertOk()
        ->assertSee('v-purchase-credit-amount', false)
        ->assertSee('name="national_id_front"', false)
        ->assertSee('name="national_id_back"', false)
        ->assertSee('v-text="identityNames.front"', false)
        ->assertSee('v-text="identityNames.back"', false)
        ->assertSee('v-text="uploadErrors.front"', false)
        ->assertSee('v-text="uploadErrors.back"', false)
        ->assertDontSee('{{ $side }}', false);
});

it('shows the independent admin settings and applications screens', function () {
    $this->loginAsAdmin();
    get(route('admin.customers.credit.settings'))->assertOk()->assertSee('name="factor"', false)->assertSee('name="minimum_amount"', false);
    get(route('admin.customers.credit.applications'))->assertOk();
});

it('queues a separate database job for each customer with paid purchases', function () {
    Bus::fake([SendPurchaseCreditNotice::class]);
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $other = purchaseCreditCustomer();
    $this->artisan('credit:dispatch-notices', ['--now' => true])->assertSuccessful();
    Bus::assertDispatched(SendPurchaseCreditNotice::class, fn ($job) => $job->customerId === $customer->id && $job->connection === 'database' && $job->queue === 'purchase-credit');
    Bus::assertNotDispatched(SendPurchaseCreditNotice::class, fn ($job) => $job->customerId === $other->id);
});

it('filters dispatch by purchases in the months before each customers last qualifying order', function (int $minimum, int $months) {
    purchaseCreditSettings(['minimum_amount' => $minimum, 'factor' => '0.01', 'months' => $months]);
    Bus::fake([SendPurchaseCreditNotice::class]);
    $below = purchaseCreditCustomer();
    purchaseCreditOrder($below, $minimum - 1);
    $equal = purchaseCreditCustomer();
    purchaseCreditOrder($equal, $minimum);
    $eligible = purchaseCreditCustomer();
    purchaseCreditOrder($eligible, intdiv($minimum, 2));
    purchaseCreditOrder($eligible, intdiv($minimum, 2) + 1);
    $historical = purchaseCreditCustomer();
    $lastPurchase = now()->subMonthsNoOverflow(6);
    purchaseCreditOrder($historical, intdiv($minimum, 2), $lastPurchase)->forceFill(['created_at' => $lastPurchase])->save();
    purchaseCreditOrder($historical, intdiv($minimum, 2) + 1, $lastPurchase->copy()->subMonthsNoOverflow($months))->forceFill(['created_at' => $lastPurchase->copy()->subMonthsNoOverflow($months)])->save();
    purchaseCreditOrder($historical, $minimum + 1, null, 'moneytransfer', 'canceled');
    $outsideWindow = purchaseCreditCustomer();
    purchaseCreditOrder($outsideWindow, $minimum + 1, $lastPurchase->copy()->subMonthsNoOverflow($months)->subDay())->forceFill(['created_at' => $lastPurchase->copy()->subMonthsNoOverflow($months)->subDay()])->save();
    purchaseCreditOrder($outsideWindow, 100, $lastPurchase)->forceFill(['created_at' => $lastPurchase])->save();
    $rial = purchaseCreditCustomer();
    purchaseCreditOrder($rial, ($minimum + 1) * 10)->update(['base_currency_code' => 'IRR']);
    $rialBelow = purchaseCreditCustomer();
    purchaseCreditOrder($rialBelow, $minimum + 1)->update(['base_currency_code' => 'IRR']);

    $this->artisan('credit:dispatch-notices', ['--now' => true])->assertSuccessful();

    foreach ([$eligible, $rial, $historical] as $customer) {
        Bus::assertDispatched(SendPurchaseCreditNotice::class, fn ($job) => $job->customerId === $customer->id);
    }
    foreach (['below' => $below, 'equal' => $equal, 'outside window' => $outsideWindow, 'rial below' => $rialBelow] as $case => $customer) {
        $this->assertSame(0, Bus::dispatched(SendPurchaseCreditNotice::class, fn ($job) => $job->customerId === $customer->id)->count(), $case);
    }
})->with([[5000000, 2], [2000000, 1]]);

it('sends only through 0098 and never repeats an offer or a fortnightly reminder', function () {
    purchaseCreditSettings(['sms_testing' => false]);
    $this->travelTo(now()->startOfDay()->hour(10));
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $sms = $this->mock(CustomerOtpSms::class);
    $sms->shouldReceive('sendVipMessage')->twice()->with($customer->phone, Mockery::type('string'));
    (new SendPurchaseCreditNotice($customer->id))->handle();
    (new SendPurchaseCreditNotice($customer->id))->handle();
    $this->travel(14)->days();
    (new SendPurchaseCreditNotice($customer->id))->handle();
    (new SendPurchaseCreditNotice($customer->id))->handle();
    expect(app(PurchaseCreditNoticeRepository::class)->getModel()->newQuery()->where('customer_id', $customer->id)->where('status', 'sent')->count())->toBe(2);
});

it('records test messages without HTTP and allows real sending after test mode is disabled', function () {
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    (new SendPurchaseCreditNotice($customer->id))->handle();
    Http::assertNothingSent();
    expect(app(PurchaseCreditNoticeRepository::class)->getModel()->newQuery()->where('customer_id', $customer->id)->where('status', 'tested')->count())->toBe(1);
    purchaseCreditSettings(['sms_testing' => false]);
    expect(PurchaseCreditSettings::all()['sms_testing'])->toBeFalse();
    expect(app(PurchaseCreditEligibility::class)->calculate($customer)['ceiling'])->toBe(25000000);
    $this->mock(CustomerOtpSms::class)->shouldReceive('sendVipMessage')->once();
    (new SendPurchaseCreditNotice($customer->id))->handle();
});

it('does not retry uncertain delivery or send reminders after a return or opt out', function () {
    purchaseCreditSettings(['sms_testing' => false]);
    $this->travelTo(now()->startOfDay()->hour(10));
    $customer = purchaseCreditCustomer();
    $order = purchaseCreditOrder($customer);
    $this->mock(CustomerOtpSms::class)->shouldReceive('sendVipMessage')->once()->andThrow(new RuntimeException('private provider details'));
    (new SendPurchaseCreditNotice($customer->id))->handle();
    (new SendPurchaseCreditNotice($customer->id))->handle();
    expect(app(PurchaseCreditNoticeRepository::class)->getModel()->newQuery()->where('customer_id', $customer->id)->first()->error)->toBe('delivery_failed');
    $this->travel(14)->days();
    $customer->forceFill(['credit_marketing_opt_out' => true])->save();
    (new SendPurchaseCreditNotice($customer->id))->handle();
    $customer->forceFill(['credit_marketing_opt_out' => false])->save();
    Refund::factory()->create(['order_id' => $order->id]);
    (new SendPurchaseCreditNotice($customer->id))->handle();
});

it('saves independent settings and validates the factor and editable SMS placeholders', function () {
    $this->loginAsAdmin();
    $settings = array_merge(PurchaseCreditSettings::defaults(), ['enabled' => 1, 'factor' => '0.5', 'months' => 2, 'accounting_address' => 'Accounting test address']);
    post(route('admin.customers.credit.settings.save'), $settings)->assertRedirect()->assertSessionHas('success');
    expect(PurchaseCreditSettings::all()['factor'])->toBe('0.5')->and(PurchaseCreditSettings::all()['enabled'])->toBeTrue();
    post(route('admin.customers.credit.settings.save'), array_merge($settings, ['reminder_days' => 10, 'reminder_limit' => 4]))->assertRedirect();
    expect((int) PurchaseCreditSettings::all()['reminder_days'])->toBe(10)
        ->and((int) PurchaseCreditSettings::all()['reminder_limit'])->toBe(4);
    postJson(route('admin.customers.credit.settings.save'), array_merge($settings, ['reminder_days' => 0, 'reminder_limit' => -1]))
        ->assertUnprocessable()->assertJsonValidationErrorFor('reminder_days')->assertJsonValidationErrorFor('reminder_limit');
    postJson(route('admin.customers.credit.settings.save'), array_merge($settings, ['factor' => 50]))->assertUnprocessable()->assertJsonValidationErrorFor('factor');
    postJson(route('admin.customers.credit.settings.save'), array_merge($settings, ['offer_text' => 'Missing amount']))->assertUnprocessable()->assertJsonValidationErrorFor('offer_text');
});

it('requires a separate admin permission to review cheques and change settings', function () {
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $application = app(PurchaseCreditWorkflow::class)->submit($customer, 20000000, [['path' => 'private.pdf', 'name' => 'document.pdf']]);
    $role = Role::factory()->create(['permission_type' => 'custom', 'permissions' => ['customers.purchase_credit']]);
    $this->loginAsAdmin(Admin::factory()->create(['role_id' => $role->id]));
    postJson(route('admin.customers.credit.review', $application->id), ['action' => 'documents'])->assertUnauthorized();
    postJson(route('admin.customers.credit.settings.save'), PurchaseCreditSettings::defaults())->assertUnauthorized();
});

it('records rejection and allows corrected documents without granting money', function () {
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $workflow = app(PurchaseCreditWorkflow::class);
    $application = $workflow->submit($customer, 20000000, [['path' => 'first.pdf', 'name' => 'first.pdf']]);
    $admin = $this->loginAsAdmin();
    post(route('admin.customers.credit.review', $application->id), ['action' => 'reject', 'reason' => 'Identity document missing'])->assertRedirect();
    expect($application->fresh()->status)->toBe('rejected');
    $workflow->submit($customer, 15000000, [['path' => 'corrected.pdf', 'name' => 'corrected.pdf']]);
    expect($application->fresh()->status)->toBe('documents_pending')->and($application->fresh()->history)->toHaveCount(3)
        ->and(app(CreditAccountRepository::class)->forCustomer($customer))->toBeNull();
});

it('does not queue notices while disabled or outside the configured sending hour', function () {
    Bus::fake([SendPurchaseCreditNotice::class]);
    purchaseCreditSettings(['enabled' => false]);
    $this->artisan('credit:dispatch-notices', ['--now' => true])->assertSuccessful();
    purchaseCreditSettings(['send_hour' => 11]);
    $this->travelTo(now('Asia/Tehran')->startOfDay()->hour(10));
    $this->artisan('credit:dispatch-notices')->assertSuccessful();
    Bus::assertNothingDispatched();
});

it('always uses the 0098 SOAP transport for Persian credit messages regardless of the OTP provider', function () {
    purchaseCreditSettings(['sms_testing' => false]);
    foreach (['ghasedak.provider' => 'kavenegar', 'vip0098.from' => '3000123456', 'vip0098.username' => 'credit-user', 'vip0098.password' => 'credit-pass'] as $field => $value) {
        CoreConfig::updateOrCreate(['code' => 'customer.sms.'.$field, 'channel_code' => null, 'locale_code' => null], ['value' => $value]);
    }
    $xml = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><SendSMSResponse xmlns="http://tempuri.org/"><SendSMSResult>2</SendSMSResult></SendSMSResponse></soap:Body></soap:Envelope>';
    Http::fake(['webservice.0098vip.com/*' => Http::response($xml)]);
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    (new SendPurchaseCreditNotice($customer->id))->handle();
    Http::assertSent(fn ($request) => $request->url() === 'https://webservice.0098vip.com/service.asmx' && str_contains($request->body(), '۲۵,۰۰۰,۰۰۰'));
    Http::assertSentCount(1);
});

it('anchors reminders to payment confirmation when an invoice was created earlier', function () {
    $this->travelTo(now()->startOfDay()->hour(10));
    $customer = purchaseCreditCustomer();
    $order = Order::factory()->create(['customer_id' => $customer->id, 'status' => 'completed', 'base_currency_code' => 'IRT', 'base_grand_total' => 50000000]);
    OrderPayment::factory()->create(['order_id' => $order->id, 'method' => 'moneytransfer']);
    $invoice = Invoice::factory()->create(['order_id' => $order->id, 'state' => 'pending', 'base_grand_total' => 50000000, 'created_at' => now()->subMonths(3)]);
    expect($invoice->purchase_credit_paid_at)->toBeNull();
    $invoice->update(['state' => 'paid']);
    expect(Carbon::parse($invoice->fresh()->purchase_credit_paid_at)->equalTo(now()))->toBeTrue();
    expect(app(PurchaseCreditEligibility::class)->calculate($customer)['last_paid_at']->equalTo(now()))->toBeTrue();
    (new SendPurchaseCreditNotice($customer->id))->handle();
    $this->travel(13)->days();
    (new SendPurchaseCreditNotice($customer->id))->handle();
    expect(app(PurchaseCreditNoticeRepository::class)->getModel()->newQuery()->where('customer_id', $customer->id)->count())->toBe(1);
    $this->travel(1)->days();
    (new SendPurchaseCreditNotice($customer->id))->handle();
    expect(app(PurchaseCreditNoticeRepository::class)->getModel()->newQuery()->where('customer_id', $customer->id)->count())->toBe(2);
});

it('uses the configured interval and stops at the per-customer reminder limit until a new purchase', function () {
    purchaseCreditSettings(['reminder_days' => 7, 'reminder_limit' => 2]);
    $this->travelTo(now()->startOfDay()->hour(10));
    $customer = purchaseCreditCustomer();
    $order = purchaseCreditOrder($customer);
    $job = fn () => (new SendPurchaseCreditNotice($customer->id))->handle();
    $query = fn () => app(PurchaseCreditNoticeRepository::class)->getModel()->newQuery()->where('customer_id', $customer->id);
    $job(); // Initial offer does not consume the reminder allowance.
    $this->travel(6)->days();
    $job();
    expect($query()->count())->toBe(1);
    $this->travel(1)->days();
    $job();
    $job();
    expect($query()->where('kind', 'marketing')->count())->toBe(1);
    $this->travel(7)->days();
    $job();
    expect($query()->where('kind', 'marketing')->count())->toBe(2);
    $this->travel(7)->days();
    $job();
    expect($query()->where('order_id', $order->id)->count())->toBe(3);
    $newOrder = purchaseCreditOrder($customer);
    $job();
    $this->travel(7)->days();
    $job();
    expect($query()->where('order_id', $newOrder->id)->where('kind', 'marketing')->count())->toBe(1);
    Http::assertNothingSent();
});

it('applies interval changes immediately and lets zero disable reminders without suppressing the initial offer', function () {
    purchaseCreditSettings(['reminder_days' => 7, 'reminder_limit' => 0]);
    $this->travelTo(now()->startOfDay()->hour(10));
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $job = fn () => (new SendPurchaseCreditNotice($customer->id))->handle();
    $query = fn () => app(PurchaseCreditNoticeRepository::class)->getModel()->newQuery()->where('customer_id', $customer->id);
    $job();
    $this->travel(7)->days();
    $job();
    expect($query()->count())->toBe(1);
    purchaseCreditSettings(['reminder_days' => 7, 'reminder_limit' => 3]);
    $job();
    expect($query()->where('kind', 'marketing')->count())->toBe(1);
    $this->travel(3)->days();
    purchaseCreditSettings(['reminder_days' => 3, 'reminder_limit' => 3]);
    $job();
    expect($query()->where('kind', 'marketing')->count())->toBe(2);
});

it('requires national ID and a separate cheque approval before the fourth allocation step', function () {
    Storage::fake('private');
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $this->actingAs($customer, 'customer');
    postJson(route('shop.customers.account.credit.apply'), ['amount' => 20000000, 'accept_terms' => 1, 'documents' => [UploadedFile::fake()->create('other.pdf', 10, 'application/pdf')]])->assertUnprocessable()->assertJsonValidationErrorFor('national_id_front')->assertJsonValidationErrorFor('national_id_back');
    post(route('shop.customers.account.credit.apply'), ['amount' => 20000000, 'accept_terms' => 1, 'national_id_front' => UploadedFile::fake()->create('front.pdf', 10, 'application/pdf'), 'national_id_back' => UploadedFile::fake()->create('back.pdf', 10, 'application/pdf')])->assertRedirect();
    $application = app(PurchaseCreditApplicationRepository::class)->findOneByField('customer_id', $customer->id);
    postJson(route('shop.customers.account.credit.cheque', $application->id), ['cheque' => UploadedFile::fake()->create('cheque.pdf', 10, 'application/pdf'), 'cheque_sent' => 1])->assertRedirect();
    $admin = $this->loginAsAdmin();
    post(route('admin.customers.credit.review', $application->id), ['action' => 'documents'])->assertRedirect();
    postJson(route('admin.customers.credit.review', $application->id), ['action' => 'activate', 'amount' => 20000000])->assertUnprocessable();
    post(route('shop.customers.account.credit.cheque', $application->id), ['cheque' => UploadedFile::fake()->create('cheque.pdf', 10, 'application/pdf'), 'cheque_sent' => 1])->assertRedirect();
    expect($application->fresh()->status)->toBe('cheque_pending');
    post(route('admin.customers.credit.review', $application->id), ['action' => 'cheque', 'cheque_reference' => 'STEP-4-CHECK', 'due_date' => now()->addMonth()->format('Y-m-d'), 'cheque_amount' => 25000000, 'sayad_confirmed' => 1])->assertRedirect();
    expect($application->fresh()->status)->toBe('allocation_pending')->and(app(CreditAccountRepository::class)->forCustomer($customer))->toBeNull();
    post(route('admin.customers.credit.review', $application->id), ['action' => 'activate', 'amount' => 20000000])->assertRedirect();
    expect($application->fresh()->status)->toBe('active')->and(app(CreditAccountRepository::class)->forCustomer($customer)->balance_rial)->toBe(200000000);
    $cheque = app(CreditChequeRepository::class)->getModel()->newQuery()->where('application_id', $application->id)->firstOrFail();
    expect($cheque->allocated_toman)->toBe(20000000)->and($cheque->sayad_confirmed)->toBeTrue();
});

it('requires the front and back separately and compresses a large image before private storage', function () {
    Storage::fake('private');
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $this->actingAs($customer, 'customer');
    postJson(route('shop.customers.account.credit.apply'), [
        'amount' => 20000000, 'accept_terms' => 1,
        'national_id_front' => UploadedFile::fake()->image('front.png'),
    ])->assertUnprocessable()->assertJsonValidationErrorFor('national_id_back');

    $front = UploadedFile::fake()->image('front.png', 2200, 1400);
    file_put_contents($front->getRealPath(), file_get_contents($front->getRealPath()).str_repeat('0', 6 * 1024 * 1024));
    clearstatcache(true, $front->getRealPath());
    post(route('shop.customers.account.credit.apply'), [
        'amount' => 20000000, 'accept_terms' => 1,
        'national_id_front' => $front,
        'national_id_back' => UploadedFile::fake()->create('back.pdf', 10, 'application/pdf'),
    ])->assertRedirect()->assertSessionHasNoErrors();

    $application = app(PurchaseCreditApplicationRepository::class)->findOneByField('customer_id', $customer->id);
    expect($application->documents)->toHaveCount(2)
        ->and(array_column($application->documents, 'type'))->toBe(['national_id_front', 'national_id_back']);
    foreach ($application->documents as $document) {
        Storage::disk('private')->assertExists($document['path']);
        expect(Storage::disk('private')->size($document['path']))->toBeLessThan(5 * 1024 * 1024);
    }
    $image = Storage::disk('private')->get($application->documents[0]['path']);
    $dimensions = getimagesizefromstring($image);
    expect($dimensions['mime'])->toBe('image/jpeg')
        ->and(max($dimensions[0], $dimensions[1]))->toBeLessThanOrEqual(1600)
        ->and(strlen($image))->toBeLessThan($front->getSize());
});

it('rejects a PDF at five megabytes and cleans up any already saved front image', function () {
    Storage::fake('private');
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $this->actingAs($customer, 'customer');
    postJson(route('shop.customers.account.credit.apply'), [
        'amount' => 20000000, 'accept_terms' => 1,
        'national_id_front' => UploadedFile::fake()->image('front.jpg'),
        'national_id_back' => UploadedFile::fake()->create('back.pdf', 5120, 'application/pdf'),
    ])->assertUnprocessable()->assertJsonValidationErrorFor('national_id_back');
    expect(Storage::disk('private')->allFiles())->toBe([])
        ->and(app(PurchaseCreditApplicationRepository::class)->findOneByField('customer_id', $customer->id))->toBeNull();
});

it('changes only the minimum while keeping the ceiling and five million amount step', function () {
    $this->loginAsAdmin();
    $settings = array_merge(PurchaseCreditSettings::defaults(), ['enabled' => 1, 'minimum_amount' => 2000000, 'accounting_address' => 'Accounting']);
    post(route('admin.customers.credit.settings.save'), $settings)->assertRedirect()->assertSessionHasNoErrors();
    expect(PurchaseCreditSettings::minimumAmount())->toBe(2000000);
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    expect(app(PurchaseCreditEligibility::class)->calculate($customer)['ceiling'])->toBe(25000000);
    $this->actingAs($customer, 'customer');
    get(route('shop.customers.account.credit.index'))->assertOk()
        ->assertSee(':minimum="2000000"', false)
        ->assertSee(':maximum="22000000"', false)
        ->assertSee('step: 5000000', false);
    $workflow = app(PurchaseCreditWorkflow::class);
    expect(fn () => $workflow->submit($customer, 1000000, []))->toThrow(ValidationException::class);
    expect(fn () => $workflow->submit($customer, 3000000, []))->toThrow(ValidationException::class);
    expect($workflow->submit($customer, 2000000, [])->requested_toman)->toBe(2000000);
    expect($workflow->submit($customer, 7000000, [])->requested_toman)->toBe(7000000);
    expect(fn () => $workflow->submit($customer, 5000000, []))->toThrow(ValidationException::class);
    expect(fn () => $workflow->submit($customer, 27000000, []))->toThrow(ValidationException::class);

    foreach ([0, -1, 1000000000001] as $minimum) {
        postJson(route('admin.customers.credit.settings.save'), array_merge($settings, ['minimum_amount' => $minimum]))
            ->assertUnprocessable()->assertJsonValidationErrorFor('minimum_amount');
    }
});

it('configures a one million amount step for the form calculation and final allocation', function () {
    $admin = $this->loginAsAdmin();
    $settings = array_merge(PurchaseCreditSettings::defaults(), ['enabled' => 1, 'amount_step' => 1000000, 'accounting_address' => 'Accounting']);
    post(route('admin.customers.credit.settings.save'), $settings)->assertRedirect();
    expect(PurchaseCreditSettings::amountStep())->toBe(1000000);
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer, 22000000);
    expect(app(PurchaseCreditEligibility::class)->calculate($customer)['ceiling'])->toBe(11000000);
    $this->actingAs($customer, 'customer');
    get(route('shop.customers.account.credit.index'))->assertOk()->assertSee(':initial="11000000"', false)->assertSee('step: 1000000', false);
    $workflow = app(PurchaseCreditWorkflow::class);
    expect(fn () => $workflow->submit($customer, 5500000, [['path' => 'id.pdf', 'name' => 'id.pdf']]))->toThrow(ValidationException::class);
    $application = $workflow->submit($customer, 11000000, [['path' => 'id.pdf', 'name' => 'id.pdf']]);
    $workflow->review($application->id, 'documents', [], $admin->id);
    $workflow->submitCheque($customer, $application->id, ['path' => 'cheque.pdf', 'name' => 'cheque.pdf']);
    $workflow->review($application->id, 'cheque', ['cheque_reference' => 'ONE-MILLION-'.$application->id, 'due_date' => now()->addMonth()->format('Y-m-d'), 'cheque_amount' => 11000000, 'sayad_confirmed' => 1], $admin->id);
    $workflow->review($application->id, 'activate', ['amount' => 11000000], $admin->id);
    expect(app(CreditAccountRepository::class)->forCustomer($customer)->balance_rial)->toBe(110000000);
    foreach ([0, -1, 1000000000001] as $invalid) {
        postJson(route('admin.customers.credit.settings.save'), array_merge($settings, ['amount_step' => $invalid]))->assertUnprocessable()->assertJsonValidationErrorFor('amount_step');
    }
});

it('deducts the chosen term percentage from requested credit only once on allocation', function (int $months, int $net) {
    purchaseCreditSettings(['amount_step' => 1000000]);
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer, 22000000);
    $workflow = app(PurchaseCreditWorkflow::class);
    $application = $workflow->submit($customer, 11000000, [['path' => 'id.pdf', 'name' => 'id.pdf']], $months);
    expect($application->requested_toman)->toBe(11000000)->and($application->repayment_months)->toBe($months)
        ->and($application->netAmount())->toBe($net);
    $admin = $this->loginAsAdmin();
    $workflow->review($application->id, 'documents', [], $admin->id);
    $workflow->submitCheque($customer, $application->id, ['path' => 'cheque.pdf', 'name' => 'cheque.pdf']);
    $workflow->review($application->id, 'cheque', ['cheque_reference' => 'TERM-'.$application->id, 'due_date' => now()->addMonths($months)->format('Y-m-d'), 'cheque_amount' => 11000000, 'sayad_confirmed' => 1], $admin->id);
    if ($months > 1) {
        expect(fn () => $workflow->review($application->id, 'activate', ['amount' => 11000000], $admin->id))->toThrow(ValidationException::class);
    }
    $workflow->review($application->id, 'activate', ['amount' => $net], $admin->id);
    $workflow->review($application->id, 'activate', ['amount' => $net], $admin->id);
    expect($application->fresh()->approved_toman)->toBe($net)
        ->and(app(CreditAccountRepository::class)->forCustomer($customer)->balance_rial)->toBe($net * 10);
})->with([[1, 11000000], [2, 9900000], [3, 8800000], [4, 7700000]]);

it('rejects repayment terms outside one to four months without creating a request', function (int $months) {
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    $this->actingAs($customer, 'customer');
    postJson(route('shop.customers.account.credit.apply'), ['amount' => 10000000, 'repayment_months' => $months, 'accept_terms' => 1])
        ->assertUnprocessable()->assertJsonValidationErrorFor('repayment_months');
    expect(fn () => app(PurchaseCreditWorkflow::class)->submit($customer, 10000000, [['path' => 'id.pdf', 'name' => 'id.pdf']], $months))->toThrow(ValidationException::class);
    expect(app(PurchaseCreditApplicationRepository::class)->getModel()->newQuery()->where('customer_id', $customer->id)->exists())->toBeFalse();
})->with([0, 5]);

it('stores the submitted repayment term and ignores a forged final credit amount', function () {
    Storage::fake('private');
    purchaseCreditSettings(['amount_step' => 1000000]);
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer, 22000000);
    $this->actingAs($customer, 'customer');
    post(route('shop.customers.account.credit.apply'), [
        'amount' => 7000000, 'repayment_months' => 4, 'net_amount' => 11000000, 'accept_terms' => 1,
        'national_id_front' => UploadedFile::fake()->create('front.pdf', 10, 'application/pdf'),
        'national_id_back' => UploadedFile::fake()->create('back.pdf', 10, 'application/pdf'),
    ])->assertRedirect();
    $application = app(PurchaseCreditApplicationRepository::class)->findOneByField('customer_id', $customer->id);
    expect($application->repayment_months)->toBe(4)->and($application->requested_toman)->toBe(7000000)
        ->and($application->netAmount())->toBe(7000000)->and($application->amount_is_net)->toBeTrue()
        ->and(app(CreditAccountRepository::class)->forCustomer($customer))->toBeNull();
});

it('counts only the verified cash portion of mixed payments in new requests and the SMS dispatcher', function (string $currency, int $totalToman, int $ceiling) {
    purchaseCreditSettings(['amount_step' => 1000000, 'minimum_amount' => 1000000]);
    Bus::fake([SendPurchaseCreditNotice::class]);
    $customer = purchaseCreditCustomer();
    $order = purchaseCreditOrder($customer, 30000000, null, 'customer_credit');
    $order->update(['base_currency_code' => $currency]);
    $order->payment->update(['additional' => ['credit_split' => ['state' => 'paid', 'gateway_amount' => 20000000, 'credit_rial' => CreditIdentity::orderRial(10000000, $currency)]]]);
    $eligibility = app(PurchaseCreditEligibility::class)->calculate($customer);
    expect($eligibility['total'])->toBe($totalToman)->and($eligibility['ceiling'])->toBe($ceiling);
    $this->actingAs($customer, 'customer');
    get(route('shop.customers.account.credit.index', ['new' => 1]))->assertOk()
        ->assertViewHas('eligibility', fn ($value) => $value['total'] === $totalToman && $value['ceiling'] === $ceiling)
        ->assertSee(':initial="'.$ceiling.'"', false);
    $this->artisan('credit:dispatch-notices', ['--now' => true])->assertSuccessful();
    Bus::assertDispatched(SendPurchaseCreditNotice::class, fn ($job) => $job->customerId === $customer->id);
    (new SendPurchaseCreditNotice($customer->id))->handle();
    expect(app(PurchaseCreditNoticeRepository::class)->findOneByField('customer_id', $customer->id)->amount_toman)->toBe($ceiling);
    $application = app(PurchaseCreditWorkflow::class)->submit($customer, $ceiling, [['path' => 'id.pdf', 'name' => 'id.pdf']]);
    expect($application->requested_toman)->toBe($ceiling);
})->with([['TMN', 20000000, 10000000], ['IRR', 2000000, 1000000]]);

it('excludes unverified refunded and previously used mixed payments', function () {
    $customer = purchaseCreditCustomer();
    $order = purchaseCreditOrder($customer, 30000000, null, 'customer_credit');
    foreach (['pending', 'canceled'] as $state) {
        $order->payment->update(['additional' => ['credit_split' => ['state' => $state, 'gateway_amount' => 20000000]]]);
        expect(app(PurchaseCreditEligibility::class)->calculate($customer)['total'])->toBe(0);
    }
    $order->payment->update(['additional' => ['credit_split' => ['state' => 'paid', 'gateway_amount' => 20000000]]]);
    app(PurchaseCreditApplicationRepository::class)->create(['customer_id' => $customer->id, 'requested_toman' => 10000000, 'ceiling_toman' => 10000000, 'status' => 'active', 'activated_at' => now()->addSecond(), 'documents' => [], 'history' => []]);
    expect(app(PurchaseCreditEligibility::class)->calculate($customer)['total'])->toBe(0);
    $this->travel(2)->seconds();
    $new = purchaseCreditOrder($customer, 30000000, null, 'customer_credit');
    $new->payment->update(['additional' => ['credit_split' => ['state' => 'paid', 'gateway_amount' => 20000000]]]);
    expect(app(PurchaseCreditEligibility::class)->calculate($customer)['total'])->toBe(20000000);
    Refund::factory()->create(['order_id' => $new->id]);
    expect(app(PurchaseCreditEligibility::class)->calculate($customer)['total'])->toBe(0);
});

it('uses manual credit grant dates as the purchase cutoff in the form and dispatcher', function (string $grantType) {
    purchaseCreditSettings(['amount_step' => 1000000]);
    Bus::fake([SendPurchaseCreditNotice::class]);
    $customer = purchaseCreditCustomer();
    $admin = $this->loginAsAdmin();
    $this->travelTo(now()->startOfSecond());
    purchaseCreditOrder($customer, 50000000, now()->subDay());
    $accounts = app(CreditAccountRepository::class);
    $account = $accounts->open(['phone' => $customer->phone], $grantType === 'opening' ? 5000000 : 0, (string) Str::uuid(), $admin->id);
    $accounts->forCustomer($customer);
    if ($grantType === 'increase') {
        $accounts->adjust($account->id, 5000000, 'increase', (string) Str::uuid(), 'Manual allocation', null, $admin->id);
    }
    expect(app(PurchaseCreditEligibility::class)->calculate($customer)['total'])->toBe(0);
    $this->actingAs($customer, 'customer');
    get(route('shop.customers.account.credit.index'))->assertOk()->assertViewHas('eligibility', fn ($value) => $value['ceiling'] === 0);
    $this->artisan('credit:dispatch-notices', ['--now' => true])->assertSuccessful();
    Bus::assertNotDispatched(SendPurchaseCreditNotice::class, fn ($job) => $job->customerId === $customer->id);
    $this->travel(1)->days();
    purchaseCreditOrder($customer, 12000000);
    expect(app(PurchaseCreditEligibility::class)->calculate($customer)['total'])->toBe(12000000)
        ->and(app(PurchaseCreditEligibility::class)->calculate($customer)['ceiling'])->toBe(6000000);
    get(route('shop.customers.account.credit.index'))->assertOk()->assertViewHas('eligibility', fn ($value) => $value['ceiling'] === 6000000);
    $this->artisan('credit:dispatch-notices', ['--now' => true])->assertSuccessful();
    Bus::assertDispatched(SendPurchaseCreditNotice::class, fn ($job) => $job->customerId === $customer->id);
    $this->travel(1)->days();
    $accounts->adjust($account->id, 1000000, 'decrease', (string) Str::uuid(), 'Correction', null, $admin->id);
    expect(app(PurchaseCreditEligibility::class)->calculate($customer)['total'])->toBe(12000000);
    $accounts->adjust($account->id, 1000000, 'increase', (string) Str::uuid(), 'New allocation', null, $admin->id);
    expect(app(PurchaseCreditEligibility::class)->calculate($customer)['total'])->toBe(0);
})->with(['opening', 'increase']);

it('uses the original manual grant date rather than the later account claim date', function () {
    purchaseCreditSettings(['amount_step' => 1000000]);
    $this->travelTo(now()->startOfSecond());
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer, 50000000, now()->subDay());
    $accounts = app(CreditAccountRepository::class);
    $account = $accounts->open(['phone' => $customer->phone], 5000000, (string) Str::uuid(), null);
    expect($account->customer_id)->toBeNull();
    $this->travel(1)->days();
    purchaseCreditOrder($customer, 12000000);
    $this->travel(1)->days();
    $accounts->forCustomer($customer);
    expect(app(PurchaseCreditEligibility::class)->calculate($customer)['total'])->toBe(12000000)
        ->and(app(PurchaseCreditEligibility::class)->calculate($customer)['ceiling'])->toBe(6000000);
});

it('allocates the selected final credit without applying the term deduction twice', function () {
    purchaseCreditSettings(['amount_step' => 1000000]);
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer, 20000000);
    $workflow = app(PurchaseCreditWorkflow::class);
    expect(PurchaseCreditWorkflow::termMaximum(10000000, 2))->toBe(9000000);
    expect(fn () => $workflow->submit($customer, 10000000, [['path' => 'id.pdf', 'name' => 'id.pdf']], 2, true))->toThrow(ValidationException::class);
    $application = $workflow->submit($customer, 8000000, [['path' => 'id.pdf', 'name' => 'id.pdf']], 2, true);
    expect($application->requested_toman)->toBe(8000000)->and($application->netAmount())->toBe(8000000);
    $admin = $this->loginAsAdmin();
    $workflow->review($application->id, 'documents', [], $admin->id);
    $workflow->submitCheque($customer, $application->id, ['path' => 'cheque.pdf', 'name' => 'cheque.pdf']);
    $workflow->review($application->id, 'cheque', ['cheque_reference' => 'NET-'.$application->id, 'due_date' => now()->addMonths(2)->format('Y-m-d'), 'cheque_amount' => 8000000, 'sayad_confirmed' => 1], $admin->id);
    $workflow->review($application->id, 'activate', ['amount' => 8000000], $admin->id);
    expect(app(CreditAccountRepository::class)->forCustomer($customer)->balance_rial)->toBe(80000000);
});

it('configures the monthly deduction and keeps the submitted rate for later approval', function () {
    $admin = $this->loginAsAdmin();
    $settings = array_merge(PurchaseCreditSettings::defaults(), ['enabled' => 1, 'amount_step' => 1000000, 'monthly_deduction_percent' => 5, 'accounting_address' => 'Accounting']);
    post(route('admin.customers.credit.settings.save'), $settings)->assertRedirect();
    expect(PurchaseCreditWorkflow::termMaximum(10000000, 3))->toBe(9000000);
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer, 20000000);
    $workflow = app(PurchaseCreditWorkflow::class);
    $application = $workflow->submit($customer, 9000000, [['path' => 'id.pdf', 'name' => 'id.pdf']], 3, true);
    expect($application->monthly_deduction_percent)->toBe(5)->and($application->deductionPercent())->toBe(10);
    purchaseCreditSettings(['amount_step' => 1000000, 'monthly_deduction_percent' => 15]);
    $workflow->review($application->id, 'documents', [], $admin->id);
    $workflow->submitCheque($customer, $application->id, ['path' => 'cheque.pdf', 'name' => 'cheque.pdf']);
    $workflow->review($application->id, 'cheque', ['cheque_reference' => 'RATE-'.$application->id, 'due_date' => now()->addMonths(3)->format('Y-m-d'), 'cheque_amount' => 9000000, 'sayad_confirmed' => 1], $admin->id);
    $workflow->review($application->id, 'activate', ['amount' => 9000000], $admin->id);
    expect(app(CreditAccountRepository::class)->forCustomer($customer)->balance_rial)->toBe(90000000);
    foreach ([-1, 101, '5.5'] as $invalid) {
        postJson(route('admin.customers.credit.settings.save'), array_merge($settings, ['monthly_deduction_percent' => $invalid]))->assertUnprocessable()->assertJsonValidationErrorFor('monthly_deduction_percent');
    }
    purchaseCreditSettings(['monthly_deduction_percent' => 0]);
    expect(PurchaseCreditWorkflow::netAmount(10000000, 4))->toBe(10000000);
    purchaseCreditSettings(['monthly_deduction_percent' => 100]);
    expect(PurchaseCreditWorkflow::netAmount(10000000, 4))->toBe(0);
});

it('shows the requested final amount in the header after submission instead of the available ceiling', function () {
    purchaseCreditSettings(['amount_step' => 1000000]);
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer, 20000000);
    $this->actingAs($customer, 'customer');
    $before = get(route('shop.customers.account.credit.index'))->assertOk();
    preg_match('/class="pc-wizard__ceiling">(.*?)<\/div>/s', $before->getContent(), $header);
    expect($header[1])->toContain('10,000,000');
    app(PurchaseCreditWorkflow::class)->submit($customer, 7000000, [['path' => 'id.pdf', 'name' => 'id.pdf']], 2, true);
    $after = get(route('shop.customers.account.credit.index', ['step' => 3]))->assertOk();
    preg_match('/class="pc-wizard__ceiling">(.*?)<\/div>/s', $after->getContent(), $header);
    $after->assertSee('draftAmount: 7000000', false);
    expect($header[1])->toContain('draftAmount')->not->toContain('10,000,000')
        ->and($header[1])->toContain(trans('customer::purchase-credit.amount'));
});

it('replaces the rejected seven million request with the newly selected ten million without requiring uploads again', function () {
    purchaseCreditSettings(['amount_step' => 1000000]);
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer, 20000000);
    $workflow = app(PurchaseCreditWorkflow::class);
    $documents = [['path' => 'front.pdf', 'name' => 'front.pdf', 'type' => 'national_id_front'], ['path' => 'back.pdf', 'name' => 'back.pdf', 'type' => 'national_id_back']];
    $application = $workflow->submit($customer, 7000000, $documents, 4, true);
    $admin = $this->loginAsAdmin();
    $workflow->review($application->id, 'reject', ['reason' => 'kk'], $admin->id);
    $this->actingAs($customer, 'customer');
    post(route('shop.customers.account.credit.revise', $application->id), ['amount' => 10000000, 'repayment_months' => 1, 'accept_terms' => 1])->assertRedirect(route('shop.customers.account.credit.index', ['step' => 3]));
    expect($application->fresh()->requested_toman)->toBe(10000000)->and($application->fresh()->repayment_months)->toBe(1)
        ->and($application->fresh()->rejection_reason)->toBeNull()->and($application->fresh()->documents)->toEqual($documents)
        ->and($application->fresh()->status)->toBe('documents_pending');
    $page = get(route('shop.customers.account.credit.index'))->assertOk();
    preg_match('/class="pc-wizard__ceiling">(.*?)<\/div>/s', $page->getContent(), $header);
    $page->assertSee('draftAmount: 10000000', false);
    expect($header[1])->toContain('draftAmount')->not->toContain('7,000,000');
    $workflow->review($application->id, 'documents', [], $admin->id);
    postJson(route('shop.customers.account.credit.revise', $application->id), ['amount' => 9000000, 'repayment_months' => 1, 'accept_terms' => 1])->assertUnprocessable();
    $this->actingAs(purchaseCreditCustomer(), 'customer');
    postJson(route('shop.customers.account.credit.revise', $application->id), ['amount' => 9000000, 'repayment_months' => 1, 'accept_terms' => 1])->assertNotFound();
});

it('requires a new cheque review after changing the requested amount or term', function () {
    purchaseCreditSettings(['amount_step' => 1000000]);
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer, 20000000);
    $workflow = app(PurchaseCreditWorkflow::class);
    $application = $workflow->submit($customer, 7000000, [['path' => 'id.pdf', 'name' => 'id.pdf']], 4, true);
    $admin = $this->loginAsAdmin();
    $workflow->submitCheque($customer, $application->id, ['path' => 'cheque.pdf', 'name' => 'cheque.pdf']);
    $workflow->review($application->id, 'cheque', ['cheque_reference' => 'REVISE-'.$application->id, 'due_date' => now()->addMonths(4)->format('Y-m-d'), 'cheque_amount' => 7000000, 'sayad_confirmed' => 1], $admin->id);
    expect($application->fresh()->chequeApproved())->toBeTrue();
    $workflow->revise($customer, $application->id, 10000000, 1);
    expect($application->fresh()->chequeApproved())->toBeFalse()->and($application->fresh()->cheque_reference)->toBeNull();
});

it('paginates credit requests five at a time and preserves search and status filters', function () {
    $this->loginAsAdmin();
    $customer = purchaseCreditCustomer();
    $repository = app(PurchaseCreditApplicationRepository::class);
    $ids = [];
    for ($i = 0; $i < 6; $i++) {
        $ids[] = $repository->create(['customer_id' => $customer->id, 'requested_toman' => 5000000, 'ceiling_toman' => 5000000, 'status' => 'documents_pending', 'documents' => [], 'history' => []])->id;
    }
    $filters = ['q' => $customer->phone, 'status' => 'documents_pending'];
    $first = get(route('admin.customers.credit.applications', $filters))->assertOk();
    $first->assertViewHas('applications', fn ($pages) => $pages->perPage() === 5 && $pages->total() === 6 && $pages->pluck('id')->all() === array_reverse(array_slice($ids, 1)));
    $pages = $first->viewData('applications');
    expect($pages->nextPageUrl())->toContain('page=2')->toContain('q='.$customer->phone)->toContain('status=documents_pending');
    get(route('admin.customers.credit.applications', array_merge($filters, ['page' => 2])))->assertOk()
        ->assertViewHas('applications', fn ($pages) => $pages->currentPage() === 2 && $pages->pluck('id')->all() === [$ids[0]]);
});

it('uses the short credit URL by default and supports a custom SMS link in settings', function () {
    $this->loginAsAdmin();
    get(route('shop.credit.short'))->assertRedirect('/customer/account/credit');
    $settings = array_merge(PurchaseCreditSettings::defaults(), ['enabled' => 1, 'accounting_address' => 'Accounting', 'sms_link' => 'https://example.com/c']);
    post(route('admin.customers.credit.settings.save'), $settings)->assertRedirect();
    $customer = purchaseCreditCustomer();
    purchaseCreditOrder($customer);
    (new SendPurchaseCreditNotice($customer->id))->handle();
    $notice = app(PurchaseCreditNoticeRepository::class)->findOneByField('customer_id', $customer->id);
    expect($notice->message)->toContain('https://example.com/c');
    foreach (['javascript:alert(1)', '/bad-link'] as $link) {
        postJson(route('admin.customers.credit.settings.save'), array_merge($settings, ['sms_link' => $link]))->assertUnprocessable()->assertJsonValidationErrorFor('sms_link');
    }
    purchaseCreditSettings(['sms_link' => '']);
    $other = purchaseCreditCustomer();
    purchaseCreditOrder($other);
    (new SendPurchaseCreditNotice($other->id))->handle();
    expect(app(PurchaseCreditNoticeRepository::class)->findOneByField('customer_id', $other->id)->message)->toContain(route('shop.credit.short'));
});
