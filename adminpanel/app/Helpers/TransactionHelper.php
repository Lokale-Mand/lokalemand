<?php

namespace App\Helpers;
use App\Models\Order;
use App\Models\Setting;


use Illuminate\Support\Facades\Log;
use App\Models\Refund;
use App\Helpers\PaypalClient;
use Razorpay\Api\Api;
use App\Models\UserAddress;


class TransactionHelper
{
    public static function fetchPaymentStatus($transaction_type,$transaction_id,$transaction_amount)
    {
        $place_order = 0;
        $transaction_status = "failed";
        $server_output = "";
        $gateway_amount = 0;
        \Log::info("transaction_amount => ".$transaction_amount);
        if($transaction_type == "CCAvenueGateway")
        {
            $post = [
                'order_no' => $transaction_id
            ];
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, 'https://111printphoto.in/Photo_case/CCAvenue/getTransactionStatus.php');
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($post));
            $server_output = curl_exec($ch);

            $result = json_decode($server_output, 1);
            if ($result['status'] == 1 && $result['data']['error_code'] == "")
            {
                $status = $result['data']['order_status'];
                $gateway_amount = $result['data']['order_amt'];

                if($status == 'Shipped')
                {
                    $place_order = 1;
                    $transaction_status = 'success';
                }
                elseif($status == 'Awaited' || $status == 'Successful' )
                {
                    $place_order = 1;
                    $transaction_status = 'pending';
                }
                else
                {
                    $place_order = 0;
                    $transaction_status = 'failed';
                }
            }
            else
            {
                $place_order = 0;
                $transaction_status = 'api_error';
            }

            if($place_order == 1 && $transaction_amount != $gateway_amount)
            {
                $place_order = 0;
                $transaction_status = 'amount_mismatch';
            }
        }
        else if($transaction_type == "Paytm")
        {
            $post = [
                'ORDER_ID' => $transaction_id
            ];
            $url = url('paytm/TXNStatus.php');
            Log::info($url);
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($post));
            $server_output = curl_exec($ch);

            $result = json_decode($server_output, 1);
            \Log::info('-------------Paytm start---------------');
            \Log::info($result);

            if(isset($result['data']['STATUS'])) {
                $status = $result['data']['STATUS'] ? $result['data']['STATUS'] : '';
                \Log::info("PAYTM STATUS SET: ".$status);
            }else {
                \Log::info("PAYTM STATUS: NOT SET--->");
            }

            $gateway_amount = $result['data']['TXNAMOUNT'];

            if($status == 'TXN_SUCCESS')
            {
                $place_order = 1;
                $transaction_status = 'success';
            }
            elseif($status == 'PENDING')
            {
                $place_order = 1;
                $transaction_status = 'pending';
            }
            else
            {
                $place_order = 0;
                $transaction_status = 'failed';
            }

            if($place_order == 1 && $transaction_amount != $gateway_amount)
            {
                $place_order = 0;
                $transaction_status = 'amount_mismatch';
            }
            \Log::info('-------------Paytm end---------------');

        }
        else if($transaction_type == "Paypal")
        {
            $paypalClient = new PaypalClient();
            $server_output = $paypalClient->getPayment($transaction_id);
            $result = json_decode($server_output, 1);
            \Log::info('-------------Paypal start---------------');

            if(isset($result['state']) && $result['state'] == 'approved')
            {
                $place_order = 1;
                $transaction_status = 'success';

                $gateway_amount = $result['transactions'][0]['amount']['total'];
            }
            else
            {
                $place_order = 0;
                $transaction_status = 'failed';
            }

            \Log::info($transaction_amount != $gateway_amount);
            if(( $place_order == 1) && ($transaction_amount != $gateway_amount))
            {
                \Log::info("gateway_amount => ".$gateway_amount);
                \Log::info("transaction_amount =>".$transaction_amount);
                $place_order = 0;
                $transaction_status = 'amount_mismatch';
            }
            \Log::info('-------------Paypal end---------------');
        }
        else if($transaction_type == "COD")
        {
            $place_order = 1;
            $transaction_status = "";
        }

        $out = array();
        $out['place_order'] = $place_order;
        $out['transaction_status'] = $transaction_status;
        $out['raw_api_response'] = $server_output; // Added for Logging Purpose.

        return $out;
    }

    public static function refund($request)
    {
        $message = "";
        $transaction_status = "";

        $merchant_refund_id = 'REFUND'.round(microtime(true) * 1000);
        $gateway_refund_id = "";

        if($request->transaction_type == "CCAvenueGateway")
        {
            $data = array();
            $data['reference_no'] = $request->reference_no;
            $data['refund_amount'] = $request->refund_amount;
            $data['refund_ref_no'] = $merchant_refund_id;

            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, 'https://printphoto.in/Photo_case/CCAvenue/refund.php');
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
            $server_output = curl_exec($ch);
            curl_close($ch);

            $result = json_decode($server_output, 1);
            if($result['status'] == 1 && $result['data']['refund_status'] == 0)
            {
                $status = 1;
                $transaction_status = "success";
            }
            else
            {
                $message = "Error Code: ".$result['data']['error_code']." Reason:".$result['data']['reason'];
                $transaction_status = "failed";
            }
        }
        else if($request->transaction_type == "Paytm")
        {

            $paytm_error_codes['328'] = __('Currency_not_same');
            $paytm_error_codes['501'] = __('System_error');
            $paytm_error_codes['600'] = __('Invalid_refund_request');
            $paytm_error_codes['606'] = __('Checksum_generated_by_Paytm_payment_gateway_does_not_match_checksum_expected_by_bank');
            $paytm_error_codes['607'] = __('Order_not_exist_for_current_request');
            $paytm_error_codes['609'] = __('Refund_initiated_for_a_rejected_transaction');
            $paytm_error_codes['612'] = __('This_is_a_valid_authorized_transaction');
            $paytm_error_codes['617'] = __('Refund_already_raised');
            $paytm_error_codes['619'] = __('Invalid_refund_amount');
            $paytm_error_codes['620'] = __('Refund_failed');
            $paytm_error_codes['622'] = __('No_token_transaction_limited');
            $paytm_error_codes['640'] = __('Order_is_frozen');
            $paytm_error_codes['700'] = __('Invalid_consult_request');
            $paytm_error_codes['701'] = __('Refund_already_raised_with_same_refid');
            $paytm_error_codes['702'] = __('Not_allowed_to_reprocess_refund_request');
            $paytm_error_codes['703'] = __('Refund_is_already_success_or_in_pending_state._Please_check_status_query_for_final_result');
            $paytm_error_codes['704'] = __('Balance_not_enough');

            $data = array();
            $data['ORDERID'] = $request->ORDERID;
            $data['REFID'] = $merchant_refund_id;
            $data['TXNID'] = $request->TXNID;
            $data['REFUNDAMOUNT'] = $request->REFUNDAMOUNT;

            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, 'https://printphoto.in/Photo_case/PaytmKit/refund.php');
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
            $server_output = curl_exec($ch);
            curl_close($ch);

            $result = json_decode($server_output, 1);

            $gateway_refund_id = (string)@$result['REFUNDID'];

            if($result['STATUS'] == 'TXN_SUCCESS' )
            {
                $transaction_status = "success";
            }
            else if($result['STATUS'] == 'TXN_FAILURE' )
            {
                $transaction_status = "failed";
                $message = "Response Code: ".$result['RESPCODE'].' - '.@$paytm_error_codes[$result['RESPCODE']];
            }
            else if($result['STATUS'] == 'PENDING')
            {
                $transaction_status = "pending";
                $message = "Response Code: ".$result['RESPCODE'].' - '.@$paytm_error_codes[$result['RESPCODE']];
            }
        }
        if($request->transaction_type == "Razorpay")
        {
            try
            {
                $merchant_refund_id = "";
                $api = new Api(env('RAZORPAY_API_KEY'), env('RAZORPAY_API_SECRET'));
                $refund = $api->refund->create(array('payment_id' => $request->paymentId, 'amount'=>$request->refundAmount * 100));
                $gateway_refund_id = $refund->id;
                $transaction_status = 'success';
            }
            catch(\Exception $e)
            {
                $transaction_status = "failed";
                $message = $e->getMessage();
            }
        }

        if($transaction_status != "")
        {
            $order_status = array();
            $order_status['order_id'] = $request->order_id;
            $order_status['merchant_refund_id'] = $merchant_refund_id;
            $order_status['gateway_refund_id'] = $gateway_refund_id;
            $order_status['transaction_status'] = $transaction_status;
            $order_status['transaction_status_checked_at'] = \Carbon\Carbon::now('UTC')->toDateTimeString();
            Refund::create($order_status);

            if($transaction_status == 'success')
            {
                $order_status = array();
                $order_status['order_id'] = $request->order_id;
                $order_status['order_item_id'] = 0;
                $order_status['status'] = "Order Refunded";
                $order_status['created_by'] = 0;
                $order_status['user_type'] = 0;
                CommonHelper::setOrderStatus($order_status);
            }
            elseif($transaction_status == 'failed')
            {
                $order_status = array();
                $order_status['order_id'] = $request->order_id;
                $order_status['order_item_id'] = 0;
                $order_status['status'] = "Refund Failed";
                $order_status['created_by'] = 0;
                $order_status['user_type'] = 0;
                CommonHelper::setOrderStatus($order_status);
            }
        }

        $out['transaction_status'] = $transaction_status;
        $out['message'] = $message;
        return $out;
    }

    public static function syncRefundStatus()
    {
        $refund_status =  "";

        $pending_refunds = Refund::with('order')->where('transaction_status','pending')->get();
        foreach($pending_refunds as $refund_record)
        {
            if($refund_record->order->transaction_type != 'Paytm')
            {
                continue;
            }

            $data = array();
            $data['ORDERID'] = $refund_record->order->transaction_id;
            $data['REFID'] = $refund_record->merchant_refund_id;
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, 'https://printphoto.in/Photo_case/PaytmKit/refund_status.php');
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
            $server_output = curl_exec($ch);
            curl_close($ch);

            $result = json_decode($server_output, 1);
            $paytm_status = "";
            if(isset($result['REFUND_LIST']))
            {
                foreach($result['REFUND_LIST'] as $refund)
                {
                    if($refund['REFID'] == $refund_record->merchant_refund_id)
                    {
                        $paytm_status = $refund['STATUS'];
                    }
                }
            }

            if($paytm_status == 'TXN_SUCCESS')
            {
                $refund_status = "success";
            }
            else if($paytm_status == 'TXN_FAILURE' )
            {
                $refund_status = "failed";
            }
            else if($result['STATUS'] == 'PENDING')
            {
                $refund_status = "failed";
            }

            if($refund_status != "")
            {
                if($refund_status == 'success')
                {
                    $refund_record->transaction_status = $refund_status;
                    $refund_record->transaction_status_checked_at = \Carbon\Carbon::now('UTC')->toDateTimeString();
                    $refund_record->save();

                    $order_status = array();
                    $order_status['order_id'] = $refund_record->order_id;
                    $order_status['order_item_id'] = 0;
                    $order_status['status'] = "Order Refunded";
                    $order_status['created_by'] = 0;
                    $order_status['user_type'] = 0;
                    CommonHelper::setOrderStatus($order_status);
                }
                elseif($refund_status == 'failed')
                {
                    $refund_record->transaction_status = $refund_status;
                    $refund_record->transaction_status_checked_at = \Carbon\Carbon::now('UTC')->toDateTimeString();
                    $refund_record->save();

                    $order_status = array();
                    $order_status['order_id'] = $refund_record->order_id;
                    $order_status['order_item_id'] = 0;
                    $order_status['status'] = "Refund Failed";
                    $order_status['created_by'] = 0;
                    $order_status['user_type'] = 0;
                    CommonHelper::setOrderStatus($order_status);
                }
            }
        }
        return 1;
    }


    public static function createOrderonRazorpay($order_id)
    {

        $order =  Order::with('items')->where('id',$order_id)->first();
        \Log::error("createOrderonRazorpay = ",[$order]);

        /*$order_amount = 0;
        foreach ($order->items as $item){
            $order_amount += round($item->price,2);
        }*/

        $order_amount = $order->final_total;

        $transaction_id = "";
         try{

            \Log::error("razorpay_key => ".Setting::get_value('razorpay_key'));
            \Log::error("razorpay_secret_key => ".Setting::get_value('razorpay_secret_key'));
            \Log::error("before api function");

            $api = new Api(Setting::get_value("razorpay_key"), Setting::get_value("razorpay_secret_key"));

            \Log::error("payment_method = ",[$api]);

            $currency_code = Setting::get_value('currency_code')??'INR';
            $order_details = array();
            $order_details['amount'] = $order_amount * 100;
            $order_details['currency'] = $currency_code;
            $order_details['payment_capture'] = 1;
            $order_details['receipt'] = $order->id;
            $rpay_order  = $api->order->create($order_details); // Creates order

            \Log::error("payment_method = ",[$rpay_order]);

            $transaction_id = $rpay_order->id;

            // return $transaction_id;

        }catch(\Exception $e) {
            \Log::error("getMessage Exception ".$e->getMessage());

            \Log::error($e->getTraceAsString());
        }finally {
            return $transaction_id;
        }
    }

    public static function createOrderOnStripe($order){
        // $address = UserAddress::where('id',$order->address_id)->first();

        $response = "";
         try{
            $stripe_secret_key = Setting::get_value('stripe_secret_key');
            $stripe_currency_code = Setting::get_value('stripe_currency_code');
            $app_name = Setting::get_value('app_name');

            $stripe = new \Stripe\StripeClient(
             $stripe_secret_key
            );

            /*$customer = $stripe->customers->create([
                'description' => $app_name,
                'name' => $address->name ?? auth()->user()->name,
                'address' => [
                    'line1' => $order->address ?? $address->address,
                    'postal_code' => $address->pincode,
                    'city' => $address->city,
                    'state' => $address->state,
                    'country' => $address->country,
                ],
                'shipping' => [
                    'name' => $address->name ?? auth()->user()->name,
                    'address' => [
                        'line1' => $order->address ?? $address->address,
                        'postal_code' => $address->pincode,
                        'city' => $address->city,
                        'state' => $address->state,
                        'country' => $address->country,
                    ]
                ],

            ]);

            Log::info("stripe customer : ",[$customer]);*/

            Log::info("stripe : ",[$stripe]);
            $amount = $order->final_total;
            $stripeAmount = $amount * 100;
            $stripeData = $stripe->paymentIntents->create([
                'description' => $app_name,

                /*'customer' => $customer,*/

                'customer' => auth()->user()->stripe_id ?? "",

                /*'shipping' => [
                    'name' => $address->name ?? auth()->user()->name,
                    'address' => [
                        'line1' => $order->address ?? $address->address,
                        'postal_code' => $address->pincode,
                        'city' => $address->city,
                        'state' => $address->state,
                        'country' => $address->country,
                    ]
                ],*/

                'amount' => $stripeAmount,
                'currency' => $stripe_currency_code,
                'automatic_payment_methods' => [
                    'enabled' => true,
                ],
            ]);
            $response = $stripeData;
         }catch(\Exception $e) {
             \Log::error("getMessage Exception ".$e->getMessage());

             \Log::error($e->getTraceAsString());
         }finally {
             return $response;
         }
    }

    public static function verifyRazorpaySignature($razorpay_order_id, $razorpay_payment_id, $razorpay_signature)
    {
        $generated_signature = hash_hmac('sha256',$razorpay_order_id."|".$razorpay_payment_id, Setting::get_value("razorpay_secret_key"));
        if ($generated_signature == $razorpay_signature)
        {
            return true;
        }
        return false;
    }

    public static function fetchRazorpayOrders($from,$to)
    {
        $api = new Api(env('RAZORPAY_API_KEY'), env('RAZORPAY_API_SECRET'));
        $skip = 0;
        $count = 100;
        $orders = array();

        do{
            $options = array(
                'count' => $count,
                'skip'  => $skip,
                'from'  => $from,
                'to' => $to
            );
            $result = $api->order->all($options);
            foreach($result->items as $order)
            {
                $orders[] = $order;
            }
            $has_next = $result->count < $count ? 0 : 1;
            $skip = $skip + $count;
        }
        while($has_next);

        return $orders;
    }

    public static function fetchRazorpayPayments($from,$to)
    {
        $api = new Api(env('RAZORPAY_API_KEY'), env('RAZORPAY_API_SECRET'));
        $skip = 0;
        $count = 100;
        $payments = array();

        do{
            $options = array(
                'count' => $count,
                'skip'  => $skip,
                'from'  => $from,
                'to' => $to
            );
            $result = $api->payment->all($options);
            foreach($result->items as $payment)
            {
                $payments[] = $payment;
            }
            $has_next = $result->count < $count ? 0 : 1;
            $skip = $skip + $count;
        }
        while($has_next);

        return $payments;
    }

    public static function setRazorpayPaymentFees($transaction_id)
    {
        $url = env('RAZORPAY_BASE_URL').'orders/'.$transaction_id.'/payments';

        $clientId = env('RAZORPAY_API_KEY');
        $secret = env('RAZORPAY_API_SECRET');

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_HEADER, false);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_USERPWD, $clientId . ":" . $secret);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        $server_output = curl_exec($ch);

        $result = json_decode($server_output,1);

        $fees = 0;

        if(isset($result['items'])){
            foreach ($result['items'] as $order){
                if($order['status'] == 'captured'){
                    $fees = $order['fee']/100;
                }
            }
        }

        $response = CommonHelper::set_payment_gateway_fees($transaction_id, $fees);
        return $response;
    }

    public static function setPaypalPaymentFees($transaction_id)
    {
        $paypalClient = new PaypalClient();
        $server_output = $paypalClient->getPayment($transaction_id);

        $result = json_decode($server_output, 1);
        $fees = 0;

        if(isset($result['transactions'][0]['related_resources'])){
            foreach ($result['transactions'][0]['related_resources'] as $transactions){
                if(isset($transactions['sale'])){
                    $fees = $transactions['sale']['transaction_fee']['value'];
                }
            }
        }

        $response = CommonHelper::set_payment_gateway_fees($transaction_id, $fees);
        return $response;
    }
}

?>
