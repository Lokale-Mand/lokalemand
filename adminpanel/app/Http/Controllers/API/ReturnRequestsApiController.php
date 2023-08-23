<?php

namespace App\Http\Controllers\API;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Models\ReturnRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ReturnRequestsApiController extends Controller
{
    public function index(){
        $ReturnRequests = ReturnRequest::select('return_requests.*','users.name',
            'order_items.product_variant_id','order_items.quantity','order_items.price',
            'order_items.discounted_price','order_items.product_name','order_items.variant_name')
            ->leftJoin('users', 'return_requests.user_id', '=', 'users.id')
            ->leftJoin('order_items', 'return_requests.order_item_id', '=', 'order_items.id')
            ->leftJoin('products', 'return_requests.product_id', '=', 'products.id')
            ->leftJoin('product_variants', 'return_requests.product_variant_id', '=', 'product_variants.id')
            ->orderBy('return_requests.id','DESC')
            ->get();
        return CommonHelper::responseWithData($ReturnRequests);
    }
    public function update(Request $request){
        $validator = Validator::make($request->all(),[
            'status' => 'required',
            'remark' => 'required'
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }
        if(isset($request->id)){
            $returnRequest = ReturnRequest::find($request->id);
            $returnRequest->remarks = $request->remark;
            $returnRequest->status = $request->status;
            $returnRequest->save();
        }
        return CommonHelper::responseSuccess("Return Request Status Updated Successfully!");
    }
    public function delete(Request $request){
        if(isset($request->id)){
            $returnRequest = ReturnRequest::find($request->id);
            if($returnRequest){
                $returnRequest->delete();
                return CommonHelper::responseSuccess("Return Request Deleted Successfully!");
            }else{
                return CommonHelper::responseSuccess("Return Request Already Deleted!");
            }
        }
    }
}
