<?php

namespace App\Http\Controllers\API;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Section;
use App\Models\Product;
use App\Models\Setting;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class SectionsApiController extends Controller
{
    public function index(){
        $sections = Section::orderBy('id','DESC')->get();
        if(empty($sections)){
            return  CommonHelper::responseError('Section not found.');
        }
        return CommonHelper::responseWithData($sections);

    }

    public function save(Request $request){

        // \Log::info('Save : ',[$request->all()]);
        $validator = Validator::make($request->all(),[
            'title' => 'required',
            'short_description' => 'required',
            /*'style' => 'required',*/
            /*'category_ids' => 'required',*/
            'product_type' => 'required',
            'product_ids' => ($request->product_type == "custom_products")?'required':""
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }
        $section = new Section();
        $section->title = $request->title;
        $section->short_description = $request->short_description;
        //$section->style = $request->style;
        $section->category_ids = $request->category_ids??"";
        $section->product_type = $request->product_type;
        $section->product_ids = $request->product_ids;
        $section->save();
        return CommonHelper::responseSuccess("Section Saved Successfully!");
    }

    public function update(Request $request){
        $validator = Validator::make($request->all(),[
            'title' => 'required',
            'short_description' => 'required',
            /*'style' => 'required',*/
            /*'category_ids' => 'required',*/
            'product_type' => 'required',
            'product_ids' => ($request->product_type == "custom_products")?'required':""
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }
        if(isset($request->id)){
            $section = Section::find($request->id);
            $section->title = $request->title;
            $section->short_description = $request->short_description;
            //$section->style = $request->style;
            $section->category_ids = $request->category_ids??"";
            $section->product_type = $request->product_type;
            $section->product_ids = $request->product_ids;
            $section->save();
        }
        return CommonHelper::responseSuccess("Section Updated Successfully!");
    }

    public function delete(Request $request){
        if(isset($request->id)){
            $section = Section::find($request->id);
            if($section){
                $section->delete();
                return CommonHelper::responseSuccess("Section Deleted Successfully!");
            }else{
                return CommonHelper::responseSuccess("Section Already Deleted!");
            }
        }
    }

    public function getSectionsByRowOrder(){
        $sections = Section::orderBy('row_order','ASC')->get();
        if(empty($sections)){
            return  CommonHelper::responseError('Section not found.');
        }
        return CommonHelper::responseWithData($sections);
    }


    public function updateSectionsOrder(Request $request){
        $sections = $request->all();
        foreach ($sections as $key => $section){
            $data = Section::find($section["id"]);
            $data->row_order = $section["row_order"];
            $data->save();
        }
        return CommonHelper::responseSuccess("Section Order Updated Successfully!");
    }


}
