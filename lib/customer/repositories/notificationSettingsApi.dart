import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getAppNotificationSettingsRepository(
    {required Map<String, dynamic> params,
    required BuildContext context}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: (Constant.session.getBoolData(SessionManager.isSeller) == true)
          ? ApiAndParams.apiSellerNotificationSettings
          : ApiAndParams.apiNotificationSettings,
      params: params,
      isPost: false,
      context: context);

  return json.decode(response);
}

Future<Map<String, dynamic>> updateAppNotificationSettingsRepository(
    {required Map<String, dynamic> params,
    required BuildContext context}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: (Constant.session.getBoolData(SessionManager.isSeller) == true)
          ? ApiAndParams.apiSellerNotificationSettingsUpdate
          : ApiAndParams.apiNotificationSettings,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}
