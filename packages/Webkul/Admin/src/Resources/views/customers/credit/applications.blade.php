<x-admin::layouts>
<x-slot:title>@lang('customer::purchase-credit.applications')</x-slot>
<h1 class="mb-6 text-xl font-bold">@lang('customer::purchase-credit.applications')</h1>
@include('admin::customers.credit.errors')
<form class="mb-5 flex gap-3" method="GET">
<input class="rounded border p-2 dark:bg-gray-900" name="q" value="{{ request('q') }}" aria-label="{{ trans('customer::purchase-credit.customer') }}">
<select class="rounded border p-2 dark:bg-gray-900" name="status"><option value="">@lang('customer::purchase-credit.all')</option>@foreach (['documents_pending','cheque_pending','allocation_pending','rejected','active'] as $state)<option value="{{ $state }}" @selected(request('status') === $state)>@lang('customer::purchase-credit.'.$state)</option>@endforeach</select>
<button class="secondary-button">@lang('customer::purchase-credit.filter')</button>
</form>
@forelse ($applications as $application)
<article class="mb-5 rounded border bg-white p-5 dark:bg-gray-900">
<h2 class="font-bold">{{ $application->customer?->name }} — {{ $application->customer?->phone }}</h2>
<p class="my-3">@lang('customer::purchase-credit.'.$application->status)</p>
<p>@lang('customer::purchase-credit.amount'): {{ number_format($application->requested_toman) }} / @lang('customer::purchase-credit.ceiling'): {{ number_format($application->ceiling_toman) }}</p>
<ul class="my-3">@foreach ($application->documents as $index => $file)<li><a class="text-blue-600 underline" href="{{ route('admin.customers.credit.document', [$application->id, $index]) }}">@if (in_array($file['type'] ?? '', ['national_id_front', 'national_id_back'])){{ trans('customer::purchase-credit.'.($file['type'] === 'national_id_front' ? 'identityFront' : 'identityBack')) }}: @endif{{ $file['name'] }}</a></li>@endforeach</ul>
@if ($application->rejection_reason)<p>{{ $application->rejection_reason }}</p>@endif
@if ($application->status === 'active')<p>@lang('customer::purchase-credit.approvedAmount'): {{ number_format($application->approved_toman) }} — @lang('customer::purchase-credit.cheque_reference'): {{ $application->cheque_reference }}</p>@endif
@if (bouncer()->hasPermission('customers.purchase_credit.approve') && $application->status !== 'active')
@if ($application->status === 'documents_pending')
<form method="POST" action="{{ route('admin.customers.credit.review', $application->id) }}">@csrf<input type="hidden" name="action" value="documents"><button class="primary-button">@lang('customer::purchase-credit.approveDocuments')</button></form>
@endif
@if ($application->status === 'cheque_pending' && collect($application->documents)->contains(fn ($file) => ($file['type'] ?? '') === 'cheque'))
<form method="POST" action="{{ route('admin.customers.credit.review', $application->id) }}" class="my-4 grid gap-3">@csrf<input type="hidden" name="action" value="cheque">
<label>@lang('customer::purchase-credit.cheque_reference')<input class="block rounded border p-2 dark:bg-gray-900" name="cheque_reference" maxlength="100" required></label>
<label>@lang('customer::cheques.dueDate')<input class="block rounded border p-2 dark:bg-gray-900" type="date" name="due_date" required></label>
<label>@lang('customer::cheques.amount')<input class="block rounded border p-2 dark:bg-gray-900" type="number" min="1" max="1000000000000" name="cheque_amount" value="{{ $application->requested_toman }}" required></label>
<label>@lang('customer::cheques.company')<input class="block rounded border p-2 dark:bg-gray-900" name="company_name" maxlength="255"></label>
<label>@lang('customer::cheques.bank')<input class="block rounded border p-2 dark:bg-gray-900" name="bank_name" maxlength="100"></label>
<label><input type="checkbox" name="sayad_confirmed" value="1" required> @lang('customer::cheques.sayad')</label>
<button class="primary-button">@lang('customer::purchase-credit.approveCheque')</button></form>
@endif
@if ($application->status === 'allocation_pending')
<form method="POST" action="{{ route('admin.customers.credit.review', $application->id) }}" class="my-4 flex flex-wrap gap-3">@csrf<input type="hidden" name="action" value="activate">
<label>@lang('customer::purchase-credit.approvedAmount')<input class="block rounded border p-2 dark:bg-gray-900" name="amount" type="number" min="5000000" max="{{ $application->requested_toman }}" step="5000000" value="{{ $application->requested_toman }}" required></label>
<button class="primary-button">@lang('customer::purchase-credit.activate')</button></form>
@endif
<form method="POST" action="{{ route('admin.customers.credit.review', $application->id) }}" class="mt-4 flex gap-3">@csrf<input type="hidden" name="action" value="reject"><input class="rounded border p-2 dark:bg-gray-900" name="reason" maxlength="2000" placeholder="{{ trans('customer::purchase-credit.reason') }}" required><button class="secondary-button">@lang('customer::purchase-credit.reject')</button></form>
@endif
<details class="mt-4"><summary>@lang('customer::purchase-credit.history')</summary>@foreach ($application->history as $event)<p>{{ $event['at'] }} — {{ trans('customer::'.($event['action']==='admin_cheque'?'cheques.':'purchase-credit.').$event['action']) }} — {{ $event['admin_id'] ?? '' }} {{ $event['reason'] ?? '' }}</p>@endforeach</details>
</article>
@empty<p>@lang('customer::purchase-credit.empty')</p>@endforelse
{{ $applications->links() }}
<h2 class="my-6 text-xl font-bold">@lang('customer::purchase-credit.notices')</h2>
<div class="overflow-x-auto"><table class="w-full text-sm"><thead><tr>@foreach (['customer','status','amount'] as $key)<th class="p-3 text-start">@lang('customer::purchase-credit.'.$key)</th>@endforeach<th class="p-3">@lang('customer::credit.date')</th></tr></thead><tbody>
@forelse ($notices as $notice)<tr class="border-b"><td class="p-3">{{ $notice->phone }}<p>{{ $notice->message }}</p></td><td class="p-3">@lang('customer::purchase-credit.'.$notice->kind)<br>@lang('customer::purchase-credit.'.$notice->status)</td><td class="p-3">{{ number_format($notice->amount_toman) }}</td><td class="p-3">{{ $notice->created_at }}</td></tr>@empty<tr><td colspan="4">@lang('customer::purchase-credit.empty')</td></tr>@endforelse
</tbody></table></div>{{ $notices->links() }}
</x-admin::layouts>
