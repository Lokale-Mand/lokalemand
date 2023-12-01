import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/repositories/sellerAddProductApi.dart';

enum SellerAddUpdateProductState {
  initial,
  loading,
  loaded,
  error,
}

class SellerAddUpdateProductProvider extends ChangeNotifier {
  SellerAddUpdateProductState sellerCategoryState =
      SellerAddUpdateProductState.initial;
  String message = '';

  addOrUpdateProducts(
      {required Map<String, String> params,
      required List<String> fileParamsNames,
      required List<String?> fileParamsFilesPath,
      required BuildContext context,
      required bool isAdd}) async {
    try {
      var getResult = await addOrUpdateSellerProduct(
          context: context,
          isAdd: isAdd,
          params: params,
          fileParamsNames: fileParamsNames,
          fileParamsFilesPath: fileParamsFilesPath);


      if (getResult[ApiAndParams.status].toString() == "1") {
        sellerCategoryState = SellerAddUpdateProductState.loaded;
        notifyListeners();
      } else {
        sellerCategoryState = SellerAddUpdateProductState.error;
        notifyListeners();
      }
      GeneralMethods.showMessage(
          context, getResult[ApiAndParams.message], MessageType.warning);
    } catch (e) {
      message = e.toString();

      print(">>>>>>>>>>>>>>>> ${message}");

      sellerCategoryState = SellerAddUpdateProductState.error;
      GeneralMethods.showMessage(context, message, MessageType.warning);
      notifyListeners();
    }
  }

}
