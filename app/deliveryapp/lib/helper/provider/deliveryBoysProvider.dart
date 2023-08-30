
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
enum DeliveryBoysState {
  initial,
  loading,
  loaded,
  updating,
  loadingMore,
  error,
}

class DeliveryBoysProvider extends ChangeNotifier {
  DeliveryBoysState deliveryBoysState = DeliveryBoysState.initial;
  String message = '';
  late DeliveryBoys deliveryBoys;
  List<DeliveryBoysData> deliveryBoysList = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;
  String selectedDeliveryBoy = "0";

  getDeliveryBoys({
    required int selectedDeliveryBoyIndex,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      deliveryBoysState = DeliveryBoysState.loading;
      notifyListeners();
    } else {
      deliveryBoysState = DeliveryBoysState.loadingMore;
      notifyListeners();
    }

    try {
      Map<String, String> params = {};
      selectedDeliveryBoy = selectedDeliveryBoyIndex.toString();
      params[ApiAndParams.limit] = Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData = (await getDeliveryBoysRepository(params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        deliveryBoys = DeliveryBoys.fromJson(getData);
        totalData = getData[ApiAndParams.total];
        List<DeliveryBoysData> tempDeliveryBoys = deliveryBoys.data ?? [];

        deliveryBoysList.addAll(tempDeliveryBoys);
      }

      hasMoreData = totalData > deliveryBoysList.length;
      if (hasMoreData) {
        offset += Constant.defaultDataLoadLimitAtOnce;
      }

      deliveryBoysState = DeliveryBoysState.loaded;
      notifyListeners();
    } catch (e) {
      message = e.toString();
      deliveryBoysState = DeliveryBoysState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }

  Future updateOrdersDeliveryBoy({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    try {
      deliveryBoysState = DeliveryBoysState.updating;
      notifyListeners();

      Map<String, dynamic> getUpdatedOrderData = await updateOrdersDeliveryBoyRepository(params: params);

      if (getUpdatedOrderData[ApiAndParams.status].toString() == "1") {
        deliveryBoysState = DeliveryBoysState.loaded;
        notifyListeners();
        return true;
      } else {
        deliveryBoysState = DeliveryBoysState.error;
        GeneralMethods.showSnackBarMsg(context, getUpdatedOrderData[ApiAndParams.message]);
        notifyListeners();
        return false;
      }
    } catch (e) {
      message = e.toString();
      deliveryBoysState = DeliveryBoysState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
      return false;
    }
  }

  Future setSelectedIndex(String index) async {
    selectedDeliveryBoy = index;
    notifyListeners();
  }
}
