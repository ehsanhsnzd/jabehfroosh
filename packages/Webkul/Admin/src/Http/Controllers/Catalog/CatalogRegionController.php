<?php

namespace Webkul\Admin\Http\Controllers\Catalog;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Event;
use Illuminate\Validation\Rule;
use Webkul\Admin\Http\Controllers\Controller;
use Webkul\Product\Helpers\CatalogRegionSettings;

class CatalogRegionController extends Controller
{
    public function index()
    {
        return view('admin::catalog.regions.index', ['regions' => CatalogRegionSettings::all()]);
    }

    public function update(Request $request)
    {
        $codes = array_keys(CatalogRegionSettings::labels());
        $data = $request->validate([
            'home' => ['sometimes', 'array'],
            'home.*' => ['string', 'distinct', Rule::in($codes)],
            'product' => ['sometimes', 'array'],
            'product.*' => ['string', 'distinct', Rule::in(array_diff($codes, ['northwest']))],
        ]);
        CatalogRegionSettings::save($data['home'] ?? [], $data['product'] ?? []);
        Event::dispatch('core.configuration.save.after');

        return back()->with('success', trans('admin::catalog-regions.saved'));
    }
}
