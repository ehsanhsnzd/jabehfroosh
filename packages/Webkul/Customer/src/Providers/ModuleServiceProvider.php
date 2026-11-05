<?php

namespace Webkul\Customer\Providers;

use Webkul\Core\Providers\CoreModuleServiceProvider;
use Webkul\Customer\Models\CompareItem;
use Webkul\Customer\Models\CreditAccount;
use Webkul\Customer\Models\CreditTransaction;
use Webkul\Customer\Models\Customer;
use Webkul\Customer\Models\CustomerAddress;
use Webkul\Customer\Models\CustomerGroup;
use Webkul\Customer\Models\CustomerNote;
use Webkul\Customer\Models\Wishlist;

class ModuleServiceProvider extends CoreModuleServiceProvider
{
    /**
     * Models.
     *
     * @var array
     */
    protected $models = [
        CompareItem::class,
        CreditAccount::class,
        CreditTransaction::class,
        Customer::class,
        CustomerAddress::class,
        CustomerGroup::class,
        CustomerNote::class,
        Wishlist::class,
    ];
}
