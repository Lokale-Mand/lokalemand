import 'package:lokale_mand/helper/utils/generalImports.dart';

Future addOrUpdateSellerProduct(
    {required Map<String, String> params,
    required List<String> fileParamsNames,
    required List<String?> fileParamsFilesPath,
    required BuildContext context,
    required bool isAdd}) async {
  try {
    var response = await GeneralMethods.sendApiMultiPartRequest(
        apiName: isAdd
            ? ApiAndParams.apiAddSellerProduct
            : ApiAndParams.apiUpdateSellerProduct,
        params: params,
        fileParamsFilesPath: fileParamsFilesPath,
        fileParamsNames: fileParamsNames,
        context: context);
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
