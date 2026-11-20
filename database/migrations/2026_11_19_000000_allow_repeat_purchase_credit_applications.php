<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('purchase_credit_applications', function (Blueprint $table) {
            $table->index(['customer_id', 'id']);
        });
        Schema::table('purchase_credit_applications', function (Blueprint $table) {
            $table->dropUnique(['customer_id']);
        });
    }

    public function down(): void
    {
        Schema::table('purchase_credit_applications', function (Blueprint $table) {
            $table->unique('customer_id');
        });
        Schema::table('purchase_credit_applications', function (Blueprint $table) {
            $table->dropIndex(['customer_id', 'id']);
        });
    }
};
