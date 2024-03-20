import 'package:lokale_mand/customer/models/sellerRating.dart';
import 'package:lokale_mand/customer/repositories/ratingsAndReview.dart';

import '../../helper/utils/generalImports.dart';

enum RatingState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

enum RatingImagesState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

enum RatingAddUpdateState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

class RatingListProvider extends ChangeNotifier {
  RatingState ratingState = RatingState.initial;
  RatingImagesState ratingImagesState = RatingImagesState.initial;
  RatingAddUpdateState ratingAddUpdateState = RatingAddUpdateState.initial;
  String message = '';
  List<SellerRatingData> sellerRatingData = [];
  late SellerRating sellerRating;
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  List<String> images = [];
  int imagesOffset = 0;
  int totalImages = 0;
  bool hasMoreImages = false;

  Future getRatingApiProvider({
    required Map<String, String> params,
    required BuildContext context,
    String? limit,
  }) async {
    if (offset == 0) {
      ratingState = RatingState.loading;
    } else {
      ratingState = RatingState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          limit ?? Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> ratingData =
          await getRatingsList(context: context, params: params);

      if (ratingData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(ratingData[ApiAndParams.total].toString());
        SellerRating sellerRating = SellerRating.fromJson(ratingData);

        List<SellerRatingData> tempRatings = sellerRating.data ?? [];

        sellerRatingData.addAll(tempRatings);

        hasMoreData = totalData > sellerRatingData.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        ratingState = RatingState.loaded;
        notifyListeners();
      } else {
        message = ratingData[ApiAndParams.message];
        ratingState = RatingState.empty;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      ratingState = RatingState.error;
      notifyListeners();
      rethrow;
    }
  }

  Future addOrUpdateRating({
    required BuildContext context,
    required List<String> fileParamsFilesPath,
    required List<String> fileParamsNames,
    required Map<String, String> params,
    required bool isAdd,
  }) async {
    ratingAddUpdateState = RatingAddUpdateState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> ratingData = await getRatingsAddUpdate(
          context: context,
          params: params,
          fileParamsFilesPath: fileParamsFilesPath,
          fileParamsNames: fileParamsNames,
          isAdd: isAdd);

      if (ratingData[ApiAndParams.status].toString() == "1") {
        ratingAddUpdateState = RatingAddUpdateState.loaded;
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
        ratingAddUpdateState = RatingAddUpdateState.empty;
        notifyListeners();
        return null;
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showMessage(context, message, MessageType.warning);
      ratingAddUpdateState = RatingAddUpdateState.error;
      notifyListeners();
      rethrow;
    }
  }
}
