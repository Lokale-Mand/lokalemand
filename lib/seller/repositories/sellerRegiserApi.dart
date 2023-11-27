import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> registerSellerApi(
    {required BuildContext context,
      required Map<String, dynamic> params}) async {
  try {
    var response = await GeneralMethods.sendApiRequest(
        apiName: ApiAndParams.apiRegisterSeller,
        params: params,
        isPost: true,
        context: context);
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
