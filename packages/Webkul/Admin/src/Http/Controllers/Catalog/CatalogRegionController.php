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

    public function store(Request $request)
    {
        $data = $request->validate(['region_name' => 'required|string|min:2|max:100']);
        CatalogRegionSettings::add($data['region_name']);
        Event::dispatch('core.configuration.save.after');

        return redirect()->route('admin.catalog.regions.index')->with('success', trans('admin::catalog-regions.city-created'));
    }

    public function update(Request $request)
    {
        $codes = array_keys(CatalogRegionSettings::labels());
        $data = $request->validate([
            'home' => ['sometimes', 'array'],
            'home.*' => ['string', 'distinct', Rule::in($codes)],
            'product' => ['sometimes', 'array'],
            'product.*' => ['string', 'distinct', Rule::in(array_diff($codes, ['northwest', 'other']))],
        ]);
        CatalogRegionSettings::save($data['home'] ?? [], $data['product'] ?? []);
        Event::dispatch('core.configuration.save.after');

        return back()->with('success', trans('admin::catalog-regions.saved'));
    }
}
