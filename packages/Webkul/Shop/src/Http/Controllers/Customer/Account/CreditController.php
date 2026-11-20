<?php

namespace Webkul\Shop\Http\Controllers\Customer\Account;

use Webkul\Customer\Helpers\CreditIdentity;
use Webkul\Customer\Helpers\PurchaseCreditEligibility;
use Webkul\Customer\Helpers\PurchaseCreditSettings;
use Webkul\Customer\Repositories\CreditAccountRepository;
use Webkul\Customer\Repositories\PurchaseCreditApplicationRepository;
use Webkul\Shop\Http\Controllers\Controller;

class CreditController extends Controller
{
    public function index(CreditAccountRepository $accounts)
    {
        $account = $accounts->forCustomer(auth()->guard('customer')->user());
        $transactions = $account?->transactions()->where('amount_rial', '!=', 0)->latest('id')->paginate(20);
        $customer = auth()->guard('customer')->user();
        $purchaseSettings = PurchaseCreditSettings::all();
        $eligibility = app(PurchaseCreditEligibility::class)->calculate($customer);
        $application = app(PurchaseCreditApplicationRepository::class)->getModel()->newQuery()
            ->where('customer_id', $customer->id)->latest('id')->first();
        if (request()->boolean('new') && $application?->status === 'active') {
            $application = null;
        }

        return view('shop::customers.account.credit.index', compact('account', 'transactions', 'customer', 'purchaseSettings', 'eligibility', 'application'));
    }

    public function verify()
    {
        $customer = auth()->guard('customer')->user();
        $phone = CreditIdentity::phone((string) $customer->phone);

        if (! preg_match('/^09\d{9}$/', $phone)) {
            return redirect()->route('shop.customers.account.profile.edit')
                ->with('error', trans('customer::credit.completePhone'));
        }

        $redirectTo = request('redirect_to', '/customer/account/credit');
        if (! is_string($redirectTo) || ! str_starts_with($redirectTo, '/') || str_starts_with($redirectTo, '//')) {
            $redirectTo = '/customer/account/credit';
        }

        return view('shop::customers.account.credit.verify', compact('customer', 'phone', 'redirectTo'));
    }
}
