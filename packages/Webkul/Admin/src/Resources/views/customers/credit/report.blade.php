<x-admin::layouts>
    <x-slot:title>@lang('customer::credit.report')</x-slot>
    <div class="mb-6 flex flex-wrap items-center justify-between gap-3">
        <h1 class="text-xl font-bold">@lang('customer::credit.report')</h1>
        <div class="flex gap-3">
            <a class="secondary-button" href="{{ route('admin.customers.credit.index') }}">@lang('customer::credit.back')</a>
            @if (bouncer()->hasPermission('customers.credit.export'))<a class="primary-button" href="{{ route('admin.customers.credit.export', request()->query()) }}">@lang('customer::credit.export')</a>@endif
        </div>
    </div>
    @include('admin::customers.credit.errors')
    <div class="mb-5 grid grid-cols-3 gap-3">
        @foreach ($stats as $label => $amount)<div class="rounded bg-white p-4 dark:bg-gray-900"><p class="text-sm">@lang('customer::credit.'.$label)</p><strong class="text-xl">{{ $label === 'count' ? $amount : \Webkul\Customer\Helpers\CreditIdentity::toman($amount) }}</strong> {{ $label === 'count' ? '' : trans('customer::credit.toman') }}</div>@endforeach
    </div>
    <form method="GET" class="mb-5 flex flex-wrap items-end gap-3">
        <label class="grid gap-1 text-sm">@lang('customer::credit.search')<input name="q" value="{{ request('q') }}" maxlength="100" class="rounded border px-3 py-2 dark:bg-gray-900"></label>
        <label class="grid gap-1 text-sm">@lang('customer::credit.type')<select name="kind" class="rounded border px-3 py-2 dark:bg-gray-900"><option value="">@lang('customer::credit.all')</option>@foreach (['manual_credit','manual_debit','purchase','refund','cancel','profile','claim'] as $kind)<option value="{{ $kind }}" @selected(request('kind') === $kind)>@lang('customer::credit.'.$kind)</option>@endforeach</select></label>
        @foreach (['from','to'] as $field)<label class="grid gap-1 text-sm">@lang('customer::credit.'.$field)<input type="date" name="{{ $field }}" value="{{ request($field) }}" class="rounded border px-3 py-2 dark:bg-gray-900"></label>@endforeach
        @if (request('account'))<input type="hidden" name="account" value="{{ request('account') }}">@endif
        <button class="secondary-button">@lang('customer::credit.filter')</button>
    </form>
    <p class="mb-5 text-sm text-gray-500">@lang('customer::credit.csvHelp')</p>
    @include('admin::customers.credit.transactions')
</x-admin::layouts>
