import 'package:lokale_mand/helper/utils/generalImports.dart';

Future registerSeller(
    {required Map<String, String> params,
    required List<String> fileParamsNames,
    required List<String> fileParamsFilesPath,
    required BuildContext context}) async {
  try {
    var response = await GeneralMethods.sendApiMultiPartRequest(
        apiName: ApiAndParams.apiSellerRegister,
        params: params,
        fileParamsFilesPath: fileParamsFilesPath,
        fileParamsNames: fileParamsNames,
        context: context);
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
