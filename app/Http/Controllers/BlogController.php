<?php

namespace App\Http\Controllers;

use Illuminate\View\View;
use Webkul\CMS\Models\Page;

class BlogController extends Controller
{
    public const SLUGS = [
        'entekhab-jabe-ghazaye-garm',
        'chap-branding-bastebandi',
        'bastebandi-foroush-dobare',
        'rahnamaye-entekhab-jabe-fastfood',
    ];

    public function index(): View
    {
        $pages = Page::query()
            ->whereHas('channels', fn ($query) => $query->where('channels.id', core()->getCurrentChannel()->id))
            ->whereHas('translations', fn ($query) => $query->where('locale', app()->getLocale())->whereIn('url_key', self::SLUGS))
            ->get()
            ->sortBy(fn ($page) => array_search($page->url_key, self::SLUGS, true))
            ->values();

        return view('blog.index', compact('pages'));
    }

    public function show(string $slug): View
    {
        abort_unless(in_array($slug, self::SLUGS, true), 404);

        $page = Page::query()
            ->whereHas('channels', fn ($query) => $query->where('channels.id', core()->getCurrentChannel()->id))
            ->whereTranslation('url_key', $slug)
            ->firstOrFail();

        return view('blog.show', compact('page'));
    }
}
