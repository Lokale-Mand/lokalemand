import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getCustomerChatDetailApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiGetAllMessage,
      params: params,
      isPost: false,
      context: context);
  return json.decode(response);
}
