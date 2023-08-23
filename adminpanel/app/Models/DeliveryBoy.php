<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DeliveryBoy extends Model
{
    use HasFactory;
    protected $appends = ['pending_order_count'];

    // 0 - "Register", 1 - "Active", 2 - "Not Approved", 3 - "Deactive"

    public static $bonusFixed = 0;
    public static $bonusCommission = 1;
    public static $commission = "Commission";
    public static $fixed = "Fixed/Salaried";


    public static $statusRegistered = 0;
    public static $statusActive = 1;
    public static $statusRejected = 2;
    public static $statusDeactivated = 3;
    public static $statusRemoved = 7;

    public static $Registered = "Registered";
    public static $Active = "Active";
    public static $Rejected = "Rejected";
    public static $Deactivated = "Deactivated";
    public static $Removed = "Removed";

    public function admin(){
        return $this->belongsTo(Admin::class,'admin_id','id');
    }

    public function getPendingOrderCountAttribute(){
        $ignoreStatus = array(
            OrderStatusList::$paymentPending,
            OrderStatusList::$delivered,
            OrderStatusList::$cancelled,
            OrderStatusList::$returned,
        );
        return Order::where('delivery_boy_id', $this->id)->whereNotIn('active_status', $ignoreStatus)->count();
    }
}
