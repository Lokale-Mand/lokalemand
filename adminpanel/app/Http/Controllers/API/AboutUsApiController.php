<?php

namespace App\Http\Controllers\API;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Models\Setting;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AboutUsApiController extends Controller
{
    public function index()
    {
        $about_us = Setting::where('variable', 'about_us')->first();
        return CommonHelper::responseWithData($about_us);
    }
    public function save(Request $request)
    {
        /*$validator = Validator::make($request->all(),[
            'about_us' => 'required',
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }*/

        $setting = Setting::where('variable', 'about_us')->first();
        if ($setting) {
            $setting->value = $request->about_us ?? "";
            $setting->save();
        } else {
            $setting = new Setting();
            $setting->variable = 'about_us';
            $setting->value = $request->about_us ?? "";
            $setting->save();
        }
        return CommonHelper::responseSuccess("About Us Saved Successfully!");
    }
}
