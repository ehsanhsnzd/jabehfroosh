<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * The catalogue uses Bagisto's existing configurable color attribute.
     */
    public function up(): void
    {
        DB::table('attributes')
            ->whereIn('code', ['print_color_primary', 'print_color_secondary'])
            ->delete();
    }

    public function down(): void
    {
        // These duplicate attributes must not be restored on rollback.
    }
};
