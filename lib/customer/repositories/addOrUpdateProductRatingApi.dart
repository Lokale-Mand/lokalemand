import 'package:lokale_mand/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getAddOrUpdateProductRating(
    {required BuildContext context,
    required Map<String, dynamic> params,
    required bool isAdd}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: isAdd
          ? ApiAndParams.apiGetProductRatingAdd
          : ApiAndParams.apiGetProductRatingUpdate,
      params: params,
      isPost: true,
      context: context);
  return json.decode(response);
}
