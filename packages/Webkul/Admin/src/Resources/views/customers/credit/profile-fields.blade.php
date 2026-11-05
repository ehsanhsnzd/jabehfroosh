@foreach (['holder_name' => 'holder', 'iban' => 'iban'] as $field => $label)
    <label class="mb-4 grid gap-2 text-sm">
        @lang('customer::credit.'.$label)
        <input class="w-full rounded border px-3 py-2 dark:bg-gray-900" name="{{ $field }}" value="{{ old($field, $account?->{$field}) }}" maxlength="{{ $field === 'iban' ? 34 : 200 }}" @if($field === 'iban') dir="ltr" placeholder="IR…" @endif>
    </label>
@endforeach
<label class="mb-4 grid gap-2 text-sm">
    @lang('customer::credit.notes')
    <textarea class="w-full rounded border px-3 py-2 dark:bg-gray-900" name="notes" maxlength="2000">{{ old('notes', $account?->notes) }}</textarea>
</label>
<input type="hidden" name="is_active" value="0">
<label class="mb-4 flex items-center gap-2 text-sm"><input type="checkbox" name="is_active" value="1" @checked(old('is_active', $account?->is_active ?? true))> @lang('customer::credit.active')</label>
<p class="mb-4 text-xs text-gray-500">@lang('customer::credit.securityHelp')</p>
