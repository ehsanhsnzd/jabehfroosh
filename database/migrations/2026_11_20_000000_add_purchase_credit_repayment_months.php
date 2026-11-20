<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('purchase_credit_applications', fn (Blueprint $table) => $table->unsignedTinyInteger('repayment_months')->default(1));
    }

    public function down(): void
    {
        Schema::table('purchase_credit_applications', fn (Blueprint $table) => $table->dropColumn('repayment_months'));
    }
};
