import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getSellerListApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiSellers,
      params: params,
      isPost: false,
      context: context);
  return json.decode(response);
}
