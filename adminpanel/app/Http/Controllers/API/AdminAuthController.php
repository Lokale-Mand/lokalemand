<?php

// namespace App\Http\Controllers\Api;
namespace App\Http\Controllers\API;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Models\Admin;
use App\Models\DeliveryBoy;
use App\Models\Role;
use App\Models\Seller;
use App\Models\SellerCommission;
use App\Models\Setting;
use App\Models\UserToken;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use App\Models\User;

class AdminAuthController extends Controller
{
    public function login(Request $request)
    {
        $requestData = $request->all();
        $validator = Validator::make($requestData,[
            'email' => 'email|required',
            'password' => 'required'
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        $user = Admin::with('seller')
            ->where('email', request()->email)
            ->where('role_id',$request->get('type',1))
            ->first();

        if(!$user){
            return CommonHelper::responseError('User is not register with this email address!');
        }
        if (!Hash::check(request()->password, $user->password)) {
            return CommonHelper::responseError('Email/Password is wrong!');
        }

        //$otherRoleIds = array(3,4);
        $otherRoleIds = array(Role::$roleSeller, Role::$roleDeliveryBoy);
        if(in_array($user->role_id,$otherRoleIds) && \App\Models\Setting::get_value('purchase_code')==''){
            return CommonHelper::responseError('System is not activated yet, Please Contact to Administrator!');
        }

        //If Seller
        if($user->role_id == Role::$roleSeller && isset($user->seller) && $user->seller->status == Seller::$statusRegistered){
            return CommonHelper::responseError("Your request under review, you will get notification after get approval!");
        }

        if($user->role_id == Role::$roleSeller && isset($user->seller) && $user->seller->status == Seller::$statusRejected){
            $data["status"] = $user->seller->status;
            $data["remark"] = $user->seller->remark ?? "";
            return CommonHelper::responseErrorWithData("Your request rejected, Please Contact to Administrator for approval!", $data);
        }

        if($user->role_id == Role::$roleSeller && isset($user->seller) && $user->seller->status == Seller::$statusDeactivated){
            $data["status"] = $user->seller->status;
            $data["remark"] = $user->seller->remark ?? "";
            return CommonHelper::responseErrorWithData("Your Account is Deactivated, Please Contact to Administrator for activate!", $data);
        }

        //If delivery boy
        if($user->role_id == Role::$roleDeliveryBoy && isset($user->deliveryBoy) && $user->deliveryBoy->status == DeliveryBoy::$statusRegistered){
            return CommonHelper::responseError("Your request under review, you will get notification after get approval!");
        }

        if($user->role_id == Role::$roleDeliveryBoy && isset($user->deliveryBoy) && $user->deliveryBoy->status == DeliveryBoy::$statusRejected){
            $data["status"] = $user->deliveryBoy->status;
            $data["remark"] = $user->deliveryBoy->remark ?? "";
            return CommonHelper::responseErrorWithData("Your request rejected, Please Contact to Administrator for approval!", $data);
        }

        if($user->role_id == Role::$roleDeliveryBoy && isset($user->deliveryBoy) && $user->deliveryBoy->status == DeliveryBoy::$statusDeactivated){
            $data["status"] = $user->deliveryBoy->status;
            $data["remark"] = $user->deliveryBoy->remark ?? "";
            return CommonHelper::responseErrorWithData("Your Account is Deactivated, Please Contact to Administrator for activate!", $data);
        }


        //Auth::login($user,true);
        Auth::login($user,false);

        if(isset($request->fcm_token)) {
            $type = "";
            $user_id = 0;
            if($user->role_id == Role::$roleSeller){
                $type = Role::$roleNameSeller;
                $user_id = auth()->user()->seller->id;
            }elseif($user->role_id == Role::$roleSeller){
                $type = Role::$roleDeliveryBoy;
                $user_id = auth()->user()->deliveryBoy->id;
            }
            UserToken::firstOrCreate([
                'user_id' => $user_id,
                'type' => $type,
                'fcm_token' => $request->fcm_token
            ]);
        }


        $accessToken = $user->createToken('authToken')->accessToken;

        $res = ['user' => $user, 'access_token' => $accessToken];
        return CommonHelper::responseWithData($res);
    }

    public function logout (Request $request)
    {
        $token = $request->user()->token();
        $token->revoke();
        $response = ['message' => 'You have been successfully logged out!'];
        return response($response, 200);
    }

    public function forgetPassword(Request $request){

        $requestData = $request->all();
        $validator = Validator::make($requestData,[
            'email' => 'required|email|exists:admins',
        ],[
            'email.exists' => "This Email is not registered, Please enter valid Email Address"
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        $token = time().Str::random(30);

        DB::table('password_resets')->insert([
            'email' => $request->email,
            'token' => $token,
            'created_at' => Carbon::now()
        ]);

        /*Mail::send('forgetPassword', ['token' => $token], function($message) use($request){
            $message->to($request->email);
            $message->subject('Reset Password');
        });*/

        $data = array();
        $data['type'] = "forgot_password";
        $data['token'] = $token;
        CommonHelper::sendMail($request->email,"Reset Password",$data);

        return CommonHelper::responseSuccess("We have e-mailed your password reset link!");
    }

    public function resetPassword(Request $request){

        $requestData = $request->all();
        $validator = Validator::make($requestData,[
            'password' => 'required|string|min:6|confirmed',
            'password_confirmation' => 'required'
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        $updatePassword = DB::table('password_resets')
            ->where(['token' => $request->token])
            ->first();

        if(!$updatePassword){
            return CommonHelper::responseError("Invalid token!");
        }

        $admin = Admin::where('email', $updatePassword->email)
            ->update(['password' => bcrypt($request->password)]);

        DB::table('password_resets')->where(['email'=> $updatePassword->email])->delete();

        return CommonHelper::responseSuccess("Password updated successfully!");
    }

    /*public function submitResetPasswordForm(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users',
            'password' => 'required|string|min:6|confirmed',
            'password_confirmation' => 'required'
        ]);

        $updatePassword = DB::table('password_resets')
            ->where([
                'email' => $request->email,
                'token' => $request->token
            ])
            ->first();

        if(!$updatePassword){
            return back()->withInput()->with('error', 'Invalid token!');
        }

        $user = User::where('email', $request->email)
            ->update(['password' => Hash::make($request->password)]);

        DB::table('password_resets')->where(['email'=> $request->email])->delete();

        return redirect('/login')->with('message', 'Your password has been changed!');
    }*/

    /*Seller*/
    public function sellerRegister(Request $request){
        $requestData = $request->all();
        $validator = Validator::make($requestData,[
            'username' => 'required',
            /*'store_name' => 'required',*/
            'email' => 'email|required|unique:admins',
            'mobile' => 'required',
            'password' => 'required|confirmed'
        ],[
            'email.unique' => 'The :attribute has already been taken.',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        DB::beginTransaction();
        try {
            $data = array();
            $data['username'] = $request->username;
            $data['store_name'] = $request->store_name??"";
            $data['email'] = $request->email;
            $data['password'] = bcrypt($request->password);
            $data['role_id'] = Role::$roleSeller;
            $data['created_by'] = 0;
            $admin = Admin::create($data);

            //Create Seller
           /* $sellerData = array();
            $sellerData['admin_id'] = $admin->id;
            $sellerData['name'] = $request->username;
            $sellerData['slug'] = $request->store_name??"";
            $sellerData['store_name'] = $request->store_name;
            $sellerData['email'] = $request->email;
            $sellerData['mobile'] = $request->mobile;
            $sellerData['status'] = Seller::$statusRegistered;
            $seller = Seller::create($sellerData);*/

            $seller = new Seller();
            $seller->admin_id = $admin->id;
            $seller->name = $request->username;
            $seller->slug = $request->store_name??"";
            $seller->store_name = $request->store_name;
            $seller->email = $request->email;
            $seller->mobile = $request->mobile;
            $seller->status = Seller::$statusRegistered;
            $seller->save();

            /*$app_name = Setting::get_value('app_name');
            $status = Seller::$Registered;
            $subject = "Your Account is ".$status." Successful! on ".$app_name;
            $data['type'] = "seller_status";
            $data['status_name'] = $status;
            $data['status'] = Seller::$statusRegistered;
            $data['subject'] = $subject;
            $data['seller'] = $seller;
            CommonHelper::sendMail($request->email, $subject ,$data);*/


            try {
                CommonHelper::sendMailAdminStatus( "seller", $seller, $seller->status, $request->email);
            }catch ( \Exception $e){
                Log::error("Register Seller status send mail error",[$e->getMessage()] );
            }


            DB::commit();
            return CommonHelper::responseSuccess("Seller Registration Successful!");

        }catch (\Exception $e){
            Log::info("Seller Register Error : ",[$e->getMessage()]);
            DB::rollBack();
            return CommonHelper::responseError("Something went wrong!");
        }
    }

    public function saveSellerDetails(Request $request){

        $record = Seller::where('admin_id',auth()->user()->id)->first();
        if(!$record){
            return CommonHelper::responseError("Seller Details Not Found");
        }

        $validator = Validator::make($request->all(),[
            'name' => 'required',
            'email' => 'email|required|unique:admins,email,'.auth()->user()->id,

            'store_url' => 'required',
            'store_name' => 'required',

            'store_logo' => ($record->store_logo == "")?'required|':''.'mimes:jpeg,jpg,png,gif,pdf',
            'national_id_card' => ($record->national_id_card == "")?'required|':''.'mimes:jpeg,jpg,png,gif,pdf',
            'address_proof' => ($record->address_proof == "")?'required|':''.'mimes:jpeg,jpg,png,gif,pdf',

            'street' => 'required',
            'city_id' => 'required',
            'state' => 'required',
            'categories_ids' => 'required',
            'account_number' => 'required',
            'ifsc_code' => 'required',
            'bank_name' => 'required',
            'account_name' => 'required',
            'latitude' => 'required',
            'longitude' => 'required',
            'place_name' => 'required',
            'formatted_address' => 'required',
            'store_description' => 'required'
        ],[
            'email.unique' => 'The :attribute has already been taken.',
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        $record->name = $request->name;
        $record->email = $request->email;
        $record->mobile = $request->mobile;
        $record->store_url = $request->store_url;
        $record->store_name = $request->store_name;
        $record->street = $request->street;
        $record->pincode_id = ($request->pincode_id)??0;
        $record->city_id = $request->city_id;
        $record->state = $request->state;
        $record->categories = $request->categories_ids;
        $record->account_number = $request->account_number;
        $record->bank_ifsc_code = $request->ifsc_code;
        $record->bank_name = $request->bank_name;
        $record->account_name = $request->account_name;
        $record->tax_name = $request->tax_name;
        $record->tax_number = $request->tax_number;
        $record->pan_number = $request->pan_number;
        $record->latitude = $request->latitude;
        $record->longitude = $request->longitude;
        $record->place_name = $request->place_name;
        $record->formatted_address = $request->formatted_address;
        $record->store_description = $request->store_description;

        if($record->status == Seller::$statusRegistered ){
            $record->require_products_approval = $request->require_products_approval ?? 0;
            $record->customer_privacy = $request->customer_privacy ?? 0;
            $record->view_order_otp = $request->view_order_otp ?? 0;
            $record->assign_delivery_boy = $request->assign_delivery_boy ?? 0;
            $record->change_order_status_delivered = $request->change_order_status_delivered ?? 0;
        }

        if($request->hasFile('store_logo')){
            $file = $request->file('store_logo');
            $fileName = time().'_'.rand(1111,99999).'.'.$file->getClientOriginalExtension();
            $image = Storage::disk('public')->putFileAs('sellers', $file, $fileName);
            $record->logo = $image;
        }

        if($request->hasFile('national_id_card')){
            $file = $request->file('national_id_card');
            $fileName = time().'_'.rand(1111,99999).'.'.$file->getClientOriginalExtension();
            $image = Storage::disk('public')->putFileAs('sellers', $file, $fileName);
            $record->national_identity_card = $image;
        }

        if($request->hasFile('address_proof')){
            $file = $request->file('address_proof');
            $fileName = time().'_'.rand(1111,99999).'.'.$file->getClientOriginalExtension();
            $image = Storage::disk('public')->putFileAs('sellers', $file,$fileName);
            $record->address_proof = $image;
        }
        $record->save();

        if($record->status == Seller::$statusRegistered ){
            $categories_ids = explode(',',$request->categories_ids);
            foreach ($categories_ids as $key => $category_id){
                $commission = new SellerCommission();
                $commission->seller_id = $record->id;
                $commission->category_id = $category_id;
                $commission->save();
            }
        }
        if($record->status == Seller::$statusRegistered ) {
            return CommonHelper::responseSuccess("Your Request send to admin and will approve soon. Thank You!");
        }else{
            return CommonHelper::responseSuccess("Your updated successfully. Thank You!");
        }
    }


    /*Delivery Boy*/
    public function deliveryBoyRegister(Request $request){

        $requestData = $request->all();
        $validator = Validator::make($requestData,[
            'username' => 'required',
            'email' => 'email|required|unique:admins',
            //'email' => 'required|unique:users,email,'.$user->id.',id,deleted_at,NULL',
            'mobile' => 'required',
            'password' => 'required|confirmed'
        ],[
            'email.unique' => 'The :attribute has already been taken.',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        DB::beginTransaction();
        try {
            $data = array();
            $data['username'] = $request->username;
            $data['email'] = $request->email;
            $data['password'] = bcrypt($request->password);
            $data['role_id'] = Role::$roleDeliveryBoy;
            $data['created_by'] = 0;
            $admin = Admin::create($data);

            //Create Delivery Boy
            /*$deliveryBoyData = array();
            $deliveryBoyData['admin_id'] = $admin->id;
            $deliveryBoyData['name'] = $request->username;
            $deliveryBoyData['mobile'] = $request->mobile;
            $deliveryBoyData['address'] = '';
            $deliveryBoyData['bonus'] = 0;
            $deliveryBoyData['status'] = DeliveryBoy::$statusRegistered;
            $deliveryBoyData['city_id'] = 0;
            $deliveryBoy = DeliveryBoy::insert($deliveryBoyData);*/



            $deliveryBoy = new DeliveryBoy();
            $deliveryBoy->city_id = 0;
            $deliveryBoy->admin_id = $admin->id;
            $deliveryBoy->name = $request->username;
            $deliveryBoy->mobile = $request->mobile;
            $deliveryBoy->address = '';

            $bonus = CommonHelper::getDeliveryBoyBonusSettings();

            $deliveryBoy->bonus_type = $bonus['delivery_boy_bonus_type'] ?? 0;
            $deliveryBoy->bonus_percentage =  $bonus['delivery_boy_bonus_percentage'] ?? 0;
            $deliveryBoy->bonus_min_amount =  $bonus['delivery_boy_bonus_min_amount'] ?? 0;
            $deliveryBoy->bonus_max_amount =  $bonus['delivery_boy_bonus_max_amount'] ?? 0;

            $deliveryBoy->status = DeliveryBoy::$statusRegistered;
            $deliveryBoy->save();


            /*$app_name = Setting::get_value('app_name');
            $status = Seller::$Registered;
            $subject = "Your Account is ".$status." Successful! on ".$app_name;
            $data['type'] = "delivery_boy_status";
            $data['status_name'] = $status;
            $data['status'] = Seller::$statusRegistered;
            $data['subject'] = $subject;
            $data['delivery_boy'] = $deliveryBoy;
            CommonHelper::sendMail($request->email, $subject ,$data);*/



            try {
                CommonHelper::sendMailAdminStatus( "delivery_boy", $deliveryBoy, $deliveryBoy->status, $request->email);
            }catch ( \Exception $e){
                Log::error("Register delivery_boy status send mail error",[$e->getMessage()] );
            }

            DB::commit();
            return CommonHelper::responseSuccess("Delivery Boy Registration Successful!");

        }catch (\Exception $e){
            Log::info("Delivery Boy Register Error : ",[$e->getMessage()]);
            DB::rollBack();
            return CommonHelper::responseError("Something went wrong!");
        }
    }
    public function saveDeliveryBoyDetails(Request $request){

        $deliveryBoy = DeliveryBoy::where('admin_id',auth()->user()->id)->first();

        if(!$deliveryBoy){
            return CommonHelper::responseError("No Delivery boy details found!");
        }

        $validator = Validator::make($request->all(),[
            'name' => 'required',
            'mobile' => 'required',
            'dob' => 'required',
            'driving_license' => ($deliveryBoy->driving_license == "")?'required|':''.'mimes:jpeg,jpg,png,gif,pdf',
            'national_identity_card' => ($deliveryBoy->national_identity_card == "")?'required|':''.'mimes:jpeg,jpg,png,gif,pdf',
            'ifsc_code' => 'required',
            'bank_name' => 'required',
            'bank_account_number' => 'required',
            'account_name' => 'required',
            'city_id' => 'required',
            'address' => 'required'
        ],[
            'email.unique' => 'The :attribute has already been taken.',
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        $deliveryBoy->name = $request->name;
        $deliveryBoy->mobile = $request->mobile;
        $deliveryBoy->dob = $request->dob;
        $deliveryBoy->city_id = $request->city_id;
        $driving_license = '';
        if($request->hasFile('driving_license')){
            $file = $request->file('driving_license');
            $fileName = time().'_'.rand(1111,99999).'.'.$file->getClientOriginalExtension();
            $driving_license = Storage::disk('public')
                ->putFileAs('delivery_boy/driving_license', $file,$fileName);
        }
        $deliveryBoy->driving_license = $driving_license;
        $national_identity_card = '';
        if($request->hasFile('national_identity_card')){
            $file = $request->file('national_identity_card');
            $fileName = time().'_'.rand(1111,99999).'.'.$file->getClientOriginalExtension();
            $national_identity_card = Storage::disk('public')
                ->putFileAs('delivery_boy/national_identity_card', $file, $fileName);
        }
        $deliveryBoy->national_identity_card = $national_identity_card;
        $deliveryBoy->ifsc_code = $request->ifsc_code;
        $deliveryBoy->bank_name = $request->bank_name;
        $deliveryBoy->bank_account_number = $request->bank_account_number;
        $deliveryBoy->account_name = $request->account_name;
        $deliveryBoy->address = $request->address;
        $deliveryBoy->other_payment_information = $request->other_payment_information;
        $deliveryBoy->save();

        if($deliveryBoy->status == DeliveryBoy::$statusRegistered ) {
            return CommonHelper::responseSuccess("Your Request send to admin and will approve soon. Thank You!");
        }else{
            return CommonHelper::responseSuccess("Your updated successfully. Thank You!");
        }
    }

    public function validateLogin(){
        //check login
        $login = validateLogin();
        if(isset($login['is_login']) && $login['is_login']==true){
            return CommonHelper::responseSuccess("Success");
        }
        return CommonHelper::responseError("Success");
    }
}
