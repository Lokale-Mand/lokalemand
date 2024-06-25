import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerChatList.dart';
import 'package:lokale_mand/seller/repositories/sellerChatListApi.dart';

enum SellerChatListState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

class SellerChatListProvider extends ChangeNotifier {
  SellerChatListState sellerChatListState = SellerChatListState.initial;
  String message = '';
  List<SellerChatListData> chats = [];
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

  getSellerChatList({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      sellerChatListState = SellerChatListState.loading;
    } else {
      sellerChatListState = SellerChatListState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getSellerChatListApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());

        if (totalData == 0) {
          sellerChatListState = SellerChatListState.empty;
          notifyListeners();
        } else {
          List<SellerChatListData> tempSellerChatList =
              (getData['data'] as List)
                  .map((e) => SellerChatListData.fromJson(Map.from(e ?? {})))
                  .toList();

          chats.addAll(tempSellerChatList);

          hasMoreData = totalData > chats.length;
          if (hasMoreData) {
            offset += Constant.defaultDataLoadLimitAtOnce;
          }

          sellerChatListState = SellerChatListState.loaded;
          notifyListeners();
        }
      }
    } catch (e) {
      message = e.toString();
      sellerChatListState = SellerChatListState.error;
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
    }
  }
}
