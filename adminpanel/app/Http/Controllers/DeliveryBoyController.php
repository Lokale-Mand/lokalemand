<?php

namespace App\Http\Controllers;

use App\Helpers\CommonHelper;
use App\Http\Controllers\API\OrdersApiController;
use App\Http\Controllers\API\OrderStatusApiController;
use App\Models\Category;
use App\Models\DeliveryBoy;
use App\Models\FundTransfer;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\OrderStatusList;
use App\Models\PanelNotification;
use App\Models\Product;
use App\Models\ProductVariant;
use App\Models\ReturnRequest;
use App\Models\Seller;
use App\Models\Setting;
use App\Models\Transaction;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Session;

class DeliveryBoyController extends BaseController
{
    public function index(){
        $delivery_boy_id = auth()->user()->deliveryBoy->id;
        $data = array();
        $data['order_count'] = Order::where('delivery_boy_id',$delivery_boy_id)->count();
        $data['balance'] = auth()->user()->deliveryBoy->balance;
        return CommonHelper::responseWithData($data);
    }
    public function doLanguageChange(Request $request)
    {
        Session::put('lang',$request->language);
        // Log::info('session : '.Session::get('lang'));
        return response()->json(['status' => true]);
    }

    public function createSlug($text){
        $slug = CommonHelper::slugify($text);
        return CommonHelper::responseWithData($slug);
    }

    public function getTopNotifications(){
        $notifications = PanelNotification::where('notifiable_id',auth()->user()->id);
        $unReadCount = (clone $notifications)->where('read_at',NULL)->get()->count();
        $notifications = $notifications->orderBy('created_at','DESC')->get();

        $data = array();
        $data['unread'] = $unReadCount;
        $data['notifications'] = $notifications;
        return CommonHelper::responseWithData($data);
    }

    public function markAsReadNotifications(Request $request){

        //$notification = PanelNotification::where('id',$request->id)->first();
        auth()->user()
            ->unreadNotifications
            ->when($request->input('id'), function ($query) use ($request) {
                return $query->where('id', $request->input('id'));
            })
            ->markAsRead();
        return CommonHelper::responseWithData("Notification Mark as Read Successfully!");

    }

    public function getOrders(Request $request){

        $delivery_boy_id = auth()->user()->deliveryBoy->id;

        $limit = ($request->limit)??12;
        $offset = ($request->offset)??0;

        $startDate = Carbon::parse($request->input('startDate'))->startOfDay();
        $endDate = Carbon::parse($request->input('endDate'))->endOfDay();

        $orders = Order::select('orders.*','orders.id as order_id','delivery_boys.name as delivery_boy_name','sellers.name as seller_name',
            'users.name as user_name','order_items.active_status as order_status')
            ->leftJoin('order_items', 'order_items.order_id', '=', 'orders.id')
            ->leftJoin('users', 'orders.user_id', '=', 'users.id')
            ->leftJoin('product_variants', 'order_items.product_variant_id', '=', 'product_variants.id')
            ->leftJoin('products', 'product_variants.product_id', '=', 'products.id')
            ->leftJoin('delivery_boys', 'order_items.delivery_boy_id', '=', 'delivery_boys.id')
            ->leftJoin('sellers', 'order_items.seller_id', '=', 'sellers.id')->where('orders.delivery_boy_id', $delivery_boy_id);

        if(isset($request->startDate) && $request->startDate != "" && isset($request->endDate) && $request->endDate != ""){
            $orders = $orders->whereBetween('order_items.created_at', [$startDate, $endDate]);
        }

        if(isset($request->status) && $request->status != "" && $request->status != 0){
            $orders = $orders->where('orders.active_status', $request->status);
        }
        $totalOrder = clone $orders;
        $totalOrder = $totalOrder->groupBy('orders.id')->get()->count();
        $orders = $orders->groupBy('orders.id')->orderBy('orders.id','DESC')->skip($offset)->take($limit)->get();
        //$orders = $orders->makeHidden(['image','updated_at','deleted_at','current_status']);

        $order_items = Order::select('order_items.*','orders.mobile','orders.total' ,'orders.delivery_charge','orders.discount','orders.promo_code',
            'orders.promo_discount','orders.wallet_balance','orders.final_total','orders.payment_method','orders.address','orders.delivery_time',
            'users.name as user_name'
            ,'order_items.status as order_status','sellers.name as seller_name')
            ->leftJoin('order_items', 'order_items.order_id', '=', 'orders.id')
            ->leftJoin('users', 'orders.user_id', '=', 'users.id')
            ->leftJoin('product_variants', 'order_items.product_variant_id', '=', 'product_variants.id')
            ->leftJoin('products', 'product_variants.product_id', '=', 'products.id')
            ->leftJoin('delivery_boys', 'order_items.delivery_boy_id', '=', 'delivery_boys.id')
            ->leftJoin('sellers', 'order_items.seller_id', '=', 'sellers.id')->where('orders.delivery_boy_id', $delivery_boy_id);

        if(isset($request->startDate) && $request->startDate != "" && isset($request->endDate) && $request->endDate != ""){
            $order_items = $order_items->whereBetween('order_items.created_at', [$startDate, $endDate]);
        }
        if(isset($request->status) && $request->status != "" && $request->status != 0){
            $order_items = $order_items->where('orders.active_status', $request->status);
        }
        $totalOrderItem = clone $order_items;
        $totalOrderItem = $totalOrderItem->count();
        $order_items = $order_items->orderBy('order_items.id','DESC')->skip($offset)->take($limit)->get();
        //$order_items = $order_items->makeHidden(['image','updated_at','deleted_at','current_status']);
        $data = array(
            "orders" => $orders,
            "total_order_item" => $totalOrderItem,
            "order_items" => $order_items
        );
        return CommonHelper::responseWithData($data,$totalOrder);
    }
    public function getOrder(Request $request){
        //app(TwitterController::class)->functionName($request);
        return app(OrdersApiController::class)->view($request->order_id);
    }
    public function getOrderStatus(){
        return app(OrderStatusApiController::class)->getOrderStatus();
    }
    public function getCashCollection(Request $request){
        $delivery_boy_id = auth()->user()->deliveryBoy->id;
        $transactions = Transaction::select('delivery_boys.name','delivery_boys.mobile','delivery_boys.address', 'transactions.*')
            ->leftJoin('delivery_boys', 'transactions.user_id', '=', 'delivery_boys.id')->where('transactions.user_id', $delivery_boy_id);
        if(isset($request->startDate) && $request->startDate != "" && isset($request->endDate) && $request->endDate != ""){
            $startDate = Carbon::parse($request->input('startDate'))->startOfDay();
            $endDate = Carbon::parse($request->input('endDate'))->endOfDay();
            $transactions = $transactions->whereBetween('transactions.created_at', [$startDate, $endDate]);
        }
        $transactions = $transactions->orderBy('transactions.id','DESC')->get();

        $data['transactions'] = $transactions;
        $data['cash_in_hand'] = DeliveryBoy::where('id',$delivery_boy_id)->value('cash_received');
        $data['cash_collected'] = Transaction::select(DB::raw('SUM(amount) AS total_amt'))->where(['type' => 'delivery_boy_cash_collection', 'user_id' => $delivery_boy_id])->value('total_amt');
        return CommonHelper::responseWithData($data);
    }
    public function getFundTransfers(){
        $delivery_boy_id = auth()->user()->deliveryBoy->id;
        $fundTransfers = FundTransfer::select('delivery_boys.name','delivery_boys.mobile','delivery_boys.address', 'fund_transfers.*')
            ->leftJoin('delivery_boys', 'fund_transfers.delivery_boy_id', '=', 'delivery_boys.id')->where('fund_transfers.delivery_boy_id', $delivery_boy_id)
            ->orderBy('fund_transfers.id','DESC')->get();
        return CommonHelper::responseWithData($fundTransfers);
    }


    public function getProductSalesReport(Request $request){
        $delivery_boy_id = auth()->user()->deliveryBoy->id;
        $startDate = Carbon::parse($request->input('startDate'))->startOfDay();
        $endDate = Carbon::parse($request->input('endDate'))->endOfDay();
        $ProductSalesReports = OrderItem::select('product_variants.product_id','products.name as product_name',
            'sellers.name as seller_name','product_variants.measurement','units.short_code AS unit_name','order_items.*',
            DB::raw('(SELECT COUNT(order_items.product_variant_id) FROM order_items WHERE product_variants.id = order_items.product_variant_id) as total_sales'),
            DB::raw('(SELECT SUM(order_items.sub_total) FROM `order_items` WHERE product_variants.id = order_items.product_variant_id) as total_price')
        )
            ->leftJoin('orders', 'order_items.order_id', '=', 'orders.id')
            ->leftJoin('product_variants', 'order_items.product_variant_id', '=', 'product_variants.id')
            ->leftJoin('units', 'product_variants.stock_unit_id', '=', 'units.id')
            ->leftJoin('products', 'product_variants.product_id', '=', 'products.id')
            ->leftJoin('sellers', 'products.seller_id', '=', 'sellers.id')
            ->where('orders.delivery_boy_id', $delivery_boy_id)
            ->where('orders.active_status', OrderStatusList::$delivered)
            ->whereBetween('order_items.created_at', [$startDate, $endDate])
            ->orderBy('order_items.id','DESC')
            ->groupBy('product_variants.id')
            ->get();
        return CommonHelper::responseWithData($ProductSalesReports);
    }

    public function getSalesReport(Request $request){
        $delivery_boy_id = auth()->user()->deliveryBoy->id;
        $startDate = Carbon::parse($request->input('startDate'))->startOfDay();
        $endDate = Carbon::parse($request->input('endDate'))->endOfDay();
        $categories = Category::orderBy('id','DESC')->get()->toArray();
        $SalesReports = OrderItem::select('order_items.id','orders.total',
            'order_items.seller_id','order_items.sub_total','orders.user_id','orders.mobile',
            'products.name as product_name','orders.final_total','orders.address',
            'users.name as user_name','order_items.status',
            DB::raw('DATE_FORMAT(order_items.created_at,"%d-%m-%Y") as added_date'))
            ->leftJoin('users', 'order_items.user_id', '=', 'users.id')
            ->leftJoin('product_variants', 'order_items.product_variant_id', '=', 'product_variants.id')
            ->leftJoin('products', 'product_variants.product_id', '=', 'products.id')
            ->leftJoin('orders', 'order_items.order_id', '=', 'orders.id')
            ->where('orders.delivery_boy_id', $delivery_boy_id)
            ->whereBetween('order_items.created_at', [$startDate, $endDate])
            ->where('orders.active_status', OrderStatusList::$delivered);
        if(isset($request->category) && $request->category != ""){
            $SalesReports = $SalesReports->where('products.category_id', $request->category);
        }
        $SalesReports = $SalesReports->orderBy('order_items.id','DESC')->get();
        $data = array(
            "categories" => $categories,
            "salesReports" => $SalesReports
        );
        return CommonHelper::responseWithData($data);
    }

    public function getSettings(){
        $variables = array(
            "app_name",
            "support_number",
            "support_email",
            "current_version",
            "minimum_version_required",
            "is_version_system_on",
            "ios_is_version_system_on",
            "currency",
            "currency_code",
            "decimal_point",
            "low_stock_limit",
            "app_mode_seller",
            "privacy_policy_delivery_boy",
            "terms_conditions_delivery_boy",
            "google_place_api_key"
        );
        $settings = CommonHelper::getSettings($variables);
        $settings["allPermissions"] = auth()->user()->allPermissions;
        if(!empty($settings)){
            return CommonHelper::responseWithData($settings);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

    public function getPrivacyPolicy(){
        $variables = array(
            "privacy_policy_delivery_boy",
            "terms_conditions_delivery_boy",
        );
        $settings = CommonHelper::getSettings($variables);

        if(!empty($settings)){
            return CommonHelper::responseWithData($settings);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }























    public function deploy(){

        //exec("git reset --hard");
        exec("git pull");
        exec("composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev");
        exec("php artisan migrate");
        echo "Done";
    }
}
