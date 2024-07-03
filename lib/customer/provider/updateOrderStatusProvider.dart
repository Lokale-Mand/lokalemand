import 'package:lokale_mand/customer/models/order.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

enum UpdateOrderStatus { initial, inProgress, success, failure }

class UpdateOrderStatusProvider extends ChangeNotifier {
  UpdateOrderStatus _updateOrderStatus = UpdateOrderStatus.initial;
  String errorMessage = "";

  UpdateOrderStatus getUpdateOrderStatus() {
    return _updateOrderStatus;
  }

  Future updateStatus(
      {required Order order,
      String? orderItemId,
      required String status,
      required BuildContext context}) async {
    try {
      _updateOrderStatus = UpdateOrderStatus.inProgress;
      notifyListeners();

      late PackageInfo packageInfo;
      packageInfo = await PackageInfo.fromPlatform();

      Map<String, String> params = {
        "order_id": order.id,
        "order_item_id": orderItemId ?? "",
        "status": status,
        "device_type": Platform.isAndroid
            ? "android"
            : Platform.isIOS
                ? "ios"
                : "other",
        "app_version": packageInfo.version.toString()
      };

      if (orderItemId == null) {
        params.remove("order_item_id");
      }

      Map<String, dynamic> result = await updateOrderStatus(
        params: params,
        context: context,
      );

      if (result[ApiAndParams.status].toString() == "1") {
        Map<String, dynamic> data = result[ApiAndParams.data];
        order.copyWith(
            newFinalTotal: data[ApiAndParams.finalTotal].toString(),
            newTotal: data[ApiAndParams.total].toString());
        GeneralMethods.showMessage(
          context,
          getTranslatedValue(context, "oops_order_item_cancelled_successfully"),
          MessageType.success,
        );
        _updateOrderStatus = UpdateOrderStatus.success;
        notifyListeners();
        return true;
      } else {
        GeneralMethods.showMessage(
          context,
          getTranslatedValue(context, "oops_order_item_unable_to_cancel"),
          MessageType.warning,
        );
        _updateOrderStatus = UpdateOrderStatus.failure;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = e.toString();
      GeneralMethods.showMessage(
        context,
        errorMessage,
        MessageType.error,
      );
      _updateOrderStatus = UpdateOrderStatus.failure;
      notifyListeners();
      return false;
    }
  }
}
