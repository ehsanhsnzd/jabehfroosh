<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('invoices', fn (Blueprint $table) => $table->timestamp('purchase_credit_paid_at')->nullable()->index());
        // Historical invoices have no payment-state timestamp; retain their known date.
        DB::table('invoices')->where('state', 'paid')->update(['purchase_credit_paid_at' => DB::raw('created_at')]);
    }

    public function down(): void
    {
        Schema::table('invoices', fn (Blueprint $table) => $table->dropColumn('purchase_credit_paid_at'));
    }
};
