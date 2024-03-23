import 'package:lokale_mand/helper/utils/generalImports.dart';

Future getSellerRatingsList(
    {required BuildContext context,
    required Map<String, String> params}) async {
  try {
    var response = await GeneralMethods.sendApiRequest(
        apiName: ApiAndParams.apiSellerRatingsList,
        params: params,
        isPost: false,
        context: context);
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}

Future getSellerRatingsAddUpdate({
  required BuildContext context,
  required Map<String, String> params,
  required List<String> fileParamsNames,
  required List<String> fileParamsFilesPath,
  required bool isAdd,
}) async {
  try {
    var response = await GeneralMethods.sendApiMultiPartRequest(
        apiName: isAdd
            ? ApiAndParams.apiSellerRatingAdd
            : ApiAndParams.apiSellerRatingUpdate,
        params: params,
        fileParamsFilesPath: fileParamsFilesPath,
        fileParamsNames: fileParamsNames,
        context: context);
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
