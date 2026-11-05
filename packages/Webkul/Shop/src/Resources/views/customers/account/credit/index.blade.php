<x-shop::layouts.account>
    <x-slot:title>@lang('customer::credit.myCredit')</x-slot>
    <div class="max-md:hidden"><x-shop::layouts.account.navigation /></div>
    <div class="mx-4 min-w-0 flex-auto">
        <h1 class="mb-6 text-2xl font-semibold">@lang('customer::credit.myCredit')</h1>
        @if (! auth()->guard('customer')->user()->credit_phone_verified_at || auth()->guard('customer')->user()->credit_verified_phone !== \Webkul\Customer\Helpers\CreditIdentity::phone((string) auth()->guard('customer')->user()->phone))
            <p class="mb-4">@lang('customer::credit.verifyHelp')</p>
            <a class="primary-button" href="{{ route('shop.customers.account.credit.verify') }}">@lang('customer::credit.verify')</a>
        @else
            <div class="mb-6 rounded-xl border p-5"><p>@lang('customer::credit.balance')</p><strong class="text-3xl">{{ \Webkul\Customer\Helpers\CreditIdentity::toman($account?->balance_rial ?? 0) }}</strong> @lang('customer::credit.toman')</div>
            @if ($account && ! $account->is_active)<p class="mb-4 text-red-600">@lang('customer::credit.inactiveHelp')</p>@endif
            <p class="mb-5 text-sm">@lang('customer::credit.fullPayment')</p>
            <div class="overflow-x-auto"><table class="w-full text-sm"><thead><tr>@foreach(['date','type','amount','balanceAfter'] as $label)<th class="border-b p-3 text-start">@lang('customer::credit.'.$label)</th>@endforeach</tr></thead><tbody>
                @forelse ($transactions ?? [] as $entry)<tr><td class="border-b p-3">{{ $entry->created_at->format('Y-m-d H:i') }}</td><td class="border-b p-3">@lang('customer::credit.'.$entry->kind)</td><td class="border-b p-3" dir="ltr">{{ \Webkul\Customer\Helpers\CreditIdentity::toman($entry->amount_rial) }}</td><td class="border-b p-3" dir="ltr">{{ \Webkul\Customer\Helpers\CreditIdentity::toman($entry->balance_after_rial) }}</td></tr>@empty<tr><td colspan="4" class="p-5">@lang('customer::credit.empty')</td></tr>@endforelse
            </tbody></table></div>
            @if ($transactions)<div class="mt-4">{{ $transactions->links() }}</div>@endif
        @endif
    </div>
</x-shop::layouts.account>
