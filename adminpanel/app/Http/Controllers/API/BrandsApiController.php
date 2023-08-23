<?php

namespace App\Http\Controllers\API;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Models\Brand;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class BrandsApiController extends Controller
{
    public function index(){

        $brands = Brand::orderBy('id','DESC')->get();

        return CommonHelper::responseWithData($brands);
    }

    public function save(Request $request){

        $validator = Validator::make($request->all(),[
            'name' => 'required',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }
        $brand = new Brand();
        $brand->name = $request->name;
        $brand->status = 1;
        $image = '';
        if($request->hasFile('image')){
            $file = $request->file('image');
            $fileName = time().'_'.rand(1111,99999).'.'.$file->getClientOriginalExtension();
            $image = Storage::disk('public')->putFileAs('brand', $file, $fileName);
        }
        $brand->image = $image;
        $brand->save();
        return CommonHelper::responseSuccess("Brands Saved Successfully!");
    }

    public function update(Request $request){

        $validator = Validator::make($request->all(),[
            'name' => 'required',
        ]);

        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }

        if(isset($request->id)){

            $brand = Brand::find($request->id);
            $brand->name = $request->name;
            $brand->status = $request->status;

            if($request->hasFile('image')){
                @Storage::disk('public')->delete($brand->image);
                $file = $request->file('image');
                $fileName = time().'_'.rand(1111,99999).'.'.$file->getClientOriginalExtension();
                $image = Storage::disk('public')->putFileAs('brand', $file, $fileName);
                $brand->image = $image;
            }
            $brand->save();
        }
        return CommonHelper::responseSuccess("Brands Updated Successfully!");
    }

    public function delete(Request $request){

        if(isset($request->id)){

            $brand = Brand::find($request->id);
            if($brand){
                $brand->delete();
                return CommonHelper::responseSuccess("Brands Deleted Successfully!");
            }else{
                return CommonHelper::responseSuccess("Brands Already Deleted!");
            }
        }
    }

    public function getBrands(){
        $brands = Brand::orderBy('id','ASC')->where('status',1)->get();
        return CommonHelper::responseWithData($brands);
    }
}
