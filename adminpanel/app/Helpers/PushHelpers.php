<?php

namespace App\Helpers;

class PushHelpers
{
    //notification title
    private $title;

    //notification message
    private $message;

    //notification image url
    private $image;

    //type of notification ex: default / category / product
    private $type;

    //ID of the type ex: category_id / product_id
    private $id;

    //initializing values in this constructor
    function __construct($title, $message, $image,$type,$type_id,$type_link) {
        $this->title = $title;
        $this->message = $message;
        $this->image = $image;
        $this->type = $type;
        if(isset($type_link) && $type_link != "" && filter_var($type_link, FILTER_VALIDATE_URL) ){
            $this->id = $type_link;
        }else{
            $this->id = $type_id;
        }
    }

    //getting the push notification
    public function getPush() {
        $res = array();
        $res['data']['title'] = $this->title;
        $res['data']['message'] = $this->message;
        $res['data']['image'] = $this->image;
        $res['data']['type'] = $this->type;
        $res['data']['id'] = $this->id;
        // print_r(json_encode($res));
        return $res;
    }

}
?>
