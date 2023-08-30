import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';


class SessionManager extends ChangeNotifier {
  static String preferenceName = "egrocerappPref";
  static String isUserLogin = "isuserlogin";
  static String isDarkTheme = "isDarkTheme";
  static String appThemeName = "appThemeName";
  static String keyAuthUid = "keyAuthUid";
  static String keyFCMToken = "keyFCMToken";
  static String keyAccessToken = "keyAccessToken";
  static String keyIsGrid = "isGrid";
  static String keyUserType = "keyUserType";
  static String keySellerProfile = "keySellerProfile";
  static String keyDeliveryBoyProfile = "keyDeliveryBoyProfile";
  static String keyRecentAddressSearch = "recentaddress";
  static String keySelectedLanguageId = "selectedLanguageId";

  //Seller profile data
  static String id = "id";
  static String admin_id = "admin_id";
  static String name = "name";
  static String store_name = "store_name";
  static String slug = "slug";
  static String email = "email";
  static String mobile = "mobile";
  static String balance = "balance";
  static String store_url = "store_url";
  static String logo = "logo";
  static String store_description = "store_description";
  static String street = "street";
  static String pincode_id = "pincode_id";
  static String city_id = "city_id";
  static String state = "state";
  static String categories = "categories";
  static String account_number = "account_number";
  static String bank_ifsc_code = "bank_ifsc_code";
  static String account_name = "account_name";
  static String bank_name = "bank_name";
  static String commission = "commission";
  static String status = "status";
  static String require_products_approval = "require_products_approval";
  static String fcm_id = "fcm_id";
  static String national_identity_card = "national_identity_card";
  static String address_proof = "address_proof";
  static String pan_number = "pan_number";
  static String tax_name = "tax_name";
  static String tax_number = "tax_number";
  static String customer_privacy = "customer_privacy";
  static String latitude = "latitude";
  static String longitude = "longitude";
  static String place_name = "place_name";
  static String formatted_address = "formatted_address";
  static String forgot_password_code = "forgot_password_code";
  static String view_order_otp = "view_order_otp";
  static String assign_delivery_boy = "assign_delivery_boy";
  static String created_at = "created_at";
  static String updated_at = "updated_at";
  static String deleted_at = "deleted_at";
  static String remark = "remark";
  static String logo_url = "logo_url";
  static String national_identity_card_url = "national_identity_card_url";
  static String address_proof_url = "address_proof_url";

  // Delivery boy profile data
  // static String id = "id";
  // static String admin_id = "admin_id";
  // static String city_id = "city_id";
  // static String name = "name";
  // static String mobile = "mobile";
  static String order_note = "order_note";
  static String address = "address";
  static String bonus = "bonus";

  // static String balance = "balance";
  static String driving_license = "driving_license";

  // static String national_identity_card = "national_identity_card";
  static String dob = "dob";
  static String bank_account_number = "bank_account_number";

  // static String bank_name = "bank_name";
  // static String account_name = "account_name";
  static String ifsc_code = "ifsc_code";
  static String other_payment_information = "other_payment_information";

  // static String status = "status";
  static String is_available = "is_available";

  // static String fcm_id = "fcm_id";
  // static String pincode_id = "pincode_id";
  static String cash_received = "cash_received";

  // static String created_at = "created_at";
  // static String updated_at = "updated_at";
  static String pending_order_count = "pending_order_count";
  static String password = "password";

  static String keyCurrency = "currency";

  late SharedPreferences prefs;

  SessionManager({required this.prefs});

  String getData(String id) {
    return prefs.getString(id) ?? "";
  }

  bool isSeller() {
    return getData(keyUserType) == "seller";
  }

  void setData(String id, String val, bool isRefresh) {
    prefs.setString(id, val);
    if (isRefresh) {
      notifyListeners();
    }
  }

  void setDoubleData(String key, double value) {
    prefs.setDouble(key, value);
    notifyListeners();
  }

  double getDoubleData(String key) {
    return prefs.getDouble(key) ?? 0.0;
  }

  bool getBoolData(String key) {
    return prefs.getBool(key) ?? false;
  }

  void setBoolData(String key, bool value, bool isRefresh) {
    prefs.setBool(key, value);
    if (isRefresh) notifyListeners();
  }

  int getIntData(String key) {
    return prefs.getInt(key) ?? 0;
  }

  void setIntData(String key, int value) {
    prefs.setInt(key, value);
    notifyListeners();
  }

  bool isUserLoggedIn() {
    return prefs.getBool(isUserLogin) ?? false;
  }

  Future setUserData(Map<String, dynamic> data) async {
    try {
      prefs.setBool(isUserLogin, true);
      for (int i = 0; i < data.entries.length; i++) {
        prefs.setString(
            data.entries.elementAt(i).key,
            data.entries.elementAt(i).value.toString() == "null"
                ? ""
                : data.entries.elementAt(i).value.toString());
        }
    } catch (e) {

    }
  }

  void logoutUser(BuildContext buildContext, {bool? confirmationRequired}) {
    if (confirmationRequired == false) {
      processToLogout(buildContext);
    } else {
      showDialog<String>(
        context: buildContext,
        builder: (BuildContext buildContext) => AlertDialog(
          title: Text(
            getTranslatedValue(buildContext, "logout_title"),
            softWrap: true,
          ),
          content: Text(
            getTranslatedValue(buildContext, "logout_message"),
            softWrap: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(buildContext),
              child: Text(
                getTranslatedValue(buildContext, "cancel"),
                softWrap: true,
              ),
            ),
            TextButton(
              onPressed: () {
                processToLogout(buildContext);
              },
              child: Text(
                getTranslatedValue(buildContext, "ok"),
                softWrap: true,
              ),
            ),
          ],
        ),
      );
    }
  }

  void processToLogout(BuildContext buildContext) {
    String themeName = getData(SessionManager.appThemeName);
    String languageId = getData(SessionManager.keySelectedLanguageId);
    String userType = getData(SessionManager.keyUserType);

    prefs.clear();
    setBoolData(isUserLogin, false, false);
    setData(SessionManager.appThemeName, themeName, false);
    setData(SessionManager.keyUserType, userType, false);
    setData(keySelectedLanguageId, languageId, false);


    setUserType(buildContext).then((value) {
      if (Constant.appLoginType == 1) {
        Navigator.of(buildContext).pushNamedAndRemoveUntil(
            loginScreen, (Route<dynamic> route) => route.isFirst);
      } else if (Constant.appLoginType == 2) {
        Navigator.of(buildContext).pushNamedAndRemoveUntil(
            loginScreen, (Route<dynamic> route) => route.isFirst);
      } else {
        Navigator.of(buildContext).pushNamedAndRemoveUntil(
            accountTypeScreen, (Route<dynamic> route) => route.isFirst);
      }
    });
  }

  Future setUserType(BuildContext buildContext) async {
    if (Constant.appLoginType == 1) {
      setData(SessionManager.keyUserType, "seller", false);
    } else if (Constant.appLoginType == 2) {
      setData(SessionManager.keyUserType, "delivery_boy", false);
    }
  }
}
