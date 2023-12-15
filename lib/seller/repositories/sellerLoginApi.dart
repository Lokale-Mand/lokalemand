import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getSellerLoginRepository(
    {required Map<String, dynamic> params,
    required BuildContext context}) async {

  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiSellerLogin,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}
