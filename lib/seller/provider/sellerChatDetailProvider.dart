import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerChatDetail.dart';
import 'package:lokale_mand/seller/repositories/sellerChatDetailApi.dart';

enum SellerChatDetailState {
  initial,
  loading,
  loaded,
  loadingMore,
  messageSending,
  empty,
  error,
}

enum SellerSendMessageState {
  initial,
  messageSending,
  loaded,
  error,
}

class SellerChatDetailProvider extends ChangeNotifier {
  SellerChatDetailState sellerChatDetailState = SellerChatDetailState.initial;
  SellerSendMessageState sellerSendMessageState =
      SellerSendMessageState.initial;
  String message = '';
  List<SellerChatDetailData> chatDetails = [];
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

  getSellerChatDetail({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      sellerChatDetailState = SellerChatDetailState.loading;
    } else {
      sellerChatDetailState = SellerChatDetailState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          (Constant.defaultDataLoadLimitAtOnce.toString().toInt + 30)
              .toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getSellerChatDetailApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());

        if (totalData == 0) {
          sellerChatDetailState = SellerChatDetailState.empty;
          notifyListeners();
        } else {
          List<SellerChatDetailData> tempSellerChatDetail =
              (getData['data'] as List)
                  .map((e) => SellerChatDetailData.fromJson(Map.from(e ?? {})))
                  .toList();

          chatDetails.addAll(tempSellerChatDetail);

          hasMoreData = totalData > chatDetails.length;
          if (hasMoreData) {
            offset +=
                (Constant.defaultDataLoadLimitAtOnce.toString().toInt + 30);
          }

          sellerChatDetailState = SellerChatDetailState.loaded;
          notifyListeners();
        }
      }
    } catch (e) {
      message = e.toString();
      sellerChatDetailState = SellerChatDetailState.error;
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
    sellerSendMessageState = SellerSendMessageState.messageSending;
    notifyListeners();

    try {
      Map<String, dynamic> getData = await getSellerSendMessageToSellerApi(
        context: context,
        params: params,
      );

      if (getData[ApiAndParams.status].toString() == "1") {
        SellerChatDetailData sellerChatDetailData =
            SellerChatDetailData.fromJson(getData[ApiAndParams.data]);
        chatDetails = [sellerChatDetailData, ...chatDetails];
        sellerSendMessageState = SellerSendMessageState.loaded;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      sellerSendMessageState = SellerSendMessageState.error;
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
    }
  }
}
