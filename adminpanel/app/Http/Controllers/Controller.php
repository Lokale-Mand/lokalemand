<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Admin;
use App\Models\Order;
use App\Models\Seller;
use App\Models\Product;
use App\Models\Setting;
use App\Models\Category;
use App\Models\OrderItem;
use App\Models\UserToken;
use App\Models\AdminToken;
use Illuminate\Http\Request;
use App\Helpers\CommonHelper;
use App\Models\ProductVariant;
use App\Models\OrderStatusList;
use App\Models\PanelNotification;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Session;
use App\Notifications\OrderNotification;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class Controller extends BaseController
{
    public function index(){
        $data = array();
        $data['order_count'] = Order::get()->count();
        $data['product_count'] = Product::get()->count();
        $data['customer_count'] = User::where('status','!=', 2)->get()->count();
        $data['seller_count'] = Seller::get()->count();

        $data['sold_out_count'] = ProductVariant::Join("products", "product_variants.product_id", "=", "products.id")
            ->where('products.is_unlimited_stock',0)
            ->where(function($query) {
                $query->where('product_variants.status',ProductVariant::$statusSoldOut)->orWhere('product_variants.stock','<=',0);
            })->get()->count();



        Log::info("Number of sold out product : ".$data['sold_out_count']);


        //$low_stock_limit = 10;
        $low_stock = Setting::where('variable', 'low_stock_limit')->first();
        $low_stock_limit = 0;
        if($low_stock){
            $low_stock_limit = $low_stock->value;
        }
        $data['low_stock_count'] = ProductVariant::select("*")->leftJoin('products', 'product_variants.product_id', '=', 'products.id')->
        where('product_variants.status',ProductVariant::$statusAvailable);
        if(isset($low_stock_limit) && $low_stock_limit !=="" && $low_stock_limit !==0 ){
            $data['low_stock_count'] = $data['low_stock_count']->where('product_variants.stock','<=',$low_stock_limit)->where('products.is_unlimited_stock','!=',1);
        }
        $data['low_stock_count'] = $data['low_stock_count']->get()->count();

        $data['top_sellers'] = OrderItem::select(DB::raw("SUM(order_items.sub_total) as total_revenue"),'order_items.seller_id',
            'sellers.name as seller_name','sellers.store_name')
            ->leftJoin('sellers', 'order_items.seller_id', '=', 'sellers.id')
            ->groupBy('order_items.seller_id')
            ->orderBy('order_items.id','DESC')
            ->get();
        //$sql = "SELECT pv.product_id,pv.id,p.name as p_name,p.category_id,p.seller_id,c.name as cat_name, pv.measurement,oi.product_name,oi.variant_name,SUM(oi.sub_total) as total_revenues FROM
        // `order_items` oi join `product_variant` pv ON oi.product_variant_id=pv.id join products p ON pv.product_id=p.id join unit u on pv.measurement_unit_id=u.id
        // JOIN category c ON p.category_id=c.id WHERE oi.date_added > DATE_SUB(NOW(), INTERVAL 1 MONTH) AND oi.active_status='delivered' GROUP BY p.category_id ORDER BY $sort $order LIMIT $offset, $limit";
        $parents = Category::get()->pluck('parent_id')->toArray();
        $data['top_categories'] = OrderItem::select('product_variants.product_id','product_variants.id','products.name as product_name','products.category_id','products.seller_id','categories.name as category_name',
            'product_variants.measurement','order_items.product_name','order_items.variant_name',DB::raw("SUM(order_items.sub_total) as total_revenue"))
            ->leftJoin('orders', 'order_items.order_id', '=', 'orders.id')
            ->leftJoin('product_variants', 'order_items.product_variant_id', '=', 'product_variants.id')
            ->leftJoin('units', 'product_variants.stock_unit_id', '=', 'units.id')
            ->leftJoin('products', 'product_variants.product_id', '=', 'products.id')
            ->leftJoin('categories', 'products.category_id', '=', 'categories.id')
            ->where(DB::raw('DATE_FORMAT(order_items.created_at, "%Y-%m-%d")'),'<', 'DATE_SUB(NOW(), INTERVAL 1 MONTH)')
            ->where('orders.active_status','=',OrderStatusList::$delivered)
            ->whereNotIn('products.category_id',$parents)
            ->groupBy('products.category_id')
            ->orderBy('order_items.id','DESC')
            ->get();


        /*$data['status_order_count'] = OrderStatusList::select('order_status_lists.id','order_status_lists.status',
                DB::raw('(select count(orders.id) from orders where orders.active_status = order_status_lists.id) AS order_count'))
            ->orderBy('order_status_lists.id','asc')
            ->get();*/

        $data['status_order_count'] = CommonHelper::getStatusOrderCount();


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

    public function deploy(){

        //exec("git reset --hard");
        //exec("git pull");
        //$output = exec('git pull');

        //exec("git config --global --add safe.directory /var/www/egrocer.wrteam.in");
        exec("git pull origin 1.9 2>&1", $output);
        echo "<pre>";
        var_dump($output);
        echo "</pre>";

        //exec('rm -rf public/storage');
        //exec('php artisan storage:link');
        exec("composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev");
        exec("php artisan migrate");

        //var_dump($output);
        echo "<br><br>Done";
    }

    public function updateToken(Request $request){
        try{

            AdminToken::firstOrCreate([
                'user_id' => auth()->user()->id,
                'type' => auth()->user()->role->name,
                'fcm_token' => $request->token
            ]);

            return response()->json(['success'=>true]);

        }catch(\Exception $e){
            report($e);
            return response()->json(['success'=>false],500);
        }
    }

    public function test(){
        $admins = Admin::get();
        foreach ($admins as $admin){
            $admin->notify(new OrderNotification(1,'new'));
            die;
        }
    }
}
