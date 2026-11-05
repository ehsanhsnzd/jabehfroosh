<?php

namespace Webkul\Admin\Http\Controllers\Customers;

use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Webkul\Admin\Http\Controllers\Controller;
use Webkul\Admin\Http\Requests\CustomerCreditRequest;
use Webkul\Customer\Helpers\CreditIdentity;
use Webkul\Customer\Repositories\CreditAccountRepository;
use Webkul\Customer\Repositories\CreditTransactionRepository;
use Webkul\Customer\Repositories\CustomerRepository;

class CreditController extends Controller
{
    public function __construct(protected CreditAccountRepository $accounts, protected CreditTransactionRepository $transactions) {}

    public function index(Request $request)
    {
        $request->validate(['q' => 'nullable|string|max:100', 'status' => ['nullable', Rule::in(['active', 'frozen', 'linked', 'pending'])]]);
        $query = $this->accounts->getModel()->newQuery()->with('customer');
        if ($q = trim((string) $request->input('q'))) {
            $phone = CreditIdentity::phone($q);
            $query->where(fn ($query) => $query->where('phone', 'like', '%'.$phone.'%')->orWhere('holder_name', 'like', '%'.$q.'%')->orWhere('iban_last_four', $q)->orWhereHas('customer', fn ($query) => $query->where('first_name', 'like', '%'.$q.'%')->orWhere('last_name', 'like', '%'.$q.'%')));
        }
        match ($request->input('status')) {
            'active' => $query->where('is_active', true),
            'frozen' => $query->where('is_active', false),
            'linked' => $query->whereNotNull('customer_id'),
            'pending' => $query->whereNull('customer_id'),
            default => null,
        };

        $stats = ['count' => (clone $query)->count(), 'balance' => (int) (clone $query)->sum('balance_rial')];
        $accounts = $query->latest('id')->paginate(25)->withQueryString();

        return view('admin::customers.credit.index', compact('accounts', 'stats'));
    }

    public function store(CustomerCreditRequest $request)
    {
        $account = $this->accounts->open(array_merge($request->only('phone'), $this->profileData($request)), (int) $request->input('opening_amount', 0), $request->input('request_key'), auth()->guard('admin')->id());
        $customer = app(CustomerRepository::class)->findOneByField('credit_verified_phone', $account->phone);
        if ($customer) {
            $this->accounts->forCustomer($customer);
        }

        return redirect()->route('admin.customers.credit.show', $account->id)->with('success', trans('customer::credit.saved'));
    }

    public function show(int $id)
    {
        $account = $this->accounts->with('customer')->findOrFail($id);
        $transactions = $account->transactions()->with(['order', 'admin'])->latest('id')->paginate(30)->withQueryString();

        return view('admin::customers.credit.show', compact('account', 'transactions'));
    }

    public function update(CustomerCreditRequest $request, int $id)
    {
        $this->accounts->profile($id, $this->profileData($request), auth()->guard('admin')->id());

        return back()->with('success', trans('customer::credit.saved'));
    }

    public function adjust(CustomerCreditRequest $request, int $id)
    {
        $this->accounts->adjust($id, (int) $request->input('amount'), $request->input('direction'), $request->input('request_key'), $request->input('reason'), $request->input('reference'), auth()->guard('admin')->id());

        return redirect()->route('admin.customers.credit.show', $id)->with('success', trans('customer::credit.saved'));
    }

    public function report(Request $request)
    {
        $query = $this->reportQuery($request);
        $stats = [
            'credit' => (int) (clone $query)->where('amount_rial', '>', 0)->sum('amount_rial'),
            'debit' => -(int) (clone $query)->where('amount_rial', '<', 0)->sum('amount_rial'),
            'count' => (clone $query)->count(),
        ];
        $transactions = $query->with(['account', 'order', 'admin'])->latest('id')->paginate(50)->withQueryString();

        return view('admin::customers.credit.report', compact('transactions', 'stats'));
    }

    public function export(Request $request)
    {
        $query = $this->reportQuery($request);

        return response()->streamDownload(function () use ($query) {
            $stream = fopen('php://output', 'w');
            fwrite($stream, "\xEF\xBB\xBF");
            fputcsv($stream, ['ID', 'Phone', 'Type', 'Amount (Toman)', 'Balance (Toman)', 'Order', 'Admin', 'Reference', 'Reason', 'Date']);
            $query->with(['account', 'order', 'admin'])->chunkById(500, function ($rows) use ($stream) {
                foreach ($rows as $row) {
                    $safe = fn ($value) => preg_match('/^[\s\x00]*[=+@\-]/u', (string) $value) ? "'".$value : $value;
                    fputcsv($stream, [$row->id, "'".$row->account->phone, $row->kind, str_replace(',', '', CreditIdentity::toman($row->amount_rial)), str_replace(',', '', CreditIdentity::toman($row->balance_after_rial)), $safe($row->order?->increment_id), $safe($row->admin?->name), $safe($row->reference), $safe($row->reason), $row->created_at->toIso8601String()]);
                }
            });
            fclose($stream);
        }, 'customer-credit-'.now()->format('Ymd-His').'.csv', ['Content-Type' => 'text/csv; charset=UTF-8', 'Cache-Control' => 'no-store, private']);
    }

    private function reportQuery(Request $request)
    {
        $request->validate([
            'q' => 'nullable|string|max:100',
            'account' => 'nullable|integer|min:1',
            'kind' => ['nullable', Rule::in(['manual_credit', 'manual_debit', 'purchase', 'refund', 'cancel', 'profile', 'claim'])],
            'from' => 'nullable|date_format:Y-m-d',
            'to' => 'nullable|date_format:Y-m-d',
        ]);
        $query = $this->transactions->getModel()->newQuery();
        if ($request->filled('account')) {
            $query->where('credit_account_id', $request->integer('account'));
        }
        if ($request->filled('kind')) {
            $query->where('kind', $request->input('kind'));
        }
        if ($request->filled('from')) {
            $query->where('created_at', '>=', $request->input('from').' 00:00:00');
        }
        if ($request->filled('to')) {
            $query->where('created_at', '<=', $request->input('to').' 23:59:59');
        }
        if ($q = trim((string) $request->input('q'))) {
            $query->where(fn ($query) => $query->where('reference', 'like', '%'.$q.'%')->orWhere('reason', 'like', '%'.$q.'%')->orWhereHas('account', fn ($query) => $query->where('phone', 'like', '%'.CreditIdentity::phone($q).'%')->orWhere('holder_name', 'like', '%'.$q.'%')->orWhere('iban_last_four', $q))->orWhereHas('order', fn ($query) => $query->where('increment_id', $q)));
        }

        return $query;
    }

    private function profileData(Request $request): array
    {
        return array_merge($request->only('holder_name', 'iban', 'notes'), ['is_active' => $request->boolean('is_active'), 'iban_last_four' => $request->input('iban') ? substr($request->input('iban'), -4) : null]);
    }
}
