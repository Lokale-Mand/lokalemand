<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;
    public static $statusSuccess = "success";
    public static $statusFailed = "failed";

    public static $paymentTypeCod = "COD";

    public static $paymentTypeStripe = "Stripe";
    public static $paymentTypeRazorpay = "Razorpay";
    public static $paymentTypePaystack = "Paystack";
    public static $paymentTypePaytm = "Paytm";
    public static $paymentTypePaypal = "Paypal";

    protected $fillable = ['user_id','order_id','type',
        'txn_id','payu_txn_id','amount',
        'status','message','transaction_date'];
}
