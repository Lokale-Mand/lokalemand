import 'package:lokale_mand/helper/utils/generalImports.dart';

enum BrandState {
  initial,
  loading,
  loaded,
  empty,
  error,
}

class BrandListProvider extends ChangeNotifier {
  BrandState brandState = BrandState.initial;
  String message = '';
  List<Brand> brands = [];

  getBrandApiProvider({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    brandState = BrandState.loading;
    notifyListeners();
    try {
      Map<String, dynamic> brandData =
          await getBrandList(context: context, params: params);

      if (brandData[ApiAndParams.status].toString() == "1") {
        brands = List.from(brandData[ApiAndParams.data])
            .map((e) => Brand.fromJson(e))
            .toList();

        brandState = BrandState.loaded;
        notifyListeners();
      } else {
        message = brandData[ApiAndParams.status];
        brandState = BrandState.empty;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      brandState = BrandState.error;
      notifyListeners();
      rethrow;
    }
  }
}
