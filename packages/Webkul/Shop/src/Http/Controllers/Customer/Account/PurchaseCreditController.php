<?php

namespace Webkul\Shop\Http\Controllers\Customer\Account;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Webkul\Customer\Helpers\CreditDocumentStorage;
use Webkul\Customer\Helpers\PurchaseCreditSettings;
use Webkul\Customer\Helpers\PurchaseCreditWorkflow;
use Webkul\Customer\Repositories\PurchaseCreditApplicationRepository;
use Webkul\Shop\Http\Controllers\Controller;

class PurchaseCreditController extends Controller
{
    public function store(Request $request, PurchaseCreditWorkflow $workflow)
    {
        $request->validate([
            'amount' => 'required|integer|min:'.PurchaseCreditSettings::minimumAmount().'|max:1000000000000',
            'accept_terms' => 'accepted',
            'repayment_months' => 'sometimes|required|integer|min:1|max:4',
            'national_id_front' => 'required|file|mimes:pdf,jpg,jpeg,png|max:20480',
            'national_id_back' => 'required|file|mimes:pdf,jpg,jpeg,png|max:20480',
        ]);
        $customer = auth()->guard('customer')->user();
        $files = [];
        try {
            foreach (['national_id_front', 'national_id_back'] as $side) {
                $files[] = app(CreditDocumentStorage::class)->store($request->file($side), $customer->id, $side);
            }
            $workflow->submit($customer, $request->integer('amount'), $files, $request->integer('repayment_months', 1), true);
        } catch (\Throwable $exception) {
            foreach ($files as $file) {
                Storage::disk('private')->delete($file['path']);
            }
            throw $exception;
        }

        return redirect()->route('shop.customers.account.credit.index', ['step' => 3])->with('success', trans('customer::purchase-credit.saved'));
    }

    public function revise(Request $request, int $id, PurchaseCreditWorkflow $workflow)
    {
        $request->validate([
            'amount' => 'required|integer|min:1|max:1000000000000',
            'repayment_months' => 'required|integer|min:1|max:4',
            'accept_terms' => 'accepted',
        ]);
        $workflow->revise(auth()->guard('customer')->user(), $id, $request->integer('amount'), $request->integer('repayment_months'));

        return redirect()->route('shop.customers.account.credit.index', ['step' => 3])->with('success', trans('customer::purchase-credit.saved'));
    }

    public function cheque(Request $request, int $id, PurchaseCreditWorkflow $workflow)
    {
        $request->validate(['cheque' => 'required|file|mimes:pdf,jpg,jpeg,png|max:5120', 'cheque_sent' => 'accepted']);
        $customer = auth()->guard('customer')->user();
        $file = $request->file('cheque');
        $document = ['path' => $file->store('credit-applications/'.$customer->id, 'private'), 'name' => basename($file->getClientOriginalName()), 'type' => 'cheque'];
        try {
            $workflow->submitCheque($customer, $id, $document);
        } catch (\Throwable $exception) {
            Storage::disk('private')->delete($document['path']);
            throw $exception;
        }

        return redirect()->route('shop.customers.account.credit.index', ['step' => 3])->with('success', trans('customer::purchase-credit.saved'));
    }

    public function document(int $id, int $index, PurchaseCreditApplicationRepository $applications)
    {
        $application = $applications->findOrFail($id);
        abort_unless($application->customer_id === auth()->guard('customer')->id(), 404);
        $file = $application->documents[$index] ?? null;
        abort_unless($file && Storage::disk('private')->exists($file['path']), 404);

        return Storage::disk('private')->download($file['path'], $file['name'], ['Cache-Control' => 'no-store, private']);
    }
}
