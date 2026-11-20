<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('purchase_credit_applications', function (Blueprint $table) {
            $table->timestamp('identity_approved_at')->nullable();
            $table->timestamp('cheque_approved_at')->nullable();
        });
        DB::table('purchase_credit_applications')->whereIn('status', ['cheque_pending', 'allocation_pending', 'active'])
            ->update(['identity_approved_at' => DB::raw('COALESCE(activated_at, updated_at)')]);
        DB::table('purchase_credit_applications')->whereIn('status', ['allocation_pending', 'active'])
            ->update(['cheque_approved_at' => DB::raw('COALESCE(activated_at, updated_at)')]);
    }

    public function down(): void
    {
        Schema::table('purchase_credit_applications', function (Blueprint $table) {
            $table->dropColumn(['identity_approved_at', 'cheque_approved_at']);
        });
    }
};
