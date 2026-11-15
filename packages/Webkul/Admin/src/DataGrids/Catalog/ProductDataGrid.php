<?php

namespace Webkul\Admin\DataGrids\Catalog;

use Illuminate\Database\Query\Builder;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Webkul\Admin\Exports\ProductDataGridExport;
use Webkul\Attribute\Repositories\AttributeFamilyRepository;
use Webkul\Core\Facades\ElasticSearch;
use Webkul\DataGrid\DataGrid;
use Webkul\Product\Helpers\Product;

class ProductDataGrid extends DataGrid
{
    /**
     * Primary column.
     *
     * @var string
     */
    protected $primaryColumn = 'product_id';

    protected bool $hasUnindexedProducts = false;

    /**
     * Constructor for the class.
     *
     * @return void
     */
    public function __construct(protected AttributeFamilyRepository $attributeFamilyRepository) {}

    /**
     * Prepare query builder.
     *
     * @return Builder
     */
    public function prepareQueryBuilder()
    {
        $tablePrefix = DB::getTablePrefix();

        $locale = app()->getLocale();

        $this->hasUnindexedProducts = DB::table('products')
            ->whereNotExists(function ($query) use ($locale) {
                $query->selectRaw('1')->from('product_flat')
                    ->whereColumn('product_flat.product_id', 'products.id')
                    ->where('product_flat.locale', $locale);
            })->exists();

        $sourceName = DB::table('product_attribute_values as name_value')
            ->join('attributes as name_attribute', 'name_attribute.id', '=', 'name_value.attribute_id')
            ->whereColumn('name_value.product_id', 'products.id')
            ->where('name_attribute.code', 'name')
            ->where(function ($query) use ($locale) {
                $query->where('name_value.locale', $locale)->orWhereNull('name_value.locale');
            })
            ->orderByDesc('name_value.locale')
            ->select('name_value.text_value')->limit(1);

        // The product table is authoritative: an incomplete index must never
        // hide a product from administrators or from bulk deletion.
        $products = DB::table('products')
            ->leftJoin('product_flat as localized_flat', function ($join) use ($locale) {
                $join->on('localized_flat.product_id', '=', 'products.id')
                    ->where('localized_flat.locale', $locale);
            })
            ->select([
                'products.id as product_id',
                'products.sku',
                'products.type',
                'products.attribute_family_id',
                'localized_flat.channel',
                'localized_flat.status',
                'localized_flat.price',
                'localized_flat.url_key',
                'localized_flat.visible_individually',
            ])
            ->selectRaw('? as locale', [$locale])
            ->selectRaw(
                'COALESCE('.$tablePrefix.'localized_flat.name, ('.$sourceName->toSql().'), '.$tablePrefix.'products.sku) as name',
                $sourceName->getBindings()
            );

        $queryBuilder = DB::query()->fromSub($products, 'product_flat')
            ->distinct()
            ->leftJoin('attribute_families as af', 'product_flat.attribute_family_id', '=', 'af.id')
            ->leftJoin('product_inventories', 'product_flat.product_id', '=', 'product_inventories.product_id')
            ->leftJoin('product_images', 'product_flat.product_id', '=', 'product_images.product_id')
            ->leftJoin('product_categories as pc', 'product_flat.product_id', '=', 'pc.product_id')
            ->leftJoin('category_translations as ct', function ($leftJoin) {
                $leftJoin->on('pc.category_id', '=', 'ct.category_id')
                    ->where('ct.locale', app()->getLocale());
            })
            ->select(
                'product_flat.locale',
                'product_flat.channel',
                'product_images.path as base_image',
                'pc.category_id',
                'ct.name as category_name',
                'product_flat.product_id',
                'product_flat.sku',
                'product_flat.name',
                'product_flat.type',
                'product_flat.status',
                'product_flat.price',
                'product_flat.url_key',
                'product_flat.visible_individually',
                'af.name as attribute_family',
            )
            ->addSelect(DB::raw('SUM(DISTINCT '.$tablePrefix.'product_inventories.qty) as quantity'))
            ->addSelect(DB::raw('COUNT(DISTINCT '.$tablePrefix.'product_images.id) as images_count'))
            ->where('product_flat.locale', app()->getLocale())
            ->groupBy('product_flat.product_id');

        $this->addFilter('product_id', 'product_flat.product_id');
        $this->addFilter('channel', 'product_flat.channel');
        $this->addFilter('locale', 'product_flat.locale');
        $this->addFilter('name', 'product_flat.name');
        $this->addFilter('sku', 'product_flat.sku');
        $this->addFilter('type', 'product_flat.type');
        $this->addFilter('status', 'product_flat.status');
        $this->addFilter('attribute_family', 'af.id');

        return $queryBuilder;
    }

    /**
     * Prepare columns.
     *
     * @return void
     */
    public function prepareColumns()
    {
        $channels = core()->getAllChannels();

        if ($channels->count() > 1) {
            $this->addColumn([
                'index' => 'channel',
                'label' => trans('admin::app.catalog.products.index.datagrid.channel'),
                'type' => 'string',
                'filterable' => true,
                'filterable_type' => 'dropdown',
                'filterable_options' => collect($channels)
                    ->map(fn ($channel) => ['label' => $channel->name, 'value' => $channel->code])
                    ->values()
                    ->toArray(),
                'sortable' => true,
                'visibility' => false,
            ]);
        }

        $this->addColumn([
            'index' => 'name',
            'label' => trans('admin::app.catalog.products.index.datagrid.name'),
            'type' => 'string',
            'searchable' => true,
            'filterable' => true,
            'sortable' => true,
        ]);

        $this->addColumn([
            'index' => 'sku',
            'label' => trans('admin::app.catalog.products.index.datagrid.sku'),
            'type' => 'string',
            'filterable' => true,
            'sortable' => true,
        ]);

        $this->addColumn([
            'index' => 'attribute_family',
            'label' => trans('admin::app.catalog.products.index.datagrid.attribute-family'),
            'type' => 'string',
            'filterable' => true,
            'filterable_type' => 'dropdown',
            'filterable_options' => $this->attributeFamilyRepository->all(['name as label', 'id as value'])->toArray(),
        ]);

        $this->addColumn([
            'index' => 'base_image',
            'label' => trans('admin::app.catalog.products.index.datagrid.image'),
            'type' => 'string',
            'exportable' => false,
            'closure' => function ($row) {
                if (! $row->base_image) {
                    return;
                }

                return Storage::url($row->base_image);
            },
        ]);

        $this->addColumn([
            'index' => 'price',
            'label' => trans('admin::app.catalog.products.index.datagrid.price'),
            'type' => 'decimal',
            'filterable' => true,
            'sortable' => true,
        ]);

        $this->addColumn([
            'index' => 'quantity',
            'label' => trans('admin::app.catalog.products.index.datagrid.qty'),
            'type' => 'integer',
            'sortable' => true,
        ]);

        $this->addColumn([
            'index' => 'product_id',
            'label' => trans('admin::app.catalog.products.index.datagrid.id'),
            'type' => 'integer',
            'filterable' => true,
            'sortable' => true,
        ]);

        $this->addColumn([
            'index' => 'status',
            'label' => trans('admin::app.catalog.products.index.datagrid.status'),
            'type' => 'boolean',
            'filterable' => true,
            'filterable_options' => [
                [
                    'label' => trans('admin::app.catalog.products.index.datagrid.active'),
                    'value' => 1,
                ],
                [
                    'label' => trans('admin::app.catalog.products.index.datagrid.disable'),
                    'value' => 0,
                ],
            ],
            'sortable' => true,
        ]);

        $this->addColumn([
            'index' => 'category_name',
            'label' => trans('admin::app.catalog.products.index.datagrid.category'),
            'type' => 'string',
        ]);

        $this->addColumn([
            'index' => 'type',
            'label' => trans('admin::app.catalog.products.index.datagrid.type'),
            'type' => 'string',
            'filterable' => true,
            'filterable_type' => 'dropdown',
            'filterable_options' => collect(config('product_types'))
                ->map(fn ($type) => ['label' => trans($type['name']), 'value' => $type['key']])
                ->values()
                ->toArray(),
            'sortable' => true,
        ]);
    }

    /**
     * Prepare actions.
     *
     * @return void
     */
    public function prepareActions()
    {
        if (bouncer()->hasPermission('catalog.products.copy')) {
            $this->addAction([
                'icon' => 'icon-copy',
                'title' => trans('admin::app.catalog.products.index.datagrid.copy'),
                'method' => 'POST',
                'url' => function ($row) {
                    return route('admin.catalog.products.copy', $row->product_id);
                },
            ]);
        }

        if (bouncer()->hasPermission('catalog.products.edit')) {
            $this->addAction([
                'icon' => 'icon-sort-right',
                'title' => trans('admin::app.catalog.products.index.datagrid.edit'),
                'method' => 'GET',
                'url' => function ($row) {
                    $filteredChannel = request()->input('filters.channel')[0] ?? null;

                    return route('admin.catalog.products.edit', [
                        'id' => $row->product_id,
                        'channel' => $filteredChannel,
                    ]);
                },
            ]);
        }
    }

    /**
     * Prepare mass actions.
     *
     * @return void
     */
    public function prepareMassActions()
    {
        if (bouncer()->hasPermission('catalog.products.delete')) {
            $this->addMassAction([
                'title' => trans('admin::app.catalog.products.index.datagrid.delete'),
                'url' => route('admin.catalog.products.mass_delete'),
                'method' => 'POST',
            ]);
        }

        if (bouncer()->hasPermission('catalog.products.edit')) {
            $this->addMassAction([
                'title' => trans('admin::app.catalog.products.index.datagrid.update-status'),
                'url' => route('admin.catalog.products.mass_update'),
                'method' => 'POST',
                'options' => [
                    [
                        'label' => trans('admin::app.catalog.products.index.datagrid.active'),
                        'value' => 1,
                    ],
                    [
                        'label' => trans('admin::app.catalog.products.index.datagrid.disable'),
                        'value' => 0,
                    ],
                ],
            ]);
        }
    }

    /**
     * Return a custom exporter that includes all product attribute values.
     */
    public function getExporter(): ProductDataGridExport
    {
        return new ProductDataGridExport($this);
    }

    /**
     * Process request.
     */
    protected function processRequest(): void
    {
        if (
            $this->hasUnindexedProducts
            || core()->getConfigData('catalog.products.search.engine') != 'elastic'
            || core()->getConfigData('catalog.products.search.admin_mode') != 'elastic'
        ) {
            parent::processRequest();

            return;
        }

        /**
         * Store all request parameters in this variable; avoid using direct request helpers afterward.
         */
        $params = $this->validatedRequest();

        if (isset($params['export']) && (bool) $params['export']) {
            parent::processRequest();

            return;
        }

        $this->dispatchEvent('process_request.before', $this);

        $pagination = $params['pagination'];

        $channelCodes = request()->input('filters.channel') ?? core()->getAllChannels()->pluck('code')->toArray();

        $indexNames = collect($channelCodes)->map(function ($channelCode) {
            return Product::formatElasticSearchIndexName($channelCode, app()->getLocale());
        })->toArray();

        $results = ElasticSearch::search([
            'index' => $indexNames,
            'ignore_unavailable' => true,
            'body' => [
                'from' => ($pagination['page'] * $pagination['per_page']) - $pagination['per_page'],
                'size' => $pagination['per_page'],
                'stored_fields' => [],
                'query' => [
                    'bool' => $this->getElasticFilters($params['filters'] ?? []) ?: new \stdClass,
                ],
                'sort' => $this->getElasticSort($params['sort'] ?? []),
                'track_total_hits' => true,
            ],
        ]);

        $ids = collect($results['hits']['hits'])->pluck('_id')->toArray();

        $this->queryBuilder
            ->whereIn('product_flat.product_id', $ids);

        if ($ids) {
            $this->queryBuilder
                ->orderBy(DB::raw('FIELD('.DB::getTablePrefix().'product_flat.product_id, '.implode(',', $ids).')'));
        }

        $total = $results['hits']['total']['value'];

        $this->paginator = new LengthAwarePaginator(
            $total ? $this->queryBuilder->get() : [],
            $total,
            $pagination['per_page'],
            $pagination['page'],
            [
                'path' => request()->url(),
                'query' => [],
            ]
        );

        $this->dispatchEvent('process_request.after', $this);
    }

    /**
     * Process request.
     */
    protected function getElasticFilters($params): array
    {
        $filters = [];

        foreach ($params as $attribute => $value) {
            if (in_array($attribute, ['channel', 'locale'])) {
                continue;
            }

            if ($attribute == 'all') {
                $attribute = 'name';
            }

            $filters['filter'][] = $this->getFilterValue($attribute, $value);
        }

        return $filters;
    }

    /**
     * Return applied filters
     */
    public function getFilterValue(mixed $attribute, mixed $values): array
    {
        switch ($attribute) {
            case 'product_id':
                return [
                    'terms' => [
                        'id' => $values,
                    ],
                ];

            case 'attribute_family':
                return [
                    'terms' => [
                        'attribute_family_id' => $values,
                    ],
                ];

            case 'sku':
            case 'name':
                $filters = [];

                foreach ($values as $value) {
                    $filters['bool']['should'][] = [
                        'match_phrase_prefix' => [
                            $attribute => $value,
                        ],
                    ];
                }

                return $filters;

            default:
                return [
                    'terms' => [
                        $attribute => $values,
                    ],
                ];
        }
    }

    /**
     * Process request.
     */
    protected function getElasticSort($params): array
    {
        $sort = $params['column'] ?? $this->primaryColumn;

        if ($sort == 'type') {
            $sort .= '.keyword';
        }

        if ($sort == 'name') {
            $sort .= '.keyword';
        }

        if ($sort == 'attribute_family') {
            $sort .= '_id';
        }

        if ($sort == 'product_id') {
            $sort = 'id';
        }

        return [
            $sort => [
                'order' => $params['order'] ?? $this->sortOrder,
            ],
        ];
    }
}
