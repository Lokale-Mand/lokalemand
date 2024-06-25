import 'package:lokale_mand/customer/models/chatDetail.dart';
import 'package:lokale_mand/customer/repositories/customerChatDetailApi.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

enum CustomerChatDetailState {
  initial,
  loading,
  loaded,
  loadingMore,
  messageSending,
  empty,
  error,
}

enum CustomerSendMessageState {
  initial,
  messageSending,
  loaded,
  error,
}

class CustomerChatDetailProvider extends ChangeNotifier {
  CustomerChatDetailState customerChatDetailState =
      CustomerChatDetailState.initial;
  CustomerSendMessageState customerSendMessageState =
      CustomerSendMessageState.initial;
  String message = '';
  List<CustomerChatDetailData> chatDetails = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  // void updateOrder(Order order) {
  //   final orderIndex = orders.indexWhere((element) {
  //     element.id == order.id;
  //     return element.id == order.id;
  //   });
  //
  //   if (orderIndex != -1) {
  //     orders[orderIndex] = order;
  //   }
  //   notifyListeners();
  // }

  getCustomerChatDetail({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      customerChatDetailState = CustomerChatDetailState.loading;
    } else {
      customerChatDetailState = CustomerChatDetailState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          (Constant.defaultDataLoadLimitAtOnce.toString().toInt + 30)
              .toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getCustomerChatDetailApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());

        if (totalData == 0) {
          customerChatDetailState = CustomerChatDetailState.empty;
          notifyListeners();
        } else {
          List<CustomerChatDetailData> tempCustomerChatDetail = (getData['data']
                  as List)
              .map((e) => CustomerChatDetailData.fromJson(Map.from(e ?? {})))
              .toList();

          chatDetails.addAll(tempCustomerChatDetail);

          hasMoreData = totalData > chatDetails.length;
          if (hasMoreData) {
            offset +=
                (Constant.defaultDataLoadLimitAtOnce.toString().toInt + 30);
          }

          customerChatDetailState = CustomerChatDetailState.loaded;
          notifyListeners();
        }
      }
    } catch (e) {
      message = e.toString();
      customerChatDetailState = CustomerChatDetailState.error;
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
    }
  }

  Future sendMessageToSeller({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    customerSendMessageState = CustomerSendMessageState.messageSending;
    notifyListeners();

    try {
      Map<String, dynamic> getData = await getCustomerSendMessageToSellerApi(
        context: context,
        params: params,
      );

      if (getData[ApiAndParams.status].toString() == "1") {
        CustomerChatDetailData customerChatDetailData =
            CustomerChatDetailData.fromJson(getData[ApiAndParams.data]);
        chatDetails = [customerChatDetailData, ...chatDetails];
        customerSendMessageState = CustomerSendMessageState.loaded;
        customerChatDetailState = CustomerChatDetailState.loaded;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      customerSendMessageState = CustomerSendMessageState.error;
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
    }
  }
}
