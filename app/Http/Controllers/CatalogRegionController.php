<?php

namespace App\Http\Controllers;

use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class CatalogRegionController extends Controller
{
    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'region' => ['required', Rule::in(array_keys(config('catalog-regions')))],
        ]);

        $request->session()->put('catalog_region', $validated['region']);

        // A separate cookie also distinguishes browser/proxy caches using Vary: Cookie.
        return back()->withCookie(cookie('catalog_region', $validated['region'], 0));
    }
}
