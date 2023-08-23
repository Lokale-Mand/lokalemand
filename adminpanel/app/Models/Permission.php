<?php

namespace App\Models;

use Spatie\Permission\Models\Permission as BasePermission;

Class Permission extends BasePermission
{
    protected $table = 'permissions';

    // Add route to this array if only one permission should be checked against a route.
    // e.g. 'permission-name' => ['route-1', 'route-1']
    // access to route-1 will be grated if only user has access to permission 'permission-name'
    public const ROUTE_MATCH = [
        'manage_dashboard' => ['home'],

        /*orders*/
        'manage_order' => ['deliveries.manage'],
        'create_order' => ['deliveries.create','deliveries.store'],
        'order_details' => ['delivery.detail'],
        'delete_order' => ['delivery.delete'],
        'change_order_status' => ['change_status'],
        'change_region' => ['change_bus'],
        'change_driver' => ['change_driver'],

    ];

}
