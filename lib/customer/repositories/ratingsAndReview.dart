import 'package:lokale_mand/helper/utils/generalImports.dart';

Future getRatingsList(
    {required BuildContext context,
    required Map<String, String> params}) async {
  try {

    print(">>>>>>>> ${ApiAndParams.apiCustomerRatingsList}");
    var response = await GeneralMethods.sendApiRequest(
        apiName: ApiAndParams.apiCustomerRatingsList,
        params: params,
        isPost: false,
        context: context);
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}

Future getRatingsAddUpdate({
  required BuildContext context,
  required Map<String, String> params,
  required List<String> fileParamsNames,
  required List<String> fileParamsFilesPath,
  required bool isAdd,
}) async {
  try {
    var response = await GeneralMethods.sendApiMultiPartRequest(
        apiName:
            isAdd ? ApiAndParams.apiCustomerRatingAdd : ApiAndParams.apiCustomerRatingUpdate,
        params: params,
        fileParamsFilesPath: fileParamsFilesPath,
        fileParamsNames: fileParamsNames,
        context: context);
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
