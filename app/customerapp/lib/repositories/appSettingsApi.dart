import 'package:egrocer/helper/utils/generalImports.dart';

Future getAppSettings({required BuildContext context}) async {
  try {
    var response = await GeneralMethods.sendApiRequest(
        apiName: ApiAndParams.apiAppSettings,
        params: {},
        isPost: false,
        context: context);
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
