<?php

namespace Webkul\Customer\Helpers;

use Webkul\Core\Repositories\CoreConfigRepository;

class PurchaseCreditSettings
{
    public const STEP = 5000000;

    public static function defaults(): array
    {
        return [
            'enabled' => false, 'factor' => '0.5', 'months' => 2, 'minimum_amount' => self::STEP, 'amount_step' => self::STEP, 'monthly_deduction_percent' => 10,
            'instructions' => trans('customer::purchase-credit.defaultInstructions'),
            'accounting_address' => '', 'marketing_enabled' => false, 'sms_testing' => true,
            'send_hour' => 10, 'sms_link' => '',
            'reminder_days' => 14, 'reminder_limit' => 3,
            'offer_text' => trans('customer::purchase-credit.defaultOffer', [], 'fa'),
            'marketing_text' => trans('customer::purchase-credit.defaultMarketing', [], 'fa'),
        ];
    }

    public static function all(): array
    {
        $settings = self::defaults();
        $stored = app(CoreConfigRepository::class)->getModel()->newQuery()
            ->whereIn('code', array_map(fn ($key) => 'customer.purchase_credit.'.$key, array_keys($settings)))
            ->whereNull('channel_code')->whereNull('locale_code')->pluck('value', 'code');
        foreach ($settings as $key => $default) {
            $value = $stored['customer.purchase_credit.'.$key] ?? null;
            if ($value !== null) {
                $settings[$key] = is_bool($default) ? filter_var($value, FILTER_VALIDATE_BOOLEAN) : $value;
            }
        }

        $settings['minimum_amount'] = max(1, min(1000000000000, (int) $settings['minimum_amount']));

        $settings['amount_step'] = max(1, min(1000000000000, (int) $settings['amount_step']));

        $settings['monthly_deduction_percent'] = max(0, min(100, (int) $settings['monthly_deduction_percent']));

        return $settings;
    }

    public static function amountStep(): int
    {
        return self::all()['amount_step'];
    }

    public static function minimumAmount(): int
    {
        return self::all()['minimum_amount'];
    }
}
