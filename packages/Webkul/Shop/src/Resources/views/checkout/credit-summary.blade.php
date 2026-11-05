<div v-if="cart.credit && cart.credit.authenticated" class="my-5 rounded-xl border p-4 text-sm">
    <template v-if="cart.credit.verified">
        <div class="flex items-center justify-between gap-3">
            <strong>@lang('customer::credit.balance')</strong>
            <span>@{{ cart.credit.balance }} @lang('customer::credit.toman')</span>
        </div>
        <p v-if="! cart.credit.active" class="mt-3 text-red-600">@lang('customer::credit.inactiveHelp')</p>
        <p v-else-if="cart.credit.eligible" class="mt-3">@lang('customer::credit.availableHelp')</p>
        <p v-else class="mt-3">@lang('customer::credit.fullPayment')</p>
        <a :href="cart.credit.history_url" class="mt-3 inline-block text-primary">@lang('customer::credit.transactions')</a>
    </template>
    <template v-else>
        <p>@lang('customer::credit.verifyHelp')</p>
        <a :href="cart.credit.verify_url" class="mt-3 inline-block text-primary">@lang('customer::credit.verify')</a>
    </template>
</div>
