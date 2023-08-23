<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
//use Illuminate\Database\Eloquent\SoftDeletes;

class OrderItem extends Model
{
    //use HasFactory,SoftDeletes;
    use HasFactory;
    protected $hidden = [];

    protected $appends = ['image_url'];

    public function images(){
        return $this->hasMany(ProductImages::class,'product_variant_id','product_variant_id');
            /*->where('product_id',0);*/
    }

    public function getImageUrlAttribute(){
        /*if($this->image){
            $image_url = \Storage::url($this->image);
            return $image_url;
        }
        return $this->image;*/

        if($this->image){
            //$image_url = \Storage::url($this->image);
            $image_url = asset('storage/'.$this->image);
            return $image_url;
        }
        return $this->image;

    }
}
