<?php

namespace App\Http\Controllers\API;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Offer;
use App\Models\Section;
use App\Models\Setting;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class OffersApiController extends Controller
{
    public function index(){
        $sections = Section::orderBy('id','DESC')->get()->toArray();
        $offers = Offer::orderBy('id','DESC')->get();
        $data = array(
            "sections" => $sections,
            "offers" => $offers
        );
        return CommonHelper::responseWithData($data);
    }

    public function save(Request $request){
        $validator = Validator::make($request->all(),[
            'image' => 'required|mimes:jpeg,jpg,png,gif',
            'position' => 'required',
            'section_id' => ['required_if:position,below_section']
        ],[
            'section_id.required_if' => 'The section position field is required when position is below section.',
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }
        $offer = new Offer();
        $image = '';
        if($request->hasFile('image')){
            $file = $request->file('image');
            $fileName = time().'_'.rand(1111,99999).'.'.$file->getClientOriginalExtension();
            $image = Storage::disk('public')->putFileAs('offers', $file, $fileName);
        }
        $offer->image = $image;
        $offer->position = $request->position;
        $offer->section_position = $request->section_id ?? 0;
        $offer->save();
        return CommonHelper::responseSuccess("Offer Saved Successfully!");
    }

    public function delete(Request $request){

        if(isset($request->id)){

            $offer = Offer::find($request->id);
            if($offer){
                @Storage::disk('public')->delete($offer->image);
                $offer->delete();
                return CommonHelper::responseSuccess("Offer Deleted Successfully!");
            }else{
                return CommonHelper::responseSuccess("Offer Already Deleted!");
            }
        }
    }


}
