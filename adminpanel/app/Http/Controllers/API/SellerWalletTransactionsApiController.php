<?php

namespace App\Http\Controllers\API;

use App\Helpers\CommonHelper;
use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\WalletTransaction;
use App\Models\Seller;
use App\Models\SellerWalletTransaction;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class SellerWalletTransactionsApiController extends Controller
{
    public function index(){
        $sellers = Seller::orderBy('id','DESC')->get();
        $SellerWalletTransaction = SellerWalletTransaction::select('sellers.name', 'seller_wallet_transactions.*')
            ->leftJoin('sellers', 'seller_wallet_transactions.seller_id', '=', 'sellers.id')
            ->orderBy('seller_wallet_transactions.id','DESC')->get();
        $data = array(
            'sellers' => $sellers,
            'walletTransactions' => $SellerWalletTransaction
        );
        return CommonHelper::responseWithData($data);
    }
    public function save(Request $request){
        $validator = Validator::make($request->all(),[
            'seller' => 'required',
            'type' => 'required',
            'amount' => 'required'
        ]);
        if ($validator->fails()) {
            return CommonHelper::responseError($validator->errors()->first());
        }
        $sellerData = json_decode($request->seller);
        $sellerWalletTransactions = new SellerWalletTransaction();
        $sellerWalletTransactions->seller_id = $sellerData->id;
        $sellerWalletTransactions->type = $request->type;
        $sellerWalletTransactions->amount = $request->amount;
        $sellerWalletTransactions->message = $request->message;
        $sellerWalletTransactions->status = 1;
        $sellerWalletTransactions->save();

        $seller = Seller::find($sellerData->id);
        $seller->balance = ($request->type == 'debit')?($seller->balance - $request->amount):($seller->balance + $request->amount);
        $seller->save();
        return CommonHelper::responseSuccess("Seller Wallet Transaction Saved Successfully!");
    }
}
