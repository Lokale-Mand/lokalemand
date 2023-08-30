
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';import 'package:geocoding/geocoding.dart';

enum CityByLatLongState {
  initial,
  loading,
  loaded,
  error,
}

class CityByLatLongProvider extends ChangeNotifier {
  CityByLatLongState cityByLatLongState = CityByLatLongState.initial;
  String message = '';
  Map<String, dynamic> cityByLatLong = {};
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
      cityByLatLong =
          (await getCityByLatLongApi(context: context, params: params));

      if (cityByLatLong[ApiAndParams.status].toString() == "0") {
        cityByLatLongState = CityByLatLongState.error;
        notifyListeners();
        isDeliverable = false;
      } else {
        Constant.session.setData(SessionManager.city_id,
            cityByLatLong["data"]["id"].toString(), false);
        Constant.session.setData(
            SessionManager.latitude, params[ApiAndParams.latitude], false);
        Constant.session.setData(
            SessionManager.longitude, params[ApiAndParams.longitude], false);

        cityByLatLongState = CityByLatLongState.loaded;
        notifyListeners();
        isDeliverable = true;
      }
    } catch (e) {
      message = e.toString();
      cityByLatLongState = CityByLatLongState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
      isDeliverable = false;
    }
  }

  changeState() {
    cityByLatLongState = CityByLatLongState.loading;
    notifyListeners();
  }
}
