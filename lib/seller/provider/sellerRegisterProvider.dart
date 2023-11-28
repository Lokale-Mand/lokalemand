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

  registerSellerApiProvider(
      {required Map<String, String> params,
      required List<String> fileParamsNames,
      required List<String> fileParamsFilesPath,
      required BuildContext context}) async {
    sellerRegisterState = SellerRegisterState.loading;
    notifyListeners();
    try {
      Map<String, dynamic> sellerRegisterResponse = await registerSeller(
          context: context,
          params: params,
          fileParamsNames: fileParamsNames,
          fileParamsFilesPath: fileParamsFilesPath);

      if (sellerRegisterResponse[ApiAndParams.status].toString() == "1") {
        sellerRegisterState = SellerRegisterState.loaded;
        notifyListeners();
        return true;
      } else {
        message = sellerRegisterResponse[ApiAndParams.message];
        GeneralMethods.showMessage(context, message, MessageType.warning);
        sellerRegisterState = SellerRegisterState.empty;
        notifyListeners();
        return null;
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showMessage(context, message, MessageType.warning);
      sellerRegisterState = SellerRegisterState.error;
      notifyListeners();
      rethrow;
    }
  }
}
