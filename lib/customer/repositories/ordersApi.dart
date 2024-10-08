import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> fetchOrders(
    {required Map<String, String> params,
    required BuildContext context}) async {
  try {
    final result = await GeneralMethods.sendApiRequest(
        apiName: ApiAndParams.apiOrdersHistory,
        params: params,
        isPost: false,
        context: context);

    return Map.from(jsonDecode(result));
  } catch (e) {
    //
    return {};
  }
}

Future<Map<String, dynamic>> updateOrderStatus(
    {required Map<String, String> params,
    required BuildContext context}) async {
  try {
    final response = await GeneralMethods.sendApiRequest(
        apiName: ApiAndParams.apiUpdateOrderStatus,
        params: params,
        isPost: true,
        context: context);

    if (response == null) {
      throw Exception("Something went wrong");
    }

    return Map.from(jsonDecode(response));
  } catch (e) {
    rethrow;
  }
}

Future deleteAwaitingOrderApi(
    {required Map<String, String> params,
    required BuildContext context}) async {
  try {
    final response = await GeneralMethods.sendApiRequest(
        apiName: ApiAndParams.apiDeleteOrder,
        params: params,
        isPost: true,
        context: context);

    if (response == null) {
      throw Exception("Something went wrong");
    }

    return jsonDecode(response);
  } catch (e) {
    rethrow;
  }
}
