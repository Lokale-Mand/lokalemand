
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class SettingsProvider extends ChangeNotifier {
  Future getSettingsApiProvider(
      Map<String, String> params, BuildContext context) async {
    try {
      Map<String, dynamic> settingsApiResponse =
          await getAppSettingsRepository(params: params);

      if (settingsApiResponse[ApiAndParams.status].toString() == "1") {
        if(Constant.session.isUserLoggedIn() && Constant.session.isSeller()) {
          AppSettingsSeller appSettings = AppSettingsSeller.fromJson(settingsApiResponse);
          Constant.currency = appSettings.data.currency ?? "";
          Constant.currencyCode = appSettings.data.currencyCode ?? "";
          Constant.currencyCode = appSettings.data.currencyCode ?? "";
          Constant.privacyPolicy = appSettings.data.privacyPolicySeller ?? "";
          Constant.termsConditions = appSettings.data.termsConditionsSeller ?? "";
          Constant.currencyDecimalPoint = appSettings.data.decimalPoint ?? "";
          Constant.appMode = appSettings.data.appModeSeller ?? "";
          Constant.googleApiKey = appSettings.data.googlePlaceApiKey ?? "";
          Constant.allPermissions = appSettings.data.allPermissions ?? [];
          return true;
        }else{
          AppSettingsDeliveryBoy appSettings = AppSettingsDeliveryBoy.fromJson(settingsApiResponse);
          Constant.currency = appSettings.data?.currency ?? "";
          Constant.currencyCode = appSettings.data?.currencyCode ?? "";
          Constant.currencyCode = appSettings.data?.currencyCode ?? "";
          Constant.privacyPolicy = appSettings.data?.privacyPolicyDeliveryBoy ?? "";
          Constant.termsConditions = appSettings.data?.termsConditionsDeliveryBoy ?? "";
          Constant.currencyDecimalPoint = appSettings.data?.decimalPoint ?? "";
          Constant.appMode = appSettings.data?.appModeSeller ?? "";
          Constant.googleApiKey = appSettings.data?.googlePlaceApiKey ?? "";
          Constant.allPermissions = appSettings.data?.allPermissions ?? [];
          return true;
        }
      } else {
        GeneralMethods.showSnackBarMsg(
            context, settingsApiResponse[ApiAndParams.message]);
        return false;
      }
    } catch (e) {
      GeneralMethods.showSnackBarMsg(
        context,
        e.toString(),
      );
      return false;
    }
  }
}
