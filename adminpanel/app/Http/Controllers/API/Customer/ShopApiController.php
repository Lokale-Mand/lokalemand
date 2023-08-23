<?php

namespace App\Http\Controllers\API\Customer;

use App\Helpers\CommonHelper;
use App\Helpers\ProductHelper;
use App\Http\Controllers\Controller;
use App\Http\Repository\CategoryRepository;
use App\Http\Repository\ProductRepository;
use App\Models\Cart;
use App\Models\Category;
use App\Models\City;
use App\Models\Favorite;
use App\Models\Offer;
use App\Models\Pincode;
use App\Models\Product;
use App\Models\Section;
use App\Models\Seller;
use App\Models\Setting;
use App\Models\Slider;
use Illuminate\Http\Request;
use DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class ShopApiController extends Controller
{

    public $categoryRepository;

    public function __construct(CategoryRepository $categoryRepository)
    {
        $this->categoryRepository = $categoryRepository;
    }

    public function getShopData(Request $request)
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


            $user_id = $request->user('api-customers') ? $request->user('api-customers')->id : '';
            $sort = ($request->sort) ?? 'id';
            $limit = ($request->limit) ?? 12;
            $offset = ($request->offset) ?? 0;


            if ($sort == 'new') {
                $sort = 'created_at DESC';
                $price = 'MIN(discounted_price)';
                $price_sort = 'pv.discounted_price  ASC';
            } elseif ($sort == 'old') {
                $sort = 'created_at ASC';
                $price = 'MIN(discounted_price)';
                $price_sort = 'pv.discounted_price  ASC';
            } elseif ($sort == 'high') {
                $sort = 'price DESC';
                $price = 'MAX(if(pv.discounted_price > 0 && pv.discounted_price != 0, pv.discounted_price, pv.price))';
                $price_sort = 'if(pv.discounted_price > 0 && pv.discounted_price != 0, pv.discounted_price, pv.price) DESC';
            } elseif ($sort == 'low') {
                $sort = 'price ASC';
                $price = 'MIN(if(pv.discounted_price > 0 && pv.discounted_price != 0, pv.discounted_price, pv.price))';
                $price_sort = 'if(pv.discounted_price > 0 && pv.discounted_price != 0, pv.discounted_price, pv.price) ASC';
            } else {
                $sort = 'p.row_order ASC';
                $price = 'MIN(discounted_price)';
                $price_sort = 'pv.id  ASC';
            }


            $where = '';
            $where1 = '';

            if (isset($request->search) && $request->search != '') {
                $search = $request->search;
                if (empty($where)) {
                    $where = " (p.`id` like '%" . $search . "%' OR p.`name` like '%" . $search . "%' OR p.`image` like '%" . $search . "%' OR p.`slug` like '%" . $search . "%' OR p.`description` like '%" . $search . "%')";
                } else {
                    $where .= " AND (p.`id` like '%" . $search . "%' OR p.`name` like '%" . $search . "%' OR p.`image` like '%" . $search . "%' OR p.`slug` like '%" . $search . "%' OR p.`description` like '%" . $search . "%')";
                }
            }

            if (isset($request->section) && intval($request->section)) {
                $section = Section::select('*')->where('sections.id', '=', intval($request->section))->first();

                if (!empty($section)) {
                    $cate_ids = $section->category_ids;
                    $product_ids = $section->product_ids;

                    if ($section->product_type == 'all_products') {
                        if (empty($section->category_ids)) {
                            $sql = "SELECT id as product_id FROM `products` WHERE status = 1 ORDER BY product_id DESC";
                        } else {
                            $sql = "SELECT id as product_id FROM `products` WHERE status = 1 AND category_id IN($cate_ids) ORDER BY product_id DESC";
                        }
                    } elseif ($section->product_type == 'new_added_products') {
                        if (empty($section->category_ids)) {
                            $sql = "SELECT id as product_id FROM `products` WHERE status = 1 ORDER BY product_id DESC";
                        } else {
                            $sql = "SELECT id as product_id FROM `products` WHERE status = 1 AND category_id IN($cate_ids) ORDER BY product_id DESC";
                        }
                    } elseif ($section->product_type == 'products_on_sale') {
                        if (empty($section->category_ids)) {
                            $sql = "SELECT p.id as product_id FROM `products` p LEFT JOIN product_variant pv ON p.id=pv.product_id WHERE p.status = 1 AND pv.discounted_price > 0 AND pv.price > pv.discounted_price ORDER BY p.id DESC";
                        } else {
                            $sql = "SELECT p.id as product_id FROM `products` p LEFT JOIN product_variant pv ON p.id=pv.product_id WHERE p.status = 1 AND p.category_id IN($cate_ids) AND pv.discounted_price > 0 AND pv.price > pv.discounted_price ORDER BY p.id DESC";
                        }
                    } elseif ($section->product_type == 'most_selling_products') {
                        if (empty($section->category_ids)) {
                            $sql = "SELECT p.id as product_id,oi.product_variant_id, COUNT(oi.product_variant_id) AS total FROM order_items oi LEFT JOIN product_variant pv ON oi.product_variant_id = pv.id LEFT JOIN products p ON pv.product_id = p.id WHERE oi.product_variant_id != 0 AND p.id != '' GROUP BY pv.id,p.id ORDER BY total DESC";
                        } else {
                            $sql = "SELECT p.id as product_id,oi.product_variant_id, COUNT(oi.product_variant_id) AS total FROM order_items oi LEFT JOIN product_variant pv ON oi.product_variant_id = pv.id LEFT JOIN products p ON pv.product_id = p.id WHERE oi.product_variant_id != 0 AND p.id != '' AND p.category_id IN ($cate_ids) GROUP BY pv.id,p.id ORDER BY total DESC";
                        }
                    } else {
                        $product_ids = $product_ids;
                    }

                    if ($section->product_type != 'custom_products' && !empty($section->product_type)) {
                        $products = \DB::select(\DB::raw($sql));
                        $rows = $tempRow = array();
                        foreach ($products as $product) {
                            $tempRow['product_id'] = $product->product_id;
                            $rows[] = $tempRow;
                        }
                        $pro_id = array_column($rows, 'product_id');
                        $product_ids = implode(",", $pro_id);
                    }

                    if (empty($where)) {
                        $where = " p.id IN ($product_ids) AND p.status = 1 AND pv.stock >= 0";
                    } else {
                        $where .= " AND p.id IN ($product_ids) AND p.status = 1 AND pv.stock >= 0";
                    }

                } else {
                    $output = array(
                        'status' => 0,
                        'message' => 'Section Not created.'
                    );
                    return false;
                }
            }

            if (isset($request->category) && trim($request->category) != "") {
                $category_ids = explode(',', $request->category);
                $category_id = implode(',', $category_ids);
                if (empty($where)) {
                    $where = " p.category_id IN($category_id)";
                } else {
                    $where .= " AND p.category_id IN($category_id)";
                }
            }

            if (isset($request->pincode) && trim($request->pincode) != "") {
                $pincode = Pincode::select('*')->where('pincode.id', '=', $request->pincode)->first();
                if (!isset($pincode) || empty($pincode)) {
                    $output = array(
                        'error' => true,
                        'message' => 'Invalid pincode.'
                    );
                }
                // get pincode id
                $pincode_id = $pincode->id;
                if (isset($request->section) && intval($request->section)) {
                    if (empty($where)) {
                        $where .= " ((p.type='included' and FIND_IN_SET('$pincode_id', p.pincodes)) or p.type = 'all' and p.id IN ($product_ids)) OR ((p.type='excluded' and NOT FIND_IN_SET('$pincode_id', p.pincodes) and p.id IN ($product_ids))) ";
                    } else {
                        $where .= " AND ((p.type='included' and FIND_IN_SET('$pincode_id', p.pincodes)) or p.type = 'all' and p.id IN ($product_ids)) OR ((p.type='excluded' and NOT FIND_IN_SET('$pincode_id', p.pincodes) and p.id IN ($product_ids))) ";
                    }
                } else {
                    if (empty($where)) {
                        $where .= " ((p.type='included' and FIND_IN_SET('$pincode_id', p.pincodes)) or p.type = 'all') OR ((p.type='excluded' and NOT FIND_IN_SET('$pincode_id', p.pincodes))) ";
                    } else {
                        $where .= " AND ((p.type='included' and FIND_IN_SET('$pincode_id', p.pincodes)) or p.type = 'all') OR ((p.type='excluded' and NOT FIND_IN_SET('$pincode_id', p.pincodes))) ";
                    }
                }
            }


            if (empty($where)) {
                $where .= " p.status = 1  ";
            } else {
                $where .= " AND p.status = 1  ";
            }


            //$city = City::select('id','latitude','longitude')->where('id',$request->city_id)->first();

            /*$sellers = Seller::select('id')->where('city_id', $request->city_id)->get();
            $sellers = $sellers->makeHidden(['logo_url']);
            $seller_ids = array_values(array_column($sellers->toarray(), 'id'));*/

            $seller_ids = CommonHelper::getSellerIds($request->latitude, $request->longitude);

            $productSql = Product::from('products as p')->select(
                DB::raw('COUNT(p.id) AS total'),
                DB::raw('MIN((select MIN(if(discounted_price > 0, discounted_price, price)) from product_variants where product_variants.product_id = p.id)) as min_price'),
                DB::raw('MAX((select MAX(if(discounted_price > 0, discounted_price, price)) from product_variants where product_variants.product_id = p.id)) as max_price')
            )->leftJoin('product_variants as pv', 'pv.product_id', '=', 'p.id')->whereIn('p.seller_id', $seller_ids);

            $productResult = $productSql->whereRaw($where)->first();
            $total = $productResult->total;
            $min_price = $productResult->min_price;
            $max_price = $productResult->max_price;

            $productResult1 = $productSql->first();
            $all_total = $productResult1->total;
            $all_min_price = $productResult1->min_price;
            $all_max_price = $productResult1->max_price;

            $sql = Product::with('images')->from("products as p")->select("p.*", "c.name as category_name",
                "t.title as tax_title", "t.percentage as tax_percentage",
                DB::raw("ceil(((price-discounted_price)/price)*100) as cal_discount_percentage"),
                DB::raw("(SELECT ceil(if(t.percentage > 0 , " . $price . " + ( " . $price . " * (t.percentage / 100)), " . $price . ")) FROM product_variants as pv WHERE pv.product_id=p.id) as price"),
                DB::raw("(select MIN(if(discounted_price > 0, discounted_price, price)) from product_variants where product_variants.product_id = p.id) as min_price"),
                DB::raw("(select MAX(if(discounted_price > 0, discounted_price, price)) from product_variants where product_variants.product_id = p.id) as max_price")
            )
                ->leftJoin("categories as c", "p.category_id", "=", "c.id")
                ->Join("product_variants as pv", "pv.product_id", "=", "p.id")
                ->leftJoin("taxes as t", "p.tax_id", "=", "t.id")
                ->whereIn('p.seller_id', $seller_ids)
                ->whereRaw($where)
                ->groupBy("p.id");

            if (isset($request->min_price) && isset($request->max_price) && intval($request->max_price)) {
                $sql = $sql->havingRaw(" min_price > " . intval(intval($request->min_price) - 1) . " and max_price < " . intval(intval($request->max_price) + 1));
            }

            if (isset($request->discount_filter) && intval($request->discount_filter)) {
                if (empty($request->min_price) && empty($request->max_price)) {
                    $sql = $sql->having("cal_discount_percentage ", ">= ", $request->discount_filter);
                } else {
                    $sql = $sql->havingRaw("cal_discount_percentage >= " . $request->discount_filter);
                }
            }
            $products = $sql->orderByRaw($sort)->skip($offset)->take($limit)->get();
            $products = $products->makeHidden(['image', 'images']);
            $total = $sql->count();

            /*$addresses = array();
            foreach ($products as $key => $value) {
                $id = $value->id;
                if (in_array($id, $addresses)) {
                    unset($products[$key]);
                } else {
                    $addresses[] = $id;
                }
            }
            unset($addresses);*/
            $product = array();
            foreach ($products as $key => $row) {
                /*$row['other_images'] = json_decode($row['other_images'], 1);
                $row['other_images'] = (empty($row['other_images'])) ? array() : $row['other_images'];*/

                $row->price = ($row->price == 0) ? 0 : $row->price;
                //$row->shipping_delivery= (!empty($row->shipping_delivery)) ? $row->shipping_delivery : '';
                $row->cal_discount_percentage = (!empty($row->cal_discount_percentage)) ? $row->cal_discount_percentage : "";
                /*$row->pickup_location = (isset($row->pickup_location) == null)  ? "" : $row->pickup_location;
                $row->pickup_postcode = (isset($row->pickup_postcode) == null)  ? "" : $row->pickup_postcode;
                $row->weight = (isset($row->weight) == null)  ? "" : $row->weight;
                $row->length = (isset($row->length) == null)  ? "" : $row->length;
                $row->breadt = (isset($row->breadt) == null)  ? "" : $row->breadt;
                $row->height = (isset($row->height) == null)  ? "" : $row->height;*/

                /*for ($j = 0; $j < count($row['other_images']); $j++) {
                    $row['other_images'][$j] = DOMAIN_URL . $row['other_images'][$j];
                }
                $row['image'] = DOMAIN_URL . $row['image'];*/
                /*if ($row['tax_id'] == 0) {
                    $row['tax_title'] = "";
                    $row['tax_percentage'] = "0";
                } else {
                    $t_id = $row['tax_id'];
                    $sql_tax = "SELECT * from taxes where id= $t_id";
                    $db->sql($sql_tax);
                    $res_tax1 = $db->getResult();
                    foreach ($res_tax1 as $tax1) {
                        $row['tax_title'] = (!empty($tax1['title'])) ? $tax1['title'] : "";
                        $row['tax_percentage'] =  (!empty($tax1['percentage'])) ? $tax1['percentage'] : "0";
                    }
                }*/

                if (!empty($user_id)) {
                    $favorite = Favorite::select("id")->where('product_id', '=', $row->id)->where('user_id', '=', $user_id)->first();
                    if (!empty($favorite)) {
                        $row->is_favorite = true;
                    } else {
                        $row->is_favorite = false;
                    }
                } else {
                    $row->is_favorite = false;
                }

                //$product[$key] = $row;
                /*$sql = "SELECT *,(SELECT short_code FROM unit u WHERE u.id=pv.measurement_unit_id) as measurement_unit_name,
                            (SELECT short_code FROM unit u WHERE u.id=pv.stock_unit_id) as stock_unit_name
                                FROM product_variant pv WHERE pv.product_id=" . $row['id'] . " $where1 ORDER BY " . $price_sort . "";
                $db->sql($sql);
                $variants = $db->getResult();*/

                $variants = $row->variants;
                foreach ($variants as $subkey => $variant) {
                    $taxed = ProductHelper::getTaxableAmount($variant->id);
                    //$variants[$subkey]['taxable_amount'] = $taxed->taxable_amount;

                    //$variants[$subkey]->images = CommonHelper::getImages($variant->product_id,$variant->id);

                    if (!empty($user_id)) {
                        /*$sql = "SELECT qty as cart_count FROM cart where product_variant_id= " . $variants[$k]['id'] . " AND user_id=" . $user_id;
                        $db->sql($sql);
                        $categories = $db->getResult();*/
                        $cart = Cart::select("qty as cart_count")->where('product_variant_id', '=', $variant->id)->where('user_id', '=', $user_id)->first();
                        if (!empty($cart)) {
                            $variants[$subkey]->cart_count = $cart->cart_count;
                        } else {
                            $variants[$subkey]->cart_count = "0";
                        }
                    } else {
                        $variants[$subkey]->cart_count = "0";
                    }
                }

                //$product[$i]['variants'] = $variants;
                $row->variants = $variants;
                $product[$key] = $row;
            }
        } catch (\Exception $e) {
            Log::info("Shop api Error : " . $e->getMessage());
            throw $e;
            return CommonHelper::responseError("Something Went Wrong!");
        }


        //$city = City::select('id','latitude','longitude')->where('id',$request->city_id)->first();

        /*$sellers = Seller::select('id')->where('city_id', $request->city_id)->get();
        $sellers = $sellers->makeHidden(['logo_url']);
        $seller_ids = array_values(array_column($sellers->toarray(), 'id'));*/

        $seller_ids = CommonHelper::getSellerIds($request->latitude, $request->longitude);

        $user_id = $request->user('api-customers') ? $request->user('api-customers')->id : 0;
        $sections = CommonHelper::getSectionWithProduct($seller_ids, $user_id);

        $categories = Category::where('status', 1)
            ->where('parent_id', 0)
            ->where('status', 1)
            ->orderBy('row_order', 'ASC')
            ->get(['id', 'name', 'subtitle', 'image']);
        $categories = $categories->makeHidden(['image']);

        $sliders = Slider::where('status', 1)->orderBy('id', 'DESC')->get();
        $sliders = $sliders->makeHidden(['image', 'product', 'category', 'created_at', 'updated_at', 'status']);

        /* $slider =  array_map("array_filter",$slider->toArray());
        $slider = array_filter($slider); */

        foreach ($sliders as $key => $slider) {
            $sliders[$key]->slider_url = $sliders[$key]->slider_url ?? "";
            $sliders[$key]->type_id = $sliders[$key]->type_id ? intval($sliders[$key]->type_id) : 0;
        }

        $offers = Offer::orderBy('id', 'DESC')->get();
        $offers = $offers->makeHidden(['image']);

        $output = array(

            'category' => $categories,
            'sliders' => $sliders,
            'offers' => $offers,
            'sections' => $sections,




            /*'total' => ($total != "") ? $total : 0,
            'min_price' => $min_price ?? 0,
            'max_price' => $max_price ?? 0,
            'total_min_price' => $total_min_price  ?? 0,
            'total_max_price' => $total_max_price  ?? 0,
            'products' => $product*/
        );
        /*  if (!empty($sections)) {

         } else {
             $output = array(
                 'min_price' => $min_price ?? 0,
                 'max_price' => $max_price ?? 0,
                 'total_min_price' => $total_min_price  ?? 0,
                 'total_max_price' => $total_max_price  ?? 0,
                 'category' => $categories,
                 'slider' => $slider,
                 'offers' => $offers,
                 'products' => array(),
             );
         } */
        return CommonHelper::responseWithData($output);
    }
}
