import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerCityByLatLong.dart';
import 'package:lokale_mand/seller/repositories/SellerCityByLatLongApi.dart';

export 'package:geocoding/geocoding.dart';

enum SellerCityByLatLongState {
  initial,
  loading,
  loaded,
  error,
}

class SellerCityByLatLongProvider extends ChangeNotifier {
  SellerCityByLatLongState cityByLatLongState =
      SellerCityByLatLongState.initial;
  String message = '';
  late SellerCityByLatLong cityByLatLong;
  String address = "";
  late List<Placemark> addresses;
  bool isDeliverable = false;

  Future getSellerCityByLatLongApiProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    cityByLatLongState = SellerCityByLatLongState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> getCity =
          (await getSellerCityByLatLongApi(context: context, params: params));

      if (getCity[ApiAndParams.status].toString() == "1") {
        cityByLatLong = SellerCityByLatLong.fromJson(getCity);

        Constant.session.setData(
            SessionManager.keyLatitude, params[ApiAndParams.latitude], false);

        Constant.session.setData(
            SessionManager.keyLongitude, params[ApiAndParams.longitude], false);

        cityByLatLongState = SellerCityByLatLongState.loaded;
        notifyListeners();
        isDeliverable = true;
        return cityByLatLong;
      } else {
        cityByLatLongState = SellerCityByLatLongState.error;
        notifyListeners();
        isDeliverable = false;
        return null;
      }
    } catch (e) {
      message = e.toString();
      cityByLatLongState = SellerCityByLatLongState.error;
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
      isDeliverable = false;
      return null;
    }
  }
}
