<?php

namespace App\Http\Controllers\API;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Models\OrderStatusList;
use App\Models\Seller;
use App\Models\Category;
use App\Models\OrderItem;
use Carbon\Carbon;
use Illuminate\Http\Request;
use DB;
class SalesReportsApiController extends Controller
{
    public function getSalesReport(Request $request){

        /*$sellers = Seller::select("*");
        if(isset($filterStatus) && $filterStatus != ""){
            $sellers = $sellers->where("status",$filterStatus);
        }
        $sellers = $sellers->orderBy('id','DESC')->get();*/

        /*$startDate = Carbon::createFromFormat('Y-m-d',date('Y-m-d',strtotime($request->startDate)))->format('Y-m-d');
        $endDate = Carbon::createFromFormat('Y-m-d',date('Y-m-d',strtotime($request->endDate)))->subSecond()->format('Y-m-d');*/

        $startDate = Carbon::parse($request->input('startDate'))->startOfDay();
        $endDate = Carbon::parse($request->input('endDate'))->endOfDay();

        $sellers = Seller::orderBy('id','DESC')->get()->toArray();
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
            ->where('orders.active_status', OrderStatusList::$delivered);

        if(isset($request->startDate) && $request->startDate != "" && isset($request->endDate) && $request->endDate != "") {
            $startDate = Carbon::parse($request->input('startDate'))->startOfDay();
            $endDate = Carbon::parse($request->input('endDate'))->endOfDay();
            $SalesReports = $SalesReports->whereBetween('order_items.created_at', [$startDate, $endDate]);
        }

        if(isset($request->seller) && $request->seller != ""){
            $SalesReports = $SalesReports->where('order_items.seller_id', $request->seller);
        }

        if(isset($request->category) && $request->category != ""){
            $SalesReports = $SalesReports->where('products.category_id', $request->category);
        }

        $SalesReports = $SalesReports->orderBy('order_items.id','DESC')->get();

        $data = array(
            "sellers" => $sellers,
            "categories" => $categories,
            "salesReports" => $SalesReports
        );
        return CommonHelper::responseWithData($data);

    }
}
