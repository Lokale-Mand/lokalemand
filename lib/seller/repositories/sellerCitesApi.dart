import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getCityListRepository(BuildContext context) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.city, params: {}, isPost: false, context: context);

  return json.decode(response);
}
