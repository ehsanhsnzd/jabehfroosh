<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Webkul\Customer\Helpers\CreditIdentity;
use Webkul\Customer\Repositories\CreditChequeRepository;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('customer_credit_cheques', fn (Blueprint $table) => $table->string('sayad_hash', 64)->nullable());
        app(CreditChequeRepository::class)->getModel()->newQuery()->chunkById(200, function ($rows) {
            foreach ($rows as $row) {
                $row->update(['reference_hash' => hash('sha256', CreditChequeRepository::normalizeReference($row->reference)), 'sayad_hash' => $row->sayad_id ? hash('sha256', CreditIdentity::digits($row->sayad_id)) : null]);
            }
        });
        Schema::table('customer_credit_cheques', function (Blueprint $table) {
            $table->unique(['customer_id', 'reference_hash']);
            $table->unique('sayad_hash');
        });
    }

    public function down(): void
    {
        Schema::table('customer_credit_cheques', function (Blueprint $table) {
            $table->dropUnique(['customer_id', 'reference_hash']);
            $table->dropUnique(['sayad_hash']);
            $table->dropColumn('sayad_hash');
        });
    }
};
