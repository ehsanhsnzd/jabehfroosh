<x-admin::layouts>
    <x-slot:title>@lang('customer::credit.title')</x-slot>
    <div class="mb-6 flex items-center justify-between gap-4">
        <h1 class="text-xl font-bold">@lang('customer::credit.title')</h1>
        @if (bouncer()->hasPermission('customers.credit.report'))
            <a class="secondary-button" href="{{ route('admin.customers.credit.report') }}">@lang('customer::credit.report')</a>
        @endif
    </div>
    @include('admin::customers.credit.errors')
    <div class="mb-6 grid grid-cols-2 gap-4">
        <div class="rounded bg-white p-5 dark:bg-gray-900"><p class="text-sm text-gray-500">@lang('customer::credit.accounts')</p><strong class="text-2xl">{{ $stats['count'] }}</strong></div>
        <div class="rounded bg-white p-5 dark:bg-gray-900"><p class="text-sm text-gray-500">@lang('customer::credit.balance')</p><strong class="text-2xl">{{ \Webkul\Customer\Helpers\CreditIdentity::toman($stats['balance']) }}</strong> @lang('customer::credit.toman')</div>
    </div>
    <form method="GET" class="mb-5 flex flex-wrap gap-3">
        <input name="q" value="{{ request('q') }}" maxlength="100" class="min-w-0 flex-1 rounded border px-3 py-2 dark:bg-gray-900" placeholder="{{ trans('customer::credit.search') }}" aria-label="{{ trans('customer::credit.search') }}">
        <select name="status" class="rounded border px-3 py-2 dark:bg-gray-900" aria-label="{{ trans('customer::credit.status') }}">
            <option value="">@lang('customer::credit.all')</option>
            @foreach (['active','frozen','linked','pending'] as $status)<option value="{{ $status }}" @selected(request('status') === $status)>@lang('customer::credit.'.$status)</option>@endforeach
        </select>
        <button class="secondary-button">@lang('customer::credit.filter')</button>
    </form>
    <div class="overflow-x-auto rounded bg-white dark:bg-gray-900">
        <table class="w-full text-start text-sm">
            <thead><tr class="border-b text-start">
                @foreach (['phone','holder','balance','status','date','details'] as $label)<th class="p-4 text-start">@lang('customer::credit.'.$label)</th>@endforeach
            </tr></thead>
            <tbody>
                @forelse ($accounts as $account)
                    <tr class="border-b">
                        <td class="p-4"><a class="text-blue-600" href="{{ route('admin.customers.credit.show', $account->id) }}" dir="ltr">{{ $account->phone }}</a></td>
                        <td class="p-4">{{ $account->holder_name ?: $account->customer?->name ?: '—' }}</td>
                        <td class="p-4 whitespace-nowrap">{{ \Webkul\Customer\Helpers\CreditIdentity::toman($account->balance_rial) }} @lang('customer::credit.toman')</td>
                        <td class="p-4">@lang('customer::credit.'.($account->is_active ? 'active' : 'frozen'))<br><small class="text-gray-500">@lang('customer::credit.'.($account->customer_id ? 'linked' : 'pending'))</small></td>
                        <td class="p-4 whitespace-nowrap">{{ $account->created_at->format('Y-m-d H:i') }}</td>
                        <td class="p-4"><a class="text-blue-600" href="{{ route('admin.customers.credit.show', $account->id) }}">@lang('customer::credit.details')</a></td>
                    </tr>
                @empty<tr><td colspan="6" class="p-6 text-center">@lang('customer::credit.empty')</td></tr>@endforelse
            </tbody>
        </table>
    </div>
    <div class="my-4">{{ $accounts->links() }}</div>
    @if (bouncer()->hasPermission('customers.credit.create'))
        <details class="mt-6 rounded bg-white p-5 dark:bg-gray-900" @if($errors->any()) open @endif>
            <summary class="cursor-pointer text-base font-semibold">@lang('customer::credit.create')</summary>
            <form method="POST" action="{{ route('admin.customers.credit.store') }}" class="mt-5 max-w-xl">
                @csrf
                <input type="hidden" name="request_key" value="{{ old('request_key', (string) \Illuminate\Support\Str::uuid()) }}">
                <label class="mb-4 grid gap-2 text-sm">@lang('customer::credit.phone')<input type="tel" name="phone" value="{{ old('phone') }}" required class="rounded border px-3 py-2 dark:bg-gray-900" dir="ltr" placeholder="09123456789"></label>
                <label class="mb-4 grid gap-2 text-sm">@lang('customer::credit.opening') (@lang('customer::credit.toman'))<input name="opening_amount" value="{{ old('opening_amount', 0) }}" inputmode="numeric" required class="rounded border px-3 py-2 dark:bg-gray-900"></label>
                @include('admin::customers.credit.profile-fields', ['account' => null])
                <button class="primary-button">@lang('customer::credit.create')</button>
            </form>
        </details>
    @endif
</x-admin::layouts>
