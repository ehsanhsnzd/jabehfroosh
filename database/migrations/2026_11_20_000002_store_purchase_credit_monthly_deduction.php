<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('purchase_credit_applications', fn (Blueprint $table) => $table->unsignedTinyInteger('monthly_deduction_percent')->default(10));
    }

    public function down(): void
    {
        Schema::table('purchase_credit_applications', fn (Blueprint $table) => $table->dropColumn('monthly_deduction_percent'));
    }
};
