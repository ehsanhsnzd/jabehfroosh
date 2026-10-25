<?php

namespace Webkul\Shop\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Webkul\Attribute\Repositories\AttributeOptionRepository;
use Webkul\Attribute\Repositories\AttributeRepository;
use Webkul\Product\Helpers\Review;

class ProductCardResource extends JsonResource
{
    /**
     * Review helper instance.
     *
     * @var Review
     */
    protected $reviewHelper;

    /**
     * Create a new resource instance.
     *
     * @param  mixed  $resource
     * @return void
     */
    public function __construct($resource)
    {
        $this->reviewHelper = app(Review::class);

        parent::__construct($resource);
    }

    /**
     * Transform the resource into an array.
     *
     * This is a slim variant of {@see ProductResource} used for product
     * listings and carousels. The heavy `description` field and the full
     * `images` gallery are intentionally omitted - the product card never
     * renders them - which keeps listing payloads small and avoids
     * generating cached gallery image URLs for every product.
     *
     * @param  Request  $request
     * @return array
     */
    public function toArray($request)
    {
        $productTypeInstance = $this->getTypeInstance();
        $unitPriceProduct = $this->parent_id ? $this->parent : $this;
        $prices = $productTypeInstance->getProductPrices();

        $regularPrice = data_get($prices, 'regular.price', data_get($prices, 'from.regular.price'));
        $finalPrice = data_get($prices, 'final.price', data_get($prices, 'from.final.price'));

        $discountPercent = $regularPrice && $finalPrice && $finalPrice < $regularPrice
            ? (int) round((($regularPrice - $finalPrice) / $regularPrice) * 100)
            : 0;

        $presentation = $this->getPresentationAttributes();

        $ratingAverage = $this->reviewHelper->getAverageRating($this);

        return [
            'id' => $this->id,
            'sku' => $this->sku,
            'name' => $this->name,
            'url_key' => $this->url_key,
            'base_image' => product_image()->getProductBaseImage($this),
            'is_new' => (bool) $this->new,
            'is_featured' => (bool) $this->featured,
            'on_sale' => (bool) $productTypeInstance->haveDiscount(),
            'is_saleable' => (bool) $productTypeInstance->isSaleable(),
            'is_catalog_inquiry' => str_starts_with($this->sku, 'SP-')
                && (float) $productTypeInstance->getMinimalPrice() <= 0,
            'discount_percent' => $discountPercent,
            'paper_type' => $presentation['paper_type'],
            'sale_unit' => $presentation['sale_unit'],
            'print_colors' => $presentation['print_colors'],
            'is_wishlist' => (bool) auth()->guard()->user()?->wishlist_items
                ->where('channel_id', core()->getCurrentChannel()->id)
                ->where('product_id', $this->id)->count(),
            'unit_price' => core()->formatPrice($unitPriceProduct->price),
            'min_price' => core()->formatPrice($productTypeInstance->getMinimalPrice()),
            'price_html' => $productTypeInstance->getPriceHtml(),
            'ratings' => [
                'average' => (float) $ratingAverage > 0 ? $ratingAverage : 2.8,
                'total' => $this->reviewHelper->getTotalRating($this),
            ],
            'reviews' => [
                'total' => $this->reviewHelper->getTotalReviews($this),
            ],
        ];
    }

    /**
     * Prepare manually maintained packaging details for the compact catalogue card.
     */
    protected function getPresentationAttributes(): array
    {
        $attributeRepository = app(AttributeRepository::class);
        $optionRepository = app(AttributeOptionRepository::class);

        $attributes = collect([
            'paper_type',
            'sale_unit',
            'color',
        ])->mapWithKeys(fn (string $code) => [$code => $attributeRepository->findOneByField('code', $code)]);

        $saleUnitAttribute = $attributes['sale_unit'];
        $saleUnitValue = $this->getCustomAttributeValue($saleUnitAttribute);
        $saleUnit = $saleUnitValue ? $optionRepository->find($saleUnitValue) : null;

        $colorAttribute = $attributes['color'];

        $colorOptionIds = $this->type === 'configurable'
            ? $this->variants()->get()->map(fn ($variant) => $variant->getCustomAttributeValue($colorAttribute))
            : collect([$this->getCustomAttributeValue($colorAttribute)]);

        $printColors = $colorOptionIds
            ->filter()
            ->map(fn ($optionId) => $optionRepository->find($optionId)?->swatch_value)
            ->filter()
            ->unique()
            ->values()
            ->all();

        return [
            'paper_type' => $this->getCustomAttributeValue($attributes['paper_type']),
            'sale_unit' => $saleUnit?->label ?: $saleUnit?->admin_name ?: 'عدد',
            'print_colors' => $printColors,
        ];
    }
}
