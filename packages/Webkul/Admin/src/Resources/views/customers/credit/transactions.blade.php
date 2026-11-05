<div class="overflow-x-auto rounded bg-white dark:bg-gray-900">
    <table class="w-full text-start text-sm">
        <thead><tr class="border-b">
            @foreach (['date','phone','type','amount','balanceAfter','order','operator','reference','reason'] as $label)<th class="p-3 text-start">@lang('customer::credit.'.$label)</th>@endforeach
        </tr></thead>
        <tbody>
            @forelse ($transactions as $entry)
                <tr class="border-b">
                    <td class="p-3 whitespace-nowrap">#{{ $entry->id }}<br>{{ $entry->created_at->format('Y-m-d H:i:s') }}</td>
                    <td class="p-3" dir="ltr">{{ $entry->account->phone }}</td>
                    <td class="p-3">@lang('customer::credit.'.$entry->kind)</td>
                    <td class="p-3 whitespace-nowrap {{ $entry->amount_rial < 0 ? 'text-red-600' : 'text-green-700' }}" dir="ltr">{{ \Webkul\Customer\Helpers\CreditIdentity::toman($entry->amount_rial) }}</td>
                    <td class="p-3 whitespace-nowrap" dir="ltr">{{ \Webkul\Customer\Helpers\CreditIdentity::toman($entry->balance_after_rial) }}</td>
                    <td class="p-3">{{ $entry->order?->increment_id ?: '—' }}</td>
                    <td class="p-3">{{ $entry->admin?->name ?: ($entry->admin_id ? '#'.$entry->admin_id : '—') }}</td>
                    <td class="p-3">{{ $entry->reference ?: '—' }}</td>
                    <td class="p-3 max-w-xs break-words">{{ $entry->reason }}</td>
                </tr>
            @empty<tr><td colspan="9" class="p-6 text-center">@lang('customer::credit.empty')</td></tr>@endforelse
        </tbody>
    </table>
</div>
<div class="my-4">{{ $transactions->links() }}</div>
