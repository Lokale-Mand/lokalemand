<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Offer extends Model
{
    use HasFactory;
    protected $appends = ['image_url'];
    protected $hidden = ['created_at','updated_at'];
    public function getImageUrlAttribute(){
        if($this->image){
            $image_url = asset('storage/'.$this->image);
            return $image_url;
        }
        return $this->image;
    }
}
