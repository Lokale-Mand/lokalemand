import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getCustomerChatListApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiGetChatList,
      params: params,
      isPost: false,
      context: context);
  return json.decode(response);
}
