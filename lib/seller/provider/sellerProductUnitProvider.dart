import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerProductUnit.dart';
import 'package:lokale_mand/seller/repositories/sellerProductUnitApi.dart';

enum SellerProductUnitState {
  initial,
  loading,
  loaded,
  error,
}

class SellerProductUnitListProvider extends ChangeNotifier {
  SellerProductUnitState sellerProductUnitState =
      SellerProductUnitState.initial;
  String message = '';
  List<ProductUnitData> productUnits = [];
  List<String> selectedProductUnitIdsList = [];
  List<String> selectedProductUnitNamesList = [];
  bool startedApiCalling = false;

  Future getProductUnitApiProvider({required BuildContext context}) async {
    try {
      sellerProductUnitState = SellerProductUnitState.loading;
      notifyListeners();

      var getProductUnitData = await getProductUnitRepository(context);

      if (getProductUnitData[ApiAndParams.status].toString() == "1") {
        ProductUnit productUnit = ProductUnit.fromJson(getProductUnitData);
        productUnits = productUnit.data ?? [];
        sellerProductUnitState = SellerProductUnitState.loaded;
        notifyListeners();
      } else {
        sellerProductUnitState = SellerProductUnitState.error;
        GeneralMethods.showMessage(context,
            getProductUnitData[ApiAndParams.message], MessageType.warning);
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      Navigator.pop(context);
      sellerProductUnitState = SellerProductUnitState.error;
      GeneralMethods.showMessage(context, message, MessageType.warning);
      notifyListeners();
    }
  }

  productUnitSingleSelection({required String id, required String name}) {
    selectedProductUnitIdsList.clear();
    selectedProductUnitNamesList.clear();
    if (selectedProductUnitIdsList.contains(id)) {
      selectedProductUnitIdsList.remove(id);
      selectedProductUnitNamesList.remove(name);
    } else {
      selectedProductUnitIdsList.add(id);
      selectedProductUnitNamesList.add(name);
    }
    notifyListeners();
  }
}
