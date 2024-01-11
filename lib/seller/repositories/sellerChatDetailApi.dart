import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getSellerChatDetailApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiSellerAllMessage,
      params: params,
      isPost: false,
      context: context);
  return json.decode(response);
}

Future<Map<String, dynamic>> getSellerSendMessageToSellerApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiSendMessageToCustomer,
      params: params,
      isPost: true,
      context: context);
  return json.decode(response);
}
