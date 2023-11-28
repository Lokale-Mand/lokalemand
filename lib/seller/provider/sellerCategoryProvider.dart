import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerCategory.dart';
import 'package:lokale_mand/seller/repositories/sellerCategoryApi.dart';

enum SellerCategoryState {
  initial,
  loading,
  loaded,
  error,
}

class SellerCategoryListProvider extends ChangeNotifier {
  SellerCategoryState sellerCategoryState = SellerCategoryState.initial;
  String message = '';
  List<CategoryData> categories = [];
  List<String> selectedCategoryIdsList = [];
  bool startedApiCalling = false;
  List<String> selectedCategoriesNames = [];

  getCategoryApiProviderForRegistration({required BuildContext context}) async {
    try {
      var getCategoryData = await getMainCategoryListRepository(context);
      if (getCategoryData[ApiAndParams.status].toString() == "1") {
        CategoryList category = CategoryList.fromJson(getCategoryData);
        categories = category.data ?? [];
        sellerCategoryState = SellerCategoryState.loaded;
        notifyListeners();
      } else {
        sellerCategoryState = SellerCategoryState.error;
        Navigator.pop(context);
        GeneralMethods.showMessage(context,
            getCategoryData[ApiAndParams.message], MessageType.warning);
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      Navigator.pop(context);
      sellerCategoryState = SellerCategoryState.error;
      GeneralMethods.showMessage(context, message, MessageType.warning);
      notifyListeners();
    }
  }

  addOrRemoveCategoryFromSelection({required String id, required String name}) {
    if (selectedCategoryIdsList.contains(id)) {
      selectedCategoryIdsList.remove(id);
      selectedCategoriesNames.remove(name);
    } else {
      selectedCategoryIdsList.add(id);
      selectedCategoriesNames.add(name);
    }
    notifyListeners();
  }
}
