import 'package:lokale_mand/customer/repositories/addOrUpdateProductRatingApi.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

enum ProductRatingState {
  initial,
  loading,
  loaded,
  error,
}

class ProductRatingProvider extends ChangeNotifier {
  ProductRatingState productRatingState = ProductRatingState.initial;
  String message = '';

  Future addOrUpdateProductRating({
    required Map<String, String> params,
    required BuildContext context,
    required bool isAdd,
  }) async {
    productRatingState = ProductRatingState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> getData = await getAddOrUpdateProductRating(
        context: context,
        params: params,
        isAdd: isAdd,
      );

      if (getData[ApiAndParams.status].toString() == "1") {
        GeneralMethods.showMessage(
          context,
          getData[ApiAndParams.message].toString(),
          MessageType.success,
        );
        productRatingState = ProductRatingState.loaded;
        notifyListeners();
        return true;
      } else {
        GeneralMethods.showMessage(
          context,
          getData[ApiAndParams.message].toString(),
          MessageType.warning,
        );
        productRatingState = ProductRatingState.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      message = e.toString();
      productRatingState = ProductRatingState.error;
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
      return false;
    }
  }
}
