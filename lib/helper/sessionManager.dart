import 'package:lokale_mand/helper/utils/generalImports.dart';

class SessionManager extends ChangeNotifier {
  static String isUserLogin = "isUserLogin";
  static String isSeller = "isSeller";
  static String introSlider = "introSlider";
  static String isDarkTheme = "isDarkTheme";
  static String appThemeName = "appThemeName";
  static String keySelectedLanguageId = "selectedLanguageId";
  static String keyRecentAddressSearch = "recentAddress";
  static String keySkipLogin = "keySkipLogin";
  static String keySearchHistory = "keySearchHistory";
  static String keyAuthUid = "keyAuthUid";
  static String keyUserName = "username";
  static String keyUserId = "userId";
  static String keyUserImage = "image";
  static String keyPhone = "phone";
  static String keyEmail = "email";
  static String keyPassword = "password";
  static String keyCountryCode = "countryCode";
  static String keyReferralCode = "referral_code";
  static String keyUserStatus = "userStatus";
  static String keyToken = "keyToken";
  static String keyFCMToken = "keyFCMToken";
  static String keyIsGrid = "isGrid";
  static String keyLatitude = "keyLatitude";
  static String keyLongitude = "keyLongitude";
  static String keyAddress = "keyAddress";
  static String keyShippingAddress = "keyShippingAddress";
  static String keyPopupOfferEnabled = "keyPopupOfferEnabled";
  static String keyPopupAlwaysShowHome = "keyPopupAlwaysShowHome";
  static String keyPopupOfferType = "keyPopupOfferType";
  static String keyPreviousPopupOfferType = "keyPreviousPopupOfferType";
  static String keyPopupOfferTypeId = "keyPopupOfferTypeId";
  static String keyPreviousPopupOfferTypeId = "keyPreviousPopupOfferTypeId";
  static String keyPopupOfferImage = "keyPopupOfferImage";
  static String keyPopupOfferUrl = "keyPopupOfferUrl";
  static String keyFavoriteIds = "keyFavoriteIds";
  static String keySellerLatitude = "keySellerLatitude";
  static String keySellerLongitude = "keySellerLongitude";
  static String keySellerId = "keySellerId";

  late SharedPreferences prefs;

  SessionManager({required this.prefs});

  String getData(String id) {
    return prefs.getString(id) ?? "";
  }

  void setData(String id, String val, bool isRefresh) {
    prefs.setString(id, val);
    if (isRefresh) {
      notifyListeners();
    }
  }

  void addItemIntoList(String id, String item) {
    if (!Constant.searchedItemsHistoryList.contains(item)) {
      Constant.searchedItemsHistoryList.add(item);
      prefs.setStringList(id, Constant.searchedItemsHistoryList);
    }
  }

  void clearItemList(String id) {
    Constant.searchedItemsHistoryList = [];
    prefs.setStringList(id, []);
  }

  Future setUserData({
    required String firebaseUid,
    required String name,
    required String id,
    required String email,
    required String profile,
    required String countryCode,
    required String mobile,
    required String referralCode,
    required int status,
    required String token,
    required bool isUserSeller,
    /*required String balance*/
  }) async {
    prefs.setString(keyAuthUid, firebaseUid);
    setData(keyUserName, name, false);
    setData(keyUserId, id, false);
    setData(keyUserImage, profile, false);
    setData(keyEmail, email, false);
    prefs.setString(keyCountryCode, countryCode);
    prefs.setString(keyPhone, mobile);
    prefs.setString(keyReferralCode, referralCode);
    prefs.setInt(keyUserStatus, status);
    prefs.setString(keyToken, token);
    setBoolData(isUserLogin, true, false);
    setBoolData(isSeller, isUserSeller, false);
    notifyListeners();
/*
    prefs.setString(keyBalance, balance.toString());
*/
  }

  Future setSellerData({
    required String firebaseUid,
    required String name,
    required String id,
    required String email,
    required String profile,
    required String countryCode,
    required String mobile,
    required String referralCode,
    required int status,
    required String token,
    required bool isUserSeller,
    required String sellerLatitude,
    required String sellerLongitude,
  }) async {
    prefs.setString(keyAuthUid, firebaseUid);
    setData(keyUserName, name, false);
    setData(keyUserId, id, false);
    setData(keyUserImage, profile, false);
    setData(keyEmail, email, false);
    prefs.setString(keyCountryCode, countryCode);
    prefs.setString(keyPhone, mobile);
    prefs.setString(keyReferralCode, referralCode);
    prefs.setInt(keyUserStatus, status);
    prefs.setString(keyToken, token);
    prefs.setString(keySellerId, id);
    prefs.setString(keySellerLatitude, sellerLatitude);
    prefs.setString(keySellerLongitude, sellerLongitude);
    prefs.setString(keyToken, token);
    setBoolData(isUserLogin, true, false);
    setBoolData(isSeller, isUserSeller, false);
    notifyListeners();
  }

  void setDoubleData(String key, double value) {
    prefs.setDouble(key, value);
    notifyListeners();
  }

  double getDoubleData(String key) {
    return prefs.getDouble(key) ?? 0.0;
  }

  bool getBoolData(String key) {
    return prefs.getBool(key) ?? false;
  }

  setSystemTheme(String key, bool value, bool isRefresh) {
    setBoolData(key, value, isRefresh);
  }

  void setBoolData(String key, bool value, bool isRefresh) {
    prefs.setBool(key, value);
    if (isRefresh) notifyListeners();
  }

  int getIntData(String key) {
    return prefs.getInt(key) ?? 0;
  }

  void setIntData(String key, int value) {
    prefs.setInt(key, value);
    notifyListeners();
  }

  bool isUserLoggedIn() {
    return getBoolData(isUserLogin);
  }

  void logoutUser(BuildContext buildContext) {
    showDialog<String>(
      context: buildContext,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        surfaceTintColor: Colors.transparent,
        title: CustomTextLabel(
          jsonKey: "logout_title",
          softWrap: true,
        ),
        content: CustomTextLabel(
          jsonKey: "logout_message",
          softWrap: true,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomTextLabel(
              jsonKey: "cancel",
              softWrap: true,
              style: TextStyle(color: ColorsRes.subTitleMainTextColor),
            ),
          ),
          TextButton(
            onPressed: () {
              String themeName = getData(SessionManager.appThemeName);
              String languageId = getData(SessionManager.keySelectedLanguageId);
              String latitude = getData(SessionManager.keyLatitude);
              String longitude = getData(SessionManager.keyLongitude);
              String address = getData(SessionManager.keyAddress);

              bool isDark = false;
              if (themeName == Constant.themeList[2]) {
                isDark = true;
              } else if (themeName == Constant.themeList[1]) {
                isDark = false;
              } else if (themeName == "" ||
                  themeName == Constant.themeList[0]) {
                var brightness = PlatformDispatcher.instance.platformBrightness;
                isDark = brightness == Brightness.dark;

                if (themeName == "") {
                  setData(SessionManager.appThemeName, Constant.themeList[0],
                      false);
                }
              }
              prefs.clear();
              setBoolData(introSlider, true, false);
              setBoolData(isUserLogin, false, false);
              setData(SessionManager.appThemeName, themeName, false);
              setData(keySelectedLanguageId, languageId, false);
              setData(SessionManager.keyLatitude, latitude, false);
              setData(SessionManager.keyLongitude, longitude, false);
              setData(SessionManager.keyAddress, address, false);
              setBoolData(SessionManager.isDarkTheme, isDark, false);
              setBoolData(SessionManager.introSlider, true, false);
              context.read<CartListProvider>().cartList.clear();
              Navigator.of(buildContext).pushNamedAndRemoveUntil(
                  userTypeSelectionScreen, (Route<dynamic> route) => false);
            },
            child: CustomTextLabel(
              jsonKey: "ok",
              softWrap: true,
              style: TextStyle(color: ColorsRes.appColor),
            ),
          ),
        ],
      ),
    );
  }

  void logoutUserMethod(BuildContext context) {
    {
      String themeName = getData(SessionManager.appThemeName);
      String languageId = getData(SessionManager.keySelectedLanguageId);
      String latitude = getData(SessionManager.keyLatitude);
      String longitude = getData(SessionManager.keyLongitude);
      String address = getData(SessionManager.keyAddress);

      bool isDark = false;
      if (themeName == Constant.themeList[2]) {
        isDark = true;
      } else if (themeName == Constant.themeList[1]) {
        isDark = false;
      } else if (themeName == "" || themeName == Constant.themeList[0]) {
        var brightness = PlatformDispatcher.instance.platformBrightness;
        isDark = brightness == Brightness.dark;

        if (themeName == "") {
          setData(SessionManager.appThemeName, Constant.themeList[0], false);
        }
      }
      prefs.clear();
      setBoolData(introSlider, true, false);
      setBoolData(isUserLogin, false, false);
      setData(SessionManager.appThemeName, themeName, false);
      setData(keySelectedLanguageId, languageId, false);
      setData(SessionManager.keyLatitude, latitude, false);
      setData(SessionManager.keyLongitude, longitude, false);
      setData(SessionManager.keyAddress, address, false);
      setBoolData(SessionManager.isDarkTheme, isDark, false);
      setBoolData(SessionManager.introSlider, true, false);
      context.read<CartListProvider>().cartList.clear();
      Navigator.of(context).pushNamedAndRemoveUntil(
          userTypeSelectionScreen, (Route<dynamic> route) => false);
    }
  }

  void deleteUserAccount(BuildContext buildContext) {
    showDialog<String>(
      context: buildContext,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        surfaceTintColor: Colors.transparent,
        title: CustomTextLabel(
          jsonKey: "delete_user_title",
          softWrap: true,
        ),
        content: CustomTextLabel(
          jsonKey: "delete_user_message",
          softWrap: true,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomTextLabel(
              jsonKey: "cancel",
              softWrap: true,
              style: TextStyle(color: ColorsRes.subTitleMainTextColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              await getDeleteAccountApi(context: context)
                  .then((response) async {
                String themeName = getData(SessionManager.appThemeName);
                String languageId =
                    getData(SessionManager.keySelectedLanguageId);
                String latitude = getData(SessionManager.keyLatitude);
                String longitude = getData(SessionManager.keyLongitude);
                String address = getData(SessionManager.keyAddress);

                bool isDark = false;
                if (themeName == Constant.themeList[2]) {
                  isDark = true;
                } else if (themeName == Constant.themeList[1]) {
                  isDark = false;
                } else if (themeName == "" ||
                    themeName == Constant.themeList[0]) {
                  var brightness =
                      PlatformDispatcher.instance.platformBrightness;
                  isDark = brightness == Brightness.dark;

                  if (themeName == "") {
                    setData(SessionManager.appThemeName, Constant.themeList[0],
                        false);
                  }
                }
                prefs.clear();
                setBoolData(introSlider, true, false);
                setBoolData(isUserLogin, false, false);
                setData(SessionManager.appThemeName, themeName, false);
                setData(SessionManager.keyLatitude, latitude, false);
                setData(SessionManager.keyLongitude, longitude, false);
                setData(SessionManager.keyAddress, address, false);
                setBoolData(SessionManager.isDarkTheme, isDark, false);
                setBoolData(SessionManager.introSlider, true, false);
                setData(keySelectedLanguageId, languageId, false);
                context.read<CartListProvider>().cartList.clear();
                Navigator.of(buildContext).pushNamedAndRemoveUntil(
                    userTypeSelectionScreen, (Route<dynamic> route) => false);
              });
            },
            child: CustomTextLabel(
              jsonKey: "ok",
              softWrap: true,
              style: TextStyle(color: ColorsRes.appColor),
            ),
          ),
        ],
      ),
    );
  }
}
