import 'package:lokale_mand/customer/models/productRating.dart';
import 'package:lokale_mand/customer/repositories/productRatingListApi.dart';
import 'package:lokale_mand/customer/repositories/productRatingListApi.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

enum ProductRatingListState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

class ProductRatingListProvider extends ChangeNotifier {
  ProductRatingListState productRatingListState = ProductRatingListState.initial;
  String message = '';
  List<ProductRatingData> ratings = [];
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

  getProductRatingList({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      productRatingListState = ProductRatingListState.loading;
    } else {
      productRatingListState = ProductRatingListState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getProductRatingListApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());

        if (totalData == 0) {
          productRatingListState = ProductRatingListState.empty;
          notifyListeners();
        } else {
          List<ProductRatingData> tempProductRatingList =
              (getData['data'] as List)
                  .map((e) => ProductRatingData.fromJson(Map.from(e ?? {})))
                  .toList();

          ratings.addAll(tempProductRatingList);

          // hasMoreData = totalData > chats.length;
          // if (hasMoreData) {
          //   offset += Constant.defaultDataLoadLimitAtOnce;
          // }

          productRatingListState = ProductRatingListState.loaded;
          notifyListeners();
        }
      }
    } catch (e) {
      message = e.toString();
      productRatingListState = ProductRatingListState.error;
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
    }
  }
}
