<?php

namespace App\Models;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    //use HasFactory,SoftDeletes;
    use HasFactory;
    protected $fillable = ['name'];

    protected $appends = ['image_url'];

    protected $hidden=['created_at','updated_at','deleted_at'];

    public function seller(){

        return $this->belongsTo(Seller::class,'seller_id','id');
    }

    public function tax(){
        return $this->belongsTo(Tax::class,'tax_id','id');
    }

    public function madeInCountry(){
        return $this->belongsTo(Country::class,'made_in','id');
    }

    public function category(){
        return $this->belongsTo(Category::class,'category_id','id');
    }

    public function variants(){

        return $this->hasMany(ProductVariant::class,'product_id','id');
    }

    public function images(){

        return $this->hasMany(ProductImages::class,'product_id','id')
            ->where('product_variant_id',0);
    }


    public function getImageUrlAttribute(){

        if($this->image){
            //$image_url = \Storage::url($this->image);
            $image_url = asset('storage/'.$this->image);
            //$this->image;
        }else{
            //$this->image = '';
            $image_url = '';
        }
        return $image_url;
    }
}
