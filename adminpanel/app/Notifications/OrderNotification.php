<?php

namespace App\Notifications;

use App\Helpers\CommonHelper;
use App\Models\Admin;
use App\Models\AdminToken;
use App\Models\Order;
use App\Models\OrderStatusList;
use App\Models\UserToken;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Support\Facades\Log;

class OrderNotification extends Notification
{
    use Queueable;
    public $order_id;
    public $type;
    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct($order_id,$type)
    {
        $this->order_id = $order_id;
        $this->type = $type;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function via($notifiable)
    {
        return ['database'];
    }

    /**
     * Get the array representation of the notification.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function toArray($notifiable)
    {
        $order = Order::with('user')->where('id',$this->order_id)->first();

        if($order) {

            // CommonHelper::sendNotificationOrderStatus($order);

            $orderStatusList = OrderStatusList::where('id', $order->active_status)->first();
            $status_name = $orderStatusList->status;

            /*$text = '';
            if($this->type == OrderStatusList::$received){
                $text =  "You have new order from " .$order->user->name." with Order ID : ".$order->id;
            }elseif($this->type == "refund"){
                $text =  $order->user->name." has requested for refund against Order ID : ".$order->id;
            }elseif($this->type == "cancel"){
                $text = "Order is cancelled with Order ID :".$order->id;
            }*/


            if ($order->active_status == OrderStatusList::$received) {
                $text = "You have " . $status_name . " new order  #" . $order->id;
            } else {
                $text = "Order  #" . $order->id . " has been " . $status_name;
            }

            //User
            /*$userTokens = UserToken::where('user_id',$order->user->id)->get()->pluck('fcm_token')->toArray();
            Log::info("userTokens : ",[$userTokens]);*/





            //Admin
            $adminTokens = AdminToken::where('user_id',$notifiable->id)->get()->pluck('fcm_token')->toArray();
            Log::info("adminTokens : ",[$adminTokens]);
            Log::info("notifiable : ",[$notifiable]);



            //Log::info("allUserTokens : ",[$allUserTokens]);
            if(count($adminTokens)>0){

                CommonHelper::sendNotification($adminTokens,"Order Status Updated!",$text);

            }

            return [
                'type' => $this->type,
                'order_id' => $order->id,
                'text' => $text,
            ];
        }else{

             $adminTokens = AdminToken::get()->pluck('fcm_token')->toArray();
            Log::info("Notifications : ",[$adminTokens]);
            CommonHelper::sendNotification($adminTokens,"Order Status Updated!","Test");
            return ['text'=>'testing'];
        }
    }
}
