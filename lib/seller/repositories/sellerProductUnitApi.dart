import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getProductUnitRepository(
    BuildContext context) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiSellerProductUnit,
      params: {},
      isPost: false,
      context: context);

  return json.decode(response);
}
