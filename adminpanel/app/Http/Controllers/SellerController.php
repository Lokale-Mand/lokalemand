<?php

namespace App\Http\Controllers;

use App\Helpers\CommonHelper;
use App\Http\Controllers\API\OrdersApiController;
use App\Http\Controllers\API\OrderStatusApiController;
use App\Models\Category;
use App\Models\City;
use App\Models\DeliveryBoy;
use App\Models\Favorite;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\OrderStatusList;
use App\Models\PanelNotification;
use App\Models\Product;
use App\Models\ProductVariant;
use App\Models\ReturnRequest;
use App\Models\Seller;
use App\Models\Setting;
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

class SellerController extends BaseController
{
    public function index(){

        $seller_id = auth()->user()->seller->id;
        $orderIds = OrderItem::where('seller_id',$seller_id)->get()->pluck('order_id')->toArray() ?? [];
        $productsIds = Product::where('seller_id',$seller_id)->get()->pluck('id')->toArray() ?? [];

        $data = array();

        $data['order_count'] = Order::whereIn('id',$orderIds)->count() ?? 0;

        $ignoreStatus = array(
            OrderStatusList::$paymentPending,
            OrderStatusList::$delivered,
            OrderStatusList::$cancelled,
            OrderStatusList::$returned,
        );
        $data['pending_order_count'] = Order::whereIn('id',$orderIds)->whereNotIn('active_status', $ignoreStatus)->count() ?? 0;

        $data['product_count'] = Product::where('seller_id',$seller_id)->get()->count() ?? 0;

        $categoryIds = Seller::select('categories')->where('id',$seller_id)->value('categories')??"";

        if($categoryIds != ""){
            $data['category_count'] = count(explode(',', $categoryIds));
        }else{
            $data['category_count'] = 0;
        }

        $data['sold_out_count'] = ProductVariant::where('status',ProductVariant::$statusSoldOut)
            ->whereIn('product_id',$productsIds)
            ->where('stock','<=',0)->get()->count();

        $low_stock = Setting::where('variable', 'low_stock_limit')->first();
        $low_stock_limit = 0;
        if($low_stock){
            $low_stock_limit = $low_stock->value;
        }
        $data['low_stock_count'] = ProductVariant::where('status',ProductVariant::$statusAvailable)->whereIn('product_id',$productsIds);
        if($low_stock_limit !==0){
            $data['low_stock_count'] = $data['low_stock_count']->where('stock','<=',$low_stock_limit);
        }
        $data['low_stock_count'] = $data['low_stock_count']->get()->count();


        $data['balance'] = Seller::select('balance')->where('id',$seller_id)->value('balance');

        if($categoryIds != ""){

            $categoryIdsArray = explode(',', $categoryIds);
            $categoryIds = Category::whereIn('id', $categoryIdsArray)
                ->orWhereIn('parent_id', $categoryIdsArray)
                ->get()->pluck('id')->implode(',');

            $category_product_count = Category::select('id','name',DB::raw('(SELECT count(id) from `products` WHERE products.category_id = categories.id and categories.id IN('.$categoryIds.') ) AS product_count'))
                ->having('product_count','!=',0)
                ->orderBy('id','ASC')->get()->makeHidden(['image_url','has_child','has_active_child']);
        }else{
            $category_product_count = Category::select('id','name')->get()->makeHidden(['image_url']);
        }

        $data['category_product_count'] = $category_product_count;

        $year = date("Y");
        $curdate = date('Y-m-d');

        $data['weekly_sales'] = Order::select(DB::raw('ROUND(SUM(final_total), 2) AS total_sale'), DB::raw('DATE(created_at) AS order_date'))
            ->where(DB::raw('YEAR(created_at)'),'=', $year)
            ->where(DB::raw('DATE(created_at)'),'<=', $curdate)
            ->whereIn('orders.id', $orderIds)
            ->groupBy(DB::raw('DATE(created_at)'))
            ->orderBy(DB::raw('DATE(created_at)'),'DESC')
            ->limit(7)->get();

        $orderIdsString = 0;
        if(count($orderIds) != 0){
            $orderIdsString = implode(",", array_unique($orderIds));
        }
        $data['status_order_count'] = OrderStatusList::select('order_status_lists.id','order_status_lists.status',
            DB::raw('(select count(orders.id) from orders where orders.active_status = order_status_lists.id and orders.id IN ('. $orderIdsString .')) AS order_count'))
            ->orderBy('order_status_lists.id','asc')
            ->get();
        // dd($categoryIds, $categoryIdsArray, $categories, $category_product_count->toArray());
        return CommonHelper::responseWithData($data);
    }



    public function getProducts(Request $request){
        $seller_id = auth()->user()->seller->id;

        $join = "LEFT JOIN `categories` c ON c.id = p.category_id
        LEFT JOIN `product_variants` pv ON pv.product_id = p.id
            LEFT JOIN `units` u ON u.id = pv.stock_unit_id
            LEFT JOIN `sellers` s ON s.id = p.seller_id
            LEFT JOIN `order_status_lists` osl ON osl.id = p.till_status
            ";
        $where = " WHERE p.is_approved = 1 AND p.seller_id=".$seller_id;

        //here Sold Out as 0
        if(isset($request->type) && $request->type === 'sold_out'){
            $where .= empty($where) ? " WHERE pv.stock <=0 AND pv.status = '0'" : " AND stock <=0 AND pv.status = '0'";
        }
        //here Available as 1, low_stock_limit
        if(isset($request->type) && $request->type === 'low_stock'){
            $low_stock_limit = Setting::where('variable', 'low_stock_limit')->first();
            $where .= empty($where) ? " WHERE pv.stock <= ".$low_stock_limit['value']." AND pv.status = '1'" : " AND stock <= ".$low_stock_limit['value']." AND pv.status = '1'";
        }

        $products  = \DB::select(\DB::raw("SELECT p.id AS product_id,p.*, p.name,p.seller_id,p.status,p.tax_id, p.image,
        s.name as seller_name, p.indicator, p.manufacturer, p.made_in, p.return_status, p.cancelable_status, p.till_status, osl.status as till_status_name ,p.description,
        pv.id as product_variant_id, pv.price, pv.discounted_price, pv.measurement, pv.status as pv_status , pv.stock,pv.stock_unit_id, u.short_code,
        (select short_code from units where units.id = pv.stock_unit_id) as stock_unit
        FROM `products` p $join $where  order by p.id desc, pv.id asc "));

        $data = array(
            "products" => $products,
        );

        return CommonHelper::responseWithData($data);
    }

    public function getWeeklySales(){

        $seller_id = auth()->user()->seller->id;
        $year = date("Y");
        $curdate = date('Y-m-d');
        $orders = Order::select(DB::raw('ROUND(SUM(final_total), 2) AS total_sale'),
            DB::raw('DATE(orders.created_at) AS order_date'))
            ->where(DB::raw('YEAR(orders.created_at)'),'=', $year)
            ->where(DB::raw('DATE(orders.created_at)'),'<=', $curdate)
            ->leftJoin('order_items', 'order_items.order_id', '=', 'orders.id')
            ->where('order_items.seller_id',$seller_id)
            ->groupBy(DB::raw('DATE(orders.created_at)'))
            ->orderBy(DB::raw('DATE(orders.created_at)'),'DESC')
            ->limit(7)
            ->get();

        return CommonHelper::responseWithData($orders);
    }

    public function countProductCategoryWise(){
        $sellerCategoryIds = auth()->user()->seller->categories;
        $categories = Category::select('name',DB::raw('(SELECT count(id) from `products` WHERE products.category_id = categories.id) AS product_count'))
            ->whereIn('id',explode(',',$sellerCategoryIds))
            ->orderBy('id','ASC')->get();
        return CommonHelper::responseWithData($categories);
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
        $seller_id = auth()->user()->seller->id;

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
            ->leftJoin('delivery_boys', 'orders.delivery_boy_id', '=', 'delivery_boys.id')
            ->leftJoin('sellers', 'order_items.seller_id', '=', 'sellers.id')->where('order_items.seller_id', $seller_id);

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
            ->leftJoin('delivery_boys', 'orders.delivery_boy_id', '=', 'delivery_boys.id')
            ->leftJoin('sellers', 'order_items.seller_id', '=', 'sellers.id')
            ->where('order_items.seller_id', $seller_id);

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

        $statusOrderCount = CommonHelper::getStatusOrderCount($seller_id)->toArray() ?? [];
        array_unshift($statusOrderCount, array("id" => 0, "status" => "All Orders", "order_count" => $totalOrder));

        if($orders){
            $data = array(
                "status_order_count" => $statusOrderCount,
                "orders" => $orders,
                "total_order_item" => $totalOrderItem,
                "order_items" => $order_items
            );
            return CommonHelper::responseWithData($data, $totalOrder);
        }else{
            return CommonHelper::responseSuccess('Order not found');
        }

    }

    public function getOrder(Request $request){
        //app(TwitterController::class)->functionName($request);
        //return app(OrdersApiController::class)->view($request->order_id);
        $data = CommonHelper::getOrderDetails($request->order_id);
        return CommonHelper::responseWithData($data);
    }

    public function getOrderStatus(){
        return app(OrderStatusApiController::class)->getOrderStatus();
    }

    public function getCategories(Request $request){
        $seller_categories = auth()->user()->seller->categories;
        $category_id = $request->get('category_id',0);
        if(isset($request->category_id)  ){
            $categories =  Category::where('parent_id',$category_id)->orderBy('name','ASC')->get();
        }else{
            $categories =  Category::whereIn('id', explode(",", $seller_categories))->where('parent_id',$category_id)->orderBy('name','ASC')->get();
        }
        return CommonHelper::responseWithData($categories);
    }

    public function getReturnRequests(){
        $seller_id = auth()->user()->seller->id;
        $ReturnRequests = ReturnRequest::select('return_requests.*','users.name',
            'order_items.product_variant_id','order_items.quantity','order_items.price',
            'order_items.discounted_price','order_items.product_name','order_items.variant_name')
            ->leftJoin('users', 'return_requests.user_id', '=', 'users.id')
            ->leftJoin('order_items', 'return_requests.order_item_id', '=', 'order_items.id')
            ->leftJoin('products', 'return_requests.product_id', '=', 'products.id')
            ->leftJoin('product_variants', 'return_requests.product_variant_id', '=', 'product_variants.id')
            ->where('products.seller_id',$seller_id)
            ->orderBy('return_requests.id','DESC')
            ->get();
        return CommonHelper::responseWithData($ReturnRequests);
    }

    public function getProductSalesReport(Request $request){
        $seller_id = auth()->user()->seller->id;
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
            ->where('products.seller_id', $seller_id)
            ->where('orders.active_status', OrderStatusList::$delivered)
            ->whereBetween('order_items.created_at', [$startDate, $endDate])
            ->orderBy('order_items.id','DESC')
            ->groupBy('product_variants.id')
            ->get();
        return CommonHelper::responseWithData($ProductSalesReports);
    }

    public function getSalesReport(Request $request){
        $seller_id = auth()->user()->seller->id;
        $startDate = Carbon::parse($request->input('startDate'))->startOfDay();
        $endDate = Carbon::parse($request->input('endDate'))->endOfDay();
        $categories = CommonHelper::getSellerCategories($seller_id);
        $SalesReports = OrderItem::select('order_items.id','orders.total',
            'order_items.seller_id','order_items.sub_total','orders.user_id','orders.mobile',
            'products.name as product_name','orders.final_total','orders.address',
            'users.name as user_name','order_items.status',
            DB::raw('DATE_FORMAT(order_items.created_at,"%d-%m-%Y") as added_date'))
            ->leftJoin('users', 'order_items.user_id', '=', 'users.id')
            ->leftJoin('product_variants', 'order_items.product_variant_id', '=', 'product_variants.id')
            ->leftJoin('products', 'product_variants.product_id', '=', 'products.id')
            ->leftJoin('orders', 'order_items.order_id', '=', 'orders.id')
            ->where('products.seller_id', $seller_id)
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
            "privacy_policy_seller",
            "terms_conditions_seller",
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
            "privacy_policy_seller",
            "terms_conditions_seller",
        );
        $settings = CommonHelper::getSettings($variables);
        if(!empty($settings)){
            return CommonHelper::responseWithData($settings);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

    public function getDeliveryBoys(Request $request){
        $limit = ($request->limit)??10;
        $offset = ($request->offset)??0;

        $city_id = auth()->user()->seller->city_id;

        $deliveryBoys = DeliveryBoy::select('id','name')->where('city_id',$city_id);

        $totalDeliveryBoys = clone $deliveryBoys;
        $totalDeliveryBoys = $totalDeliveryBoys->count();

        $deliveryBoys = $deliveryBoys->orderBy('id','DESC')->skip($offset)->take($limit)->get();
        return CommonHelper::responseWithData($deliveryBoys, $totalDeliveryBoys);
    }

    public function getCities(){
        $cities = City::select('id','name','state','formatted_address','latitude','longitude')->orderBy('id','DESC')->get();
        if(empty($cities)){
            return  CommonHelper::responseError('Cities not found.');
        }
        return CommonHelper::responseWithData($cities);
    }
    public function getMainCategories(){
        $categories = CommonHelper::getMainCategories();
        if(empty($categories)){
            return  CommonHelper::responseError('Cities not found.');
        }
        return CommonHelper::responseWithData($categories);
    }

























    public function deploy(){
        //exec("git reset --hard");
        exec("git pull");
        exec("composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev");
        exec("php artisan migrate");
        echo "Done";
    }
}
