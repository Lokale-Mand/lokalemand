import 'package:lokale_mand/customer/models/customerChatList.dart';
import 'package:lokale_mand/customer/repositories/customerChatListApi.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

enum CustomerChatListState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

class CustomerChatListProvider extends ChangeNotifier {
  CustomerChatListState customerChatListState = CustomerChatListState.initial;
  String message = '';
  List<CustomerChatListData> chats = [];
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

  getCustomerChatList({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      customerChatListState = CustomerChatListState.loading;
    } else {
      customerChatListState = CustomerChatListState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getCustomerChatListApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());

        if (totalData == 0) {
          customerChatListState = CustomerChatListState.empty;
          notifyListeners();
        } else {
          List<CustomerChatListData> tempCustomerChatList =
              (getData['data'] as List)
                  .map((e) => CustomerChatListData.fromJson(Map.from(e ?? {})))
                  .toList();

          chats.addAll(tempCustomerChatList);

          hasMoreData = totalData > chats.length;
          if (hasMoreData) {
            offset += Constant.defaultDataLoadLimitAtOnce;
          }

          customerChatListState = CustomerChatListState.loaded;
          notifyListeners();
        }
      }
    } catch (e) {
      message = e.toString();
      customerChatListState = CustomerChatListState.error;
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
    }
  }
}
