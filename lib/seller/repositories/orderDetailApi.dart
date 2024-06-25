import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/helper/utils/generalMethods.dart';

Future<Map<String, dynamic>> getOrderDetailRepository(
    {required Map<String, dynamic> params,
    required BuildContext context}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiSellerOrderById,
      params: params,
      isPost: false,
      context: context);

  return json.decode(response);
}
