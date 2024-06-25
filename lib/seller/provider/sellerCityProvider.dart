import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerCities.dart';
import 'package:lokale_mand/seller/model/sellerCities.dart';
import 'package:lokale_mand/seller/repositories/sellerCitesApi.dart';

enum SellerCitiesState {
  initial,
  loading,
  loaded,
  error,
}

class SellerCitiesListProvider extends ChangeNotifier {
  SellerCitiesState sellerCitiesState = SellerCitiesState.initial;
  String message = '';
  List<SellerCitiesData> cities = [];

  bool startedApiCalling = false;

  Future getCitiesApiProvider({required BuildContext context}) async {
    try {
      sellerCitiesState = SellerCitiesState.loading;
      notifyListeners();
      var getCitiesData = await getCityListRepository(context);

      if (getCitiesData[ApiAndParams.status].toString() == "1") {
        SellerCities sellerCities = SellerCities.fromJson(getCitiesData);
        cities = sellerCities.data ?? [];
        sellerCitiesState = SellerCitiesState.loaded;
        notifyListeners();
      } else {
        sellerCitiesState = SellerCitiesState.error;
        GeneralMethods.showMessage(
            context, getCitiesData[ApiAndParams.message], MessageType.warning);
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      Navigator.pop(context);
      sellerCitiesState = SellerCitiesState.error;
      GeneralMethods.showMessage(context, message, MessageType.warning);
      notifyListeners();
    }
  }
}
