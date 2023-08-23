<?php

// namespace App\Http\Controllers\Api\Customer;
namespace App\Http\Controllers\API\Customer;

use App\Helpers\CommonHelper;
use App\Helpers\ProductHelper;
use App\Http\Controllers\Controller;
use App\Http\Repository\CategoryRepository;
use App\Http\Repository\ProductRepository;
use App\Models\Admin;
use App\Models\Cart;
use App\Models\City;
use App\Models\Favorite;
use App\Models\OrderItem;
use App\Models\Product;
use App\Models\ProductImages;
use App\Models\ProductVariant;
use App\Models\Section;
use App\Models\Seller;
use App\Models\Setting;
use App\Models\Tax;
use App\Models\Transaction;
use App\Models\WalletTransaction;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use function App\Models\Setting;

use Response;

class ProductApiController extends Controller
{
    public $productRepository;
    public $categoryRepository;

    public function __construct(ProductRepository $productRepository, CategoryRepository $categoryRepository)
    {
        $this->productRepository = $productRepository;
        $this->categoryRepository = $categoryRepository;
    }

    public function getProducts(Request $request)
    {
        /*$request->city_id = 1;
        $request->latitude = 23.2419997;
        $request->longitude = 69.6669324;*/

        $validator = Validator::make($request->all(), [
            'latitude' => 'required',
            'longitude' => 'required',
        ], [
            'latitude.required' => 'The latitude field is required.',
            'longitude.required' => 'The longitude field is required.'
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        try {

            $currency = Setting::get_value('currency');
            $user_id = $request->user('api-customers') ? $request->user('api-customers')->id : '';

            $limit = ($request->limit) ?? 10;
            $offset = ($request->offset) ?? 0;

            $sort = ($request->sort) ?? 'row_order';
            $order = ($request->order) ?? 'asc';

            if ($sort == 'new') {
                $sort = 'created_at DESC';
                $price = 'MIN(discounted_price)';
                $price_sort = 'pv.discounted_price  ASC';
            } elseif ($sort == 'old') {
                $sort = 'created_at ASC';
                $price = 'MIN(discounted_price)';
                $price_sort = 'pv.discounted_price  ASC';
            } elseif ($sort == 'high') {
                //$sort = 'price DESC';

                $sort = 'max_price DESC';

                $price = 'MAX(if(pv.discounted_price > 0 && pv.discounted_price != 0, pv.discounted_price, pv.price))';
                $price_sort = 'if(pv.discounted_price > 0 && pv.discounted_price != 0, pv.discounted_price, pv.price) DESC';
            } elseif ($sort == 'low') {
                // $sort = 'price ASC';

                $sort = 'min_price ASC';

                $price = 'MIN(if(pv.discounted_price > 0 && pv.discounted_price != 0, pv.discounted_price, pv.price))';
                $price_sort = 'if(pv.discounted_price > 0 && pv.discounted_price != 0, pv.discounted_price, pv.price) ASC';
            } elseif ($sort == 'discount') {
                $sort = 'cal_discount_percentage DESC';
                $price = 'MIN(if(pv.discounted_price > 0 && pv.discounted_price != 0, pv.discounted_price, pv.price))';
                $price_sort = 'cal_discount_percentage DESC';
            } elseif ($sort == 'popular') {
                $sort = 'order_counter DESC';
                $price = 'MIN(pv.discounted_price)';
                $price_sort = 'order_counter DESC';
            } else {
                $sort = 'p.row_order ASC';
                $price = 'MIN(pv.discounted_price)';
                $price_sort = 'pv.id  ASC';
            }

            // ->orderByRaw($sort)

            //$product_id = $request->get('product_id');

            $category_id = $request->get('category_id');



            $seller_id = $request->get('seller_id');
            $seller_slug = '';
            $where = "";

            if (isset($request['search']) && $request['search'] != '') {
                $search = $request['search'];
//                $where .= " AND (p.`id` like '%" . $search . "%' OR p.`name` like '%" . $search . "%' OR s.`name` like '%" . $search . "%' OR p.`category_id` like '%" . $search . "%' OR p.`slug` like '%" . $search . "%' OR p.`description` like '%" . $search . "%') ";
                $where .= " AND ( p.`name` like '%" . $search . "%' OR p.`slug` like '%" . $search . "%' OR p.`tags` like '%" . $search . "%') ";
            }

            if (isset($request->section_id) && $request->section_id != "") {
                $section_id = $request->section_id;
                $section = Section::select("*")->where("id", "=", $section_id)->first();

                $product_ids = CommonHelper::getProductIdsSection($section);
                if ($product_ids !== "") {
                    $where .= "AND p.id IN  ($product_ids)";
                }
            }

            /*if (isset($request['product_id']) && !empty($request['product_id']) && is_numeric($request['product_id'])) {
                $where .= " AND p.`id` = " . $product_id;
            }*/

            if (isset($request['seller_slug']) && !empty($request['seller_slug'])) {
                $seller_slug = $request['seller_slug'];
                if (isset($request['category_id']) && !empty($request['category_id']) && is_numeric($request['category_id'])) {
                    $seller_category = Seller::where('slug', $seller_slug)->first(['categories']);
                    if(!empty($seller_category)) {
                        $category = $seller_category['categories'];
                        $data = explode(",", $category);
                        $search = (in_array($category_id, $data, TRUE)) ? 1 : 2;
                        if ($search == 2) {
                            return CommonHelper::responseError(__('no_products_found'));
                        } else {
                            $where .= " AND s.`slug` = '$seller_slug' AND p.`category_id` IN (" . $category_id . ") ";
                        }
                    }else{
                        return CommonHelper::responseError(__('no_products_found'));
                    }
                } else {
                    $seller_category = Seller::where('slug', $seller_slug)->first(['categories']);
                    if(!empty($seller_category)) {
                        $category = $seller_category['categories'];
                        $where .= " AND s.`slug` =  '$seller_slug' AND p.category_id IN (" . $category . " )";
                    }else{
                        return CommonHelper::responseError(__('no_products_found'));
                    }
                }
            }

            if (isset($request['slug']) && !empty($request['slug'])) {
                $slug = $request['slug'];
                $where .= " AND p.`slug` =  '$slug' ";
            }

            if (isset($request['seller_id']) && !empty($request['seller_id']) && is_numeric($request['seller_id'])) {
                if (isset($request['category_id']) && !empty($request['category_id']) && is_numeric($request['category_id'])) {
                    $seller_category = Seller::where('slug', $seller_slug)->first(['categories']);
                    if(!empty($seller_category)) {
                        $category = $seller_category['categories'];
                        $data = explode(",", $category);
                        $search = (in_array($category_id, $data, TRUE)) ? 1 : 2;
                        if ($search == 2) {
                            return CommonHelper::responseError(__('no_products_found'));
                        } else {
                            $where .= " AND p.`seller_id` = " . $seller_id . " AND p.`category_id` IN (" . $category_id . ") ";
                        }
                    }else{
                        return CommonHelper::responseError(__('no_products_found'));
                    }
                } else {
                    $seller_category = Seller::where('slug', $seller_slug)->first(['categories']);
                    if(!empty($seller_category)) {
                        $category = $seller_category['categories'];
                        $where .= " AND p.`seller_id` = " . $seller_id . " AND p.category_id IN (" . $category . " )";
                    }else{
                        return CommonHelper::responseError(__('no_products_found'));
                    }
                }
            }

            if (isset($request['category_id']) && !empty($request['category_id']) && is_numeric($request['category_id'])) {
                if (!isset($request['seller_id']) && empty($request['seller_id']) && !isset($request['seller_slug']) && empty($request['seller_slug'])) {
                    $where .= " AND p.`category_id`=" . $category_id;
                }
            }


            if (isset($request['category_id']) && !empty($request['category_id']) && is_numeric($request['category_id'])) {
                $where .= " AND p.`category_id`=" . $category_id;
            }




            $seller_ids = CommonHelper::getSellerIds($request->latitude, $request->longitude);


            $productSql = Product::from('products as p')->select(
                DB::raw('COUNT(p.id) AS total'),
                DB::raw('MIN((select MIN(if(discounted_price > 0, discounted_price, price)) from product_variants where product_variants.product_id = p.id)) as min_price'),
                DB::raw('MAX((select MAX(if(discounted_price > 0, discounted_price, price)) from product_variants where product_variants.product_id = p.id)) as max_price')
            )->leftJoin('product_variants as pv', 'pv.product_id', '=', 'p.id')->whereIn('p.seller_id', $seller_ids);

            $productResult = $productSql->first();
            $total_min_price = $productResult->min_price;
            $total_max_price = $productResult->max_price;

            /*if($where != ""){
                $productSql = $productSql->whereRaw(substr($where,4));
            }
            $productResult = $productSql->first();
            $min_price = $productResult->min_price;
            $max_price = $productResult->max_price;*/


            \DB::enableQueryLog();
            $sql = Product::select('p.*', 'p.type as d_type', 's.store_name as seller_name', 's.slug as seller_slug', 's.status as seller_status',

                'pv.price', 'pv.discounted_price',

                DB::raw("if(pv.discounted_price > 0, ceil(((pv.price - pv.discounted_price)/pv.price)*100), 0)  as cal_discount_percentage"),

                DB::raw("ceil((pv.price - pv.discounted_price)) as cal_discount"),

                DB::raw('count(*) as order_counter'),
                /*DB::raw("(SELECT ceil(if(t.percentage > 0 , " . $price . " + ( " . $price . " * (t.percentage / 100)), " . $price . ")) FROM product_variants as pv WHERE pv.product_id=p.id) as price"),*/
                DB::raw("(select MIN(if(discounted_price > 0, discounted_price, price)) from product_variants where product_variants.product_id = p.id) as min_price"),
                DB::raw("(select MAX(if(discounted_price > 0, discounted_price, price)) from product_variants where product_variants.product_id = p.id) as max_price"),
                'co.name as country_made_in',
                's.longitude', 's.latitude', 'cities.max_deliverable_distance', 'cities.boundary_points'
            )
                ->from('products as p')
                ->leftJoin("countries as co", "p.made_in", "=", "co.id")
                ->leftJoin("taxes as t", "p.tax_id", "=", "t.id")
                ->Join("product_variants as pv", "pv.product_id", "=", "p.id")
                ->leftJoin('sellers as s', 'p.seller_id', '=', 's.id')
                ->leftJoin('cities', 's.city_id', '=', 'cities.id')
                ->leftJoin('categories as c', 'p.category_id', '=', 'c.id');
            if ($sort == 'popular') {
                $sql = $sql->leftJoin('order_items as oi', 'oi.product_variant_id', '=', 'pv.id');
            }
            $sql = $sql->where('p.is_approved', 1)
                ->where('p.status', 1)
                ->where('c.status', 1)
                /*->where('s.categories', 'like', DB::raw('CONCAT("%", p.category_id ,"%")'))*/
                ->where('s.status', 1)
                ->whereIn('p.seller_id', $seller_ids)->groupBy("p.id");

            if (isset($request->min_price) && isset($request->max_price) && intval($request->max_price)) {
                $sql = $sql->havingRaw(" min_price > " . intval(intval($request->min_price) - 1) . " and max_price < " . intval(intval($request->max_price) + 1));
            }

            if (isset($request->brand_ids) && $request->brand_ids != "") {
                $brand_ids = explode(",", $request->brand_ids);
                $sql = $sql->whereIn('p.brand_id', $brand_ids);
            }
            if (isset($request->sizes) && $request->sizes != "" && isset($request->unit_ids) && $request->unit_ids != "") {
                $sizes = explode(",", $request->sizes);
                $unit_ids = explode(",", $request->unit_ids);
                $sql = $sql->whereIn('pv.measurement', $sizes)->whereIn('pv.stock_unit_id', $unit_ids);
            }

            if ($where != "") {
                $sql = $sql->whereRaw(substr($where, 4));
            }
            //$total = $sql->count();
            $pro = $sql->get()->toArray();
            $total = count($pro);

            if (!empty($pro)) {
                $min_price = min(array_column($pro, 'min_price'));
                $max_price = max(array_column($pro, 'max_price'));
            }

            //$records = $sql->orderBy($sort,$order)->skip($offset)->take($limit)->get();
            $records = $sql->orderByRaw($sort)->skip($offset)->take($limit)->get();

            /*$records = $records->makeHidden(['seller_id','row_order','return_status',
                'cancelable_status','till_status','description','is_approved','return_days','pincodes',
                'cod_allowed','pickup_location','tags','d_type','seller_name','seller_slug','seller_status',
                'created_at', 'updated_at','deleted_at','image','other_images', 'type','boundary_points','country_made_in','order_counter']);
            return CommonHelper::responseWithData($records, $total);*/

            $products = array();
            $i = 0;

            foreach ($records as $row) {
                if ($request->sort == 'popular') {
                    $sql = ProductVariant::select('pv.*',
                        DB::raw("(SELECT short_code FROM units as u WHERE u.id = pv.stock_unit_id) as stock_unit_name"),
                        DB::raw("ceil(((pv.price - pv.discounted_price)/pv.price)*100) as cal_discount_percentage"),
                        DB::raw("(SELECT is_unlimited_stock FROM products as p WHERE p.id = pv.product_id) as is_unlimited_stock"),
                        DB::raw('count(*) as order_counter'), 'pv.id as id'
                    );
                    $sql = $sql->from('product_variants as pv');
                    $sql = $sql->leftJoin('order_items as oi', 'oi.product_variant_id', '=', 'pv.id');

                    if (isset($request->sizes) && $request->sizes != "" && isset($request->unit_ids) && $request->unit_ids != "") {
                        $sizes = explode(",", $request->sizes);
                        $unit_ids = explode(",", $request->unit_ids);
                        $sql = $sql->whereIn('pv.measurement', $sizes)->whereIn('pv.stock_unit_id', $unit_ids);
                    }

                    $sql = $sql->where('pv.product_id', '=', $row['id'])
                        //->orderBy('pv.status','ASC');
                        ->orderByRaw($price_sort);
                    $sql = $sql->groupBy("pv.id");

                } else {
                    $sql = ProductVariant::select('*',
                        DB::raw("(SELECT short_code FROM units as u WHERE u.id = pv.stock_unit_id) as stock_unit_name"),
                        DB::raw("ceil(((pv.price - pv.discounted_price)/pv.price)*100) as cal_discount_percentage"),
                        DB::raw("(SELECT is_unlimited_stock FROM products as p WHERE p.id = pv.product_id) as is_unlimited_stock")
                    );
                    $sql = $sql->from('product_variants as pv');

                    if (isset($request->sizes) && $request->sizes != "" && isset($request->unit_ids) && $request->unit_ids != "") {
                        $sizes = explode(",", $request->sizes);
                        $unit_ids = explode(",", $request->unit_ids);
                        $sql = $sql->whereIn('pv.measurement', $sizes)->whereIn('pv.stock_unit_id', $unit_ids);
                    }

                    $sql = $sql->where('pv.product_id', '=', $row['id'])
                        //->orderBy('pv.status','ASC');
                        ->orderByRaw($price_sort);
                }
                $variants = $sql->get();



                $row['is_deliverable'] = true;
                $row['made_in'] = $row['country_made_in'] ?? "";
                $row['is_unlimited_stock'] = intval($row['is_unlimited_stock']) ?? 0;
                $row['tax_included_in_price'] = intval($row['tax_included_in_price']) ?? 0;
                $row['status'] = intval($row['status']) ?? 0;
                if(isset($row->max_deliverable_distance) && $row->max_deliverable_distance != 0 && $row->max_deliverable_distance != ""){
                    if(isset($request->longitude) && CommonHelper::isDeliverable($row->max_deliverable_distance, $row->longitude, $row->latitude, $request->longitude, $request->latitude)){
                        $row['is_deliverable'] = true;
                    }else{
                        $row['is_deliverable'] = false;
                    }

                    $row['is_deliverable'] = true;

                }else{
                    $row['is_deliverable'] = false;
                }

                if ($user_id) {
                    $fav = Favorite::where('product_id', $row['id'])->where('user_id', $user_id)->first();
                    $row['is_favorite'] = !is_null($fav) ? true : false;
                } else {
                    $row['is_favorite'] = false;
                }
                $row = $row->makeHidden(['seller_id','row_order','return_status',
                    'cancelable_status','till_status','description','is_approved','return_days','pincodes',
                    'cod_allowed','pickup_location','tags','d_type','seller_name','seller_slug','seller_status',
                    'created_at', 'updated_at','deleted_at','image','other_images', 'price','discounted_price','cal_discount',
                    'cal_discount_percentage','min_price','max_price','type','boundary_points','country_made_in','order_counter']);

                $products[$i] = $row;

                if (!empty($variants)) {

                    foreach ($variants as $key => $variant) {
                        if ($variant) {
                            $variant = $variant->makeHidden(['product_id', 'measurement_unit_id', 'stock_unit_id', 'deleted_at', 'cal_discount_percentage', 'order_counter']);

                            if ($variant['stock'] <= 0 && $variant['is_unlimited_stock'] == 0) {
                                $variant['status'] = 0;
                            } else {
                                $variant['status'] = intval($variant['status']) ?? 0;
                            }

                            if ($user_id) {
                                $cart = Cart::where('product_variant_id', $variant['id'])
                                    ->where('user_id', $user_id)->first();
                                if ($cart) {
                                    $variant['cart_count'] = $cart['qty'];
                                } else {
                                    $variant['cart_count'] = 0;
                                }
                            } else {
                                $variant['cart_count'] = 0;
                            }

                            $taxed = ProductHelper::getTaxableAmount($variant['id']);

                            $variant['discounted_price'] = CommonHelper::doubleNumber($taxed->taxable_discounted_price ?? $variant['discounted_price']);
                            $variant['price'] = CommonHelper::doubleNumber($taxed->taxable_price ?? $variant['price']);
                            $variant['taxable_amount'] = CommonHelper::doubleNumber($taxed->taxable_amount);

                            $variant['stock_unit_name'] = $variant['stock_unit_name'] ?? '';

                            $variants[$key] = $variant;
                        }
                    }

                    $products[$i]['variants'] = $variants;
                }



                /*$products[$i] = CommonHelper::getProductDetails($row['id'],$user_id,false, $request);
                $variantArray = array();
                for ($k = 0; $k < count($variants); $k++) {
                    array_push($variantArray,CommonHelper::getProductVariant($variants[$k]['id'],$user_id));
                }
                $products[$i]['variants'] = $variantArray;*/


                $i++;
            }

            if (!empty($products)) {
                $brands = CommonHelper::getBrandsHavingProducts();
                $sizes = CommonHelper::getProductVariantsSize();
                //return CommonHelper::responseWithData($products,$total);
                return Response::json(array(
                    'status' => 1,
                    'message' => 'success',
                    'total' => $total,

                    'min_price' => $min_price ?? 0,
                    'max_price' => $max_price ?? 0,
                    'total_min_price' => $total_min_price ?? 0,
                    'total_max_price' => $total_max_price ?? 0,

                    'brands' => $brands,
                    'sizes' => $sizes,
                    'data' => $products
                ));
            } else {
                return CommonHelper::responseError(__('no_products_found'));
            }
            //dd($products);

        } catch (\Exception $e) {
            Log::info("Products Error : " . $e->getMessage());
            throw $e;
            return CommonHelper::responseError("Something Went Wrong!");
        }



    }


    public function getProduct(Request $request)
    {
        /*$request->city_id = 1;
        $request->latitude = 23.2419997;
        $request->longitude = 69.6669324;*/

        /*$validator = Validator::make($request->all(), [
            'id' => 'required',
            'city_id' => 'required',
            'latitude' => 'required',
            'longitude' => 'required',
        ], [
            'required' => 'The product :attribute field is required.',
        ]);*/

        $validator = Validator::make($request->all(), [
            'id' => 'required',
            'latitude' => 'required',
            'longitude' => 'required'
        ], [
            'required' => 'The product :attribute field is required.',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        $product_id = $request->id;
        /*$sql = Product::with(['variants' => function($q1){
            $q1->with('images')->select('*')->orderBy('status','DESC');
        } ])->with( ['images' => function($q2){
            $q2->select('*');
        } ])->select('p.*','p.type as d_type', 's.store_name as seller_name','s.slug as seller_slug','s.status as seller_status')
            ->from('products as p')
            ->leftJoin('sellers as s', 'p.seller_id', '=', 's.id')
            ->leftJoin('categories as c', 'p.category_id', '=', 'c.id')
            ->where('s.status',1)
            ->where('p.id',$product_id);
        $product = $sql->first();*/
        $sql = Product::with(['variants' => function ($query) {
            $query->select('*',
                DB::raw("(SELECT short_code FROM units as u WHERE u.id = stock_unit_id) as stock_unit_name")
            );
        }])->select('p.*', 'p.type as d_type', 's.store_name as seller_name', 's.slug as seller_slug', 's.status as seller_status', 's.latitude', 's.longitude',
            'co.name as country_made_in', 'cities.boundary_points','cities.max_deliverable_distance')
            ->from('products as p')
            ->leftJoin("countries as co", "p.made_in", "=", "co.id")
            ->leftJoin('sellers as s', 'p.seller_id', '=', 's.id')
            ->leftJoin('cities', 's.city_id', '=', 'cities.id')
            ->leftJoin('categories as c', 'p.category_id', '=', 'c.id')
            ->where('s.status', 1)
            ->where('p.id', $product_id);
        $product = $sql->first();

        if ($product) {

            $product = $product->makeHidden(['seller_id', 'row_order', 'pincodes', 'pickup_location', 'tags', 'seller_slug', 'seller_status',
                'created_at', 'updated_at', 'deleted_at', 'image', 'other_images','boundary_points','country_made_in']);

            $product->images = CommonHelper::getImages($product->id);
            $product->made_in = $product->country_made_in ?? "";

            /*if(isset($product->boundary_points) && $product->boundary_points != "") {
                $vertices_x = $product->boundary_points ? array_column(json_decode($product->boundary_points, true), "lng") : [];    // lng x-coordinates of the vertices of the polygon
                $vertices_y = $product->boundary_points ? array_column(json_decode($product->boundary_points, true), "lat") : [];    // lat y-coordinates of the vertices of the polygon
                $points_polygon = count($vertices_x);  // number vertices - zero-based array
                if (isset($request->longitude) && CommonHelper::isInPolygon($points_polygon, $vertices_x, $vertices_y, $request->longitude, $request->latitude)) {
                    $product->is_deliverable = true;
                } else {
                    $product->is_deliverable = false;
                }
            }else{
                $product->is_deliverable = false;
            }*/

            if(isset($product->max_deliverable_distance) && $product->max_deliverable_distance != 0 && $product->max_deliverable_distance != ""){
                if(CommonHelper::isDeliverable($product->max_deliverable_distance, $product->longitude, $product->latitude, $request->longitude, $request->latitude)){
                    $product->is_deliverable = true;
                }else{
                    $product->is_deliverable = false;
                }
            }else{
                $product->is_deliverable = false;
            }



            $user_id = $request->user('api-customers') ? $request->user('api-customers')->id : '';
            if ($user_id) {
                $fav = Favorite::where('product_id', $product->id)->where('user_id', $user_id)->first();
                $product->is_favorite = !is_null($fav) ? true : false;
            } else {
                $product->is_favorite = false;
            }
            $product->till_status = $product->till_status ?? '';
            $product->seller_name = $product->seller_name ?? '';
            $variants = $product->variants;

            if ($variants->count() == 0) {
                return CommonHelper::responseError(__('no_items_found'));
            }
            foreach ($variants as $key => $variant) {
                $variants = $variants->makeHidden(['product_id', 'measurement_unit_id', 'stock_unit_id', 'deleted_at']);
                if ($variants[$key]->stock <= 0 && $product->is_unlimited_stock == 0 ) {
                    $variants[$key]->status = 0;
                } else {
                    $variants[$key]->status = intval($variants[$key]->status) ?? 0;
                }
                if ($user_id) {
                    $cart = Cart::where('product_variant_id', $variants[$key]->id)
                        ->where('user_id', $user_id)->first();
                    if ($cart) {
                        $variants[$key]->cart_count = $cart->qty;
                    } else {
                        $variants[$key]->cart_count = 0;
                    }
                } else {
                    $variants[$key]->cart_count = 0;
                }
                $taxed = ProductHelper::getTaxableAmount($variants[$key]['id']);
                $variants[$key]['discounted_price'] = CommonHelper::doubleNumber($taxed->taxable_discounted_price ?? $variants[$key]['discounted_price']);
                $variants[$key]['price'] = CommonHelper::doubleNumber($taxed->taxable_price ?? $variants[$key]['price']);
                $variants[$key]['taxable_amount'] = CommonHelper::doubleNumber($taxed->taxable_amount);
                $variants[$key]->images = CommonHelper::getImages($variants[$key]->product_id, $variants[$key]->id);

                $variants[$key]->stock_unit_name = $variants[$key]->stock_unit_name ?? '';
            }

            $product->variants = $variants;
            //For Print Same Output on Application
            /*$product->description = '<!DOCTYPE html>
                <html>
                <head>
                <meta charset="utf-8">
                <script src="https://cdn.ckeditor.com/ckeditor5/35.0.1/classic/ckeditor.js"></script>
                </head>
                <body>
                <div id="editor">'.$product->description.'</div>
                <script>
                  ClassicEditor.create(document.querySelector("#editor"), {
                    toolbar: [],
                  }).then(editor => {
                    editor.enableReadOnlyMode("editor");
                    console.log(editor);
                  }).catch(error => {
                    console.error(error);
                  });
                </script>
                </body>
                </html>';*/

            return CommonHelper::responseWithData($product);

        } else {
            return CommonHelper::responseError(__('no_items_found'));
        }
    }


    /* This is not using */

    public function getProductsOffline(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'product_ids' => 'required',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        $product_ids = $request->product_ids;
        $where = "";

        if (isset($request['slug']) && !empty($request['slug'])) {
            $slug = $request['slug'];
            $where = " AND p.`slug` =  '$slug' ";
        }

        /*$sql = "SELECT  count(p.id) as total FROM `products` p JOIN `sellers`s ON s.id=p.seller_id WHERE p.is_approved = 1 AND p.status = 1 AND s.status = 1 AND p.id IN ($product_ids) " . $where;
        $total = \DB::select(\DB::raw($sql));
        echo $where;*/

        $sql = Product::select(DB::raw('COUNT(p.id) AS total'))
            ->from('products as p')
            ->leftJoin('sellers as s', 'p.seller_id', '=', 's.id')
            ->where('p.is_approved', '=', 1)
            ->where('p.status', '=', 1)
            ->where('s.status', '=', 1)
            ->whereIn('p.id', explode(',', $product_ids));
        if ($where != "") {
            $sql = $sql->whereRaw($where);
        }
        $total = $sql->first();
        //dd($total);
        if ($total->count() > 0) {
            $total = $total->total;
        } else {
            $total = 0;
        }

        /*$sql = "SELECT p.*,s.name as seller_name,s.status as seller_status
            FROM `products` p
                JOIN `sellers`s ON s.id=p.seller_id
        WHERE p.is_approved = 1 AND p.status = 1 AND s.status = 1 AND p.id IN ($product_ids)" . $where;
        $records = \DB::select(\DB::raw($sql));
        $records = json_decode(json_encode($records), true);*/

        $sql = Product::with('images')->select('p.*', 's.name as seller_name', 's.status as seller_status')
            ->from('products as p')
            ->leftJoin('sellers as s', 's.id', '=', 'p.seller_id')
            ->where('p.is_approved', '=', 1)
            ->where('p.status', '=', 1)
            ->where('s.status', '=', 1)
            ->whereIn('p.id', explode(',', $product_ids));
        if ($where != "") {
            $sql = $sql->whereRaw($where);
        }
        $records = $sql->get()->toarray();
        //$records = json_decode(json_encode($records), true);
        //dd($records);

        $products = array();
        $i = 0;
        foreach ($records as $row) {

            /* $sql = "SELECT *,(SELECT short_code FROM units u WHERE u.id=pv.measurement_unit_id) as measurement_unit_name,
                     (SELECT short_code FROM units u WHERE u.id=pv.stock_unit_id) as stock_unit_name
                 FROM product_variants pv
                 WHERE pv.product_id=" . $row['id'] . " ORDER BY `pv`.`status` ASC";

             $variants = \DB::select(\DB::raw($sql));
             $variants = json_decode(json_encode($variants), true);*/

            $sql = ProductVariant::with('images')->select('*',
                DB::raw("(SELECT short_code FROM units u WHERE u.id=pv.stock_unit_id) as stock_unit_name"))
                ->from('product_variants as pv')
                ->where('pv.product_id', '=', $row['id'])
                ->orderBy('pv.status', 'ASC');
            $variants = $sql->get()->toarray();

            if (empty($variants)) {
                continue;
            }

            $row['is_item_deliverable'] = true;
            unset($row['type']);
            $row['seller_name'] = !empty($row['seller_name']) ? $row['seller_name'] : "";
            $row['pincodes'] = (isset($row['pincodes']) == null) ? "" : $row['pincodes'];
            $row['is_approved'] = (isset($row['is_approved']) == null) ? "" : $row['is_approved'];
            $row['seller_id'] = (isset($row['seller_id']) == null) ? "" : $row['seller_id'];

            // Other images also taken with relation
            /*$otherImages = ProductImages::where('product_id',$row['id'])->where('product_variant_id',0)->get();
            $row['other_images'] = (empty($otherImages)) ? array() : $otherImages;
            for ($j = 0; $j < count($row['other_images']); $j++) {
                $row['other_images'][$j] = asset('storage/'.$row['other_images'][$j]['image']);
            }
            $row['image'] = asset('storage/'.$row['image']);*/

            if ($row['tax_id'] == 0) {
                $row['tax_title'] = "";
                $row['tax_percentage'] = "0";
            } else {

                $tax1 = Tax::find($row['tax_id']);
                $row['tax_title'] = (!empty($tax1['title'])) ? $tax1['title'] : "";
                $row['tax_percentage'] = (!empty($tax1['percentage'])) ? $tax1['percentage'] : "0";
            }

            $row['is_favorite'] = false;

            $products[$i] = $row;

            for ($k = 0; $k < count($variants); $k++) {

                // images also taken with relation
                /*$variantImages = ProductImages::where('product_id',$row['id'])->where('product_variant_id',$variants[$k]['id'])->get();
                $variants[$k]['images'] = (empty($variantImages)) ? array() :$variantImages;
                for ($j = 0; $j < count($variantImages); $j++) {
                    //$variants[$k]['images'][$j] = !empty(DOMAIN_URL . $variants[$k]['images'][$j]) ? DOMAIN_URL . $variants[$k]['images'][$j] : "";
                    $variants[$k]['images'][$j] = asset('storage/'.$variantImages[$j]['image']);
                }*/

                if ($variants[$k]['stock'] <= 0) {
                    $variants[$k]['status'] = 'Sold Out';
                } else {
                    $variants[$k]['status'] = $variants[$k]['status'];
                }

                $variants[$k]['cart_count'] = "0";
            }

            $products[$i]['variants'] = $variants;
            $i++;
        }

        if (!empty($products)) {
            $response['total'] = $total;
            $response['data'] = array_values($products);
            return CommonHelper::responseWithData($response);
        } else {
            return CommonHelper::responseError(__('no_items_found'));
        }
    }

    public function getVariantsOffline(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'variant_ids' => 'required',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }


        $variant_ids = $request->variant_ids;
        $where = "";

        if (isset($request['slug']) && !empty($request['slug'])) {
            $slug = $request['slug'];
            $where = " AND p.`slug` = '$slug' ";
        }

        $sql = "SELECT  count(pv.id) as total FROM product_variants pv JOIN products p ON p.id=pv.product_id JOIN sellers s ON s.id=p.seller_id where pv.id IN ($variant_ids) and p.is_approved = 1 AND p.status = 1 AND s.status = 1 " . $where;
        $total = \DB::select(\DB::raw($sql));
        if (count($total) > 0) {
            $total = $total[0]->total;
        } else {
            $total = 0;
        }

        $sql = "SELECT pv.id as product_variant_id,pv.*,p.tax_id FROM product_variants pv JOIN products p ON p.id=pv.product_id where pv.id IN ($variant_ids)" . $where;
        $records = \DB::select(\DB::raw($sql));
        $records = json_decode(json_encode($records), true);
        $i = 0;
        $j = 0;


        foreach ($records as $row) {

            unset($records[$i]['images']);
            $sql = "select pv.*,p.*,s.name as seller_name,p.type as d_type,s.status as seller_status,pv.measurement,(select short_code from units u where u.id=pv.stock_unit_id) as units,(Select short_code from units su where su.id=pv.stock_unit_id) as stock_unit_name from product_variants pv left join products p on p.id=pv.product_id JOIN sellers s ON s.id=p.seller_id where pv.id=" . $row['product_variant_id'];

            $item = \DB::select(\DB::raw($sql));
            $item = json_decode(json_encode($item), true);
            $res[$i]['item'] = $item;

            for ($k = 0; $k < count($res[$i]['item']); $k++) {
                /*if (!empty($pincode_id) || $pincode_id != "") {
                    $pincodes = ($res[$i]['item'][$k]['d_type'] == "all") ? "" : $res[$i]['item'][$k]['pincodes'];

                    $pincodes = explode(',', $pincodes);
                    if ($res[$i]['item'][$k]['d_type'] == "all") {
                        $res[$i]['item'][$k]['is_item_deliverable'] = true;
                    } else if ($res[$i]['item'][$k]['d_type'] == "included") {
                        if (in_array($pincode_id, $pincodes)) {
                            $res[$i]['item'][$k]['is_item_deliverable']  = true;
                        } else {
                            $res[$i]['item'][$k]['is_item_deliverable']  = false;
                        }
                    } else if ($res[$i]['item'][$k]['d_type'] == "excluded") {

                        if (in_array($pincode_id, $pincodes)) {
                            $res[$i]['item'][$k]['is_item_deliverable']  = false;
                        } else {
                            $res[$i]['item'][$k]['is_item_deliverable']  = true;
                        }
                    }
                } else {
                    $res[$i]['item'][$k]['is_item_deliverable'] = false;
                }*/
                $res[$i]['item'][$k]['is_item_deliverable'] = true;


                $variantImages = ProductImages::where('product_id', $row['id'])->where('product_variant_id', $res[$i]['item'][$k]['id'])->get();
                $res[$i]['item'][$k]['images'] = (empty($variantImages)) ? array() : $variantImages;

                for ($j = 0; $j < count($variantImages); $j++) {
                    $res[$i]['item'][$k]['images'][$j] = asset('storage/' . $variantImages[$j]['image']);;
                }

                $res[$i]['item'][$k]['cart_count'] = "0";

                $otherImages = ProductImages::where('product_id', $res[$i]['item'][$k]['id'])->where('product_variant_id', 0)->get();
                //$res[$i]['item'][$k]['other_images'] = empty($otherImages) ? array() : $res[$i]['item'][$k]['other_images'];
                for ($l = 0; $l < count($otherImages); $l++) {
                    $res[$i]['item'][$k]['other_images'][$l] = asset('storage/' . $otherImages[$l]['image']);;
                }

                if ($row['tax_id'] == 0) {
                    $res[$i]['item'][$k]['tax_title'] = "";
                    $res[$i]['item'][$k]['tax_percentage'] = "0";
                } else {
                    $tax1 = Tax::find($row['tax_id']);
                    $row['tax_title'] = (!empty($tax1['title'])) ? $tax1['title'] : "";
                    $row['tax_percentage'] = (!empty($tax1['percentage'])) ? $tax1['percentage'] : "0";
                }
            }

            for ($j = 0; $j < count($res[$i]['item']); $j++) {
                //$res[$i]['item'][$j]['image'] = !empty($res[$i]['item'][$j]['image']) ? DOMAIN_URL . $res[$i]['item'][$j]['image'] : "";
                $res[$i]['item'][$j]['image'] = !empty($res[$i]['item'][$j]['image']) ? asset('storage/' . $res[$i]['item'][$j]['image']) : "";
            }
            $i++;
        }
        if (!empty($res)) {
            $response['total'] = $total;
            $response['data'] = array_values($res);
            return CommonHelper::responseWithData($response);
        } else {
            return CommonHelper::responseError(__('no_items_found'));
        }
    }


    public function getSimilarProducts(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'product_id' => 'required',
            'category_id' => 'required',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        $user_id = $request->user('api-customers') ? $request->user('api-customers')->id : '';


        $product_id = $request['product_id'];
        $category_id = $request['category_id'];


        $limit = $request->get('limit', 6);
        $offset = 0;
        $order = "RAND()";
        $where = '';



        $sql = "SELECT count(p.id) as total FROM `products` p JOIN `sellers`s ON s.id=p.seller_id where p.id != $product_id AND p.category_id = $category_id AND p.is_approved = 1 AND p.status = 1 and s.status = 1  $where ORDER BY $order LIMIT $offset,$limit";
        $total = \DB::select(\DB::raw($sql));
        if (count($total) > 0) {
            $total = $total[0]->total;
        } else {
            $total = 0;
        }


        $rows = array();

        $sql = "SELECT p.*,s.name as seller_name,s.status as seller_status,(SELECT MIN(pv.price) FROM product_variants pv WHERE pv.product_id=p.id) as price FROM products p  JOIN sellers s on s.id=p.seller_id where p.id != $product_id and p.status=1  and p.is_approved = 1 and  s.status = 1 and category_id = $category_id $where ORDER BY $order LIMIT $offset,$limit";
        $res = \DB::select(\DB::raw($sql));
        $res = json_decode(json_encode($res), true);

        if (!empty($res)) {
            foreach ($res as $row) {
                $tempRow['id'] = $row['id'];
                $tempRow['seller_id'] = $row['seller_id'];
                $tempRow['seller_name'] = $row['seller_name'];
                $tempRow['tax_id'] = $row['tax_id'];
                $tempRow['row_order'] = $row['row_order'];
                $tempRow['name'] = $row['name'];
                $tempRow['slug'] = $row['slug'];
                $tempRow['category_id'] = $row['category_id'];

                $tempRow['indicator'] = $row['indicator'];
                $tempRow['manufacturer'] = $row['manufacturer'];
                $tempRow['made_in'] = $row['made_in'];
                $tempRow['return_status'] = $row['return_status'];
                $tempRow['cancelable_status'] = $row['cancelable_status'];
                $tempRow['till_status'] = $row['till_status'];
                $tempRow['seller_status'] = $row['seller_status'];
                $tempRow['date_added'] = $row['created_at'];
                $tempRow['price'] = $row['price'];
                $tempRow['type'] = $row['type'];
                $tempRow['pincodes'] = $row['pincodes'];
                $tempRow['is_approved'] = $row['is_approved'];
                $tempRow['return_days'] = $row['return_days'];
                $tempRow['image'] = (!empty($row['image'])) ? asset('storage/' . $row['image']) : '';

                $otherImages = ProductImages::where('product_id', $row['id'])->where('product_variant_id', 0)->get();
                if (!empty($otherImages)) {
                    for ($j = 0; $j < count($otherImages); $j++) {
                        $tempRow['other_images'][$j] = asset('storage/' . $otherImages[$j]['image']);
                    }
                } else {
                    $tempRow['other_images'] = array();
                }

                if ($row['tax_id'] == 0) {
                    $tempRow['tax_title'] = "";
                    $tempRow['tax_percentage'] = "0";
                } else {

                    $tax1 = Tax::find($row['tax_id']);
                    $tempRow['tax_title'] = $tax1['title'];
                    $tempRow['tax_percentage'] = $tax1['percentage'];

                }

                if ($user_id) {
                    $fav = Favorite::where('product_id', $row['id'])->where('user_id', $user_id)->first();
                    $row['is_favorite'] = !is_null($fav) ? true : false;
                } else {
                    $row['is_favorite'] = false;
                }

                $tempRow['description'] = $row['description'];
                $tempRow['status'] = $row['status'];

                $sql1 = "SELECT *,(SELECT short_code FROM units u WHERE u.id=pv.stock_unit_id) as measurement_unit_name,(SELECT short_code FROM units u WHERE u.id=pv.stock_unit_id) as stock_unit_name FROM product_variants pv WHERE pv.product_id=" . $row['id'] . " ORDER BY pv.status ASC";
                $variants = \DB::select(\DB::raw($sql1));
                $variants = json_decode(json_encode($variants), true);
                if (empty($variants)) {
                    continue;
                }
                for ($k = 0; $k < count($variants); $k++) {
                    $variantImages = ProductImages::where('product_id', $row['id'])->where('product_variant_id', $variants[$k]['id'])->get();
                    $variants[$k]['images'] = (empty($variantImages)) ? array() : $variantImages;
                    for ($j = 0; $j < count($variantImages); $j++) {
                        $variants[$k]['images'][$j] = !empty($variantImages[$j]['image']) ? asset('storage/' . $variantImages[$j]['image']) : "";
                    }

                    $cart = Cart::where('product_variant_id', $variants[$k]['id'])->where('user_id', $user_id)->first();
                    if ($cart) {
                        $variants[$k]['cart_count'] = $cart['qty'];
                    } else {
                        $variants[$k]['cart_count'] = "0";
                    }
                }
                $tempRow['variants'] = $variants;
                $rows[] = $tempRow;

            }

            $response['total'] = $total;
            $response['data'] = $rows;
            return CommonHelper::responseWithData($response);
        } else {
            return CommonHelper::responseError(__('data_not_found'));
        }
    }

    public function getSearchProducts(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'search' => 'required',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        $user_id = $request->user('api-customers') ? $request->user('api-customers')->id : '';

        $limit = $request->get('limit', 10);
        $offset = $request->get('offset', 0);

        $sort = $request->get('sort', 'id');
        $order = $request->get('order', 'DESC');

        $where = '';
        if (isset($request['search']) && $request['search'] != '') {
            $search = $request['search'];
            $search = str_replace(' ', '%', $search);
            $where = " AND (p.`id` like '%" . $search . "%' OR p.`name` like '%" . $search . "%' OR p.`image` like '%" . $search . "%' OR p.`slug` like '%" . $search . "%' OR p.`description` like '%" . $search . "%')";
        }
        /*if (isset($_POST['pincode_id']) && $_POST['pincode_id'] != "") {
            $pincode_id = $_POST['pincode_id'];
            $where .=  " AND (p.type='included' and FIND_IN_SET('$pincode_id', p.pincodes) OR (p.type='excluded' and NOT FIND_IN_SET('$pincode_id', p.pincodes)) or p.type='all')";
        }*/


        $sql = "SELECT COUNT(p.id) as total FROM `products`p JOIN `sellers` s ON s.id=p.seller_id WHERE p.is_approved = 1 AND p.status = 1 AND s.status = 1 " . $where;

        $total = \DB::select(\DB::raw($sql));
        if (count($total) > 0) {
            $total = $total[0]->total;
        } else {
            $total = 0;
        }

        $sql = "SELECT p.*,s.name as seller_name,s.status as seller_status FROM `products`p JOIN sellers s ON s.id=p.seller_id WHERE p.is_approved = 1 AND p.status = 1 AND s.status = 1 " . $where;
        $res = \DB::select(\DB::raw($sql));
        $res = json_decode(json_encode($res), true);

        $products = array();
        $i = 0;

        foreach ($res as $row) {
            $sql = "SELECT *,(SELECT short_code FROM units u WHERE u.id=pv.stock_unit_id) as measurement_unit_name,(SELECT short_code FROM units u WHERE u.id=pv.stock_unit_id) as stock_unit_name FROM product_variants pv WHERE pv.product_id=" . $row['id'] . " ORDER BY pv.status ASC";
            $variants = \DB::select(\DB::raw($sql));
            $variants = json_decode(json_encode($variants), true);
            if (empty($variants)) {
                continue;
            }

            if ($user_id) {
                $fav = Favorite::where('product_id', $row['id'])->where('user_id', $user_id)->first();
                $row['is_favorite'] = !is_null($fav) ? true : false;
            } else {
                $row['is_favorite'] = false;
            }


            $row['type'] = (isset($row['type']) == null) ? "" : $row['type'];
            $row['pincodes'] = (isset($row['pincodes']) == null) ? "" : $row['pincodes'];
            $row['is_approved'] = (isset($row['is_approved']) == null) ? "" : $row['is_approved'];
            $row['seller_id'] = (isset($row['seller_id']) == null) ? "" : $row['seller_id'];

            $otherImages = ProductImages::where('product_id', $row['id'])->where('product_variant_id', 0)->get();
            $row['other_images'] = (empty($otherImages)) ? array() : $otherImages;
            for ($j = 0; $j < count($otherImages); $j++) {
                $row['other_images'][$j] = asset('storage/' . $row['other_images'][$j]['image']);
            }
            if ($row['tax_id'] == 0) {
                $row['tax_title'] = "";
                $row['tax_percentage'] = "0";
            } else {
                $tax1 = Tax::find($row['tax_id']);
                $row['tax_title'] = (!empty($tax1['title'])) ? $tax1['title'] : "";
                $row['tax_percentage'] = (!empty($tax1['percentage'])) ? $tax1['percentage'] : "0";
            }
            $row['image'] = asset('storage/' . $row['image']);
            $product[$i] = $row;
            for ($k = 0; $k < count($variants); $k++) {
                $variantImages = ProductImages::where('product_id', $row['id'])->where('product_variant_id', $variants[$k]['id'])->get();
                $variants[$k]['images'] = (empty($variantImages)) ? array() : $variantImages;
                for ($j = 0; $j < count($variantImages); $j++) {
                    //$variants[$k]['images'][$j] = !empty(DOMAIN_URL . $variants[$k]['images'][$j]) ? DOMAIN_URL . $variants[$k]['images'][$j] : "";
                    $variants[$k]['images'][$j] = asset('storage/' . $variantImages[$j]['image']);
                }

                $cart = Cart::where('product_variant_id', $variants[$k]['id'])->where('user_id', auth()->user()->id)->first();
                if ($cart) {
                    $variants[$k]['cart_count'] = $cart['qty'];
                } else {
                    $variants[$k]['cart_count'] = "0";
                }
            }
            $product[$i]['variants'] = $variants;
            $i++;
        }
        if (empty($product)) {
            return CommonHelper::responseError(__('no_products_available'));
        } else {
            $response['total'] = $total;
            $response['data'] = array_values($product);
            return CommonHelper::responseWithData($response);
        }
    }

    public function getAllProductNames(Request $request)
    {

        $sql = "SELECT p.name FROM `products` p JOIN sellers s on s.id = p.seller_id where p.is_approved = 1 AND p.status = 1 AND s.status = 1";
        $res = \DB::select(\DB::raw($sql));
        $res = json_decode(json_encode($res), true);

        $rows = $tempRow = $blog_array = $blog_array1 = array();
        foreach ($res as $row) {
            $tempRow['name'] = $row['name'];
            $rows[] = $tempRow;
        }
        $names = array_column($rows, 'name');

        $pr_names = implode(",", $names);
        $pr_name = explode(",", $pr_names);

        return CommonHelper::responseWithData($pr_name);
    }
}
