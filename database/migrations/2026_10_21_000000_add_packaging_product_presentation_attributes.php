<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Add product fields used by the packaging catalogue cards.
     */
    public function up(): void
    {
        $attributes = [
            [
                'code' => 'paper_type',
                'admin_name' => 'نوع کاغذ',
                'type' => 'text',
            ],
            [
                'code' => 'sale_unit',
                'admin_name' => 'واحد فروش',
                'type' => 'select',
                'options' => [
                    ['admin_name' => 'عدد'],
                    ['admin_name' => 'کیلوگرم'],
                ],
            ],
        ];

        $attributeIds = [];

        foreach ($attributes as $position => $definition) {
            $attributeId = DB::table('attributes')->where('code', $definition['code'])->value('id');

            if (! $attributeId) {
                $attributeId = DB::table('attributes')->insertGetId([
                    'code' => $definition['code'],
                    'admin_name' => $definition['admin_name'],
                    'type' => $definition['type'],
                    'swatch_type' => $definition['swatch_type'] ?? null,
                    'position' => 200 + $position,
                    'is_required' => false,
                    'is_unique' => false,
                    'is_filterable' => false,
                    'is_comparable' => false,
                    'is_configurable' => false,
                    'is_user_defined' => true,
                    'is_visible_on_front' => false,
                    'value_per_locale' => false,
                    'value_per_channel' => false,
                    'enable_wysiwyg' => false,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);

                foreach ($definition['options'] ?? [] as $optionPosition => $option) {
                    $optionId = DB::table('attribute_options')->insertGetId([
                        'attribute_id' => $attributeId,
                        'admin_name' => $option['admin_name'],
                        'swatch_value' => $option['swatch_value'] ?? null,
                        'sort_order' => $optionPosition,
                    ]);

                    DB::table('attribute_option_translations')->insert([
                        'attribute_option_id' => $optionId,
                        'locale' => 'fa',
                        'label' => $option['admin_name'],
                    ]);
                }
            }

            DB::table('attribute_translations')->updateOrInsert([
                'attribute_id' => $attributeId,
                'locale' => 'fa',
            ], [
                'name' => $definition['admin_name'],
            ]);

            $attributeIds[] = $attributeId;
        }

        DB::table('attribute_families')->orderBy('id')->each(function ($family) use ($attributeIds) {
            $groupId = DB::table('attribute_groups')
                ->where('attribute_family_id', $family->id)
                ->where('code', 'sales-presentation')
                ->value('id');

            if (! $groupId) {
                $groupId = DB::table('attribute_groups')->insertGetId([
                    'attribute_family_id' => $family->id,
                    'name' => 'مشخصات فروش',
                    'code' => 'sales-presentation',
                    'column' => 2,
                    'position' => 999,
                    'is_user_defined' => true,
                ]);
            }

            foreach ($attributeIds as $position => $attributeId) {
                DB::table('attribute_group_mappings')->updateOrInsert([
                    'attribute_id' => $attributeId,
                    'attribute_group_id' => $groupId,
                ], [
                    'position' => $position,
                ]);
            }
        });
    }

    /**
     * Remove only the mappings and attributes introduced by this migration.
     */
    public function down(): void
    {
        DB::table('attributes')
            ->whereIn('code', [
                'paper_type',
                'sale_unit',
            ])
            ->delete();

        DB::table('attribute_groups')
            ->where('code', 'sales-presentation')
            ->delete();
    }
};
