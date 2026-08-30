<?php

namespace Database\Seeders;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Seeder;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Log;
use Webkul\Attribute\Models\AttributeFamily;
use Webkul\Category\Repositories\CategoryRepository;
use Webkul\Core\Models\CoreConfig;
use Webkul\Inventory\Models\InventorySource;
use Webkul\Marketing\Models\SearchSynonym;
use Webkul\Product\Repositories\ProductRepository;

class ShamimPackagingCatalogSeeder extends Seeder
{
    private string $assetDirectory;

    public function run(): void
    {
        // Laravel disables mass-assignment protection while seeders run. Bagisto's
        // repositories rely on that protection to keep locale/channel context out
        // of the main products table while still persisting attribute values.
        Model::reguard();

        $this->assetDirectory = database_path('seeders/data/shamim-catalog');

        $productRepository = app(ProductRepository::class);
        $categoryRepository = app(CategoryRepository::class);
        $channel = core()->getDefaultChannel();
        $familyId = AttributeFamily::query()->where('code', 'default')->value('id')
            ?? AttributeFamily::query()->value('id');
        $inventorySourceId = InventorySource::query()->where('status', 1)->value('id')
            ?? InventorySource::query()->value('id');

        if (! $channel || ! $familyId || ! $inventorySourceId) {
            throw new \RuntimeException('Default channel, attribute family, or inventory source is missing.');
        }

        $categories = $this->seedCategories($categoryRepository, (int) $channel->root_category_id);
        $filterOptions = $this->seedFilterOptions();
        $this->attachCategoryFilters($categories);

        foreach ($this->products() as $item) {
            $product = $productRepository->findOneByField('sku', $item['sku']);

            if (! $product) {
                Event::dispatch('catalog.product.create.before');

                $product = $productRepository->create([
                    'type' => 'simple',
                    'attribute_family_id' => $familyId,
                    'sku' => $item['sku'],
                ]);

                Event::dispatch('catalog.product.create.after', $product);
            }

            $categoryIds = collect($item['categories'])
                ->map(fn (string $key) => $categories[$key]->id)
                ->all();

            $description = $this->description($item);
            $imageFiles = $this->imageFiles($item);
            $priceToman = $item['price_toman'] ?? 0;

            Event::dispatch('catalog.product.update.before', $product->id);

            $product = $productRepository->update([
                'locale' => 'fa',
                'channel' => $channel->code,
                'sku' => $item['sku'],
                'name' => $item['name'],
                'url_key' => $item['slug'],
                'short_description' => $item['short_description'],
                'description' => $description,
                'meta_title' => $item['meta_title'],
                'meta_keywords' => implode(', ', $item['keywords']),
                'meta_description' => $item['meta_description'],
                'price' => $priceToman,
                'cost' => 0,
                'weight' => 0,
                'status' => 1,
                'visible_individually' => 1,
                'new' => 1,
                'featured' => in_array($item['sku'], ['SP-FC-002-W', 'SP-FC-HANDLE-B', 'SP-FF-BOAT-L', 'SP-PAPER-3550']),
                'guest_checkout' => 1,
                'manage_stock' => 1,
                'color' => $filterOptions['color'][$item['color_option']],
                'size' => $filterOptions['size'][$item['size_option']],
                'channels' => [$channel->id],
                'categories' => $categoryIds,
                'inventories' => [$inventorySourceId => 100000],
                'images' => ['files' => $imageFiles],
            ], $product->id);

            Event::dispatch('catalog.product.update.after', $product);

            $this->command?->line("Seeded: {$item['sku']} - {$item['name']}");
        }

        $this->seedSearchSynonyms();

        $this->seedSeoSettings($channel->code);

        Log::info('Shamim packaging catalog seeded', ['products' => count($this->products())]);
    }

    private function seedFilterOptions(): array
    {
        $attributes = DB::table('attributes')
            ->whereIn('code', ['color', 'size'])
            ->get()
            ->keyBy('code');

        if (! isset($attributes['color'], $attributes['size'])) {
            throw new \RuntimeException('Color or size attribute is missing from Bagisto.');
        }

        DB::table('attributes')
            ->whereIn('id', [$attributes['color']->id, $attributes['size']->id])
            ->update([
                'is_filterable' => 1,
                'is_visible_on_front' => 1,
            ]);

        foreach ([
            $attributes['color']->id => 'رنگ',
            $attributes['size']->id => 'اندازه بسته‌بندی',
        ] as $attributeId => $name) {
            DB::table('attribute_translations')->updateOrInsert([
                'attribute_id' => $attributeId,
                'locale' => 'fa',
            ], [
                'name' => $name,
            ]);
        }

        $labels = [
            'color' => [
                'Black' => 'مشکی',
                'White' => 'سفید',
                'Brown' => 'کرافت / قهوه‌ای',
            ],
            'size' => [
                'S' => 'کوچک',
                'M' => 'متوسط',
                'L' => 'بزرگ',
                'XL' => 'خیلی بزرگ',
                'XXL' => 'نیم‌متری',
                'Free Size' => 'بدون سایز',
            ],
        ];

        $options = [];

        foreach ($labels as $attributeCode => $optionLabels) {
            $attributeId = $attributes[$attributeCode]->id;
            $attributeOptions = DB::table('attribute_options')
                ->where('attribute_id', $attributeId)
                ->whereIn('admin_name', array_keys($optionLabels))
                ->get()
                ->keyBy('admin_name');

            foreach ($optionLabels as $adminName => $label) {
                $option = $attributeOptions[$adminName] ?? null;

                if (! $option) {
                    throw new \RuntimeException("Attribute option is missing: {$attributeCode}.{$adminName}");
                }

                DB::table('attribute_option_translations')->updateOrInsert([
                    'attribute_option_id' => $option->id,
                    'locale' => 'fa',
                ], [
                    'label' => $label,
                ]);

                $options[$attributeCode][$adminName] = $option->id;
            }
        }

        return $options;
    }

    private function attachCategoryFilters(array $categories): void
    {
        $attributeIds = DB::table('attributes')
            ->whereIn('code', ['price', 'color', 'size'])
            ->pluck('id');

        foreach ($categories as $category) {
            foreach ($attributeIds as $attributeId) {
                DB::table('category_filterable_attributes')->updateOrInsert([
                    'category_id' => $category->id,
                    'attribute_id' => $attributeId,
                ]);
            }
        }
    }

    private function seedCategories(CategoryRepository $repository, int $rootId): array
    {
        $definitions = [
            'cups' => ['لیوان یکبار مصرف', 'disposable-cups', 'انواع لیوان کاغذی و شفاف یکبار مصرف برای نوشیدنی گرم و سرد، کافه و رستوران.'],
            'fried' => ['جعبه سوخاری', 'fried-chicken-boxes', 'خرید و سفارش عمده جعبه مرغ سوخاری در مدل‌های ۲ تکه، ۳ تکه، ۵ تکه، دسته‌دار و سفره‌ای.'],
            'fried-standard' => ['جعبه سوخاری ساده', 'standard-fried-chicken-boxes', 'جعبه سوخاری ایندربرد سفید و مشکی برای بسته‌بندی مرغ و غذای گرم.'],
            'fried-handled' => ['جعبه سوخاری دسته‌دار', 'handled-fried-chicken-boxes', 'باکس سوخاری دسته‌دار مناسب بیرون‌بر، ارسال و سفارش‌های چندتکه.'],
            'fried-serving' => ['ظروف سرو سوخاری', 'fried-chicken-serving-packaging', 'بشقاب و جعبه سفره‌ای برای سرو سوخاری، فست‌فود و غذای بیرون‌بر.'],
            'fries' => ['جعبه سیب زمینی', 'french-fries-boxes', 'انواع جعبه و پاکت سیب‌زمینی سرخ‌کرده در مدل صندوقی، قایقی، قیفی، هرمی و نیوکلاسیک.'],
            'fries-box' => ['جعبه سیب زمینی صندوقی', 'carton-french-fries-boxes', 'جعبه سیب‌زمینی صندوقی ایندربرد برای حفظ شکل و حمل آسان.'],
            'fries-tray' => ['جعبه سیب زمینی قایقی', 'boat-french-fries-trays', 'ظرف قایقی سیب‌زمینی در سایز کوچک و بزرگ مناسب سرو فوری.'],
            'fries-special' => ['پاکت و جعبه سیب زمینی', 'special-french-fries-packaging', 'مدل‌های قیفی، نیوکلاسیک و هرمی برای سرو حرفه‌ای سیب‌زمینی.'],
            'paper' => ['کاغذ ساندویچ', 'sandwich-wrapping-paper', 'کاغذ کرافت ساندویچ و فست‌فود در سایزهای کاربردی برای بسته‌بندی بهداشتی.'],
            'pizza' => ['جعبه پیتزا', 'pizza-boxes', 'جعبه پیتزا دو رو کرافت ایفلوت در سایزهای ۲۴ تا ۵۰ سانتی‌متر، مناسب پیتزافروشی و سفارش بیرون‌بر.'],
            'pizza-standard' => ['جعبه پیتزا استاندارد', 'standard-pizza-boxes', 'جعبه پیتزا کرافت طاقدیس در سایزهای استاندارد ۲۴، ۲۸، ۳۰ و ۳۲ سانتی‌متر.'],
            'pizza-large' => ['جعبه پیتزا نیم متری', 'large-pizza-boxes', 'جعبه پیتزا نیم متری کرافت پارس و طاقدیس برای پیتزاهای بزرگ و خانوادگی.'],
            'burger' => ['جعبه برگر', 'burger-boxes', 'جعبه برگر کرافت و ایندربرد در مدل‌های صدفی، لاک‌باتوم و سفره‌ای برای فست‌فود و بیرون‌بر.'],
            'sandwich' => ['جعبه ساندویچ', 'sandwich-boxes', 'جعبه ساندویچ و هات‌داگ در مدل‌های کرافت، کشویی و صدفی با ابعاد استاندارد.'],
            'sachet' => ['بسته‌بندی ساشه', 'single-serve-sachets', 'ساشه تک‌نفره نمک، فلفل، آویشن و ادویه با امکان چاپ اختصاصی برای رستوران و فست‌فود.'],
            'food-box' => ['جعبه غذا', 'takeaway-food-boxes', 'جعبه و پک غذای بیرون‌بر کرافت برای رستوران، کترینگ و غذای گرم.'],
            'fried-bucket' => ['سطل سوخاری', 'fried-chicken-buckets', 'سطل مقوایی مرغ سوخاری در ظرفیت‌های تک‌نفره و خانوادگی مناسب بیرون‌بر.'],
            'tablecloth' => ['سفره', 'disposable-tablecloths', 'سفره یکبار مصرف و ملزومات بهداشتی سرو غذا برای رستوران، کترینگ و مراسم.'],
            'pizza-board' => ['سینگل زیر پیتزا', 'pizza-boards', 'سینگل و زیرپیتزایی مقوایی مقاوم برای سرو پیتزا و جلوگیری از تغییر شکل جعبه.'],
            'disposable' => ['ظروف یکبار مصرف', 'disposable-food-containers', 'انواع ظروف یکبار مصرف درب‌دار برای سالاد، سس، غذای گرم، دسر و ارسال بیرون‌بر.'],
            'carry-bag' => ['پاکت بیرون‌بر', 'takeaway-bags', 'پاکت کرافت بیرون‌بر و حمل غذا برای رستوران، کافه، فست‌فود و سفارش‌های تحویل.'],
            'cutlery-pack' => ['پک قاشق و چنگال', 'cutlery-packs', 'پک بهداشتی قاشق، چنگال، کارد و دستمال برای سفارش بیرون‌بر و پذیرایی.'],
            'paper-cup' => ['لیوان کاغذی یک‌بارمصرف', 'disposable-paper-cups', 'لیوان کاغذی نوشیدنی گرم در سایزهای متنوع با امکان درب و چاپ اختصاصی.'],
            'plastic-cup' => ['لیوان پلاستیکی یک‌بارمصرف', 'disposable-plastic-cups', 'لیوان شفاف نوشیدنی سرد با درب تخت یا گنبدی مناسب کافه و آبمیوه‌فروشی.'],
            'icecream-packaging' => ['بسته‌بندی بستنی', 'ice-cream-packaging', 'کاپ کاغذی بستنی و دسر در سایزهای تک‌نفره و خانوادگی.'],
            'salad-container' => ['ظرف سالاد یک‌بارمصرف', 'disposable-salad-containers', 'ظرف شفاف درب‌دار برای سالاد، میوه، دسر و غذای سرد.'],
            'sauce-cup' => ['ظرف سس یک‌بارمصرف', 'disposable-sauce-cups', 'کاپ کوچک شفاف درب‌دار برای انواع سس، چاشنی و دورچین.'],
            'straw-skewer' => ['نی و سیخ چوبی', 'straws-and-wooden-skewers', 'نی نوشیدنی و سیخ چوبی یک‌بارمصرف مناسب کافه، رستوران و پذیرایی.'],
            'nuts-packaging' => ['بسته‌بندی آجیل و خشکبار', 'nuts-packaging', 'پاکت کرافت پنجره‌دار و ایستاده برای آجیل، خشکبار، قهوه و تنقلات.'],
            'microwave-container' => ['ظرف مایکروویوی', 'microwave-food-containers', 'ظرف مقاوم در برابر حرارت با درب شفاف برای غذای گرم و ارسال بیرون‌بر.'],
            'food-tray' => ['سینی و ظرف سرو غذا', 'food-serving-trays', 'سینی کرافت مخصوص سرو فست‌فود، سوخاری، سیب‌زمینی و غذای آماده.'],
            'table-service' => ['ملزومات سرو میز', 'table-service-supplies', 'جا دستمالی، دستمال کاغذی و ملزومات کاربردی میز رستوران و کافه.'],
            'cup-carrier' => ['جالیوانی مقوایی', 'cardboard-cup-carriers', 'جالیوانی مقوایی دوخانه و چهارخانه برای حمل ایمن نوشیدنی‌های گرم و سرد.'],
            'icecream-tray' => ['سینی مقوایی بستنی', 'ice-cream-cardboard-trays', 'سینی مقوایی بستنی برای حمل چند کاپ بستنی و دسر با امکان چاپ اختصاصی.'],
        ];

        $parents = [
            'cups' => $rootId,
            'fried' => $rootId,
            'fried-standard' => 'fried',
            'fried-handled' => 'fried',
            'fried-serving' => 'fried',
            'fries' => $rootId,
            'fries-box' => 'fries',
            'fries-tray' => 'fries',
            'fries-special' => 'fries',
            'paper' => $rootId,
            'pizza' => $rootId,
            'pizza-standard' => 'pizza',
            'pizza-large' => 'pizza',
            'burger' => $rootId,
            'sandwich' => $rootId,
            'sachet' => $rootId,
            'food-box' => $rootId,
            'fried-bucket' => $rootId,
            'tablecloth' => $rootId,
            'pizza-board' => $rootId,
            'disposable' => $rootId,
            'carry-bag' => $rootId,
            'cutlery-pack' => $rootId,
            'paper-cup' => 'cups',
            'plastic-cup' => 'cups',
            'icecream-packaging' => $rootId,
            'salad-container' => 'disposable',
            'sauce-cup' => 'disposable',
            'straw-skewer' => $rootId,
            'nuts-packaging' => $rootId,
            'microwave-container' => 'disposable',
            'food-tray' => $rootId,
            'table-service' => $rootId,
            'cup-carrier' => 'cups',
            'icecream-tray' => 'icecream-packaging',
        ];

        $categories = [];

        foreach ($definitions as $key => [$name, $slug, $description]) {
            $parent = $parents[$key];
            $parentId = is_int($parent) ? $parent : $categories[$parent]->id;
            $category = $repository->findBySlug($slug);
            $translation = [
                'name' => $name,
                'slug' => $slug,
                'description' => "<p>{$description}</p>",
                'meta_title' => "{$name} | خرید عمده از جعبه فروش",
                'meta_description' => $description.' مشاهده مشخصات، ابعاد و ثبت درخواست سفارش از جعبه فروش.',
                'meta_keywords' => $name.', بسته بندی فست فود, خرید عمده بسته بندی, جعبه فروش',
            ];

            $data = [
                'parent_id' => $parentId,
                'position' => 10,
                'status' => 1,
                'display_mode' => 'products_and_description',
            ];

            if ($category) {
                $data['locale'] = 'fa';
                $data['fa'] = $translation;
            } else {
                foreach (core()->getAllLocales() as $locale) {
                    $data[$locale->code] = array_merge($translation, [
                        'locale_id' => $locale->id,
                    ]);
                }
            }

            $categories[$key] = $category
                ? $repository->update($data, $category->id)
                : $repository->create($data);
        }

        return $categories;
    }

    private function seedSearchSynonyms(): void
    {
        $groups = [
            'جعبه سوخاری' => ['جعبه سوخاری', 'باکس سوخاری', 'جعبه مرغ سوخاری', 'ظرف سوخاری', 'بسته بندی سوخاری'],
            'جعبه سیب زمینی' => ['جعبه سیب زمینی', 'پاکت سیب زمینی', 'ظرف سیب زمینی', 'باکس سیب زمینی', 'جعبه سیب زمینی سرخ کرده'],
            'کاغذ ساندویچ' => ['کاغذ ساندویچ', 'کاغذ دور ساندویچ', 'کاغذ کرافت غذا', 'کاغذ فست فود', 'کاغذ بسته بندی غذا'],
            'دسته دار' => ['دسته دار', 'دسته‌دار', 'جعبه دسته دار', 'باکس دسته دار'],
            'جعبه پیتزا' => ['جعبه پیتزا', 'باکس پیتزا', 'کارتن پیتزا', 'جعبه پیتزا کرافت', 'جعبه پیتزا ایفلوت'],
        ];

        foreach ($groups as $name => $terms) {
            SearchSynonym::query()->updateOrCreate(
                ['name' => $name],
                ['terms' => implode(',', $terms)],
            );
        }
    }

    private function seedSeoSettings(string $channelCode): void
    {
        $settings = [
            'catalog.rich_snippets.products.enable',
            'catalog.rich_snippets.products.show_sku',
            'catalog.rich_snippets.products.show_categories',
            'catalog.rich_snippets.products.show_images',
            'catalog.rich_snippets.categories.enable',
            'catalog.rich_snippets.categories.show_search_input_field',
        ];

        foreach ($settings as $code) {
            CoreConfig::query()->updateOrCreate([
                'code' => $code,
                'channel_code' => $channelCode,
                'locale_code' => null,
            ], [
                'value' => '1',
            ]);
        }
    }

    private function imageFiles(array $item): array
    {
        // Every catalog item receives its own measured studio image. Keeping a
        // single authoritative image prevents another size or generic group
        // photo from appearing on the product detail page.
        $measuredImage = "{$this->assetDirectory}/measured/{$item['sku']}.png";
        $fallbackImage = $item['image']
            ? base_path('packages/BagistoPlus/ShamimPackVisual/resources/assets/images/'.$item['image'])
            : null;
        $paths = [is_file($measuredImage) ? $measuredImage : $fallbackImage];

        foreach ($paths as $path) {
            if (! is_file($path)) {
                throw new \RuntimeException("Catalog image is missing: {$path}");
            }
        }

        return array_map(
            fn (string $path) => new UploadedFile($path, basename($path), mime_content_type($path), null, true),
            $paths,
        );
    }

    private function description(array $item): string
    {
        $keywords = implode('، ', array_slice($item['keywords'], 0, 5));
        $saleType = ($item['price_toman'] ?? 0) > 0
            ? 'فروش آنلاین و سفارش عمده'
            : 'عمده و استعلام قیمت';

        return <<<HTML
            <p>{$item['long_description']}</p>
            <h2>مشخصات {$item['name']}</h2>
            <ul>
                <li><strong>جنس:</strong> {$item['material']}</li>
                <li><strong>ابعاد:</strong> {$item['dimensions']}</li>
                <li><strong>کاربرد:</strong> {$item['usage']}</li>
                <li><strong>نوع فروش:</strong> {$saleType}</li>
            </ul>
            <h2>چرا این بسته‌بندی را انتخاب کنیم؟</h2>
            <p>ساختار کاربردی، ظاهر حرفه‌ای و امکان سفارش برای رستوران، فست‌فود، کترینگ و مجموعه‌های بیرون‌بر، این محصول را به گزینه‌ای مناسب برای ارائه منظم غذا تبدیل کرده است. برای تیراژ، قیمت روز و شرایط چاپ اختصاصی با جعبه فروش تماس بگیرید.</p>
            <p><strong>عبارت‌های مرتبط:</strong> {$keywords}</p>
            HTML;
    }

    private function products(): array
    {
        $friedUsage = 'بسته‌بندی مرغ سوخاری، فست‌فود، غذای گرم و سفارش بیرون‌بر';
        $friesUsage = 'سرو و بسته‌بندی سیب‌زمینی سرخ‌کرده برای فست‌فود، کافه و بیرون‌بر';

        return [
            $this->product('SP-FC-002-W', 'جعبه سوخاری ۲ تکه سفید ایندربرد ۲۳۰ گرم', 'fried-chicken-box-2-piece-white-230g', 1, 'fried', ['fried', 'fried-standard'], 'ایندربرد ۲۳۰ گرم', '۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر', $friedUsage, 'جعبه سوخاری دو تکه سفید با ساختار مقاوم و فضای مناسب برای سرو مرغ سوخاری؛ مناسب رستوران و سفارش بیرون‌بر.', 10100),
            $this->product('SP-FC-003-W', 'جعبه سوخاری ۳ تکه سفید ایندربرد ۲۳۰ گرم', 'fried-chicken-box-3-piece-white-230g', 2, 'fried', ['fried', 'fried-standard'], 'ایندربرد ۲۳۰ گرم', '۲۲ × ۱۲ × ۸ سانتی‌متر', $friedUsage, 'جعبه سه تکه سوخاری سفید با ابعاد کاربردی برای چیدمان منظم مرغ و حفظ ظاهر سفارش هنگام تحویل.', 13100),
            $this->product('SP-FC-005-W', 'جعبه سوخاری ۵ تکه سفید ایندربرد ۲۳۰ گرم', 'fried-chicken-box-5-piece-white-230g', 3, 'fried', ['fried', 'fried-standard'], 'ایندربرد ۲۳۰ گرم', '۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر', $friedUsage, 'جعبه پنج تکه سوخاری سفید با ارتفاع بیشتر، مناسب سفارش‌های خانوادگی و پک‌های چندتکه فست‌فود.', 13900),
            $this->product('SP-FC-002-B', 'جعبه سوخاری ۲ تکه مشکی ایندربرد ۲۵۰ گرم', 'fried-chicken-box-2-piece-black-250g', 4, 'fried', ['fried', 'fried-standard'], 'ایندربرد ۲۵۰ گرم', '۱۸.۵ × ۱۰ × ۷.۵ سانتی‌متر', $friedUsage, 'باکس سوخاری دو تکه مشکی با چاپ جذاب و مقوای ۲۵۰ گرم برای ارائه حرفه‌ای سفارش‌های بیرون‌بر.', 11600),
            $this->product('SP-FC-003-B', 'جعبه سوخاری ۳ تکه مشکی ایندربرد ۲۵۰ گرم', 'fried-chicken-box-3-piece-black-250g', 5, 'fried', ['fried', 'fried-standard'], 'ایندربرد ۲۵۰ گرم', '۲۲ × ۱۲ × ۸ سانتی‌متر', $friedUsage, 'جعبه سه تکه سوخاری مشکی مناسب رستوران‌هایی که بسته‌بندی تیره، مقاوم و متمایز می‌خواهند.', 14200),
            $this->product('SP-FC-005-B', 'جعبه سوخاری ۵ تکه مشکی ایندربرد ۲۵۰ گرم', 'fried-chicken-box-5-piece-black-250g', 6, 'fried', ['fried', 'fried-standard'], 'ایندربرد ۲۵۰ گرم', '۲۲ × ۱۲ × ۱۰.۵ سانتی‌متر', $friedUsage, 'جعبه پنج تکه سوخاری مشکی با ظرفیت بیشتر برای سفارش‌های خانوادگی، پک مرغ و غذای بیرون‌بر.', 15300),
            $this->product('SP-FC-HANDLE-W', 'جعبه سوخاری دسته‌دار سفید ایندربرد ۲۳۰ گرم', 'handled-fried-chicken-box-white-230g', 7, 'fried', ['fried', 'fried-handled'], 'ایندربرد ۲۳۰ گرم', '۲۲ × ۱۲ × ۱۱ سانتی‌متر', $friedUsage, 'جعبه سوخاری دسته‌دار سفید برای حمل آسان‌تر سفارش و تحویل مرتب غذا به مشتری.', 17900),
            $this->product('SP-FC-HANDLE-B', 'جعبه سوخاری دسته‌دار مشکی ایندربرد ۲۵۰ گرم', 'handled-fried-chicken-box-black-250g', 8, 'fried', ['fried', 'fried-handled'], 'ایندربرد ۲۵۰ گرم', '۲۲ × ۱۲ × ۱۱ سانتی‌متر', $friedUsage, 'جعبه سوخاری دسته‌دار مشکی با ظاهر حرفه‌ای و ساختار مناسب حمل سفارش‌های فست‌فودی.', 20100),
            $this->product('SP-FC-TABLE-S', 'جعبه سوخاری سفره‌ای کوچک ایندربرد ۲۵۰ گرم', 'small-tabletop-fried-chicken-box-250g', 9, 'fried', ['fried', 'fried-serving'], 'ایندربرد ۲۵۰ گرم', '۱۹.۵ × ۱۵ × ۷ سانتی‌متر', $friedUsage, 'جعبه سوخاری سفره‌ای کوچک که پس از بازشدن سطح مناسبی برای سرو مستقیم غذا فراهم می‌کند.', 23400),
            $this->product('SP-FC-TABLE-L', 'جعبه سوخاری سفره‌ای بزرگ ایندربرد ۲۵۰ گرم', 'large-tabletop-fried-chicken-box-250g', 9, 'fried', ['fried', 'fried-serving'], 'ایندربرد ۲۵۰ گرم', '۲۴.۵ × ۱۹.۵ × ۷.۵ سانتی‌متر', $friedUsage, 'جعبه سوخاری سفره‌ای بزرگ برای پک‌های حجیم و سفارش‌های خانوادگی با امکان سرو آسان.', 29500),
            $this->product('SP-FC-PLATE', 'بشقاب سوخاری قفل‌دار ایندربرد ۲۵۰ گرم', 'fried-chicken-locking-serving-plate-250g', 10, 'fried', ['fried', 'fried-serving'], 'ایندربرد ۲۵۰ گرم', '۲۵ × ۱۵ × ۵ سانتی‌متر', 'سرو مرغ سوخاری، فیله، ناگت و غذای فست‌فودی', 'بشقاب مقوایی سوخاری قفل‌دار با لبه‌های بلند برای سرو مرتب و دسترسی آسان به غذا در سالن یا بیرون‌بر.', 5700),
            $this->product('SP-FF-BOX', 'جعبه سیب زمینی صندوقی کوچک ایندربرد ۲۳۰ گرم', 'small-carton-french-fries-box-230g', 11, 'fries', ['fries', 'fries-box'], 'ایندربرد ۲۳۰ گرم', '۱۲ × ۸ × ۷ سانتی‌متر', $friesUsage, 'جعبه سیب‌زمینی صندوقی کوچک با درب یکپارچه برای حمل تمیز، حفظ فرم و جلوگیری از پراکندگی محتویات.', 6900),
            $this->product('SP-FF-BOAT-S', 'جعبه سیب زمینی قایقی کوچک ایندربرد ۲۳۰ گرم', 'small-boat-french-fries-tray-230g', 12, 'fries', ['fries', 'fries-tray'], 'ایندربرد ۲۳۰ گرم', '۱۵ × ۱۱.۵ × ۴ سانتی‌متر', $friesUsage, 'ظرف قایقی کوچک سیب‌زمینی برای سرو تک‌نفره، دسترسی سریع و نمایش بهتر محصول.', 3600),
            $this->product('SP-FF-BOAT-L', 'جعبه سیب زمینی قایقی بزرگ ایندربرد ۲۳۰ گرم', 'large-boat-french-fries-tray-230g', 12, 'fries', ['fries', 'fries-tray'], 'ایندربرد ۲۳۰ گرم', '۲۱.۵ × ۱۰ × ۶ سانتی‌متر', $friesUsage, 'ظرف قایقی بزرگ سیب‌زمینی برای پرس‌های حجیم‌تر، سیب‌زمینی ویژه و سرو اشتراکی.', 5100),
            $this->product('SP-FF-CONE', 'جعبه سیب زمینی قیفی ایندربرد ۲۵۰ گرم', 'cone-french-fries-box-250g', 13, 'fries', ['fries', 'fries-special'], 'ایندربرد ۲۵۰ گرم', 'عرض ۱۸.۵ و ارتفاع ۳۱ سانتی‌متر', $friesUsage, 'جعبه قیفی بلند سیب‌زمینی با فرم متمایز برای سرو ایستاده و ارائه جذاب در فست‌فود و رویداد.', 8300),
            $this->product('SP-FF-NEO', 'جعبه سیب زمینی نیوکلاسیک ایندربرد ۲۳۰ گرم', 'neo-classic-french-fries-box-230g', 14, 'fries', ['fries', 'fries-special'], 'ایندربرد ۲۳۰ گرم', '۱۴ × ۱۱ × ۷ سانتی‌متر', $friesUsage, 'باکس سیب‌زمینی نیوکلاسیک با دهانه باز و فرم مدرن برای سرو حرفه‌ای و برندینگ فست‌فود.', 9300),
            $this->product('SP-FF-PYRAMID-S', 'جعبه سیب زمینی هرمی کوچک ایندربرد ۲۳۰ گرم', 'small-pyramid-french-fries-box-230g', 15, 'fries', ['fries', 'fries-special'], 'ایندربرد ۲۳۰ گرم', 'ضلع بزرگ ۷.۵، ضلع کوچک ۶، ارتفاع ۱۱ سانتی‌متر', $friesUsage, 'جعبه هرمی کوچک سیب‌زمینی برای پرس تک‌نفره با ظاهر خاص و اشغال فضای کم روی میز.', 6900),
            $this->product('SP-FF-PYRAMID-L', 'جعبه سیب زمینی هرمی بزرگ ایندربرد ۲۳۰ گرم', 'large-pyramid-french-fries-box-230g', 15, 'fries', ['fries', 'fries-special'], 'ایندربرد ۲۳۰ گرم', 'ضلع بزرگ ۱۰.۵، ضلع کوچک ۶.۵، ارتفاع ۱۱.۵ سانتی‌متر', $friesUsage, 'جعبه هرمی بزرگ سیب‌زمینی با ظرفیت بیشتر برای پرس ویژه و ارائه متفاوت محصول.', 9400),
            $this->product('SP-PAPER-2535', 'کاغذ ساندویچ کرافت ۲۵ در ۳۵ سانتی متر', 'kraft-sandwich-paper-25x35', 16, 'paper', ['paper'], 'کاغذ کرافت', '۲۵ × ۳۵ سانتی‌متر', 'پیچیدن ساندویچ، برگر، فست‌فود و غذای بیرون‌بر', 'کاغذ کرافت ساندویچ سایز ۲۵ در ۳۵ برای بسته‌بندی جمع‌وجور برگر، ساندویچ و میان‌وعده.'),
            $this->product('SP-PAPER-3550', 'کاغذ ساندویچ کرافت ۳۵ در ۵۰ سانتی متر', 'kraft-sandwich-paper-35x50', 16, 'paper', ['paper'], 'کاغذ کرافت', '۳۵ × ۵۰ سانتی‌متر', 'پیچیدن ساندویچ بزرگ، برگر، فست‌فود و غذای بیرون‌بر', 'کاغذ کرافت ساندویچ سایز ۳۵ در ۵۰ برای بسته‌بندی محصولات بزرگ‌تر و پوشش کامل‌تر غذا.'),
            $this->product('SP-PIZZA-50-PARS', 'جعبه پیتزا نیم متری پارس دو رو کرافت', 'pars-half-meter-kraft-pizza-box', 0, 'pizza', ['pizza', 'pizza-large'], 'کارتن دو رو کرافت ایفلوت', '۵۰ × ۵۰ سانتی‌متر', 'بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر', 'جعبه پیتزا نیم متری پارس با ساختار مقاوم دو رو کرافت و فضای مناسب برای پیتزاهای بزرگ.', 19200, 'pizza-box-50-pars.png'),
            $this->product('SP-PIZZA-50-TAGHDIS', 'جعبه پیتزا نیم متری طاقدیس دو رو کرافت', 'taghdis-half-meter-kraft-pizza-box', 0, 'pizza', ['pizza', 'pizza-large'], 'کارتن دو رو کرافت ایفلوت', '۵۰ × ۵۰ سانتی‌متر', 'بسته‌بندی پیتزای نیم‌متری، خانوادگی و سفارش بیرون‌بر', 'جعبه پیتزا نیم متری طاقدیس با مقوای ایفلوت مقاوم برای حمل مطمئن پیتزای بزرگ.', 20600, 'pizza-box-50-taghdis.png'),
            $this->product('SP-PIZZA-32-TAGHDIS', 'جعبه پیتزا ۳۲ سانتی طاقدیس دو رو کرافت', 'taghdis-32cm-kraft-pizza-box', 0, 'pizza', ['pizza', 'pizza-standard'], 'کارتن دو رو کرافت ایفلوت', '۳۲ × ۳۲ سانتی‌متر', 'بسته‌بندی پیتزای سایز ۳۲ و سفارش بیرون‌بر', 'جعبه پیتزا ۳۲ سانتی طاقدیس با استحکام مناسب، ظاهر کرافت حرفه‌ای و فضای استاندارد پیتزا.', 25100, 'pizza-box-32-taghdis.png'),
            $this->product('SP-PIZZA-30-TAGHDIS', 'جعبه پیتزا ۳۰ سانتی طاقدیس دو رو کرافت', 'taghdis-30cm-kraft-pizza-box', 0, 'pizza', ['pizza', 'pizza-standard'], 'کارتن دو رو کرافت ایفلوت', '۳۰ × ۳۰ سانتی‌متر', 'بسته‌بندی پیتزای سایز ۳۰ و سفارش بیرون‌بر', 'جعبه پیتزا ۳۰ سانتی طاقدیس، مناسب پیتزای استاندارد با ساختار ایفلوت و مقاومت مناسب حمل.', 22700, 'pizza-box-30-taghdis.png'),
            $this->product('SP-PIZZA-28-TAGHDIS', 'جعبه پیتزا ۲۸ سانتی طاقدیس دو رو کرافت', 'taghdis-28cm-kraft-pizza-box', 0, 'pizza', ['pizza', 'pizza-standard'], 'کارتن دو رو کرافت ایفلوت', '۲۸ × ۲۸ سانتی‌متر', 'بسته‌بندی پیتزای سایز ۲۸ و سفارش بیرون‌بر', 'جعبه پیتزا ۲۸ سانتی طاقدیس با ابعاد جمع‌وجور و مقوای کرافت ایفلوت مناسب ارسال.', 18700, 'pizza-box-28-taghdis.png'),
            $this->product('SP-PIZZA-24-TAGHDIS', 'جعبه پیتزا ۲۴ سانتی طاقدیس دو رو کرافت', 'taghdis-24cm-kraft-pizza-box', 0, 'pizza', ['pizza', 'pizza-standard'], 'کارتن دو رو کرافت ایفلوت', '۲۴ × ۲۴ سانتی‌متر', 'بسته‌بندی پیتزای کوچک سایز ۲۴ و سفارش بیرون‌بر', 'جعبه پیتزا ۲۴ سانتی طاقدیس برای پیتزای کوچک و تک‌نفره با حمل آسان و ظاهر کرافت.', 14100, 'pizza-box-24-taghdis.png'),
            $this->product('SP-BAG-KRAFT', 'پاکت کرافت بیرون‌بر دسته‌دار', 'kraft-takeaway-carry-bag', 0, 'expanded', ['carry-bag'], 'کاغذ کرافت Food Grade', 'سایزبندی متنوع', 'حمل جعبه غذا، فست‌فود، شیرینی و سفارش کافه', 'پاکت کرافت مقاوم با دسته یکپارچه برای تحویل مرتب سفارش و امکان چاپ اختصاصی لوگوی مجموعه.'),
            $this->product('SP-CUTLERY-WOOD', 'پک چوبی قاشق چنگال کارد و دستمال', 'wooden-cutlery-pack', 0, 'expanded', ['cutlery-pack'], 'چوب بهداشتی و لفاف شفاف', 'پک تک‌نفره', 'سفارش بیرون‌بر، کترینگ، رستوران و پذیرایی', 'پک کامل و بهداشتی قاشق، چنگال، کارد و دستمال برای تکمیل سفارش‌های بیرون‌بر و پذیرایی حرفه‌ای.'),
            $this->product('SP-CUP-PAPER', 'لیوان کاغذی یک‌بارمصرف درب‌دار', 'disposable-paper-cup-with-lid', 0, 'expanded', ['cups', 'paper-cup'], 'کاغذ مخصوص نوشیدنی Food Grade', 'سایزهای ۱۲۰ تا ۵۰۰ میلی‌لیتر', 'قهوه، چای، دمنوش و نوشیدنی گرم', 'لیوان کاغذی مقاوم با امکان انتخاب درب و چاپ اختصاصی، مناسب کافه، رستوران و رویداد.'),
            $this->product('SP-CUP-PLASTIC', 'لیوان شفاف یک‌بارمصرف درب گنبدی', 'clear-plastic-cup-dome-lid', 0, 'expanded', ['cups', 'plastic-cup'], 'پلاستیک شفاف Food Grade', 'سایزبندی متنوع', 'آبمیوه، شیک، اسموتی و نوشیدنی سرد', 'لیوان شفاف با درب گنبدی برای نمایش بهتر نوشیدنی و حمل مطمئن سفارش‌های سرد.'),
            $this->product('SP-ICECREAM-CUP', 'کاپ کاغذی بستنی و دسر', 'paper-ice-cream-dessert-cup', 0, 'expanded', ['icecream-packaging'], 'کاغذ روکش‌دار Food Grade', 'سایزهای تک‌نفره و خانوادگی', 'بستنی، دسر، ژله و خوراکی سرد', 'کاپ کاغذی مستحکم برای سرو بستنی و دسر با قابلیت سفارش درب و چاپ اختصاصی برند.'),
            $this->product('SP-SALAD-CLEAR', 'ظرف شفاف درب‌دار سالاد', 'clear-salad-container-with-lid', 0, 'expanded', ['disposable', 'salad-container'], 'پلاستیک شفاف Food Grade', 'سایزبندی متنوع', 'سالاد، میوه، سبزیجات و غذای سرد', 'ظرف شفاف درب‌دار با نمایش کامل محتویات و بسته‌شدن مطمئن برای سفارش‌های سرد و بیرون‌بر.'),
            $this->product('SP-SAUCE-CUP', 'کاپ شفاف درب‌دار سس', 'clear-sauce-cup-with-lid', 0, 'expanded', ['disposable', 'sauce-cup'], 'پلاستیک شفاف Food Grade', 'سایزهای کوچک', 'سس، چاشنی، ترشی و دورچین', 'کاپ کوچک درب‌دار برای بسته‌بندی بهداشتی سس و چاشنی در سفارش‌های رستورانی و فست‌فودی.'),
            $this->product('SP-STRAW-SKEWER', 'پک نی و سیخ چوبی یک‌بارمصرف', 'disposable-straws-wooden-skewers', 0, 'expanded', ['straw-skewer'], 'چوب و کاغذ بهداشتی', 'سایزبندی متنوع', 'نوشیدنی، فینگرفود، کباب و پذیرایی', 'مجموعه نی و سیخ چوبی سازگار با سرو حرفه‌ای کافه، رستوران، فست‌فود و مراسم.'),
            $this->product('SP-NUTS-POUCH', 'پاکت کرافت پنجره‌دار آجیل و خشکبار', 'kraft-window-nuts-pouch', 0, 'expanded', ['nuts-packaging'], 'کرافت چندلایه Food Grade', 'سایزبندی متنوع', 'آجیل، خشکبار، قهوه، ادویه و تنقلات', 'پاکت کرافت ایستاده با پنجره شفاف برای نمایش محصول، نگهداری بهتر و امکان چاپ اختصاصی برند.'),
            $this->product('SP-MICROWAVE-BOX', 'ظرف مشکی مایکروویوی درب شفاف', 'black-microwave-container-clear-lid', 0, 'expanded', ['disposable', 'microwave-container'], 'پلی‌پروپیلن Food Grade', 'تک‌خانه و چندخانه', 'غذای گرم، برنج، خوراک و سفارش بیرون‌بر', 'ظرف مقاوم در برابر حرارت با درب شفاف و بسته‌شدن مطمئن، مناسب ارسال و گرم‌کردن غذا.'),
            $this->product('SP-FOOD-TRAY', 'سینی کرافت سرو غذای یک‌بارمصرف', 'kraft-disposable-food-serving-tray', 0, 'expanded', ['food-tray'], 'مقوای کرافت Food Grade', 'سایزبندی متنوع', 'سیب‌زمینی، سوخاری، ساندویچ و فینگرفود', 'سینی کرافت با لبه‌های مقاوم برای سرو تمیز و حرفه‌ای انواع غذا و میان‌وعده.'),
            $this->product('SP-NAPKIN-HOLDER', 'جا دستمالی کرافت رومیزی', 'kraft-tabletop-napkin-holder', 0, 'expanded', ['table-service'], 'مقوای کرافت مقاوم', 'رومیزی استاندارد', 'رستوران، کافه، فست‌فود و کانتر پذیرایی', 'جا دستمالی رومیزی کرافت با ظاهر مینیمال برای نظم میز و هماهنگی با بسته‌بندی‌های دوستدار محیط زیست.'),
            $this->product('SP-BURGER-CLAMSHELL', 'جعبه برگر صدفی کرافت', 'kraft-clamshell-burger-box', 0, 'burger', ['burger'], 'مقوای کرافت Food Grade', '۱۲ × ۱۲ × ۸ سانتی‌متر', 'همبرگر، چیزبرگر و سفارش بیرون‌بر', 'جعبه برگر صدفی با درب یکپارچه و فضای استاندارد برای جلوگیری از فشرده‌شدن برگر.', null, 'catalog-burger.webp'),
            $this->product('SP-BURGER-LOCK', 'جعبه برگر لاک‌باتوم ایندربرد', 'lock-bottom-burger-box', 0, 'burger', ['burger'], 'مقوای ایندربرد Food Grade', '۱۳ × ۱۳ × ۸ سانتی‌متر', 'برگر ویژه، دوبل و فست‌فود بیرون‌بر', 'جعبه برگر لاک‌باتوم با کف قفل‌شونده و استحکام مناسب برای حمل سفارش.', null, 'catalog-burger.webp'),
            $this->product('SP-SANDWICH-KRAFT', 'جعبه ساندویچ کرافت استاندارد', 'standard-kraft-sandwich-box', 0, 'sandwich', ['sandwich'], 'مقوای کرافت Food Grade', '۲۴ × ۹ × ۷ سانتی‌متر', 'ساندویچ، هات‌داگ و غذای بیرون‌بر', 'جعبه ساندویچ کرافت با طول استاندارد برای حفظ فرم نان و چیدمان منظم محتویات.', null, 'catalog-sandwich.webp'),
            $this->product('SP-SANDWICH-DRAWER', 'جعبه ساندویچ کشویی ایندربرد', 'drawer-sandwich-box', 0, 'sandwich', ['sandwich'], 'مقوای ایندربرد Food Grade', '۲۵ × ۱۰ × ۷ سانتی‌متر', 'ساندویچ ویژه و هات‌داگ بیرون‌بر', 'جعبه کشویی ساندویچ با بازشدن آسان و ظاهر حرفه‌ای مناسب چاپ اختصاصی برند.', null, 'catalog-sandwich.webp'),
            $this->product('SP-SACHET-SPICE', 'ساشه ادویه تک‌نفره', 'single-serve-spice-sachet', 0, 'sachet', ['sachet'], 'لفاف چندلایه بهداشتی', 'پک تک‌نفره', 'نمک، فلفل، آویشن و ادویه مخصوص', 'ساشه ادویه تک‌نفره بهداشتی برای تکمیل سفارش رستوران و امکان چاپ اختصاصی.', null, 'catalog-sachet.webp'),
            $this->product('SP-FOOD-TAKEAWAY', 'جعبه غذای بیرون‌بر کرافت', 'kraft-takeaway-food-box', 0, 'food', ['food-box'], 'مقوای کرافت Food Grade', 'سایزبندی تک‌نفره و خانوادگی', 'برنج، خوراک، غذای گرم و کترینگ', 'جعبه غذای کرافت مقاوم برای ارسال منظم غذای گرم و سفارش‌های رستورانی.', null, 'catalog-food.webp'),
            $this->product('SP-FRIED-BUCKET', 'سطل سوخاری خانوادگی کرافت', 'kraft-family-fried-chicken-bucket', 0, 'fried-bucket', ['fried', 'fried-bucket'], 'مقوای Food Grade مقاوم به چربی', 'ظرفیت خانوادگی', 'مرغ سوخاری، بال و فیله', 'سطل مقوایی سوخاری با ظرفیت خانوادگی و فرم مناسب حمل و سرو سفارش‌های چندنفره.', null, 'catalog-bucket.webp'),
            $this->product('SP-TABLECLOTH', 'سفره یکبار مصرف رستورانی', 'restaurant-disposable-tablecloth', 0, 'tablecloth', ['tablecloth'], 'پلی‌اتیلن بهداشتی', 'رول استاندارد', 'رستوران، کترینگ، مراسم و سرو غذا', 'سفره یکبار مصرف بهداشتی و مقاوم برای آماده‌سازی سریع میز و نظافت آسان‌تر.', null, 'catalog-tablecloth.webp'),
            $this->product('SP-PIZZA-BOARD', 'سینگل زیر پیتزا مقوایی', 'cardboard-pizza-board', 0, 'pizza-board', ['pizza', 'pizza-board'], 'مقوای فشرده Food Grade', 'سایزهای ۲۴ تا ۳۲ سانتی‌متر', 'زیر پیتزا، سرو و تقویت کف جعبه', 'سینگل زیر پیتزا برای سرو تمیزتر، جابه‌جایی آسان و جلوگیری از تغییر شکل کف جعبه.', null, 'catalog-pizza-board.webp'),
            $this->product('SP-CUP-CARRIER-2', 'جالیوانی مقوایی دوخانه', 'two-cup-cardboard-carrier', 0, 'cups', ['cups', 'cup-carrier'], 'خمیر کاغذ بازیافتی مقاوم', 'دوخانه', 'حمل دو لیوان نوشیدنی گرم یا سرد', 'جالیوانی دوخانه با جای‌گیری پایدار لیوان‌ها برای تحویل امن سفارش‌های کافه.', null, 'catalog-cup.webp'),
            $this->product('SP-ICECREAM-TRAY', 'سینی مقوایی حمل بستنی', 'cardboard-ice-cream-cup-tray', 0, 'icecream', ['icecream-packaging', 'icecream-tray'], 'مقوای ایندربرد Food Grade', 'دو و چهار کاپ', 'حمل کاپ بستنی، دسر و نوشیدنی', 'سینی مقوایی مخصوص حمل چند کاپ بستنی و دسر با امکان چاپ اختصاصی مجموعه.', null, 'catalog-icecream.webp'),
        ];
    }

    private function product(
        string $sku,
        string $name,
        string $slug,
        int $page,
        string $imageGroup,
        array $categories,
        string $material,
        string $dimensions,
        string $usage,
        string $longDescription,
        ?int $priceToman = null,
        ?string $image = null,
    ): array {
        $primaryKeyword = match (true) {
            str_contains($name, 'سوخاری') => 'جعبه سوخاری',
            str_contains($name, 'سیب زمینی') => 'جعبه سیب زمینی',
            str_contains($name, 'پیتزا') => 'جعبه پیتزا',
            str_contains($name, 'لیوان') => 'لیوان یک بار مصرف',
            str_contains($name, 'قاشق') => 'پک قاشق و چنگال',
            str_contains($name, 'سالاد') => 'ظرف سالاد یک بار مصرف',
            str_contains($name, 'سس') => 'ظرف سس یک بار مصرف',
            str_contains($name, 'مایکروویوی') => 'ظرف مایکروویوی',
            str_contains($name, 'آجیل') => 'بسته بندی آجیل و خشکبار',
            str_contains($name, 'بستنی') => 'بسته بندی بستنی',
            str_contains($name, 'سینی') => 'سینی سرو غذا',
            str_contains($name, 'پاکت') => 'پاکت بیرون بر',
            default => 'کاغذ ساندویچ',
        };
        $colorOption = match (true) {
            str_contains($name, 'مشکی') => 'Black',
            str_contains($name, 'سفید') => 'White',
            default => 'Brown',
        };
        $sizeOption = match (true) {
            str_contains($name, 'نیم متری') => 'XXL',
            str_contains($name, '۳۲ سانتی') => 'XL',
            str_contains($name, '۳۰ سانتی') => 'L',
            str_contains($name, '۲۸ سانتی') => 'M',
            str_contains($name, '۲۴ سانتی') => 'S',
            str_contains($name, '۵ تکه') => 'L',
            str_contains($name, '۳ تکه') => 'M',
            str_contains($name, '۲ تکه') => 'S',
            str_contains($name, 'بزرگ') => 'L',
            str_contains($name, 'کوچک') => 'S',
            str_contains($name, 'دسته‌دار') => 'L',
            str_contains($name, '۳۵ در ۵۰') => 'L',
            str_contains($name, '۲۵ در ۳۵') => 'M',
            str_contains($name, 'نیوکلاسیک') => 'M',
            str_contains($name, 'قیفی') => 'L',
            str_contains($name, 'بشقاب') => 'M',
            default => 'Free Size',
        };

        $keywords = array_values(array_unique([
            $name,
            $primaryKeyword,
            'بسته بندی فست فود',
            'بسته بندی غذای بیرون بر',
            'خرید عمده بسته بندی',
            'چاپ اختصاصی جعبه غذا',
            'جعبه فروش',
        ]));

        $priceNote = $priceToman
            ? 'قیمت درج‌شده بر اساس لیست فروش و قابل سفارش آنلاین است.'
            : 'برای قیمت روز، تیراژ و چاپ اختصاصی استعلام بگیرید.';
        $shortDescription = "{$name}، {$material}، ابعاد {$dimensions}. مناسب {$usage}. {$priceNote}";

        return compact(
            'sku',
            'name',
            'slug',
            'page',
            'imageGroup',
            'categories',
            'material',
            'dimensions',
            'usage',
            'longDescription',
            'keywords',
            'shortDescription',
            'priceToman',
            'image',
            'colorOption',
            'sizeOption',
        ) + [
            'image_group' => $imageGroup,
            'long_description' => $longDescription,
            'short_description' => $shortDescription,
            'price_toman' => $priceToman,
            'color_option' => $colorOption,
            'size_option' => $sizeOption,
            'meta_title' => mb_substr("{$name} | جعبه فروش", 0, 60),
            'meta_description' => mb_substr("خرید عمده {$name}. {$material} با ابعاد {$dimensions}. مناسب {$usage}. مشاهده مشخصات و استعلام قیمت از جعبه فروش.", 0, 158),
        ];
    }
}
