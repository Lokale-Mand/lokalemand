import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerProductList.dart';
import 'package:lokale_mand/seller/model/sellerProductListItem.dart';

enum SellerProductState {
  initial,
  loaded,
  loading,
  loadingMore,
  empty,
  error,
}

class SellerProductListProvider extends ChangeNotifier {
  SellerProductState sellerProductState = SellerProductState.initial;
  String message = '';
  int? currentSortByOrderIndex = null;
  late SellerProductList productList;
  List<SellerProductListItem> products = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getSellerProductListProvider(
      {required Map<String, dynamic> params,
      required BuildContext context}) async {
    if (offset == 0) {
      sellerProductState = SellerProductState.loading;
    } else {
      sellerProductState = SellerProductState.loadingMore;
    }
    notifyListeners();

    params[ApiAndParams.limit] = Constant.defaultDataLoadLimitAtOnce.toString();
    params[ApiAndParams.offset] = offset.toString();

    try {
      if (offset == 0) {
        products = [];
      }

      Map<String, dynamic> response =
          await getProductListApi(context: context, params: params);

      if (response[ApiAndParams.status].toString() == "1") {
        productList = SellerProductList.fromJson(response);

        totalData = int.parse(productList.total);

        if (totalData > 0) {
          products.addAll(productList.data);

          hasMoreData = totalData > products.length;

          if (hasMoreData) {
            offset += Constant.defaultDataLoadLimitAtOnce;
          }
          sellerProductState = SellerProductState.loaded;
          notifyListeners();
        } else {
          sellerProductState = SellerProductState.empty;
          notifyListeners();
        }
      } else {
        message = Constant.somethingWentWrong;
        sellerProductState = SellerProductState.empty;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      sellerProductState = SellerProductState.error;
      notifyListeners();
    }
  }
}
