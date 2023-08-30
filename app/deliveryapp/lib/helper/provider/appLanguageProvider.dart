
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
enum LanguageState {
  initial,
  loading,
  updating,
  loaded,
  error,
}

class LanguageProvider extends ChangeNotifier {
  LanguageState languageState = LanguageState.initial;
  LanguageJsonData? jsonData;
  Map<dynamic, dynamic> currentLanguage = {};
  String languageDirection = "";
  List<LanguageListData> languages = [];
  LanguageList? languageList;
  String selectedLanguage = "0";

  Future getLanguageDataProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    languageState = LanguageState.updating;
    notifyListeners();

    try {
      Map<String, dynamic> getData =
          (await getSystemLanguageApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        jsonData = LanguageJsonData.fromJson(getData);
        languageDirection = jsonData!.data!.type!;

        currentLanguage = jsonData!.data!.jsonData!;
        Constant.session.setData(
          SessionManager.keySelectedLanguageId,
          jsonData!.data!.id!.toString(),
          false,
        );

        languageState = LanguageState.loaded;
        notifyListeners();
        return true;
      } else {
        languageState = LanguageState.error;
        notifyListeners();
        return null;
      }
    } catch (e) {
      languageState = LanguageState.error;
      GeneralMethods.showSnackBarMsg(context, e.toString(),);
      notifyListeners();
      return null;
    }
  }

  getAvailableLanguageList({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    languageState = LanguageState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> getData =
          (await getAvailableLanguagesApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        languageList = LanguageList.fromJson(getData);
        languages = languageList!.data!;
      }

      languageState = LanguageState.loaded;
      notifyListeners();
    } catch (e) {
      languageState = LanguageState.error;
      notifyListeners();
    }
  }

  setSelectedLanguage(String index) {
    selectedLanguage = index;
    notifyListeners();
  }
}
