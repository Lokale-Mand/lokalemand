import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getLoginApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  try {
    var response = await GeneralMethods.sendApiRequest(
        apiName: ApiAndParams.apiLogin,
        params: params,
        isPost: true,
        context: context);

    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
