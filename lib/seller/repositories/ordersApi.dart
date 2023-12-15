import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getSellerOrdersRepository(
    {required Map<String, String> params,
    required BuildContext context}) async {
  try {
    final result = await GeneralMethods.sendApiRequest(
        context: context,
        apiName: ApiAndParams.apiSellerOrdersHistory,
        params: params,
        isPost: false);

    return Map.from(
      jsonDecode(result),
    );
  } catch (e) {
    //
    return {};
  }
}

Future<Map<String, dynamic>> getSellerOrderStatusesRepository(
    {required BuildContext context}) async {
  try {
    final result = await GeneralMethods.sendApiRequest(
        context: context,
        apiName: ApiAndParams.apiOrderStatuses,
        params: {},
        isPost: false);

    return Map.from(
      jsonDecode(result),
    );
  } catch (e) {
    //
    return {};
  }
}

Future<Map<String, dynamic>> updateSellerOrderStatusRepository(
    {required Map<String, String> params,
    required BuildContext context}) async {
  try {
    final response = await GeneralMethods.sendApiRequest(
        context: context,
        apiName: ApiAndParams.apiUpdateOrderStatus,
        params: params,
        isPost: true);

    if (response == null) {
      throw Exception("Something went wrong");
    }

    return json.decode(response);
  } catch (e) {
    throw e;
  }
}
