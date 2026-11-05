<x-admin::layouts>
    <x-slot:title>@lang('customer::credit.title') — {{ $account->phone }}</x-slot>
    <div class="mb-6 flex flex-wrap items-center justify-between gap-3">
        <h1 class="text-xl font-bold">@lang('customer::credit.title') <span dir="ltr">{{ $account->phone }}</span></h1>
        <a class="secondary-button" href="{{ route('admin.customers.credit.index') }}">@lang('customer::credit.back')</a>
    </div>
    @include('admin::customers.credit.errors')
    <div class="mb-6 rounded bg-white p-5 dark:bg-gray-900">
        <p class="text-sm text-gray-500">@lang('customer::credit.balance')</p>
        <strong class="text-3xl">{{ \Webkul\Customer\Helpers\CreditIdentity::toman($account->balance_rial) }}</strong> @lang('customer::credit.toman')
        <p class="mt-3 text-sm">@lang('customer::credit.'.($account->is_active ? 'active' : 'frozen')) — @lang('customer::credit.'.($account->customer_id ? 'linked' : 'pending')) {{ $account->customer?->name }}</p>
    </div>
    <div class="mb-6 grid gap-5 lg:grid-cols-2">
        @if (bouncer()->hasPermission('customers.credit.adjust'))
            <form method="POST" action="{{ route('admin.customers.credit.adjust', $account->id) }}" class="rounded bg-white p-5 dark:bg-gray-900">
                @csrf
                <h2 class="mb-4 font-semibold">@lang('customer::credit.adjust')</h2>
                <input type="hidden" name="request_key" value="{{ old('request_key', (string) \Illuminate\Support\Str::uuid()) }}">
                <label class="mb-4 grid gap-2 text-sm">@lang('customer::credit.type')<select name="direction" required class="rounded border px-3 py-2 dark:bg-gray-900"><option value="increase" @selected(old('direction') === 'increase')>@lang('customer::credit.increase')</option><option value="decrease" @selected(old('direction') === 'decrease')>@lang('customer::credit.decrease')</option></select></label>
                <label class="mb-4 grid gap-2 text-sm">@lang('customer::credit.amount')<input name="amount" inputmode="numeric" required value="{{ old('amount') }}" class="rounded border px-3 py-2 dark:bg-gray-900"></label>
                <label class="mb-4 grid gap-2 text-sm">@lang('customer::credit.reason')<textarea name="reason" required minlength="3" maxlength="1000" class="rounded border px-3 py-2 dark:bg-gray-900">{{ old('reason') }}</textarea></label>
                <label class="mb-4 grid gap-2 text-sm">@lang('customer::credit.reference')<input name="reference" value="{{ old('reference') }}" maxlength="150" class="rounded border px-3 py-2 dark:bg-gray-900"></label>
                <button class="primary-button">@lang('customer::credit.save')</button>
            </form>
        @endif
        @if (bouncer()->hasPermission('customers.credit.edit'))
            <details class="rounded bg-white p-5 dark:bg-gray-900">
                <summary class="cursor-pointer font-semibold">@lang('customer::credit.profile')</summary>
                <form method="POST" action="{{ route('admin.customers.credit.update', $account->id) }}" class="mt-5">
                    @csrf @method('PUT')
                    @include('admin::customers.credit.profile-fields')
                    <button class="primary-button">@lang('customer::credit.save')</button>
                </form>
            </details>
        @endif
    </div>
    <h2 class="mb-4 text-lg font-semibold">@lang('customer::credit.transactions') (@lang('customer::credit.toman'))</h2>
    @if (bouncer()->hasPermission('customers.credit.report'))
        <a class="secondary-button mb-4" href="{{ route('admin.customers.credit.report', ['account' => $account->id]) }}">@lang('customer::credit.report')</a>
    @endif
    @include('admin::customers.credit.transactions')
</x-admin::layouts>
