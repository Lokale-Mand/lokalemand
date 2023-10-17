import 'package:lokale_mand/helper/utils/generalImports.dart';

enum SellerListState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class SellerListProvider extends ChangeNotifier {
  SellerListState itemsState = SellerListState.initial;
  String message = '';
  List<SellerListData> sellerListData = [];
  late SellerList sellerLists;
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getSellerListProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      itemsState = SellerListState.loading;
    } else {
      itemsState = SellerListState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getSellerListApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        sellerLists = SellerList.fromJson(getData);
        sellerListData = sellerLists.data ?? [];
        hasMoreData = totalData > sellerListData.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        itemsState = SellerListState.loaded;
        notifyListeners();
      } else {
        itemsState = SellerListState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      itemsState = SellerListState.error;
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
    }
  }
}
