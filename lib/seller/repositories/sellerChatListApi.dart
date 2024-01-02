import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getSellerChatListApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {

  print(">>>> $params, ${ApiAndParams.getSellerChatListApi}");

  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.getSellerChatListApi,
      params: params,
      isPost: false,
      context: context);
  return json.decode(response);
}
