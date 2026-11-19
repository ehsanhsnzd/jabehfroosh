<?php

namespace Webkul\Admin\Http\Controllers\Customers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Webkul\Admin\Http\Controllers\Controller;
use Webkul\Core\Repositories\CoreConfigRepository;
use Webkul\Customer\Helpers\PurchaseCreditSettings;
use Webkul\Customer\Helpers\PurchaseCreditWorkflow;
use Webkul\Customer\Repositories\PurchaseCreditApplicationRepository;
use Webkul\Customer\Repositories\PurchaseCreditNoticeRepository;

class PurchaseCreditController extends Controller
{
    public function index(Request $request, PurchaseCreditApplicationRepository $applications, PurchaseCreditNoticeRepository $notices)
    {
        $request->validate(['q' => 'nullable|string|max:100', 'status' => 'nullable|in:documents_pending,cheque_pending,allocation_pending,rejected,active']);
        $query = $applications->getModel()->newQuery()->with('customer');
        if ($request->filled('status')) {
            $query->where('status', $request->input('status'));
        }
        if ($request->filled('q')) {
            $q = $request->input('q');
            $query->whereHas('customer', fn ($customer) => $customer->where('phone', 'like', '%'.$q.'%')->orWhere('first_name', 'like', '%'.$q.'%')->orWhere('last_name', 'like', '%'.$q.'%'));
        }
        $applications = $query->latest('id')->paginate(20)->withQueryString();
        $notices = $notices->getModel()->newQuery()->with('customer')->latest('id')->paginate(20, ['*'], 'notice_page');

        return view('admin::customers.credit.applications', compact('applications', 'notices'));
    }

    public function settings()
    {
        $settings = PurchaseCreditSettings::all();

        return view('admin::customers.credit.purchase-settings', compact('settings'));
    }

    public function saveSettings(Request $request)
    {
        $data = $request->validate([
            'factor' => 'required|numeric|min:0|max:1|decimal:0,4', 'months' => 'required|integer|min:1|max:120',
            'minimum_amount' => 'required|integer|min:1|max:1000000000000',
            'instructions' => 'required|string|max:10000', 'accounting_address' => 'nullable|string|max:3000|required_if:enabled,1',
            'offer_text' => 'required|string|max:1000', 'marketing_text' => 'required|string|max:1000',
            'send_hour' => 'required|integer|min:0|max:23',
            'reminder_days' => 'required|integer|min:1|max:365',
            'reminder_limit' => 'required|integer|min:0|max:100',
        ]);
        foreach (['enabled', 'marketing_enabled', 'sms_testing'] as $field) {
            $data[$field] = $request->boolean($field);
        }
        foreach (['offer_text', 'marketing_text'] as $field) {
            validator([$field => $data[$field]], [$field => function ($attribute, $value, $fail) {
                if (! str_contains($value, '{amount}')) {
                    $fail(trans('customer::purchase-credit.amountPlaceholder'));
                }
            }])->validate();
        }
        DB::transaction(function () use ($data) {
            foreach ($data as $key => $value) {
                app(CoreConfigRepository::class)->getModel()->newQuery()->updateOrCreate([
                    'code' => 'customer.purchase_credit.'.$key, 'channel_code' => null, 'locale_code' => null,
                ], ['value' => is_bool($value) ? (int) $value : $value]);
            }
        });

        return back()->with('success', trans('customer::purchase-credit.saved'));
    }

    public function review(Request $request, int $id, PurchaseCreditWorkflow $workflow)
    {
        $request->validate(['action' => 'required|in:documents,cheque,reject,activate']);
        $workflow->review($id, $request->input('action'), $request->only('amount', 'cheque_reference', 'reason', 'due_date', 'cheque_amount', 'sayad_confirmed', 'company_name', 'bank_name'), auth()->guard('admin')->id());

        return back()->with('success', trans('customer::purchase-credit.saved'));
    }

    public function document(int $id, int $index, PurchaseCreditApplicationRepository $applications)
    {
        $application = $applications->findOrFail($id);
        $file = $application->documents[$index] ?? null;
        abort_unless($file && Storage::disk('private')->exists($file['path']), 404);

        return Storage::disk('private')->download($file['path'], $file['name'], ['Cache-Control' => 'no-store, private']);
    }
}
