<?php

namespace Webkul\Admin\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class CatalogRuleRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        $rules = [
            'name' => 'required',
            'channels' => 'required|array|min:1',
            'customer_groups' => 'required|array|min:1',
            'starts_from' => 'nullable|date',
            'ends_till' => 'nullable|date|after_or_equal:starts_from',
            'action_type' => ['required', Rule::in(['by_percent', 'by_fixed', 'by_percent_increase'])],
            'discount_amount' => 'required|numeric',
        ];

        if (in_array(request()->input('action_type'), ['by_percent', 'by_percent_increase'])) {
            $rules = array_merge($rules, [
                'discount_amount' => 'required|numeric|min:0|max:100',
            ]);
        }

        return $rules;
    }
}
