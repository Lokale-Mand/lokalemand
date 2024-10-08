import 'package:lokale_mand/customer/models/order.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

enum ActiveOrdersState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class ActiveOrdersProvider extends ChangeNotifier {
  ActiveOrdersState activeOrdersState = ActiveOrdersState.initial;
  String message = '';
  List<Order> orders = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  void updateOrder(Order order) {
    final orderIndex = orders.indexWhere((element) {
      element.id == order.id;
      return element.id == order.id;
    });

    if (orderIndex != -1) {
      orders[orderIndex] = order;
    }
    notifyListeners();
  }

  getOrders({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      activeOrdersState = ActiveOrdersState.loading;
    } else {
      activeOrdersState = ActiveOrdersState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await fetchOrders(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());
        List<Order> tempOrders = (getData['data'] as List)
            .map((e) => Order.fromJson(Map.from(e ?? {})))
            .toList();

        orders.addAll(tempOrders);
      }

      hasMoreData = totalData > orders.length;
      if (hasMoreData) {
        offset += Constant.defaultDataLoadLimitAtOnce;
      }

      activeOrdersState = ActiveOrdersState.loaded;
      notifyListeners();
    } catch (e) {
      message = e.toString();
      activeOrdersState = ActiveOrdersState.error;
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
    }
  }

  String getVariantImageFromOrderId(String orderId) {
    String imageLink = "";
    for (int i = 0; i < orders.length; i++) {
      if (orders[i].id.toString() == orderId.toString()) {
        imageLink =
            "${Constant.hostUrl}storage/${orders[i].items[0].imageUrl.toString()}";
      }
    }

    return imageLink;
  }

  String getVariantProductNameFromOrderId(String orderId) {
    String productName = "";
    for (int i = 0; i < orders.length; i++) {
      if (orders[i].id.toString() == orderId.toString()) {
        productName = orders[i].items[0].productName.toString();
      }
    }

    return productName;
  }
}
