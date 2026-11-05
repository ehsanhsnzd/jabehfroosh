<?php

namespace Webkul\Shop\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Webkul\Core\Rules\PhoneNumber;
use Webkul\Core\Rules\PostCode;
use Webkul\Customer\Rules\VatIdRule;
use Webkul\Shop\Helpers\IranAddress;

class CartAddressRequest extends FormRequest
{
    /**
     * Rules.
     *
     * @var array
     */
    protected $rules = [];

    /**
     * Determine if the product is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        $customer = auth()->guard('customer')->user();

        foreach (['billing', 'shipping'] as $type) {
            if (! is_array($address = $this->input($type))) {
                continue;
            }

            $address['country'] = $address['country'] ?? 'IR';
            $address['email'] = $address['email'] ?? $customer?->email;
            $address['phone'] = $address['phone'] ?? $customer?->phone;

            $this->merge([$type => $address]);
        }
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        if ($this->has('billing')) {
            $this->mergeAddressRules('billing');
        }

        if (! $this->input('billing.use_for_shipping')) {
            $this->mergeAddressRules('shipping');
        }

        return $this->rules;
    }

    /**
     * Merge new address rules.
     */
    private function mergeAddressRules(string $addressType): void
    {
        $this->mergeWithRules([
            "{$addressType}.company_name" => ['nullable'],
            "{$addressType}.first_name" => ['required'],
            "{$addressType}.last_name" => ['required'],
            "{$addressType}.email" => ['nullable', 'email'],
            "{$addressType}.address" => ['required', 'array', 'min:1'],
            "{$addressType}.city" => ['required'],
            "{$addressType}.country" => core()->isCountryRequired() ? ['required'] : ['nullable'],
            "{$addressType}.state" => core()->isStateRequired() ? ['required'] : ['nullable'],
            "{$addressType}.postcode" => core()->isPostCodeRequired() ? ['required', new PostCode] : [new PostCode],
            "{$addressType}.phone" => ['nullable', new PhoneNumber],
        ]);

        if ($this->input("{$addressType}.country") === 'IR') {
            $province = $this->input("{$addressType}.state");

            $this->mergeWithRules([
                "{$addressType}.state" => ['required', 'string', Rule::in(array_column(IranAddress::provinces(), 'name'))],
                "{$addressType}.city" => ['required', 'string', Rule::in(IranAddress::cities(is_string($province) ? $province : null))],
            ]);
        }

        if ($addressType == 'billing') {
            $this->mergeWithRules([
                "{$addressType}.vat_id" => [(new VatIdRule)->setCountry($this->input('billing.country'))],
            ]);
        }
    }

    /**
     * Merge additional rules.
     */
    private function mergeWithRules($rules): void
    {
        $this->rules = array_merge($this->rules, $rules);
    }
}
