import 'package:lokale_mand/helper/utils/generalImports.dart';

enum SellerRegisterState {
  initial,
  loading,
  loaded,
  empty,
  error,
}

class SellerRegisterProvider extends ChangeNotifier {
  SellerRegisterState sellerRegisterState = SellerRegisterState.initial;
  String message = '';

  registerSellerApiProvider({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    sellerRegisterState = SellerRegisterState.loading;
    notifyListeners();
    try {
      Map<String, dynamic> sellerRegisterResponse =
          await getBrandList(context: context, params: params);

      if (sellerRegisterResponse[ApiAndParams.status].toString() == "1") {

        sellerRegisterState = SellerRegisterState.loaded;
        notifyListeners();
      } else {
        message = sellerRegisterResponse[ApiAndParams.status];
        sellerRegisterState = SellerRegisterState.empty;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      sellerRegisterState = SellerRegisterState.error;
      notifyListeners();
      rethrow;
    }
  }
}
