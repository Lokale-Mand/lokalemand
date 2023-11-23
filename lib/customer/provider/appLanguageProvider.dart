import 'package:lokale_mand/customer/models/languageJsonData.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

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
  String message = "";
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
        languageDirection = jsonData?.data?.type ?? "ltr";

        currentLanguage = jsonData?.data?.jsonData ?? {};
        Constant.session.setData(
          SessionManager.keySelectedLanguageId,
          jsonData?.data?.id?.toString() ?? "",
          false,
        );

        languageState = LanguageState.loaded;
        notifyListeners();
        return true;
      } else {
        message = Constant.somethingWentWrong;
        languageState = LanguageState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      languageState = LanguageState.error;
      notifyListeners();
    }
  }

  Future getAvailableLanguageList({
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
        languages = languageList?.data ?? [];
        languageState = LanguageState.loaded;
        notifyListeners();
      } else {
        message = Constant.somethingWentWrong;
        languageState = LanguageState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      languageState = LanguageState.error;
      notifyListeners();
    }
  }

  setSelectedLanguage(String index) {
    selectedLanguage = index;
    notifyListeners();
  }
}
