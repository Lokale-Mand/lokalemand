<?php

namespace App\Http\Controllers\API;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Models\DeliveryBoy;
use App\Models\Seller;
use App\Models\WithdrawalRequest;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class WithdrawalRequestsApiController extends Controller
{
    public function index(){
        //$withdrawalRequests = WithdrawalRequest::select('withdrawal_requests.*','users.name','sellers.name','delivery_boys.name','users.balance','sellers.balance','delivery_boys.balance')
        $withdrawalRequests = WithdrawalRequest::select('withdrawal_requests.*','users.name as user_name','sellers.name as seller_name','delivery_boys.name as delivery_boy_name',
            'users.balance as user_balance','sellers.balance as seller_balance','delivery_boys.balance as delivery_boy_balance')
            ->leftJoin('users', function($join){
                $join->where('withdrawal_requests.type', '=', WithdrawalRequest::$typeUser)
                    ->on('withdrawal_requests.type_id', '=', 'users.id');
            })
            ->leftJoin('sellers', function($join){
                $join->where('withdrawal_requests.type', '=', WithdrawalRequest::$typeSeller)
                    ->on('withdrawal_requests.type_id', '=', 'sellers.id');
            })
            ->leftJoin('delivery_boys', function($join){
                $join->where('withdrawal_requests.type', '=', WithdrawalRequest::$typeDeliveryBoy)
                    ->on('withdrawal_requests.type_id', '=', 'delivery_boys.id');
            })
            //->expect('withdrawal_requests.created_at')
            ->orderBy('withdrawal_requests.id','DESC')
            ->get()->toArray();
        $data = array();
        foreach ($withdrawalRequests as $key =>$request){
            $subData = array();
            $subData["id"] = $request["id"];
            $subData["type"] = $request["type"];
            if($request["type"] == WithdrawalRequest::$typeUser){
                $subData["name"] = $request["user_name"];
                $subData["balance"] = $request["user_balance"];
            }elseif ($request["type"] == WithdrawalRequest::$typeSeller){
                $subData["name"] = $request["seller_name"];
                $subData["balance"] = $request["seller_balance"];
            }else{
                $subData["name"] = $request["delivery_boy_name"];
                $subData["balance"] = $request["delivery_boy_balance"];
            }
            $subData["amount"] = $request["amount"];
            $subData["message"] = $request["message"];
            $subData["status"] = $request["status"];
            $subData["remark"] = $request["remark"];
            $subData["device_type"] = $request["device_type"];
            $subData["created_at"] = $request["created_at"];
            $data[] = $subData;
        }
        return CommonHelper::responseWithData($data);
    }

    public function update(Request $request){
        $validator = Validator::make($request->all(),[
            'status' => 'required'
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }
        if(isset($request->id)){

            \Illuminate\Support\Facades\DB::beginTransaction();
            try {


                $withdrawalRequest = WithdrawalRequest::find($request->id);
                if($request->status == $withdrawalRequest->status){
                    return CommonHelper::responseError('This record have same status.');
                }

                /*if($request->status == WithdrawalRequest::$statusPending){

                }

                if($request->status == WithdrawalRequest::$statusApproved){

                }

                if($request->status == WithdrawalRequest::$statusRejected){

                }*/



                $withdrawalRequest->status = $request->status;
                $withdrawalRequest->save();

                \Illuminate\Support\Facades\DB::commit();
            } catch (\Exception $e) {
                Log::info("Error : ".$e->getMessage());
                \Illuminate\Support\Facades\DB::rollBack();
                // throw $e;
                return CommonHelper::responseError("Something Went Wrong!");
            }


        }
        return CommonHelper::responseSuccess("Withdrawal Request Status Updated Successfully!");
    }


    public function delete(Request $request){
        if(isset($request->id)){
            $withdrawalRequest = WithdrawalRequest::find($request->id);
            if($withdrawalRequest){
                $withdrawalRequest->delete();
                return CommonHelper::responseSuccess("Withdrawal Request Deleted Successfully!");
            }else{
                return CommonHelper::responseSuccess("Withdrawal Request Already Deleted!");
            }
        }
    }


    public function addWithdrawalRequests(Request $request){

        $validator = Validator::make($request->all(),[
            'amount' => 'required|numeric|min:0|not_in:0'
            // 'amount' => 'required'
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        \Illuminate\Support\Facades\DB::beginTransaction();
        try {

            if($request->type == WithdrawalRequest::$typeDeliveryBoy){
                $type_id = auth()->user()->deliveryBoy->id;
                $type = WithdrawalRequest::$typeDeliveryBoy;
                $deliveryBoy = DeliveryBoy::find($type_id);
                if(empty($deliveryBoy)){
                    return CommonHelper::responseError("Delivery boy not found.");
                }
                if($deliveryBoy->balance <= $request->amount){
                    return CommonHelper::responseError("The amount is greater than your balance.");
                }
                $deliveryBoy->balance = floatval($deliveryBoy->balance) - floatval($request->amount);
                $deliveryBoy->save();

            }else if ($request->type == WithdrawalRequest::$typeSeller){

                $type_id = auth()->user()->seller->id;
                $type = WithdrawalRequest::$typeSeller;
                $seller = Seller::find($type_id);
                if(empty($seller)){
                    return CommonHelper::responseError("Seller not found.");
                }
                if($seller->balance <= $request->amount){
                    return CommonHelper::responseError("The amount is greater than your balance.");
                }
                $seller->balance = floatval($seller->balance) - floatval($request->amount);
                $seller->save();
            }else if ($request->type == WithdrawalRequest::$typeUser){
                $type_id = auth()->user()->id;
                $type = WithdrawalRequest::$typeUser;
            }

            $withdrawalRequest = new WithdrawalRequest();
            $withdrawalRequest->type = $type;
            $withdrawalRequest->type_id = $type_id;
            $withdrawalRequest->amount = $request->amount;
            $withdrawalRequest->message = $request->message;
            $withdrawalRequest->status = WithdrawalRequest::$statusPending;
            $withdrawalRequest->device_type = $request->device_type;
            $withdrawalRequest->save();

            \Illuminate\Support\Facades\DB::commit();
        } catch (\Exception $e) {
            Log::info("Error : ".$e->getMessage());
            \Illuminate\Support\Facades\DB::rollBack();
            // throw $e;
            return CommonHelper::responseError("Something Went Wrong!");
        }
        return CommonHelper::responseSuccess("Withdrawal Request Submitted Successfully!");
    }

    public function getWithdrawalRequests(Request $request){

        $limit = ($request->limit) ?? 10;
        $offset = ($request->offset) ?? 0;

        $type = WithdrawalRequest::$typeDeliveryBoy;;
        $type_id = auth()->user()->deliveryBoy->id;

        $withdrawalRequests = WithdrawalRequest::select('withdrawal_requests.*','users.name as user_name','sellers.name as seller_name','delivery_boys.name as delivery_boy_name',
            'users.balance as user_balance','sellers.balance as seller_balance','delivery_boys.balance as delivery_boy_balance')
            ->leftJoin('users', function($join){
                $join->where('withdrawal_requests.type', '=', WithdrawalRequest::$typeUser)
                    ->on('withdrawal_requests.type_id', '=', 'users.id');
            })
            ->leftJoin('sellers', function($join){
                $join->where('withdrawal_requests.type', '=', WithdrawalRequest::$typeSeller)
                    ->on('withdrawal_requests.type_id', '=', 'sellers.id');
            })
            ->leftJoin('delivery_boys', function($join){
                $join->where('withdrawal_requests.type', '=', WithdrawalRequest::$typeDeliveryBoy)
                    ->on('withdrawal_requests.type_id', '=', 'delivery_boys.id');
            })
            ->where(['type' => $type, 'type_id' => $type_id])
            ->orderBy('withdrawal_requests.id','DESC')
            ->skip($offset)->take($limit)
            ->get()->toArray();

        $data = array();
        foreach ($withdrawalRequests as $key =>$request){
            $subData = array();
            $subData["id"] = $request["id"];
            $subData["type"] = $request["type"];
            if($request["type"] == WithdrawalRequest::$typeUser){
                $subData["name"] = $request["user_name"];
                $subData["balance"] = $request["user_balance"];
            }elseif ($request["type"] == WithdrawalRequest::$typeSeller){
                $subData["name"] = $request["seller_name"];
                $subData["balance"] = $request["seller_balance"];
            }else{
                $subData["name"] = $request["delivery_boy_name"];
                $subData["balance"] = $request["delivery_boy_balance"];
            }
            $subData["amount"] = $request["amount"];
            $subData["message"] = $request["message"];
            $subData["status"] = $request["status"];
            $subData["remark"] = $request["remark"];
            $subData["device_type"] = $request["device_type"];
            $subData["created_at"] = $request["created_at"];
            $data[] = $subData;
        }
        if(!empty($data)){
            return CommonHelper::responseWithData($data);
        }else{
            return CommonHelper::responseError("Withdrawal request not found!");
        }

    }
}
