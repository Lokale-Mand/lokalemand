<?php

namespace App\Http\Controllers\API;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Models\PanelNotification;
use Illuminate\Http\Request;

class NotificationPanelApiController extends Controller
{
    public function getNotifications(Request $request){
        $page = $request->page??1;
        //$notifications = PanelNotification::orderBy('id','DESC')->get();
        $notifications = PanelNotification::orderBy('id','DESC')->paginate(1);
        //return response()->json($notifications);
        return CommonHelper::responseWithData($notifications);
    }
}
