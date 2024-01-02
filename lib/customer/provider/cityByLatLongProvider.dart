import 'package:lokale_mand/customer/models/cityByLatLong.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

export 'package:geocoding/geocoding.dart';

enum CityByLatLongState {
  initial,
  loading,
  loaded,
  error,
}

class CityByLatLongProvider extends ChangeNotifier {
  CityByLatLongState cityByLatLongState = CityByLatLongState.initial;
  String message = '';
  late CityByLatLong cityByLatLong;
  String address = "";
  late List<Placemark> addresses;
  bool isDeliverable = false;

  getCityByLatLongApiProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    cityByLatLongState = CityByLatLongState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> getCityData =
          await getCityByLatLongApi(context: context, params: params);
      if (getCityData[ApiAndParams.status].toString() == "1") {
        cityByLatLong = CityByLatLong.fromJson(getCityData);
        Constant.session.setData(
            SessionManager.keyLatitude, params[ApiAndParams.latitude], false);

        Constant.session.setData(
            SessionManager.keyLongitude, params[ApiAndParams.longitude], false);

        cityByLatLongState = CityByLatLongState.loaded;
        notifyListeners();
        isDeliverable = true;
        return cityByLatLong;
      } else {
        cityByLatLongState = CityByLatLongState.error;
        notifyListeners();
        isDeliverable = false;
        return null;
      }
    } catch (e) {
      message = e.toString();
      cityByLatLongState = CityByLatLongState.error;
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
