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
use App\Models\Favorite;
use App\Models\Product;
use App\Models\ProductImages;
use App\Models\ProductVariant;
use App\Models\PromoCode;
use App\Models\Seller;
use App\Models\Setting;
use App\Models\Tax;
use App\Models\Transaction;
use App\Models\WalletTransaction;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use function App\Models\Setting;

use Response;

class CartApiController extends Controller
{
    public function getUserCart(Request $request){
        /*$request->city_id = 1;
        $request->latitude = 23.2419997;
        $request->longitude = 69.6669324;*/

        $validator = Validator::make($request->all(), [
            'latitude' => 'required',
            'longitude' => 'required',
        ],[
            'latitude.required' => 'The latitude field is required.',
            'longitude.required' => 'The longitude field is required.'
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        /*$limit = ($request->limit)??10;
        $offset = ($request->offset)??0;*/

        $type = $request->get('type','');
        $user_id = $request->user('api-customers') ? $request->user('api-customers')->id : '';

        $variant_ids = explode(",",$request->variant_ids);

        if(ProductHelper::isItemAvailableInUserCart($user_id)){

            $res = Cart::select('carts.*','products.cod_allowed','products.image', 'products.is_unlimited_stock', 'products.seller_id',
                'sellers.longitude',  'sellers.latitude', 'cities.max_deliverable_distance', 'cities.boundary_points')
                ->Join('products', 'carts.product_id', '=', 'products.id')
                ->Join('product_variants', 'carts.product_variant_id', '=', 'product_variants.id')
                ->leftJoin('sellers', 'products.seller_id', '=', 'sellers.id')
                ->leftJoin('cities', 'sellers.city_id', '=', 'cities.id')
                ->where('carts.save_for_later','=',0)
                ->where('user_id','=',$user_id);
            if($request->variant_ids && $request->variant_ids !== ""){
                $res = $res->whereIn('carts.product_variant_id', $variant_ids);
            }
            $res = $res->orderBy('created_at','DESC')
                //->skip($offset)->take($limit)
                ->get();

            $seller_ids = array_values(array_unique( array_column($res->toArray(),'seller_id')));

            $res = $res->makeHidden(['user_id','id','save_for_later','type','stock_unit_name','image','images','created_at','updated_at','boundary_points','seller_id']);


            foreach ($res as $key => $row) {

                /*$vertices_x = $row->boundary_points ? array_column(json_decode($row->boundary_points, true), "lng") : [];    // lng x-coordinates of the vertices of the polygon
                $vertices_y = $row->boundary_points ? array_column(json_decode($row->boundary_points, true), "lat") : [];    // lat y-coordinates of the vertices of the polygonn
                $points_polygon = count($vertices_x);  // number vertices - zero-based array
                if (CommonHelper::isInPolygon($points_polygon, $vertices_x, $vertices_y, $request->longitude, $request->latitude)) {
                    $row['is_deliverable'] = 1;
                } else {
                    $row['is_deliverable'] = 0;
                }*/

                if(isset($row->max_deliverable_distance) && $row->max_deliverable_distance != 0 && $row->max_deliverable_distance != ""){
                    if(CommonHelper::isDeliverable($row->max_deliverable_distance, $row->longitude, $row->latitude, $request->longitude, $request->latitude)){
                        $row['is_deliverable'] = 1;
                    }else{
                        $row['is_deliverable'] = 0;
                    }
                }else{
                    $row['is_deliverable'] = 0;
                }


                $item = ProductVariant::select('product_variants.*','products.cod_allowed','products.seller_id as seller_id','products.name',
                        'products.type as d_type','products.cod_allowed','products.slug','products.image',
                        'products.total_allowed_quantity',
                        DB::raw('(CASE WHEN taxes.percentage != "0" THEN taxes.percentage ELSE "0" END) AS tax_percentage'),
                        DB::raw('(CASE WHEN taxes.title != "" THEN taxes.title ELSE "" END) AS tax_title'), 'product_variants.measurement',
                        DB::raw('(select short_code from units where units.id = product_variants.stock_unit_id) AS stock_unit_name')
                    )
                    ->Join('products', 'product_variants.product_id', '=', 'products.id')
                    ->leftJoin('taxes', 'products.tax_id', '=', 'taxes.id')
                    ->where('product_variants.id',$row->product_variant_id )
                    ->groupBy('product_variants.id')
                    ->orderBy('created_at','DESC')
                    ->first();
                $item = $item->makeHidden(['image','created_at','updated_at']);



                //$res[$key]->image = CommonHelper::getImages($res->product_id);
                //$res[$key]->item = $item;

                $res[$key]->type = $item->type;
                $res[$key]->measurement = $item->measurement;

                $taxed = ProductHelper::getTaxableAmount($item->id);
                /*$res[$key]->discounted_price = ($item->discounted_price != 0 && $item->discounted_price != "") ? $taxed->taxable_amount : $item->discounted_price;
                $res[$key]->price = ($item->discounted_price == 0 || $item->discounted_price == "") ? $taxed->taxable_amount : $item->price;
                $res[$key]->taxable_amount = $taxed->taxable_amount;*/

                $res[$key]->discounted_price =  CommonHelper::doubleNumber($taxed->taxable_discounted_price?? $item->discounted_price);
                $res[$key]->price = CommonHelper::doubleNumber($taxed->taxable_price??$item->price);
                $res[$key]->taxable_amount = CommonHelper::doubleNumber($taxed->taxable_amount);

                $res[$key]->stock = $item->stock;
                $res[$key]->images = CommonHelper::getImages($row['id'],$row->product_variant_id);
                $res[$key]->total_allowed_quantity = $item->total_allowed_quantity;
                $res[$key]->name = $item->name;
                $res[$key]->unit = $item->unit->short_code??'';
                $res[$key]->stock_unit_name = $item->stock_unit_name;
                $res[$key]->status = $item->status;
            }

            /*Save for Later*/
            if($request->is_checkout != 1) {
                $result = Cart::with('images')->select('carts.*','products.cod_allowed', 'products.image', 'products.is_unlimited_stock',
                    'sellers.longitude',  'sellers.latitude', 'cities.max_deliverable_distance', 'cities.boundary_points')
                    ->Join('products', 'carts.product_id', '=', 'products.id')
                    ->Join('product_variants', 'carts.product_variant_id', '=', 'product_variants.id')
                    ->leftJoin('sellers', 'products.seller_id', '=', 'sellers.id')
                    ->leftJoin('cities', 'sellers.city_id', '=', 'cities.id')
                    ->where('carts.save_for_later', 1)
                    ->where('user_id', '=', $user_id)
                    ->orderBy('created_at', 'DESC')
                    ->get();
                $result = $result->makeHidden(['user_id', 'id', 'save_for_later', 'type', 'stock_unit_name', 'image', 'images', 'created_at', 'updated_at', 'boundary_points']);
                foreach ($result as $key => $rows) {

                    /*$vertices_x = $rows->boundary_points ? array_column(json_decode($rows->boundary_points, true), "lng") : [];    // lng x-coordinates of the vertices of the polygon
                    $vertices_y = $rows->boundary_points ? array_column(json_decode($rows->boundary_points, true), "lat") : [];    // lat y-coordinates of the vertices of the polygon
                    $points_polygon = count($vertices_x);  // number vertices - zero-based array
                    if (CommonHelper::isInPolygon($points_polygon, $vertices_x, $vertices_y, $request->longitude, $request->latitude)) {
                        $rows['is_deliverable'] = 1;
                    } else {
                        $rows['is_deliverable'] = 0;
                    }*/

                    if(isset($rows->max_deliverable_distance) && $rows->max_deliverable_distance != 0 && $rows->max_deliverable_distance != ""){
                        if(CommonHelper::isDeliverable($rows->max_deliverable_distance, $rows->longitude, $rows->latitude, $request->longitude, $request->latitude)){
                            $rows['is_deliverable'] = 1;
                        }else{
                            $rows['is_deliverable'] = 0;
                        }
                    }else{
                        $rows['is_deliverable'] = 0;
                    }

                    $item = ProductVariant::select('product_variants.*', 'products.cod_allowed', 'products.seller_id as seller_id', 'products.name',
                        'products.type as d_type', 'products.cod_allowed', 'products.slug', 'products.image',
                        'products.total_allowed_quantity',
                        DB::raw('(CASE WHEN taxes.percentage != "0" THEN taxes.percentage ELSE "0" END) AS tax_percentage'),
                        DB::raw('(CASE WHEN taxes.title != "" THEN taxes.title ELSE "" END) AS tax_title'), 'product_variants.measurement',
                        DB::raw('(select short_code from units where units.id = product_variants.stock_unit_id) AS stock_unit_name')
                    )
                        ->leftJoin('products', 'product_variants.product_id', '=', 'products.id')
                        ->leftJoin('taxes', 'products.tax_id', '=', 'taxes.id')
                        ->where('product_variants.id', '=', $rows->product_variant_id)
                        ->groupBy('product_variants.id')
                        ->orderBy('created_at', 'DESC')
                        ->first();
                    $item = $item->makeHidden(['image', 'created_at', 'updated_at']);
                    //$result[$key]->image = CommonHelper::getImages($request->product_id);
                    //$result[$key]->item = $item;

                    $result[$key]->type = $item->type;
                    $result[$key]->measurement = $item->measurement;


                    $taxed = ProductHelper::getTaxableAmount($item->id);

                    /*$result[$key]->discounted_price = $item->discounted_price;
                    $result[$key]->price = $item->price;
                    $result[$key]->taxable_amount = $taxed->taxable_amount;*/

                    /*$result[$key]->discounted_price = ($item->discounted_price != 0 && $item->discounted_price != "") ? $taxed->taxable_amount : $item->discounted_price;
                    $result[$key]->price = ($item->discounted_price == 0 || $item->discounted_price == "") ? $taxed->taxable_amount : $item->price;
                    $result[$key]->taxable_amount = $taxed->taxable_amount;*/

                    $result[$key]->discounted_price =  CommonHelper::doubleNumber($taxed->taxable_discounted_price??$item->discounted_price);
                    $result[$key]->price = CommonHelper::doubleNumber($taxed->taxable_price??$item->price);
                    $result[$key]->taxable_amount = CommonHelper::doubleNumber($taxed->taxable_amount);

                    $result[$key]->stock = $item->stock;
                    $result[$key]->images = CommonHelper::getImages($rows['id'], $rows->product_variant_id);
                    $result[$key]->total_allowed_quantity = $item->total_allowed_quantity;
                    $result[$key]->name = $item->name;
                    $result[$key]->unit = $item->unit->short_code ?? '';
                    $result[$key]->stock_unit_name = $item->stock_unit_name;
                    $result[$key]->status = $item->status;
                }
            }

            if (!empty($res) || !empty($result)) {

                $total = CommonHelper::getCartCount($user_id);
                $sub_total = $total->total_amount;

                $saved_amount =  $total->save_price -  $total->total_amount;
                $saved_amount = ($saved_amount <= 0) ? 0 : $saved_amount;

                if( isset($request->is_checkout) && $request->is_checkout == 1){

                    $cod_payment_method = Setting::get_value('cod_payment_method');
                    if($cod_payment_method == 1){
                        $cod_mode = Setting::get_value('cod_mode');
                        if($cod_mode == Setting::$codModeGlobal){
                            $response['cod_allowed'] = 1;
                        }else{
                            $codArray = array_values(array_unique(array_column($res->toArray(),'cod_allowed')));
                            $cod_allowed = implode(',',$codArray);
                            if($cod_allowed == 1){
                                $response['cod_allowed'] = intval($cod_allowed);
                            }else{
                                $response['cod_allowed'] = 0;
                            }
                        }
                    }else{
                        $response['cod_allowed'] = 0;
                    }

                    $response['product_variant_id'] = $total->product_variant_id;
                    $response['quantity'] = $total->quantity;

                    $data = CommonHelper::getAllDeliveryCharge($request->latitude, $request->longitude, $seller_ids);

                    //dd($data);

                    if($data['status'] == 0){
                        return CommonHelper::responseError(__('sorry_we_are_not_delivering_on_selected_address'));
                    }else{

                        $total_amount = $total->total_amount + $data['data']['total_delivery_charge'];

                        if(isset($request->promocode_id) && $request->promocode_id && $request->promocode_id != ""){

                            $promocode_details = CommonHelper::getValidatedPromoCode($request->promocode_id, $sub_total, $user_id);
                            $response['promocode_details'] = $promocode_details;
                            $total_amount = $total_amount - $promocode_details['discount'];
                        }

                        $response['delivery_charge'] = $data['data'];
                        $response['total_amount'] = $total_amount;
                    }


                }

                $response['sub_total'] = $sub_total;
                $response['saved_amount'] = $saved_amount;

                if($request->is_checkout != 1){
                    $response['cart'] = $res;
                    $response['save_for_later'] = $result;
                }

                return CommonHelper::responseWithData($response, $total->cart_items_count);
            } else {
                return CommonHelper::responseError(__('no_items_found_in_users_cart'));
            }
        }else{
            return CommonHelper::responseError(__('no_items_found_in_users_cart'));
        }
    }

    public function addToCart(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'product_id' => 'required',
            'product_variant_id' => 'required',
            'qty' => 'required|numeric|min:1',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        $product_id = $request->product_id;
        $variant_id = $request->product_variant_id;
        $qty = $request->get('qty', '');
        $user = auth()->user();

        if (ProductHelper::isItemAvailable($product_id, $variant_id)) {

            $variant = ProductVariant::select('*', DB::raw("(SELECT is_unlimited_stock FROM products as p WHERE p.id = pv.product_id) as is_unlimited_stock"))
                ->from('product_variants as pv')->where('id',$variant_id)->first();

            if ($variant) {

                if (($variant->is_unlimited_stock == 1 || $variant->stock > 0) && $variant->status == 1) {

                    if (ProductHelper::isItemAvailableInUserCart($user->id, $variant_id)) {
                        $cart = Cart::where('user_id', $user->id)
                            ->where('product_variant_id', $variant_id)->first();

                        /* if item found in user's cart update it */
                            /*if ($cart) {
                                $cart->qty = $qty;
                                $cart->save();
                                return CommonHelper::responseSuccess('Item updated successfully.');
                            }*/


                        // check for total allowed quantity
                        $total_quantity = Cart::where('user_id', $user->id)
                            ->where('product_id', $product_id)
                            ->where('save_for_later', 0)
                            ->sum('qty');

                        if ($total_quantity) {
                            $total_allowed_quantity = Product::where('id', $product_id)->pluck('total_allowed_quantity')->first();

                            $temp = Cart::where('user_id', $user->id)->where('product_variant_id', $variant_id)->pluck('qty')->first();

                            $total_quantity = $total_quantity - $temp;
                            $total_quantity = $total_quantity + $qty;

                            if ($total_quantity > $total_allowed_quantity) {
                                return CommonHelper::responseSuccess(__('total_allowed_quantity_for_this_product_is'). $total_allowed_quantity);
                            }
                        }

                        if ($cart) {

                            $cart->qty = $qty;
                            $cart->save_for_later = 0;
                            $cart->save();

                            $total = CommonHelper::getCartCount($user->id);
                            $sub_total = $total->total_amount;
                            $saved_amount =  $total->save_price -  $total->total_amount;
                            $saved_amount = ($saved_amount <= 0) ? 0 : $saved_amount;
                            return Response::json(array('status' => 1, 'message' => __('item_updated_in_users_cart_successfully'), 'cart_items_count' => $total->cart_items_count, 'cart_total_qty' => $total->cart_total_qty, 'sub_total' => $sub_total, 'saved_amount' => $saved_amount));

                            //return CommonHelper::responseSuccess(__('item_updated_in_users_cart_successfully'));

                        } else {

                            return CommonHelper::responseError(__('item_not_found'));
                        }

                    } else {

                        if ($user->status == 1) {

                            $total_allowed_quantity = Product::where('id', $product_id)->first()->pluck('total_allowed_quantity');
                            if ($total_allowed_quantity && $qty > $total_allowed_quantity) {
                                return CommonHelper::responseSuccess(__('total_allowed_quantity_for_this_product_is') . $total_allowed_quantity . '!');
                            }

                            /* if item not found in user's cart add it */
                            $data = array(
                                'user_id' => $user->id,
                                'product_id' => $product_id,
                                'product_variant_id' => $variant_id,
                                'qty' => $qty
                            );
                            $insert = Cart::insert($data);
                            if ($insert) {
                                $total = CommonHelper::getCartCount($user->id);
                                $sub_total = $total->total_amount;
                                $saved_amount =  $total->save_price -  $total->total_amount;
                                $saved_amount = ($saved_amount <= 0) ? 0 : $saved_amount;
                                return Response::json(array('status' => 1, 'message' => __('item_added_to_users_cart_successfully'), 'cart_items_count' => $total->cart_items_count, 'cart_total_qty' => $total->cart_total_qty, 'sub_total' => $sub_total, 'saved_amount' => $saved_amount));
                                //return CommonHelper::responseSuccess(__('item_added_to_users_cart_successfully'));
                            } else {
                                return CommonHelper::responseError(__('something_went_wrong'));
                            }
                        } else {
                            return CommonHelper::responseError(__('not_allowed_to_add_to_cart_as_your_account_is_de_activated'));
                        }
                    }

                } else {
                    return CommonHelper::responseError(__('opps_stock_is_not_available'));
                }
            } else {
                return CommonHelper::responseError(__('no_such_item_available'));
            }
        }else{
            return CommonHelper::responseError(__('no_such_item_available'));
        }
    }

    public function removeFromCart(Request $request){
        $user_id = auth()->user()->id;
        $variant_id = $request->get('product_variant_id','');
        if(ProductHelper::isItemAvailableInUserCart($user_id,$variant_id)){
            $cart = Cart::where('user_id',$user_id)->where('save_for_later',0);

            if(!empty($variant_id)){
                $cart->where('product_variant_id',$variant_id);
                $cart = $cart->delete();
                if($cart){

                    $total = CommonHelper::getCartCount($user_id);
                    $sub_total = $total->total_amount;
                    $saved_amount =  $total->save_price -  $total->total_amount;
                    $saved_amount = ($saved_amount <= 0) ? 0 : $saved_amount;

                    return Response::json(array('status' => 1, 'message' => __('item_removed_from_users_cart_successfully'), 'cart_items_count' => $total->cart_items_count, 'cart_total_qty' => $total->cart_total_qty, 'sub_total' => $sub_total, 'saved_amount' => $saved_amount));
                    //return CommonHelper::responseSuccess(__('item_removed_from_users_cart_successfully'));
                } else {
                    return CommonHelper::responseError(__('no_product_found'));
                }
            }else if(isset($request->is_remove_all) && $request->is_remove_all == 1){
                $cart = $cart->delete();
                if($cart){
                    return CommonHelper::responseSuccess(__('all_items_removed_from_users_cart_successfully'));
                } else {
                    return CommonHelper::responseError(__('no_product_found'));
                }
            }else{
                return CommonHelper::responseError(__('no_items_found_in_users_cart'));
            }
        }else{
            return CommonHelper::responseError(__('no_items_found_in_users_cart'));
        }

    }

    public function addToSaveForLater(Request $request){

        $validator = Validator::make($request->all(), [
            'product_id' => 'required',
            'product_variant_id' => 'required',
            'qty' => 'required|numeric|min:1',
            'save_for_later' => 'required|numeric',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }


        $user_id = auth()->user()->id;
        $product_id = $request->product_id;
        $variant_id = $request->product_variant_id;

        $save_for_later = $request->save_for_later;

        $qty = $request->get('qty', '');

        $save_for_later = $request->save_for_later;

        if (!empty($user_id) && !empty($product_id)) {
            if (!empty($variant_id)) {
                if(ProductHelper::isItemAvailable($product_id,$variant_id)){

                    if(ProductHelper::isItemAvailableInUserCart($user_id,$variant_id)){
                        $cart = Cart::where('user_id',$user_id)->where('product_variant_id',$variant_id);
                        if (empty($qty) || $qty == 0) {
                            $cart = $cart->delete();
                            if($cart){
                                return CommonHelper::responseSuccess(__('item_removed_users_cart_due_to_0_quantity'));
                            } else {
                                return CommonHelper::responseError(__('something_went_wrong'));
                            }
                        }
                        /* if item found in user's cart update it */
                        $data = array(
                            'qty' => $qty,
                            'save_for_later' => $save_for_later
                        );
                        $cart = $cart->first();

                        $cart->save_for_later = $save_for_later;
                        $cart->qty = $qty;
                        $cart->save();
                    }else{
                        /* if item not found in user's cart add it */
                        $data = array(
                            'user_id' => $user_id,
                            'product_id' => $product_id,
                            'product_variant_id' => $variant_id,
                            'qty' => $qty,
                            'save_for_later' => $save_for_later
                        );
                        $cart = new Cart();
                        $cart->user_id = $user_id;
                        $cart->product_id = $product_id;
                        $cart->product_variant_id = $variant_id;
                        $cart->qty = $qty;
                        $cart->save_for_later = $save_for_later;
                        $cart->save();
                    }

                    if($cart) {
                        $x = 0;
                        $total_amount = 0;
                        $result = Cart::with('images')->select('carts.*','products.image')
                            ->Join('products', 'carts.product_id', '=', 'products.id')
                            ->where('save_for_later', $save_for_later)->where('user_id', $user_id)->where('product_variant_id', $variant_id)->get();
                        $result = $result->makeHidden(['image','created_at','updated_at','deleted_at']);


                        $res1 = Cart::select('qty', 'product_variant_id')->where('save_for_later', $save_for_later)->where('user_id', $user_id)->get();
                        foreach ($res1 as $row1) {
                            $result1 = ProductVariant::select('price', 'discounted_price')->where('id', $row1->product_variant_id)->get();
                            $price = 0;
                            foreach ($result1 as $result2) {
                                $price = $result2->discounted_price == 0 ? $result2->price * $row1->qty : $result2->discounted_price * $row1->qty;
                            }
                            $total_amount += $price;
                        }

                        foreach ($result as $key => $rows) {
                            $item = ProductVariant::with('images')
                                ->select('product_variants.*', 'products.seller_id as seller_id', 'products.name', 'products.type as d_type', 'products.cod_allowed', 'products.slug', 'products.image',
                                    'products.total_allowed_quantity',
                                    DB::raw('(CASE WHEN taxes.percentage != "0" THEN taxes.percentage ELSE "0" END) AS tax_percentage'),
                                    DB::raw('(CASE WHEN taxes.title != "" THEN taxes.title ELSE "" END) AS tax_title'), 'product_variants.measurement',
                                    DB::raw('(select short_code from units where units.id = product_variants.stock_unit_id) AS stock_unit_name')
                                )
                                ->leftJoin('products', 'product_variants.product_id', '=', 'products.id')
                                ->leftJoin('taxes', 'products.tax_id', '=', 'taxes.id')
                                ->where('product_variants.id', '=', $rows->product_variant_id)
                                ->groupBy('product_variants.id')
                                ->orderBy('created_at', 'DESC')
                                ->first();
                            $item = $item->makeHidden(['image','created_at','updated_at','deleted_at']);
                            //$result[$x]->item = $item;
                            $result[$key]->type = $item->type;
                            $result[$key]->measurement = $item->measurement;


                            $taxed = ProductHelper::getTaxableAmount($item->id);

                            $result[$key]->discounted_price = CommonHelper::doubleNumber($taxed->taxable_discounted_price ?? $item->discounted_price);
                            $result[$key]->price = CommonHelper::doubleNumber($taxed->taxable_price ?? $item->price);
                            $result[$key]->taxable_amount = CommonHelper::doubleNumber($taxed->taxable_amount);

                            $result[$key]->stock = $item->stock;
                            $result[$key]->images = CommonHelper::getImages($rows->id,$rows->product_variant_id);
                            $result[$key]->total_allowed_quantity = $item->total_allowed_quantity;
                            $result[$key]->unit = $item->unit->short_code??'';

                            $x++;
                        }

                        $total = CommonHelper::getCartCount($user_id);
                        $sub_total = $total->total_amount;
                        $saved_amount =  $total->save_price -  $total->total_amount;
                        $saved_amount = ($saved_amount <= 0) ? 0 : $saved_amount;

                        if($save_for_later == 1){
                            return Response::json(array('status' => 1, 'message' => __('item_added_to_save_for_later_successfully'), 'cart_items_count' => $total->cart_items_count, 'cart_total_qty' => $total->cart_total_qty, 'sub_total' => $sub_total, 'saved_amount' => $saved_amount, 'data' => $result));
                            //return CommonHelper::responseSuccessWithData(__('item_added_to_save_for_later_successfully'), $result);
                        }else{
                            return Response::json(array('status' => 1, 'message' => __('item_remove_from_save_for_later_successfully'), 'cart_items_count' => $total->cart_items_count, 'cart_total_qty' => $total->cart_total_qty, 'sub_total' => $sub_total, 'saved_amount' => $saved_amount, 'data' => $result));
                            //return CommonHelper::responseSuccessWithData(__('item_remove_from_save_for_later_successfully'), $result);
                        }

                    } else {
                        return CommonHelper::responseError(__('something_went_wrong'));
                    }
                }else{
                    return CommonHelper::responseError(__('no_such_item_available'));
                }
            } else {
                return CommonHelper::responseError(__('please_choose_at_least_one_item'));
            }
        } else {
            return CommonHelper::responseError(__('please_pass_all_the_fields'));
        }
    }

}
