<?php

namespace Webkul\Shop\Http\Controllers\Customer\Account;

use Webkul\Customer\Repositories\CreditAccountRepository;
use Webkul\Shop\Http\Controllers\Controller;

class CreditController extends Controller
{
    public function index(CreditAccountRepository $accounts)
    {
        $account = $accounts->forCustomer(auth()->guard('customer')->user());
        $transactions = $account?->transactions()->where('amount_rial', '!=', 0)->latest('id')->paginate(20);

        return view('shop::customers.account.credit.index', compact('account', 'transactions'));
    }

    public function verify()
    {
        $customer = auth()->guard('customer')->user();
        $redirectTo = request('redirect_to', '/customer/account/credit');
        if (! is_string($redirectTo) || ! str_starts_with($redirectTo, '/') || str_starts_with($redirectTo, '//')) {
            $redirectTo = '/customer/account/credit';
        }

        return view('shop::customers.account.credit.verify', compact('customer', 'redirectTo'));
    }
}
