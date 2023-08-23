<?php

namespace App\Http\Controllers\API\Customer;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Setting;
use App\Models\SubCategory;
use App\Models\User;
use App\Models\UserAddress;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class AddressApiController extends Controller
{
    public function getAddress(Request $request){

        $offset = $request->get('offset', 0);
        $limit = $request->get('limit', 10);
        $addresses = UserAddress::where('user_id',auth()->user()->id);

        if(isset($request->is_default) && $request->is_default == 1 ){
            $address = $addresses->where("is_default", 1)->get();

            /*if (count($address)>0) {
                return CommonHelper::responseWithData($address);
            }else{
                return CommonHelper::responseError(__('address_not_found'));
            }*/

            if (count($address) > 0) {
                return CommonHelper::responseWithData($address);
            }else{
                $addresses = UserAddress::where('user_id',auth()->user()->id)->get();
                if (count($addresses) > 0) {
                    $address[0] = $addresses[0];
                    return CommonHelper::responseWithData($address);
                }
                return CommonHelper::responseError(__('address_not_found'));
            }
        }
        $total = $addresses->count();
        $addresses = $addresses->orderBy("is_default","DESC")->offset($offset)->limit($limit)->get();
        if(count($addresses)>0){
            return CommonHelper::responseWithData($addresses,$total);
        }else{
            return CommonHelper::responseError(__('address_not_found'));
        }
    }

    public function save(Request $request){
        $input = $request->all();
        $validator = Validator::make($request->all(),[
            'name' => 'required',
            'mobile' => 'required',
            'type' => 'required',
            'address' => 'required',
            'latitude' => 'required',
            'longitude' => 'required',
            'pincode' => 'required',
            'city' => 'required',
            'state' => 'required',
            'country' => 'required',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }


        /*$latitude = $request->latitude;
        $longitude = $request->longitude;
        $api_key = Setting::get_value('google_place_api_key');
        $url = "https://maps.googleapis.com/maps/api/geocode/json?latlng={$latitude},{$longitude}&key={$api_key}";
        $response = file_get_contents($url);
        $data = json_decode($response, true);*/

        /*if ($data['status'] == 'OK') {
            $results = $data['results'];
            if (!empty($results)) {
                $address = $results[0]['formatted_address'];

                foreach ($results[0]['address_components'] as $component) {
                    foreach ($component['types'] as $type) {
                        if ($type == 'locality') {
                            $city = $component['long_name'];
                        } elseif ($type == 'postal_code') {
                            $pincode = $component['long_name'];
                        } elseif ($type == 'administrative_area_level_1') {
                            $state = $component['long_name'];
                        } elseif ($type == 'country') {
                            $country = $component['long_name'];
                        }
                    }
                }
            }
        }*/
        /*echo "Address: " . $address . "<br>";
        echo "City: " . $city . "<br>";
        echo "Pincode: " . $pincode . "<br>";
        echo "State: " . $state . "<br>";
        echo "Country: " . $country . "<br>";*/

        /*if ($data['status'] == 'OK') {
            $addressComponents = $data['results'][0]['address_components'];

            $address = $data['results'][0]['formatted_address'];
            $area = $addressComponents[0]['long_name'];
            $landmark = $addressComponents[1]['long_name'];
            $city = $addressComponents[2]['long_name'];
            $pincode = $addressComponents[6]['long_name'];
            $state = $addressComponents[4]['long_name'];
            $country = $addressComponents[5]['long_name'];
        }*/

        /*$input['landmark'] = $landmark ?? "";
        $input['area'] = $area ?? "";
        $input['pincode'] = $pincode ?? "";
        $input['city'] = $city ?? "";
        $input['state'] = $state ?? "";
        $input['country'] = $country ?? "";
        $input['alternate_mobile'] = $request->alternate_mobile ?? "";*/

        // dd($input);



        $city = CommonHelper::getDeliverableCity($request->latitude, $request->longitude);
        /*if (empty($city)) {
            return CommonHelper::responseError(__('we_doesnt_delivery_at_selected_city'));
        }*/

        $user_id = auth()->user()->id;
        $count = UserAddress::where('user_id',$user_id)->count();
        if($count == 0){
            $input['is_default'] = 1;
        }

        if(isset($request->is_default) && $request->is_default == 1 && $count > 0){
            UserAddress::where('user_id', '=', $user_id)->update(['is_default' => 0]);
        }

        $input['user_id'] = $user_id;
        $input['city_id'] = $city->id ?? 0;
        $address = UserAddress::create($input);

        $address->is_default = ($address->is_default == "0")?0:1; // this for type casting
        return CommonHelper::responseWithData($address);
    }

    public function update(Request $request){

        $input = $request->all();
        $validator = Validator::make($request->all(),[
            'id' => 'required',
            'name' => 'required',
            'mobile' => 'required',
            'type' => 'required',
            'address' => 'required',
            'pincode' => 'required',
            'city' => 'required',
            'state' => 'required',
            'country' => 'required',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        $city = CommonHelper::getDeliverableCity($request->latitude, $request->longitude);
        /*if (empty($city)) {
            return CommonHelper::responseError(__('we_doesnt_delivery_at_selected_city'));
        }*/

        if(isset($request->is_default) && $request->is_default == 1 ){
            $user_id = auth()->user()->id;
            UserAddress::where('user_id', '=', $user_id)->update(['is_default' => 0]);
        }

        $address = UserAddress::where('id',$request->id)->first();
        if(!$address){
            return CommonHelper::responseError(__('address_not_found'));
        }




        $input['city_id'] = $city->id ?? 0;
        $address->update($input);

        $address->is_default = ($address->is_default == "0")?0:1; // this for type casting
        return CommonHelper::responseWithData($address);
    }

    public function delete(Request $reequest){
        $id = $reequest->id;
        $address = UserAddress::find($id);
        if(!$address){
            return CommonHelper::responseError(__('address_not_found'));
        }
        $address->delete();
        return CommonHelper::responseSuccess(__('address_deleted_successfully'));
    }
}
