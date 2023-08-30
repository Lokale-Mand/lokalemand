


import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';import 'package:http/http.dart' as http;

class GeneralMethods {
  static String formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
  }

  static Future<bool> checkInternet() async {
    bool check = false;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      check = true;
    }
    return check;
  }

  static NetworkStatus getNetworkStatus(ConnectivityResult status) {
    return status == ConnectivityResult.mobile ||
            status == ConnectivityResult.wifi
        ? NetworkStatus.Online
        : NetworkStatus.Offline;
  }

  static showSnackBarMsg(BuildContext? context, String msg,
      {int snackBarSecond = 2, bool requiredAction = false}) {
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: requiredAction ? "OK" : "",
          onPressed: () {
            if (requiredAction && Constant.session.isUserLoggedIn()) {
              Constant.session.logoutUser(context);
            }
          },
        ),
        content: Text(
          msg,
          softWrap: true,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        backgroundColor: Theme.of(context).cardColor,
        duration: Duration(seconds: snackBarSecond),
      ),
    );
  }

  static List<Locale> langList() {
    return Constant.supportedLanguages
        .map(
          (languageCode) => GeneralMethods.getLocaleFromLangCode(languageCode),
        )
        .toList();
  }

  static Locale getLocaleFromLangCode(String languageCode) {
    List<String> result = languageCode.split("-");
    return result.length == 1
        ? Locale(result.first)
        : Locale(result.first, result.last);
  }

  static String setFirstLetterUppercase(String value) {
    if (value.isNotEmpty) value = value.replaceAll("_", ' ');
    return value.toTitleCase();
  }

  static Future sendApiRequest(
      {required String apiName,
      required Map<String, dynamic> params,
      required bool isPost}) async {
    try {
      String token = Constant.session.getData(SessionManager.keyAccessToken);
      String baseUrl =
          "${Constant.hostUrl}api/${Constant.session.isSeller() == true ? "seller" : "delivery_boy"}/";

      Map<String, String> headersData = {
        "accept": "application/json",
      };

      if (token.trim().isNotEmpty) {
        headersData["Authorization"] = "Bearer $token";
      }

      headersData["x-access-key"] = "903361";

      String mainUrl =
          apiName.contains("http") ? apiName : "${baseUrl}$apiName";

      http.Response response;
      if (isPost) {
        response = await http.post(Uri.parse(mainUrl),
            body: params.isNotEmpty ? params : null, headers: headersData);
      } else {
        mainUrl = await Constant.getGetMethodUrlWithParams(
            apiName.contains("http") ? apiName : "${baseUrl}$apiName", params);

        response = await http.get(Uri.parse(mainUrl), headers: headersData);
      }

      if (response.statusCode == 200) {
        if (response.body == "null") {
          return null;
        }
        return response.body;
      } else if (response.statusCode == 401) {
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future sendApiMultiPartRequest(
      {required String apiName,
      required Map<String, String> params,
      required List<String> fileParamsNames,
      required List<String> fileParamsFilesPath}) async {
    Map<String, String> headersData = {};

    String token = Constant.session.getData(SessionManager.keyAccessToken);
    String baseUrl =
        "${Constant.hostUrl}api/${Constant.session.isSeller() == true ? "seller" : "delivery_boy"}/";

    String mainUrl = apiName.contains("http") ? apiName : "${baseUrl}$apiName";

    headersData["Authorization"] = "Bearer $token";
    headersData["x-access-key"] = "903361";
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(mainUrl),
    );

    request.fields.addAll(params);

    if (fileParamsNames.length > 0) {
      for (int i = 0; i < fileParamsNames.length; i++) {
        if (!fileParamsFilesPath[i].toString().contains("http")) {
          request.files.add(
            await http.MultipartFile.fromPath(
              fileParamsNames[i].toString(),
              fileParamsFilesPath[i].toString(),
            ),
          );
        }
      }
    }
    request.headers.addAll(headersData);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      return null;
    }
  }

  static String? validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value))
      return 'Enter a valid email address';
    else
      return null;
  }

  static emailValidation(String val, String msg) {
    return validateEmail(
      val.trim(),
    );
  }

  static percentageValidation(String val, String msg) {
    double percentage = double.parse(val);
    if (percentage > 100 || percentage < 0)
      return 'Enter a valid commission';
    else
      return null;
  }

  static emptyValidation(String val, String msg) {
    if (val.trim().isEmpty) {
      return msg;
    }
    return null;
  }

  static optionalFieldValidation(String val, String msg) {
    return null;
  }

  static passwordValidation(String val, String msg) {
    if (val == "false") {
      return "";
    }
    return null;
  }

  static getUserLocation() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();

      getUserLocation();
    } else if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        await Geolocator.openLocationSettings();
        getUserLocation();
      } else {
        getUserLocation();
      }
    }
  }

  static Future<GeoAddress?> displayPrediction(
      Prediction? p, BuildContext context) async {
    if (p != null) {
      GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: Constant.googleApiKey);

      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(p.placeId!);

      String zipcode = "";
      GeoAddress address = GeoAddress();

      address.placeId = p.placeId;

      for (AddressComponent component in detail.result.addressComponents) {
        if (component.types.contains('locality')) {
          address.city = component.longName;
        }
        if (component.types.contains('administrative_area_level_2')) {
          address.district = component.longName;
        }
        if (component.types.contains('administrative_area_level_1')) {
          address.state = component.longName;
        }
        if (component.types.contains('country')) {
          address.country = component.longName;
        }
        if (component.types.contains('postal_code')) {
          zipcode = component.longName;
        }
      }

      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      //if zipcode not found
      if (zipcode.trim().isEmpty) {
        zipcode = await getZipCode(lat, lng, context);
      }
//
      address.address = detail.result.formattedAddress;
      address.lattitud = lat;
      address.longitude = lng;
      address.zipcode = zipcode;
      return address;
    }
    return null;
  }

  static getZipCode(double lat, double lng, BuildContext context) async {
    String zipcode = "";
    var result = await sendApiRequest(
      apiName: "${Constant.apiGeoCode}$lat,$lng",
      params: {},
      isPost: false,
    );
    if (result != null) {
      var getData = json.decode(result);
      if (getData != null) {
        Map data = getData['results'][0];
        List addressInfo = data['address_components'];
        for (var info in addressInfo) {
          List type = info['types'];
          if (type.contains('postal_code')) {
            zipcode = info['long_name'];
            break;
          }
        }
      }
    }
    return zipcode;
  }

  static getPlaceName(String placeId, BuildContext context) async {
    String placeName = "";
    var result = await sendApiRequest(
      apiName: "${Constant.apiGeoCodePlaceNameByPlaceId}$placeId",
      params: {},
      isPost: false,
    );
    if (result != null) {
      Map<String, dynamic> getData = json.decode(result);
      Map<String, dynamic> data = Map.from(getData['result']);
      placeName = data['name'];
    }
    return placeName;
  }

  static Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Not Available');
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<Map<String, String>> getStoreAddressFromMap(
      LatLng currentLocation, BuildContext context) async {
    try {
      Map<String, dynamic> response = json.decode(
        await GeneralMethods.sendApiRequest(
          apiName:
              "${Constant.apiGeoCode}${currentLocation.latitude},${currentLocation.longitude}",
          params: {},
          isPost: false,
        ),
      );

      final possibleLocations = response['results'] as List;
      Map location = {};
      String street = '';
      String city_id = Constant.session.getData(SessionManager.city_id);
      String state = '';
      String latitude = currentLocation.latitude.toString();
      String longitude = currentLocation.latitude.toString();
      String place_name = '';
      String formatted_address = '';

      if (possibleLocations.isNotEmpty) {
        for (var locationFullDetails in possibleLocations) {
          Map latLng = Map.from(locationFullDetails['geometry']['location']);
          double lat = double.parse(latLng['lat'].toString());
          double lng = double.parse(latLng['lng'].toString());
          place_name =
              await getPlaceName(locationFullDetails['place_id'], context);
          formatted_address = locationFullDetails['formatted_address'];
          if (lat == currentLocation.latitude &&
              lng == currentLocation.longitude) {
            location = Map.from(locationFullDetails);
            break;
          }
        }
        //If we could not find location with given lat and lng
        if (location.isNotEmpty) {
          final addressComponents = location['address_components'] as List;
          if (addressComponents.isNotEmpty) {
            for (var component in addressComponents) {
              if ((component['types'] as List).contains('sublocality') &&
                  street.isEmpty) {
                street = component['long_name'].toString();
              }
              if ((component['types'] as List)
                      .contains('administrative_area_level_1') &&
                  state.isEmpty) {
                state = component['long_name'].toString();
              }
            }
          }
        } else {
          location = Map.from(possibleLocations.first);
          final addressComponents = location['address_components'] as List;
          if (addressComponents.isNotEmpty) {
            for (var component in addressComponents) {
              if ((component['types'] as List).contains('sublocality') &&
                  street.isEmpty) {
                street = component['long_name'].toString();
              }
              if ((component['types'] as List)
                      .contains('administrative_area_level_1') &&
                  state.isEmpty) {
                state = component['long_name'].toString();
              }
            }
          }
        }

        return {
          ApiAndParams.street: street.toString().length > 0
              ? street.toString()
              : place_name.toString(),
          ApiAndParams.city_id: city_id.toString(),
          ApiAndParams.state: state.toString(),
          ApiAndParams.latitude: latitude.toString(),
          ApiAndParams.longitude: longitude.toString(),
          ApiAndParams.place_name: place_name.toString(),
          ApiAndParams.formatted_address: formatted_address.toString()
        };
      } else {
        return {"": ""};
      }
    } catch (e) {
      GeneralMethods.showSnackBarMsg(context, e.toString());
      return {"": ""};
    }
  }

  static Future<Map<String, dynamic>> getCityNameAndAddress(
      LatLng currentLocation, BuildContext context) async {
    try {
      Map<String, dynamic> response = json.decode(
        await GeneralMethods.sendApiRequest(
          apiName:
              "${Constant.apiGeoCode}${currentLocation.latitude},${currentLocation.longitude}",
          params: {},
          isPost: false,
        ),
      );

      final possibleLocations = response['results'] as List;
      Map location = {};
      String cityName = '';
      String stateName = '';
      String pinCode = '';
      String countryName = '';
      String landmark = '';
      String area = '';

      if (possibleLocations.isNotEmpty) {
        for (var locationFullDetails in possibleLocations) {
          Map latLng = Map.from(locationFullDetails['geometry']['location']);
          double lat = double.parse(latLng['lat'].toString());
          double lng = double.parse(latLng['lng'].toString());
          if (lat == currentLocation.latitude &&
              lng == currentLocation.longitude) {
            location = Map.from(locationFullDetails);
            break;
          }
        }
        //If we could not find location with given lat and lng
        if (location.isNotEmpty) {
          final addressComponents = location['address_components'] as List;
          if (addressComponents.isNotEmpty) {
            for (var component in addressComponents) {
              if ((component['types'] as List).contains('locality') &&
                  cityName.isEmpty) {
                cityName = component['long_name'].toString();
              }
              if ((component['types'] as List)
                      .contains('administrative_area_level_1') &&
                  stateName.isEmpty) {
                stateName = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('country') &&
                  countryName.isEmpty) {
                countryName = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('postal_code') &&
                  pinCode.isEmpty) {
                pinCode = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('sublocality') &&
                  landmark.isEmpty) {
                landmark = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('route') &&
                  area.isEmpty) {
                area = component['long_name'].toString();
              }
            }
          }
        } else {
          location = Map.from(possibleLocations.first);
          final addressComponents = location['address_components'] as List;
          if (addressComponents.isNotEmpty) {
            for (var component in addressComponents) {
              if ((component['types'] as List).contains('locality') &&
                  cityName.isEmpty) {
                cityName = component['long_name'].toString();
              }
              if ((component['types'] as List)
                      .contains('administrative_area_level_1') &&
                  stateName.isEmpty) {
                stateName = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('country') &&
                  countryName.isEmpty) {
                countryName = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('postal_code') &&
                  pinCode.isEmpty) {
                pinCode = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('sublocality') &&
                  landmark.isEmpty) {
                landmark = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('route') &&
                  area.isEmpty) {
                area = component['long_name'].toString();
              }
            }
          }
        }

        return {
          'address': possibleLocations.first['formatted_address'],
          'city': cityName,
          'state': stateName,
          'pin_code': pinCode,
          'country': countryName,
          'area': area,
          'landmark': landmark,
          'latitude': currentLocation.latitude,
          'longitude': currentLocation.longitude,
        };
      }
      return {};
    } catch (e) {
      GeneralMethods.showSnackBarMsg(context, e.toString());
      return {};
    }
  }

  static Future getFileFromDevice() async {
    String path = "";
    await FilePicker.platform
        .pickFiles(
            allowMultiple: false,
            allowCompression: true,
            type: FileType.image,
            lockParentWindow: true)
        .then((value) {
      path = value!.paths.first.toString();
    });
    return path;
  }

  static phoneValidation(String value, String msg) {
    String pattern = r'[0-9]';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty || !regExp.hasMatch(value)) {
      return msg;
    }
    return null;
  }

  static String getCurrencyFormat(double amount) {
    return NumberFormat.currency(
            symbol: Constant.currency,
            decimalDigits: int.parse(Constant.currencyDecimalPoint),
            name: Constant.currencyCode)
        .format(amount);
  }
}

String getTranslatedValue(BuildContext context, String key) {
  return context.read<LanguageProvider>().currentLanguage[key] ?? key;
}


extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map(
        (str) => str.toCapitalized(),
      )
      .join(' ');
}
