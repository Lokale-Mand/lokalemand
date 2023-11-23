import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getDeleteAccountApi(
    {required BuildContext context}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiDeleteAccount,
      params: {
        ApiAndParams.authUid:
            Constant.session.getData(SessionManager.keyAuthUid)
      },
      isPost: true,
      context: context);

  return json.decode(response);
}
