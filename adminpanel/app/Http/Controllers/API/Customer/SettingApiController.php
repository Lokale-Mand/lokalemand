<?php

// namespace App\Http\Controllers\Api\Customer;
namespace App\Http\Controllers\API\Customer;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Http\Repository\CategoryRepository;
use App\Http\Repository\ProductRepository;
use App\Models\Admin;
use App\Models\Cart;
use App\Models\City;
use App\Models\Favorite;
use App\Models\ProductImages;
use App\Models\Seller;
use App\Models\Setting;
use App\Models\SocialMedia;
use App\Models\Tax;
use App\Models\TimeSlot;
use App\Models\Transaction;
use App\Models\WalletTransaction;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use function App\Models\Setting;
use function PHPUnit\Framework\isJson;

class SettingApiController extends Controller
{
    public function getSettings(Request $request){
        $variables = array(
            "app_name",
            "support_number",
            "support_email",

            "is_version_system_on",
            "required_force_update",
            "current_version",
            "ios_is_version_system_on",
            "ios_required_force_update",
            "ios_current_version",

            "store_address",
            "map_latitude",
            "map_longitude",
            "currency",
            "currency_code",
            "decimal_point",
            "system_timezone",
            "default_city_id",
            "max_cart_items_count",
            "min_order_amount",
            "area_wise_delivery_charge",
            "min_amount",
            "delivery_charge",
            "is_refer_earn_on",
            "min_refer_earn_order_amount",
            "refer_earn_bonus",
            "refer_earn_method",
            "max_refer_earn_amount",
            "minimum_withdrawal_amount",
            "max_product_return_days",
            "delivery_boy_bonus_percentage",
            "user_wallet_refill_limit",
            "tax_name",
            "tax_number",
            "low_stock_limit",
            "generate_otp",

            "app_mode_customer",
            "app_mode_customer_remark",

            "app_mode_seller",
            "app_mode_seller_remark",

            "app_mode_delivery_boy",
            "app_mode_delivery_boy_remark",


            "contact_us",
            "about_us",
            "privacy_policy",
            "returns_and_exchanges_policy",
            "shipping_policy",
            "cancellation_policy",
            "terms_conditions",
            "privacy_policy_delivery_boy",
            "terms_conditions_delivery_boy",
            "privacy_policy_manager_app",
            "terms_conditions_manager_app",
            "privacy_policy_seller",
            "terms_conditions_seller",
            "common_meta_keywords",
            "common_meta_description",
            "color",
            "show_color_picker_in_website",
            "screenshots",
            "google_play",
            "favicon",
            "web_logo",
            "loading",
            "time_slots_is_enabled",
            "time_slots_delivery_starts_from",
            "time_slots_allowed_days",
            "google_place_api_key",

            "popup_enabled",
            "popup_always_show_home",
            "popup_type",
            "popup_type_id",
            "popup_url",
            "popup_image"

        );
        $data = CommonHelper::getSettings($variables);

        if(isset($data['default_city_id']) && $data['default_city_id']){
            $data["default_city"] = CommonHelper::getDefaultCity();
        }

        $user_id = $request->user('api-customers') ? $request->user('api-customers')->id : '';
        $favorite = Favorite::select('favorites.product_id')->from('favorites')->join("products", "favorites.product_id", "=", "products.id")->where('favorites.user_id',$user_id)->get()->toArray();
        if (!empty($favorite)) {
            $favorite_product_ids = array_column($favorite,'product_id');
            $data["favorite_product_ids"] = $favorite_product_ids;
        }else{
            $data["favorite_product_ids"] = [];
        }

        if(isset($request->is_web_setting) && $request->is_web_setting == 1){
            $webVariables = array(
                "site_title",
                "website_url",
                "color",
                "light_color",
                "dark_color",

                "app_title",
                "app_tagline",
                "app_short_description",

                "is_android_app",
                "android_app_url",
                "play_store_logo",

                "is_ios_app",
                "ios_app_url",
                "ios_store_logo",

                "copyright_details",

                "common_meta_keywords",
                "common_meta_description",

                "show_color_picker_in_website",
                "favicon",
                "web_logo",
                "loading",
            );
            $web_settings = CommonHelper::getSettings($webVariables);
            $data["web_settings"] = $web_settings;
            $firebase = CommonHelper::getFirebaseKeys();
            $data["firebase"] = CommonHelper::convertSettingsInArray($firebase);
            $data["social_media"] = SocialMedia::orderBy('id','ASC')->get();
        }

        if(!empty($data)){
            return CommonHelper::responseWithData($data);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

    public function getPaymentMethods(Request $request){
        $variables = array(
            "payment_method_settings",
            "cod_payment_method",
            "cod_mode",

            "paypal_payment_method",

            "razorpay_payment_method",
            "razorpay_key",
            "razorpay_secret_key",

            "paystack_payment_method",
            "paystack_public_key",
            "paystack_secret_key",
            "paystack_currency_code",

            "stripe_payment_method",
            "stripe_publishable_key",
            "stripe_secret_key",
            "stripe_currency_code",
            "stripe_mode",

            "paytm_payment_method",
            "paytm_mode",
            "paytm_merchant_key",
            "paytm_merchant_id"

        );
        $settings = Setting::whereIn('variable',$variables )->get();
        $data = array();
        foreach ($settings as $setting){
            $data[$setting->variable] = $setting->value ?? "";
        }

        if(!empty($data)){

            $data = json_encode($data);
            $data = base64_encode($data);

            /*$data = base64_decode($data);
            $data = json_decode($data);*/

            return CommonHelper::responseWithData($data);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
        /*$payment_methods = Setting::get_value('payment_methods');
        if (!empty($payment_methods)) {
            $payment_methods = json_decode($payment_methods);
            if (!isset($payment_methods->paytm_payment_method)) {
                $payment_methods->paytm_payment_method = 0;
                $payment_methods->paytm_mode = "sandbox";
                $payment_methods->paytm_merchant_key = "";
                $payment_methods->paytm_merchant_id = "";
            }
            $payment_methods->cod_mode = !isset($payment_methods->cod_mode) || empty($payment_methods->cod_mode) ? 'global' : $payment_methods->cod_mode;
            return CommonHelper::responseWithData($payment_methods);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }*/
    }

    public function getPrivacy(){

        $privacy_policy = Setting::get_value('privacy_policy');
        if (!empty($privacy_policy)) {
            return CommonHelper::responseWithData($privacy_policy);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

    public function getTerms(){

        $terms_conditions = Setting::get_value('terms_conditions');
        if (!empty($terms_conditions)) {
            return CommonHelper::responseWithData($terms_conditions);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

    public function getLogo(){

        $logo = Setting::get_value('logo');
        if (!empty($logo)) {
            $logo = asset('storage/'.$logo);
            return CommonHelper::responseWithData($logo);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

    public function getContact(){

        $contact_us = Setting::get_value('contact_us');
        if (!empty($contact_us)) {
            return CommonHelper::responseWithData($contact_us);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

    public function getAboutUs(){

        $about_us = Setting::get_value('about_us');
        if (!empty($about_us)) {
            return CommonHelper::responseWithData($about_us);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

    public function getTimezone(){

        $system_timezone = Setting::get_value('system_timezone');
        if (!empty($system_timezone)) {

            $system_timezone = json_decode($system_timezone,true);
            $system_timezone['tax_name'] = isset($system_timezone['tax_name']) && !empty($system_timezone['tax_name']) ? $system_timezone['tax_name'] : "";
            $system_timezone['tax_number'] = isset($system_timezone['tax_number']) && !empty($system_timezone['tax_number']) ? $system_timezone['tax_number'] : "0";
            $system_timezone['currency'] = Setting::get_value('currency');

            return CommonHelper::responseWithData($system_timezone);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

    public function getFcmKey(){

        $fcm_server_key = Setting::get_value('fcm_server_key');
        if (!empty($fcm_server_key)) {

            return CommonHelper::responseWithData($fcm_server_key);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

    public function getTimeSlotConfig(){

        $time_slot_config = Setting::get_value('time_slot_config');
        if (!empty($time_slot_config)) {
            $time_slot_config = json_decode($time_slot_config,true);
            return CommonHelper::responseWithData($time_slot_config);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

    public function getFrontEndSettings(){

        $front_end_settings = Setting::get_value('front_end_settings');

        if ($front_end_settings) {

            $data = array();
            $data['favicon'] = Setting::get_value('favicon') ? asset('storage/'.Setting::get_value('favicon')) : '';
            $data['screenshots'] = Setting::get_value('screenshots') ? Setting::get_value('screenshots') : '';
            $data['google_play'] = Setting::get_value('google_play') ? Setting::get_value('google_play') : '';
            $data['show_color_picker_in_website'] = Setting::get_value('show_color_picker_in_website') ? Setting::get_value('show_color_picker_in_website') : '';

            return CommonHelper::responseWithData($data);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

    public function getTimeSlots(){
        $timeSlots = TimeSlot::where('status',1)->orderBy('last_order_time')->get();
        if (count($timeSlots)) {
            $responce["time_slots_is_enabled"] = Setting::get_value('time_slots_is_enabled') ?? '';
            $responce["time_slots_delivery_starts_from"] = Setting::get_value('time_slots_delivery_starts_from') ?? '';
            $responce["time_slots_allowed_days"] = Setting::get_value('time_slots_allowed_days') ?? '';
            $responce["time_slots"] = $timeSlots;
            return CommonHelper::responseWithData($responce);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

    public function getShippingType(){

        $shipping_type = (Setting::get_value('local_shipping') == 1) ? 'local' : 'standard';

        if ($shipping_type) {

            return CommonHelper::responseWithData($shipping_type);
        }else{
            return  CommonHelper::responseError('No settings found!');
        }
    }

}
