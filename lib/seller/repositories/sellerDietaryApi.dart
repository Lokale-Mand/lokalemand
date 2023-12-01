import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getDietaryRepository(
    BuildContext context) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiProductDietaries,
      params: {},
      isPost: false,
      context: context);

  return json.decode(response);
}
