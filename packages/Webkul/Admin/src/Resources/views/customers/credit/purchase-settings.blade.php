<x-admin::layouts>
<x-slot:title>@lang('customer::purchase-credit.settings')</x-slot>
<h1 class="mb-6 text-xl font-bold">@lang('customer::purchase-credit.settings')</h1>
@include('admin::customers.credit.errors')
<p class="mb-4">@lang('customer::purchase-credit.variables')</p>
<form method="POST" action="{{ route('admin.customers.credit.settings.save') }}" class="grid max-w-3xl gap-5 rounded bg-white p-5 dark:bg-gray-900">
@csrf
@foreach (['enabled','marketing_enabled','sms_testing'] as $key)
<label><input type="checkbox" name="{{ $key }}" value="1" @checked(old($key, $settings[$key]))> @lang('customer::purchase-credit.'.$key)</label>
@endforeach
@foreach (['factor' => ['0','1','0.0001'], 'months' => ['1','120','1'], 'minimum_amount' => ['1','1000000000000','1'], 'send_hour' => ['0','23','1'], 'reminder_days' => ['1','365','1'], 'reminder_limit' => ['0','100','1']] as $key => $bounds)
<label>@lang('customer::purchase-credit.'.$key)<input class="mt-2 block w-full rounded border px-3 py-2 dark:bg-gray-900" name="{{ $key }}" type="number" min="{{ $bounds[0] }}" max="{{ $bounds[1] }}" step="{{ $bounds[2] }}" value="{{ old($key, $settings[$key]) }}" required></label>
@endforeach
<p class="text-sm">@lang('customer::purchase-credit.reminderHelp')</p>
@foreach (['instructions','accounting_address','offer_text','marketing_text'] as $key)
<label>@lang('customer::purchase-credit.'.$key)<textarea class="mt-2 block w-full rounded border px-3 py-2 dark:bg-gray-900" name="{{ $key }}" rows="4">{{ old($key, $settings[$key]) }}</textarea></label>
@endforeach
<p class="text-sm">@lang('customer::purchase-credit.smsHelp')</p>
<button class="primary-button" type="submit">@lang('customer::purchase-credit.save')</button>
</form>
</x-admin::layouts>
