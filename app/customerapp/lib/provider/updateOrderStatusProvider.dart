import 'package:egrocer/helper/utils/generalImports.dart';

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
        Map<String,dynamic> data = result[ApiAndParams.data];
        order.copyWith(newFinalTotal: data[ApiAndParams.finalTotal].toString(),newTotal: data[ApiAndParams.total].toString());
        Navigator.of(context).pop(true);
        GeneralMethods.showMessage(
          context,
          getTranslatedValue(context, "oops_order_item_cancelled_successfully"),
          MessageType.success,
        );
        return true;
      } else {
        GeneralMethods.showMessage(
          context,
          getTranslatedValue(context, "oops_order_item_unable_to_cancel"),
          MessageType.warning,
        );
        return false;
      }
    } catch (e) {
      _updateOrderStatus = UpdateOrderStatus.failure;
      errorMessage = e.toString();
      GeneralMethods.showMessage(
        context,
        errorMessage,
        MessageType.error,
      );
      notifyListeners();
      return false;
    }
  }
}
