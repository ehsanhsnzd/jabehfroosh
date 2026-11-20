<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('purchase_credit_applications', fn (Blueprint $table) => $table->boolean('amount_is_net')->default(false));
    }

    public function down(): void
    {
        Schema::table('purchase_credit_applications', fn (Blueprint $table) => $table->dropColumn('amount_is_net'));
    }
};
