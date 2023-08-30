import 'package:egrocer/helper/utils/generalImports.dart';

Future getSystemLanguageApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  try {
    var response = await GeneralMethods.sendApiRequest(
        apiName: ApiAndParams.apiSystemLanguages,
        params: params,
        isPost: false,
        context: context);

    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}

Future getAvailableLanguagesApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  try {
    var response = await GeneralMethods.sendApiRequest(
        apiName: ApiAndParams.apiSystemLanguages,
        params: params,
        isPost: false,
        context: context);
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
