<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('customers', function (Blueprint $table) {
            $table->string('credit_verified_phone', 11)->nullable();
            $table->timestamp('credit_phone_verified_at')->nullable();
        });

        Schema::create('customer_credit_accounts', function (Blueprint $table) {
            $table->id();
            $table->string('phone', 11)->unique();
            $table->unsignedInteger('customer_id')->nullable()->unique();
            $table->foreign('customer_id')->references('id')->on('customers')->nullOnDelete();
            $table->string('holder_name')->nullable();
            $table->text('iban')->nullable();
            $table->string('iban_last_four', 4)->nullable()->index();
            $table->text('notes')->nullable();
            $table->boolean('is_active')->default(true)->index();
            $table->unsignedBigInteger('balance_rial')->default(0);
            $table->timestamps();
        });

        Schema::create('customer_credit_transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('credit_account_id')->constrained('customer_credit_accounts')->restrictOnDelete();
            $table->string('kind', 20)->index();
            $table->bigInteger('amount_rial');
            $table->unsignedBigInteger('balance_after_rial');
            $table->string('idempotency_key', 100)->unique();
            $table->unsignedInteger('order_id')->nullable()->index();
            $table->unsignedInteger('refund_id')->nullable()->index();
            $table->unsignedInteger('cart_id')->nullable()->unique();
            $table->unsignedInteger('admin_id')->nullable()->index();
            $table->string('reference', 150)->nullable()->index();
            $table->text('reason');
            $table->json('metadata')->nullable();
            $table->timestamp('created_at')->useCurrent()->index();
            $table->index(['credit_account_id', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('customer_credit_transactions');
        Schema::dropIfExists('customer_credit_accounts');
        Schema::table('customers', function (Blueprint $table) {
            $table->dropColumn(['credit_verified_phone', 'credit_phone_verified_at']);
        });
    }
};
