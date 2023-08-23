<?php

namespace App\Http\Controllers\API;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Seller;
use App\Models\Setting;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class CategoryApiController extends Controller
{
    /*public function index(Request $request){}*/

    public function getCategories(Request $request){

        $categories = Category::orderBy('id','DESC')->get();

        if(empty($categories)){
            return  CommonHelper::responseError('Category not found.');
        }
        return CommonHelper::responseWithData($categories);
    }


    public function getActiveCategories(){
        $categories = Category::where('status', 1)->orderBy('id','ASC')->get()->toArray();
        return CommonHelper::responseWithData($categories);
    }
    public function getMainCategories(){
        $categories = CommonHelper::getMainCategories();

        if(empty($categories)){
            return  CommonHelper::responseError('Category not found.');
        }
        return CommonHelper::responseWithData($categories);
    }
    public function getCategoriesByRowOrder(){
        $categories = Category::orderBy('row_order','ASC')->get();
        return CommonHelper::responseWithData($categories);
    }



    public function save(Request $request){
        // \Log::info('Save : ',[$request->all()]);
        $validator = Validator::make($request->all(),[
            'name' => 'required',
            'subtitle' => 'required',
            'image' => 'required|mimes:jpeg,jpg,png,gif'
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }
        $category = new Category();
        $category->name = $request->name;
        $category->subtitle = $request->subtitle;
        $image = '';
        if($request->hasFile('image')){
            $file = $request->file('image');
            $fileName = time().'_'.rand(1111,99999).'.'.$file->getClientOriginalExtension();
            $image = Storage::disk('public')->putFileAs('categories', $file, $fileName);
        }
        $category->image = $image;
        $category->web_image = '';
        $category->status = 1;
        $category->parent_id = $request->parent_id;
        $category->save();
        return CommonHelper::responseSuccess("Category Saved Successfully!");
    }
    public function update(Request $request){
        $validator = Validator::make($request->all(),[
            'name' => 'required',
            'subtitle' => 'required',
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }
        if(isset($request->id)){
            $category = Category::find($request->id);
            $category->name = $request->name;
            $category->subtitle = $request->subtitle;
            $category->status = $request->status;
            $category->parent_id = $request->parent_id;
            if($request->hasFile('image')){
                @Storage::disk('public')->delete($category->image);
                $file = $request->file('image');
                $fileName = time().'_'.rand(1111,99999).'.'.$file->getClientOriginalExtension();
                $image = Storage::disk('public')->putFileAs('categories', $file, $fileName);
                $category->image = $image;
            }
            $category->save();
        }
        return CommonHelper::responseSuccess("Category Updated Successfully!");
    }
    public function delete(Request $request){
        if(isset($request->id)){
            $category = Category::find($request->id);
            if($category){
                @Storage::disk('public')->delete($category->image);
                $category->delete();
                return CommonHelper::responseSuccess("Category Deleted Successfully!");
            }else{
                return CommonHelper::responseSuccess("Category Already Deleted!");
            }
        }
    }


    public function getOptions(Request  $request){
        echo"<option value='0' selected disabled>Select Category</option>";
        $options = CommonHelper::categoryTree(0,'',null,array(), false,array());
    }

    public function updateCategoriesOrder(Request $request){
        $categories = $request->all();
        foreach ($categories as $key => $category){
            $data = Category::find($category["id"]);
            $data->row_order = $category["row_order"];
            $data->save();
        }
        return CommonHelper::responseSuccess("Category Order Updated Successfully!");
    }
    public function countProductCategoryWise(){
        $categories = Category::select('id','name',DB::raw('(SELECT count(id) from `products` WHERE products.category_id = categories.id) AS product_count'))
            ->orderBy('id','ASC')->get();
        return CommonHelper::responseWithData($categories);
    }

    public function getSellerCategories(Request $request){
        //$categories = CommonHelper::getSellerCategories($request->seller_id);
        //return CommonHelper::responseWithData($categories);

        CommonHelper::categoryTree(0,'',null,array(), true,array(), $request->seller_id);
    }

}
