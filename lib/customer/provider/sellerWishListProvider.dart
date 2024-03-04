import 'package:lokale_mand/customer/models/sellerWishList.dart';
import 'package:lokale_mand/customer/repositories/sellerWishlistApi.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:vibration/vibration.dart';

enum SellerAddRemoveFavoriteState {
  initial,
  loading,
  loaded,
  error,
}

class SellerAddOrRemoveFavoriteProvider extends ChangeNotifier {
  SellerAddRemoveFavoriteState sellerAddRemoveFavoriteState =
      SellerAddRemoveFavoriteState.initial;
  String message = '';

  List<int> favoriteList = Constant.favorits;

  Future<bool> getSellerAddOrRemoveFavorite({
    required BuildContext context,
    required Map<String, dynamic> params,
    required isAdd,
  }) async {
    try {
      bool returnState = false;
      sellerAddRemoveFavoriteState = SellerAddRemoveFavoriteState.loading;
      notifyListeners();

      Map<String, dynamic> map = await addOrRemoveSellerFavoriteApi(
          context: context, params: params, isAdd: isAdd);

      if (map[ApiAndParams.status].toString() == "1") {
        sellerAddRemoveFavoriteState = SellerAddRemoveFavoriteState.loaded;
        notifyListeners();
        returnState = true;

        if ((await Vibration.hasVibrator() ?? false)) {
          Vibration.vibrate(duration: 100);
        }
      } else {
        message = Constant.somethingWentWrong;
        sellerAddRemoveFavoriteState = SellerAddRemoveFavoriteState.error;
        notifyListeners();
        returnState = false;
      }
      return returnState;
    } catch (e) {
      rethrow;
    }
  }
}

enum SellerWishListState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class SellerWishListProvider extends ChangeNotifier {
  SellerWishListState sellerWishListState = SellerWishListState.initial;
  String message = '';
  List<SellerWishListData> wishlistSellers = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getSellerWishListProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      sellerWishListState = SellerWishListState.loading;
    } else {
      sellerWishListState = SellerWishListState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getSellerWishListApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());
        List<SellerWishListData> tempSellerWishLists = (getData['data'] as List)
            .map((e) => SellerWishListData.fromJson(Map.from(e)))
            .toList();

        wishlistSellers.addAll(tempSellerWishLists);
        hasMoreData = totalData > wishlistSellers.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        if (wishlistSellers.isNotEmpty) {
          sellerWishListState = SellerWishListState.loaded;
          notifyListeners();
        } else {
          sellerWishListState = SellerWishListState.error;
          notifyListeners();
        }
      } else {
        sellerWishListState = SellerWishListState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      sellerWishListState = SellerWishListState.error;
      notifyListeners();
    }
  }
}
