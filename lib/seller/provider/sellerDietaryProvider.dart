import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerDietary.dart';
import 'package:lokale_mand/seller/repositories/sellerDietaryApi.dart';

enum SellerDietaryState {
  initial,
  loading,
  loaded,
  error,
}

class SellerDietaryListProvider extends ChangeNotifier {
  SellerDietaryState sellerDietaryState = SellerDietaryState.initial;
  String message = '';
  List<DietaryData> dietaries = [];
  List<String> selectedDietaryIdsList = [];
  bool startedApiCalling = false;

  Future getDietaryApiProvider({required BuildContext context}) async {
    try {
      sellerDietaryState = SellerDietaryState.loading;
      notifyListeners();
      var getDietaryData = await getDietaryRepository(context);

      if (getDietaryData[ApiAndParams.status].toString() == "1") {
        Dietary dietary = Dietary.fromJson(getDietaryData);
        dietaries = dietary.data ?? [];
        sellerDietaryState = SellerDietaryState.loaded;
        notifyListeners();
      } else {
        sellerDietaryState = SellerDietaryState.error;
        GeneralMethods.showMessage(
            context, getDietaryData[ApiAndParams.message], MessageType.warning);
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      Navigator.pop(context);
      sellerDietaryState = SellerDietaryState.error;
      GeneralMethods.showMessage(context, message, MessageType.warning);
      notifyListeners();
    }
  }

  dietarySingleSelection({required String id}) {

    selectedDietaryIdsList.clear();
    if (selectedDietaryIdsList.contains(id)) {
      selectedDietaryIdsList.remove(id);
    } else {
      selectedDietaryIdsList.add(id);
    }
    notifyListeners();
  }
}
