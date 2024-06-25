import 'package:flutter/material.dart';
import 'package:lokale_mand/helper/utils/apiAndParams.dart';
import 'package:lokale_mand/helper/utils/generalMethods.dart';
import 'package:lokale_mand/seller/model/orderDetail.dart';
import 'package:lokale_mand/seller/repositories/orderDetailApi.dart';

enum OrderDetailState {
  initial,
  loading,
  loaded,
  error,
}

class OrderDetailProvider extends ChangeNotifier {
  String message = '';
  OrderDetailState orderDetailState = OrderDetailState.initial;
  late OrderDetail orderDetail;

  getOrderDetail({
    required String orderId,
    required BuildContext context,
  }) async {
    orderDetailState = OrderDetailState.loading;
    notifyListeners();

    try {
      Map<String, String> params = {};
      params[ApiAndParams.orderId] = orderId;

      Map<String, dynamic> getData =
          (await getOrderDetailRepository(params: params, context: context));
      if (getData[ApiAndParams.status].toString() == "1") {
        orderDetail = OrderDetail.fromJson(getData);

        orderDetailState = OrderDetailState.loaded;
        notifyListeners();
      } else {
        orderDetailState = OrderDetailState.error;
        notifyListeners();
        GeneralMethods.showMessage(
            context, getData[ApiAndParams.message], MessageType.warning);
      }
    } catch (e) {
      message = e.toString();
      orderDetailState = OrderDetailState.error;
      GeneralMethods.showMessage(context, message, MessageType.warning);
      notifyListeners();
    }
  }
}
