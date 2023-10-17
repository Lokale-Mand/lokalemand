import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getFaqApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiFaq,
      params: params,
      isPost: false,
      context: context);
  return json.decode(response);
}
