import '../../helper/utils/generalImports.dart';

Future addOrRemoveSellerFavoriteApi(
    {required BuildContext context,
    required Map<String, dynamic> params,
    required isAdd}) async {
  try {
    var response = await GeneralMethods.sendApiRequest(
        apiName: isAdd
            ? ApiAndParams.apiAddSellerToFavorite
            : ApiAndParams.apiRemoveSellerFromFavorite,
        params: params,
        isPost: true,
        context: context);

    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}

Future getSellerWishListApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  try {
    var response = await GeneralMethods.sendApiRequest(
        apiName: ApiAndParams.apiSellerFavorite,
        params: params,
        isPost: false,
        context: context);

    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
