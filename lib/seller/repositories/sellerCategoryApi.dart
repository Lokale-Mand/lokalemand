import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getMainCategoryListRepository(
    BuildContext context) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiSellerMainCategories,
      params: {},
      isPost: false,
      context: context);

  return json.decode(response);
}
