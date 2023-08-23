<?php

namespace App\Http\Controllers\API;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Models\Country;
use Illuminate\Http\Request;

class CountryApiController extends Controller
{
    public function index(){
        $cities = Country::orderBy('id','asc')->get();
        return CommonHelper::responseWithData($cities);
    }
}
