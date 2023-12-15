import 'package:flutter/material.dart';
import 'package:lokale_mand/helper/sessionManager.dart';
import 'package:lokale_mand/helper/utils/apiAndParams.dart';
import 'package:lokale_mand/helper/utils/constant.dart';
import 'package:lokale_mand/helper/utils/generalMethods.dart';
import 'package:lokale_mand/seller/model/orderStatuses.dart';
import 'package:lokale_mand/seller/model/sellerOrders.dart';
import 'package:lokale_mand/seller/repositories/ordersApi.dart';

enum SellerOrdersDetailState {
  initial,
  loading,
  loaded,
  error,
}

enum SellerOrdersState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

enum OrderUpdateStatusState {
  initial,
  loading,
  updating,
  loaded,
  error,
}

enum DeliveryBoysState {
  initial,
  loading,
  loaded,
  updating,
  loadingMore,
  error,
}

class SellerOrdersProvider extends ChangeNotifier {
  String message = '';
  SellerOrdersState ordersState = SellerOrdersState.initial;

  late SellerOrder sellerOrderData;
  List<SellerOrdersListItem> sellerOrdersList = [];
  List<SellerOrdersListProductItem> sellerOrdersProductsList = [];

  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;
  int selectedStatus = 0;

  getSellerOrders({
    required String statusIndex,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      ordersState = SellerOrdersState.loading;
      notifyListeners();
    } else {
      ordersState = SellerOrdersState.loadingMore;
      notifyListeners();
    }

    try {
      Map<String, String> params = {};
      params[ApiAndParams.status] = statusIndex;
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getSellerOrdersRepository(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        if (Constant.session.getBoolData(SessionManager.isSeller) == true) {
          sellerOrderData = SellerOrder.fromJson(getData);
          totalData = getData[ApiAndParams.total];
          List<SellerOrdersListItem> tempOrders =
              sellerOrderData.data?.orders ?? [];
          List<SellerOrdersListProductItem> tempProductsOrders =
              sellerOrderData.data?.ordersItems ?? [];

          sellerOrdersList.addAll(tempOrders);
          sellerOrdersProductsList.addAll(tempProductsOrders);

          hasMoreData = totalData > sellerOrdersList.length;
          if (hasMoreData) {
            offset += Constant.defaultDataLoadLimitAtOnce;
          }
        }
      }

      ordersState = SellerOrdersState.loaded;
      notifyListeners();
    } catch (e) {
      message = e.toString();
      ordersState = SellerOrdersState.error;
      GeneralMethods.showMessage(context, message, MessageType.warning);
      notifyListeners();
    }
  }

  Future orderListingDataUpdate(
      {required String index,
      String? activeStatus,
      String? deliveryBoyId,
      String? deliveryBoyName}) async {
    if (activeStatus != null) {
      sellerOrdersList[int.parse(index)].copyWith(activeStatus: activeStatus);
    } else if (deliveryBoyId != null && deliveryBoyName != null) {
      sellerOrdersList[int.parse(index)].copyWith(
          newDeliveryBoyId: deliveryBoyId, newDeliveryBoyName: deliveryBoyName);
    }
    notifyListeners();
  }

  Future<bool> changeOrderSelectedStatus(int index) async {
    if (selectedStatus.toString() != index.toString()) {
      selectedStatus = index;
      notifyListeners();
      offset = 0;
      sellerOrdersList = [];
      return true;
    } else {
      return false;
    }
  }

  OrderUpdateStatusState ordersStatusState = OrderUpdateStatusState.initial;
  late OrderStatuses orderStatuses;
  List<OrderStatusesData> orderStatusesList = [];
  String selectedOrderStatus = "0";

  Future getSellerOrdersStatuses({
    required BuildContext context,
  }) async {
    try {
      ordersStatusState = OrderUpdateStatusState.loading;
      notifyListeners();

      Map<String, dynamic> getStatusData =
          (await getSellerOrderStatusesRepository(context: context));

      if (getStatusData[ApiAndParams.status].toString() == "1") {
        orderStatuses = OrderStatuses.fromJson(getStatusData);
        orderStatusesList = orderStatuses.data ?? [];
        ordersStatusState = OrderUpdateStatusState.loaded;
        notifyListeners();
      } else {
        ordersStatusState = OrderUpdateStatusState.loaded;
        GeneralMethods.showMessage(
            context, getStatusData[ApiAndParams.message], MessageType.warning);
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      ordersStatusState = OrderUpdateStatusState.error;
      GeneralMethods.showMessage(context, message, MessageType.warning);
      notifyListeners();
    }
  }

  Future updateSellerOrdersStatus({
    required Map<String, String> params,
    required BuildContext context,
    SellerOrdersListItem? order,
  }) async {
    try {
      ordersStatusState = OrderUpdateStatusState.updating;
      notifyListeners();

      Map<String, dynamic> getUpdatedOrderData =
          await updateSellerOrderStatusRepository(
              params: params, context: context);

      if (getUpdatedOrderData[ApiAndParams.status].toString() == "1") {
        order?.copyWith(activeStatus: params[ApiAndParams.statusId]);
        ordersStatusState = OrderUpdateStatusState.loaded;
        notifyListeners();
      } else {
        ordersStatusState = OrderUpdateStatusState.error;
        GeneralMethods.showMessage(context,
            getUpdatedOrderData[ApiAndParams.message], MessageType.warning);
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      ordersStatusState = OrderUpdateStatusState.error;
      GeneralMethods.showMessage(context, message, MessageType.warning);
      notifyListeners();
    }
  }

  String getVariantImageFromOrderId(String orderId) {
    String imageLink = "";
    for (int i = 0; i < sellerOrdersProductsList.length; i++) {
      if (sellerOrdersProductsList[i].orderId.toString() ==
          orderId.toString()) {
        imageLink = "${Constant.hostUrl}storage/${sellerOrdersProductsList[i].image.toString()}";
      }
    }

    return imageLink;
  }

  String getVariantProductNameFromOrderId(String orderId) {
    String productName = "";
    for (int i = 0; i < sellerOrdersProductsList.length; i++) {
      if (sellerOrdersProductsList[i].orderId.toString() ==
          orderId.toString()) {
        productName = sellerOrdersProductsList[i].productName.toString();
      }
    }

    return productName;
  }

  setSelectedStatus(String index) {
    selectedOrderStatus = (int.parse(index) + 1).toString();
    notifyListeners();
  }
}
