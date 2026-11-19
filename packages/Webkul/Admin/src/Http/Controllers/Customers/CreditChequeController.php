<?php

namespace Webkul\Admin\Http\Controllers\Customers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Webkul\Admin\Http\Controllers\Controller;
use Webkul\Customer\Helpers\CreditIdentity;
use Webkul\Customer\Repositories\CreditChequeRepository;
use Webkul\Customer\Repositories\CustomerRepository;

class CreditChequeController extends Controller
{
    public function index(Request $request, CreditChequeRepository $cheques)
    {
        $query = $this->query($request, $cheques);
        $stats = ['amount' => (int) (clone $query)->sum('amount_toman'), 'allocated' => (int) (clone $query)->sum('allocated_toman'), 'overdue' => (clone $query)->whereIn('status', ['registered', 'received'])->whereDate('due_date', '<', today())->count(), 'count' => (clone $query)->count()];
        $cheques = $query->with('customer')->orderBy('due_date')->orderByDesc('id')->paginate(25)->withQueryString();

        return view('admin::customers.credit.cheques.index', compact('cheques', 'stats'));
    }

    public function create()
    {
        $selectedCustomer = app(CustomerRepository::class)->getModel()->newQuery()->find((int) old('customer_id', request('customer_id', 0)));

        return view('admin::customers.credit.cheques.form', ['cheque' => null, 'selectedCustomer' => $selectedCustomer]);
    }

    public function customers(Request $request, CustomerRepository $customers)
    {
        $request->validate(['q' => 'required|string|min:2|max:100']);
        $q = $request->input('q');

        return response()->json($customers->getModel()->newQuery()->where(fn ($query) => $query->whereRaw("CONCAT_WS(' ', first_name, last_name) LIKE ?", ['%'.$q.'%'])->orWhere('phone', 'like', '%'.CreditIdentity::phone($q).'%'))->limit(20)->get(['id', 'first_name', 'last_name', 'phone']));
    }

    public function store(Request $request, CreditChequeRepository $cheques)
    {
        $data = $request->validate(['customer_id' => 'required|integer|exists:customers,id', 'request_key' => 'required|uuid', 'reference' => 'required|string|max:100', 'sayad_id' => 'nullable|digits:16', 'document' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:5120'] + $this->rules());
        $data['sayad_confirmed'] = $request->boolean('sayad_confirmed');
        $document = null;
        if ($request->hasFile('document')) {
            $file = $request->file('document');
            $document = ['path' => $file->store('credit-cheques', 'private'), 'name' => basename($file->getClientOriginalName()), 'type' => 'cheque'];
        }
        $data['document'] = $document;
        try {
            $cheque = DB::transaction(function () use ($request, $data, $cheques) {
                $cheque = $cheques->register($data, auth()->guard('admin')->id());
                if ($request->boolean('allocate')) {
                    abort_unless(bouncer()->hasPermission('customers.credit_cheques.allocate'), 401);
                    $request->validate(['credit_amount' => 'required|integer|min:1|max:1000000000000']);
                    $cheque = $cheques->allocate($cheque->id, $request->integer('credit_amount'), auth()->guard('admin')->id());
                }

                return $cheque;
            });
        } catch (\Throwable $exception) {
            if ($document) {
                Storage::disk('private')->delete($document['path']);
            }
            throw $exception;
        }
        if ($document && ($cheque->document['path'] ?? null) !== $document['path']) {
            Storage::disk('private')->delete($document['path']);
        }

        return redirect()->route('admin.customers.cheques.show', $cheque->id)->with('success', trans('customer::purchase-credit.saved'));
    }

    public function show(int $id, CreditChequeRepository $cheques)
    {
        $cheque = $cheques->with('customer')->findOrFail($id);

        return view('admin::customers.credit.cheques.form', compact('cheque'));
    }

    public function update(Request $request, int $id, CreditChequeRepository $cheques)
    {
        $data = $request->validate($this->rules());
        $data['sayad_confirmed'] = $request->boolean('sayad_confirmed');
        $cheques->revise($id, $data, auth()->guard('admin')->id());

        return back()->with('success', trans('customer::purchase-credit.saved'));
    }

    public function allocate(Request $request, int $id, CreditChequeRepository $cheques)
    {
        $request->validate(['credit_amount' => 'required|integer|min:1|max:1000000000000']);
        $cheques->allocate($id, $request->integer('credit_amount'), auth()->guard('admin')->id());

        return back()->with('success', trans('customer::purchase-credit.saved'));
    }

    public function document(int $id, CreditChequeRepository $cheques)
    {
        $file = $cheques->findOrFail($id)->document;
        abort_unless($file && Storage::disk('private')->exists($file['path']), 404);

        return Storage::disk('private')->download($file['path'], $file['name'], ['Cache-Control' => 'no-store, private']);
    }

    public function export(Request $request, CreditChequeRepository $cheques)
    {
        $query = $this->query($request, $cheques);

        return response()->streamDownload(function () use ($query) {
            $stream = fopen('php://output', 'w');
            fwrite($stream, "\xEF\xBB\xBF");
            fputcsv($stream, ['ID', 'Customer', 'Phone', 'Company', 'Reference', 'Due date', 'Amount Toman', 'Sayad confirmed', 'Status', 'Allocated Toman']);
            $query->with('customer')->chunkById(250, function ($rows) use ($stream) {
                foreach ($rows as $row) {
                    $safe = fn ($value) => preg_match('/^[\s\x00]*[=+@\-]/u', (string) $value) ? "'".$value : $value;
                    fputcsv($stream, [$row->id, $safe($row->customer?->name), "'".$row->customer?->phone, $safe($row->company_name), $safe($row->reference), $row->due_date->format('Y-m-d'), $row->amount_toman, (int) $row->sayad_confirmed, $row->status, $row->allocated_toman]);
                }
            });
            fclose($stream);
        }, 'credit-cheques-'.now()->format('Ymd').'.csv', ['Content-Type' => 'text/csv; charset=UTF-8', 'Cache-Control' => 'no-store, private']);
    }

    private function rules(): array
    {
        return ['due_date' => 'required|date_format:Y-m-d', 'amount_toman' => 'required|integer|min:1|max:1000000000000', 'sayad_confirmed' => 'sometimes|boolean', 'company_name' => 'nullable|string|max:255', 'bank_name' => 'nullable|string|max:100', 'status' => 'required|in:registered,received,cleared,returned,canceled', 'notes' => 'nullable|string|max:5000'];
    }

    private function query(Request $request, CreditChequeRepository $cheques)
    {
        $request->validate(['q' => 'nullable|string|max:100', 'company' => 'nullable|string|max:255', 'from' => 'nullable|date_format:Y-m-d', 'to' => 'nullable|date_format:Y-m-d'.($request->filled('from') ? '|after_or_equal:from' : ''), 'min' => 'nullable|integer|min:0', 'max' => 'nullable|integer|min:0'.($request->filled('min') ? '|gte:min' : ''), 'sayad' => 'nullable|in:0,1', 'status' => 'nullable|in:registered,received,cleared,returned,canceled']);
        $query = $cheques->getModel()->newQuery();
        if ($request->filled('q')) {
            $q = $request->input('q');
            $phone = CreditIdentity::phone($q);
            $query->where(fn ($query) => $query->where('company_name', 'like', '%'.$q.'%')->orWhere('reference_hash', hash('sha256', CreditChequeRepository::normalizeReference($q)))->orWhereHas('customer', fn ($customer) => $customer->whereRaw("CONCAT_WS(' ', first_name, last_name) LIKE ?", ['%'.$q.'%'])->orWhere('phone', 'like', '%'.$phone.'%')));
        }
        foreach (['from' => ['due_date', '>='], 'to' => ['due_date', '<='], 'min' => ['amount_toman', '>='], 'max' => ['amount_toman', '<=']] as $key => [$field, $operator]) {
            if ($request->filled($key)) {
                $query->where($field, $operator, $request->input($key));
            }
        }
        if ($request->filled('company')) {
            $query->where('company_name', 'like', '%'.$request->input('company').'%');
        }
        if ($request->filled('sayad')) {
            $query->where('sayad_confirmed', $request->input('sayad'));
        }
        if ($request->filled('status')) {
            $query->where('status', $request->input('status'));
        }

        return $query;
    }
}
