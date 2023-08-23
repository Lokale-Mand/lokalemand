<?php

namespace App\Http\Controllers\API;
use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use Cassandra\Type\Set;
use Illuminate\Http\Request;
use App\Models\Setting;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class StoreSettingsApiController extends Controller
{
    public function index()
    {
        $timezone_options = CommonHelper::getTimezoneOptions();
        $countries = json_decode(file_get_contents(base_path('config/countries_currency.json')),true);
        //$variables = array("system_configurations","system_timezone_gmt","system_configurations_id","app_name","support_number","support_email","current_version","minimum_version_required","is_version_system_on","logo","store_address","map_latitude","map_longitude","currency","system_timezone","max_cart_items_count","min_order_amount","area_wise_delivery_charge","min_amount","delivery_charge","is_refer_earn_on","min_refer_earn_order_amount","refer_earn_bonus","refer_earn_method","max_refer_earn_amount","minimum_withdrawal_amount","max_product_return_days","delivery_boy_bonus_percentage","user_wallet_refill_limit","tax_name","tax_number","low_stock_limit","from_mail","reply_to","generate_otp","app_mode_customer","app_mode_seller","app_mode_delivery_boy","smtp_from_mail","smtp_reply_to","smtp_email_password","smtp_host","smtp_port","smtp_content_type","smtp_encryption_type");
        $store_settingsArray = array(
                "system_configurations" => 1,
                "system_timezone_gmt" => "+05:30",
                "system_configurations_id" => "13",
                "app_name" => "",
                "support_number" => "",
                "support_email" => "",

                "is_version_system_on" => 0,
                "required_force_update" => 0,
                "current_version" => "1.0.0",

                "ios_is_version_system_on" => 0,
                "ios_required_force_update" => 0,
                "ios_current_version" => "1.0.0",


                /*"minimum_version_required" => "",*/

                "logo" => "",
                "copyright_details" => "",
                "store_address" => "",
                'map_latitude' => "",
                "map_longitude" => "",
                "currency" => "",
                "currency_code" => "",
                "decimal_point" => "",
                "system_timezone" => "",
                "default_city_id" => 0,

                "max_cart_items_count" => "",
                "min_order_amount" => "",
                "low_stock_limit" => "",


                "delivery_boy_bonus_settings" => 0,
                "delivery_boy_bonus_type" => 0,
                "delivery_boy_bonus_percentage" => 0,
                "delivery_boy_bonus_min_amount" => 0,
                "delivery_boy_bonus_max_amount" => 0,






                "area_wise_delivery_charge" => 0,
                "min_amount" => "",
                "delivery_charge" => "",
                "is_refer_earn_on" => 0,
                "min_refer_earn_order_amount" => "",
                "refer_earn_bonus" => "",
                "refer_earn_method" => "",
                "max_refer_earn_amount" => "",
                "minimum_withdrawal_amount" => "",
                "max_product_return_days" => "",

                "user_wallet_refill_limit" => "",
                "tax_name" => "",
                "tax_number" => "",



                "from_mail" => "",
                "reply_to" => "",
                "generate_otp" => 0,

                "app_mode_customer" => 0,
                "app_mode_customer_remark" => "",

                "app_mode_seller" => 0,
                "app_mode_seller_remark" => "",

                "app_mode_delivery_boy" => 0,
                "app_mode_delivery_boy_remark" => "",

                "smtp_from_mail" => "",
                "smtp_reply_to" => "",
                "smtp_email_password" => "",
                "smtp_host" => "",
                "smtp_port" => "",
                "smtp_content_type" => "",
                "smtp_encryption_type" => "",
                "google_place_api_key" => ""
            );
        $variables = array_keys($store_settingsArray);
        $store_settings = Setting::whereIn('variable',$variables )->get();
        $data = array(
            "store_settingsObject" => $store_settingsArray,
            "timezone_options" => $timezone_options,
            "currency_code" => $countries,
            "store_settings" => $store_settings
        );
        return CommonHelper::responseWithData($data);
    }

    public function save(Request $request)
    {
        $validator = Validator::make($request->all(),[
            'logo' => $request->hasFile('logo')?'mimes:jpeg,jpg,png,gif':'',
            'copyright_details' => 'required',
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        if($request->hasFile('logo'))
        {
            $file = $request->file('logo');
            $fileName = time().'_'.rand(1111,99999).'.'.$file->getClientOriginalExtension();
            $logo = Storage::disk('public')->putFileAs('logo', $file,$fileName);
        }
        foreach ($request->all() as $key => $value){
            $value = $value ?? " ";
            $setting = Setting::where('variable', $key)->first();
            if ($setting) {
                $setting->variable = $key;
                $setting->value = ($key=='logo' && isset($logo)) ? $logo : $value;
                $setting->save();
            } else {
                $setting = new Setting();
                $setting->variable = $key;
                $setting->value = ($key=='logo' && isset($logo)) ? $logo : $value;
                $setting->save();
            }
        }
        return CommonHelper::responseSuccess("Store Settings Saved Successfully!");
    }



    public function getPurchaseCode(){
        $code = Setting::get_value('purchase_code')??'';

        return CommonHelper::responseWithData($code);
    }

    public function purchaseCode($code,$type=0){

        $domain = env('APP_URL');
        $path = 'https://wrteam.in/validator/home/validator?purchase_code='.$code.'&domain_url='.$domain;
        $response = file_get_contents($path);
        $data = json_decode($response,true);
        $valid = false;
        if(isset($data['error']) && $data['error']==false){
            $valid = true;
        }

        $setting = Setting::where('variable', 'purchase_code')->first()??new Setting();
        $setting->variable = 'purchase_code';
        $setting->value = $valid?$code:'';
        $setting->save();

        if($type){
            return $valid;
        }else{
            return CommonHelper::responseWithData($response);
        }

    }

    public function testMail(Request $request){

        $validator = Validator::make($request->all(),[
            'email' => 'required|email',
            'host' => 'required',
            'username' => 'required',
            'password' => 'required',
            'port' => 'required',
            'encryption' => 'required',
            'support_email' => 'required',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        $config = [
            'driver' => 'smtp',
            'host' => $request->host,
            'username' => $request->username,
            'password' => $request->password,
            'port' => $request->port,
            'encryption' => $request->encryption,
        ];

        \Config::set('mail', $config);
        \Config::set('mail.from.name', $config);

        try {


            \Mail::send([],[], function ($message) use ($request) {
                $message->to($request->email)
                    ->subject('Testing Mail')
                    ->setBody('Email Test Successfully!');
                $message->from($request->support_email);
            });

            return CommonHelper::responseSuccess("Test Mail Sent Successfully!");

        }catch (\Exception $e){
            return CommonHelper::responseError($e->getMessage());
        }

    }
}
