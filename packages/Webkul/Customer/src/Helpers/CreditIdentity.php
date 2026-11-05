<?php

namespace Webkul\Customer\Helpers;

class CreditIdentity
{
    public static function digits(string $value): string
    {
        return strtr($value, array_combine(
            preg_split('//u', '۰۱۲۳۴۵۶۷۸۹٠١٢٣٤٥٦٧٨٩', -1, PREG_SPLIT_NO_EMPTY),
            str_split('01234567890123456789')
        ));
    }

    public static function phone(string $value): string
    {
        $phone = preg_replace('/[\s()+-]+/', '', self::digits(trim($value)));

        if (str_starts_with($phone, '0098')) {
            $phone = '0'.substr($phone, 4);
        } elseif (str_starts_with($phone, '98')) {
            $phone = '0'.substr($phone, 2);
        }

        return $phone;
    }

    public static function iban(?string $value): ?string
    {
        $iban = strtoupper(preg_replace('/[\s-]+/', '', self::digits($value ?? '')));

        return $iban === '' ? null : $iban;
    }

    public static function validIban(?string $iban): bool
    {
        if ($iban === null) {
            return true;
        }

        if (! preg_match('/^IR\d{24}$/', $iban)) {
            return false;
        }

        $digits = substr($iban, 4).'1827'.substr($iban, 2, 2);
        $remainder = 0;
        foreach (str_split($digits) as $digit) {
            $remainder = ($remainder * 10 + (int) $digit) % 97;
        }

        return $remainder === 1;
    }

    public static function orderRial($amount, string $currency): int
    {
        $factor = match (strtoupper($currency)) {
            'IRR' => 1,
            'IRT', 'TOMAN', 'TMN' => 10,
            default => throw new \InvalidArgumentException(trans('customer::credit.unsupported-currency')),
        };

        return (int) round((float) $amount * $factor);
    }

    public static function toman(int $rial): string
    {
        $negative = $rial < 0 ? '-' : '';
        $rial = abs($rial);

        return $negative.number_format(intdiv($rial, 10)).($rial % 10 ? '.'.($rial % 10) : '');
    }
}
