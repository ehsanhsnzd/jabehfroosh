<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('purchase_credit_applications', fn (Blueprint $table) => $table->boolean('identity_bypassed')->default(false));
        Schema::create('customer_credit_cheques', function (Blueprint $table) {
            $table->id();
            $table->uuid('request_key')->unique();
            $table->unsignedInteger('customer_id');
            $table->unsignedBigInteger('application_id')->nullable()->unique();
            $table->foreign('application_id')->references('id')->on('purchase_credit_applications')->nullOnDelete();
            $table->foreign('customer_id')->references('id')->on('customers')->restrictOnDelete();
            $table->string('company_name')->nullable()->index();
            $table->text('reference');
            $table->string('reference_hash', 64)->index();
            $table->text('sayad_id')->nullable();
            $table->string('bank_name', 100)->nullable();
            $table->date('due_date')->index();
            $table->unsignedBigInteger('amount_toman');
            $table->boolean('sayad_confirmed')->default(false)->index();
            $table->string('status', 20)->default('received')->index();
            $table->unsignedBigInteger('allocated_toman')->default(0);
            $table->timestamp('allocated_at')->nullable();
            $table->unsignedInteger('allocated_by')->nullable();
            $table->unsignedInteger('created_by');
            $table->text('notes')->nullable();
            $table->json('document')->nullable();
            $table->json('history');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('customer_credit_cheques');
        Schema::table('purchase_credit_applications', fn (Blueprint $table) => $table->dropColumn('identity_bypassed'));
    }
};
