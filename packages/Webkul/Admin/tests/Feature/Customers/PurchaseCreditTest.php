<?php

use App\Services\CustomerOtpSms;
use Carbon\Carbon;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Bus;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;
use Webkul\Core\Models\CoreConfig;
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
    get(route('shop.customers.account.credit.index'))->assertOk()->assertSee('v-purchase-credit-amount', false)->assertSee('name="national_id_front"', false)->assertSee('name="national_id_back"', false);
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
    postJson(route('shop.customers.account.credit.cheque', $application->id), ['cheque' => UploadedFile::fake()->create('cheque.pdf', 10, 'application/pdf'), 'cheque_sent' => 1])->assertUnprocessable();
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
