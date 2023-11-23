import 'package:lokale_mand/helper/utils/generalImports.dart';

enum CategoryState {
  initial,
  loading,
  loaded,
  empty,
  error,
}

class CategoryListProvider extends ChangeNotifier {
  CategoryState categoryState = CategoryState.initial;
  String message = '';
  List<CategoryItem> categories = [];

  getCategoryApiProvider({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    categoryState = CategoryState.loading;
    notifyListeners();
    try {
      Map<String, dynamic> categoryData =
          await getCategoryList(context: context, params: params);

      if (categoryData[ApiAndParams.status].toString() == "1") {
        categories = List.from(categoryData[ApiAndParams.data])
            .map((e) => CategoryItem.fromJson(e))
            .toList();

        categoryState = CategoryState.loaded;
        notifyListeners();
      } else {
        message = categoryData[ApiAndParams.status];
        categoryState = CategoryState.empty;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      categoryState = CategoryState.error;
      notifyListeners();
      rethrow;
    }
  }
}
