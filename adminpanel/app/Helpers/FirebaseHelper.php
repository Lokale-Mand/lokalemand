<?php
namespace App\Helpers;

use App\Models\Setting;
use Illuminate\Support\Facades\Log;

class FirebaseHelper {

    public static function send($registration_ids, $message) {
        // echo 'registration id :'.$registration_ids;
        $fields = array(
            'registration_ids' => $registration_ids,
            'data' => $message,
        );
        return self::sendPushNotification($fields);
    }

    /*
    * This function will make the actuall curl request to firebase server
    * and then the message is sent
    */
    private static function sendPushNotification($fields) {

        // firebase server url to send the curl request
        $url = 'https://fcm.googleapis.com/fcm/send';
        $setting = Setting::where('variable', 'fcm_server_key')->first();
        $FIREBASE_API_KEY = $setting['value'] ?? "";

        Log::info("FIREBASE_API_KEY : ".$FIREBASE_API_KEY);

        //building headers for the request
        $headers = array(
            'Authorization: key=' . $FIREBASE_API_KEY,
            'Content-Type: application/json'
        );

        //Initializing curl to open a connection
        $ch = curl_init();

        //Setting the curl url
        curl_setopt($ch, CURLOPT_URL, $url);

        //setting the method as post
        curl_setopt($ch, CURLOPT_POST, true);

        //adding headers
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

        //disabling ssl support
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        //adding the fields in json format
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));
        //finally executing the curl request
        $result = curl_exec($ch);
        if ($result === FALSE) {
            \Log::info("sendPushNotification fields: Curl failed",[$fields]);
            die('Curl failed: ' . curl_error($ch));
        }

        //Now close the connection
        curl_close($ch);
        // print_r($result);

        \Log::info("sendPushNotification fields: ",[$fields]);

        \Log::info("sendPushNotification : ",[$result]);
        //and return the result
        return $result;
    }
}
