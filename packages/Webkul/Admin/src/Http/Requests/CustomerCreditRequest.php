<?php

namespace Webkul\Admin\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Webkul\Customer\Helpers\CreditIdentity;

class CustomerCreditRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        if ($this->has('phone')) {
            $this->merge(['phone' => CreditIdentity::phone((string) $this->input('phone'))]);
        }
        if ($this->has('iban')) {
            $this->merge(['iban' => CreditIdentity::iban($this->input('iban'))]);
        }
        foreach (['amount', 'opening_amount'] as $field) {
            if ($this->has($field)) {
                $this->merge([$field => str_replace([',', '٬', ' '], '', CreditIdentity::digits((string) $this->input($field)))]);
            }
        }
    }

    public function rules(): array
    {
        if ($this->routeIs('admin.customers.credit.adjust')) {
            return [
                'amount' => ['required', 'integer', 'min:1', 'max:1000000000000'],
                'direction' => ['required', Rule::in(['increase', 'decrease'])],
                'reason' => ['required', 'string', 'min:3', 'max:1000'],
                'reference' => ['nullable', 'string', 'max:150'],
                'request_key' => ['required', 'uuid'],
            ];
        }

        $rules = [
            'holder_name' => ['nullable', 'string', 'max:200'],
            'notes' => ['nullable', 'string', 'max:2000'],
            'is_active' => ['required', 'boolean'],
            'iban' => ['nullable', 'string', function ($attribute, $value, $fail) {
                if (! CreditIdentity::validIban($value)) {
                    $fail(trans('customer::credit.invalid-iban'));
                }
            }],
        ];

        if ($this->routeIs('admin.customers.credit.store')) {
            $rules = array_merge($rules, [
                'phone' => ['required', 'regex:/^09\d{9}$/'],
                'opening_amount' => ['nullable', 'integer', 'min:0', 'max:1000000000000'],
                'request_key' => ['required', 'uuid'],
            ]);
        }

        return $rules;
    }
}
