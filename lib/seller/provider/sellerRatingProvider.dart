import 'package:lokale_mand/seller/model/customerRating.dart';
import 'package:lokale_mand/seller/repositories/sellerRatingsAndReview.dart';

import '../../helper/utils/generalImports.dart';

enum SellerRatingState {
  initial,
  loading,
  silentLoading,
  loaded,
  loadingMore,
  empty,
  error,
}

enum SellerRatingAddUpdateState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

class SellerRatingListProvider extends ChangeNotifier {
  SellerRatingState sellerRatingState = SellerRatingState.initial;
  SellerRatingAddUpdateState sellerRatingAddUpdateState =
      SellerRatingAddUpdateState.initial;
  String message = '';
  List<CustomerRatingData> customerRatingData = [];
  late CustomerRating customerRating;
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  List<String> images = [];
  int imagesOffset = 0;
  int totalImages = 0;
  bool hasMoreImages = false;

  Future getSellerRatingApiProvider({
    required Map<String, String> params,
    required BuildContext context,
    String? limit,
  }) async {
    if (offset == 0) {
      sellerRatingState = SellerRatingState.loading;
    } else {
      sellerRatingState = SellerRatingState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          limit ?? Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> ratingData =
          await getSellerRatingsList(context: context, params: params);

      if (ratingData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(ratingData[ApiAndParams.total].toString());
        CustomerRating customerRating = CustomerRating.fromJson(ratingData);

        List<CustomerRatingData> tempRatings = customerRating.data ?? [];

        customerRatingData.addAll(tempRatings);

        hasMoreData = totalData > customerRatingData.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        if (customerRatingData.isNotEmpty) {
          sellerRatingState = SellerRatingState.loaded;
          notifyListeners();
        } else {
          sellerRatingState = SellerRatingState.empty;
          notifyListeners();
        }
      } else {
        message = ratingData[ApiAndParams.message];
        sellerRatingState = SellerRatingState.empty;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      sellerRatingState = SellerRatingState.error;
      notifyListeners();
      rethrow;
    }
  }

  Future addOrUpdateSellerRating({
    required BuildContext context,
    required List<String> fileParamsFilesPath,
    required List<String> fileParamsNames,
    required Map<String, String> params,
    required bool isAdd,
  }) async {
    sellerRatingAddUpdateState = SellerRatingAddUpdateState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> ratingData = await getSellerRatingsAddUpdate(
          context: context,
          params: params,
          fileParamsFilesPath: fileParamsFilesPath,
          fileParamsNames: fileParamsNames,
          isAdd: isAdd);

      if (ratingData[ApiAndParams.status].toString() == "1") {
        sellerRatingAddUpdateState = SellerRatingAddUpdateState.loaded;
        notifyListeners();

        GeneralMethods.showMessage(
            context,
            getTranslatedValue(
                context,
                isAdd
                    ? "rating_added_successfully"
                    : "rating_updated_successfully"),
            MessageType.success);
      } else {
        message = ratingData[ApiAndParams.message];
        GeneralMethods.showMessage(context, message, MessageType.warning);
        sellerRatingAddUpdateState = SellerRatingAddUpdateState.empty;
        notifyListeners();
        return null;
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showMessage(context, message, MessageType.warning);
      sellerRatingAddUpdateState = SellerRatingAddUpdateState.error;
      notifyListeners();
      rethrow;
    }
  }
}
