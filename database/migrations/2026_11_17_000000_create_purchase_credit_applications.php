<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('purchase_credit_applications', function (Blueprint $table) {
            $table->id();
            $table->unsignedInteger('customer_id')->unique();
            $table->foreign('customer_id')->references('id')->on('customers')->cascadeOnDelete();
            $table->string('status', 30)->default('documents_pending')->index();
            $table->unsignedBigInteger('requested_toman');
            $table->unsignedBigInteger('ceiling_toman');
            $table->unsignedBigInteger('approved_toman')->nullable();
            $table->json('documents');
            $table->json('history');
            $table->text('cheque_reference')->nullable();
            $table->text('rejection_reason')->nullable();
            $table->timestamp('activated_at')->nullable();
            $table->timestamps();
        });
        Schema::create('purchase_credit_notices', function (Blueprint $table) {
            $table->id();
            $table->unsignedInteger('customer_id');
            $table->foreign('customer_id')->references('id')->on('customers')->cascadeOnDelete();
            $table->string('delivery_key', 150)->unique();
            $table->string('kind', 20);
            $table->string('status', 20)->index();
            $table->unsignedBigInteger('amount_toman');
            $table->unsignedInteger('order_id')->nullable();
            $table->string('phone', 11);
            $table->text('message');
            $table->string('error', 100)->nullable();
            $table->timestamp('sent_at')->nullable();
            $table->timestamps();
        });
        Schema::table('customers', function (Blueprint $table) {
            $table->boolean('credit_marketing_opt_out')->default(false);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('purchase_credit_notices');
        Schema::dropIfExists('purchase_credit_applications');
        Schema::table('customers', fn (Blueprint $table) => $table->dropColumn('credit_marketing_opt_out'));
    }
};
