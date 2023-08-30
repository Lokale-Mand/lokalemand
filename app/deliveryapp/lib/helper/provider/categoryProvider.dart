
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
enum CategoryState {
  initial,
  loading,
  loaded,
  error,
}

class CategoryListProvider extends ChangeNotifier {
  CategoryState categoryState = CategoryState.initial;
  String message = '';
  List<CategoryData> categories = [];
  Map<String, List<CategoryData>> subCategoriesList = {};
  List<String> selectedCategoryIdsList = ["0"];
  List<String> selectedCategoryNamesList = ["All"];
  String currentSelectedCategoryId = "0";
  bool startedApiCalling = false;
  List<String> selectedCategories = [];

  getCategoryApiProvider({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    categoryState = CategoryState.loading;
    notifyListeners();
    try {
      var getCategoryData = await getCategoryListRepository(params: params);
      if (getCategoryData[ApiAndParams.status].toString() == "1") {
        Category category = Category.fromJson(getCategoryData);
        categories = category.data ?? [];

        categoryState = CategoryState.loaded;
        notifyListeners();
      } else {
        categoryState = CategoryState.error;
        GeneralMethods.showSnackBarMsg(
            context, getCategoryData[ApiAndParams.message]);
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      categoryState = CategoryState.error;
      notifyListeners();
    }
  }

  setCategoryList(List<CategoryData> categoriesList) {
    categories = categoriesList;
    notifyListeners();
  }

  setCategoryData(int index) {
    currentSelectedCategoryId = selectedCategoryIdsList[index];
    setCategoryList(subCategoriesList["$index"] as List<CategoryData>);

    if (index == 0) {
      selectedCategoryIdsList.clear();
      selectedCategoryNamesList.clear();
      selectedCategoryIdsList = ["0"];
      selectedCategoryNamesList = ["All"];
      currentSelectedCategoryId = "0";
    } else {
      selectedCategoryIdsList.removeRange(
          index, selectedCategoryIdsList.length - 1);
      selectedCategoryNamesList.removeRange(
          index, selectedCategoryNamesList.length - 1);
    }

    notifyListeners();
  }

  getCategoryApiProviderForRegistration({required BuildContext context}) async {
    try {
      var getCategoryData = await getMainCategoryListRepository();
      if (getCategoryData[ApiAndParams.status].toString() == "1") {
        Category category = Category.fromJson(getCategoryData);
        categories = category.data ?? [];
        categoryState = CategoryState.loaded;
        notifyListeners();
      } else {
        categoryState = CategoryState.error;
        Navigator.pop(context);
        GeneralMethods.showSnackBarMsg(
            context, getCategoryData[ApiAndParams.message]);
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      Navigator.pop(context);
      categoryState = CategoryState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }

  addOrRemoveCategoryFromSelection(String id) {
    if (selectedCategories.contains(id)) {
      selectedCategories.remove(id);
    } else {
      selectedCategories.add(id);
    }
    notifyListeners();
  }
}
