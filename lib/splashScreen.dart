import 'package:geolocator/geolocator.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late PackageInfo packageInfo;
  String currentAppVersion = "1.0.0";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then(
      (value) {
        callAllApis();
      },
    );
  }

  callAllApis() {
    try {
      context
          .read<AppSettingsProvider>()
          .getAppSettingsProvider(context)
          .then((value) async {
        packageInfo = await PackageInfo.fromPlatform();
        currentAppVersion = packageInfo.version;
        LocationPermission permission;
        permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        } else if (permission == LocationPermission.deniedForever) {
          return Future.error('Location Not Available');
        }

        Map<String, String> params = {ApiAndParams.system_type: "1"};
        if (Constant.session
            .getData(SessionManager.keySelectedLanguageId)
            .isEmpty) {
          params[ApiAndParams.is_default] = "1";
        } else {
          params[ApiAndParams.id] =
              Constant.session.getData(SessionManager.keySelectedLanguageId);
        }

        await context.read<LanguageProvider>().getAvailableLanguageList(
            params: {ApiAndParams.system_type: "1"},
            context: context).then((value) {
          context
              .read<LanguageProvider>()
              .getLanguageDataProvider(
                params: params,
                context: context,
              )
              .then((value) {
            if (context.read<LanguageProvider>().languageState ==
                    LanguageState.loaded &&
                context.read<AppSettingsProvider>().settingsState ==
                    SettingsState.loaded) {
              startTime();
            }
          });
        });
      });
    } on SocketException {
      context.read<AppSettingsProvider>().changeState();
      throw Constant.noInternetConnection;
    } catch (e) {
      context.read<AppSettingsProvider>().changeState();
      throw Constant.somethingWentWrong;
    }
  }

  startTime() async {
    return Timer(
      const Duration(seconds: 1),
      () async {
        if (Constant.appMaintenanceMode == "1") {
          Navigator.pushReplacementNamed(context, underMaintenanceScreen);
        } else if (Platform.isAndroid) {
          if (!Constant.session.getBoolData(SessionManager.introSlider)) {
            if ((Constant.isVersionSystemOn == "1" ||
                    Constant.currentRequiredAppVersion.isNotEmpty) &&
                (Version.parse(Constant.currentRequiredAppVersion) >
                    Version.parse(currentAppVersion))) {
              if (Constant.requiredForceUpdate == "1") {
                Constant.session
                    .setBoolData(SessionManager.introSlider, true, false);
                Navigator.pushReplacementNamed(context, introSliderScreen);
                Navigator.pushReplacementNamed(context, appUpdateScreen,
                    arguments: true);
              } else {
                Constant.session
                    .setBoolData(SessionManager.introSlider, true, false);
                Navigator.pushReplacementNamed(context, introSliderScreen);
                Navigator.pushNamed(context, appUpdateScreen, arguments: false);
              }
            } else {
              Constant.session
                  .setBoolData(SessionManager.introSlider, true, false);
              Navigator.pushReplacementNamed(context, introSliderScreen);
            }
          } else if (Constant.session.getBoolData(SessionManager.isUserLogin) &&
              Constant.session.getIntData(SessionManager.keyUserStatus) == 2) {
            if (Constant.isVersionSystemOn == "1" &&
                (Version.parse(Constant.currentRequiredAppVersion) >
                    Version.parse(currentAppVersion))) {
              if (Constant.requiredForceUpdate == "1") {
                Navigator.pushReplacementNamed(context, editProfileScreen,
                    arguments: "register");
                Navigator.pushReplacementNamed(context, appUpdateScreen,
                    arguments: true);
              } else {
                Navigator.pushReplacementNamed(context, editProfileScreen,
                    arguments: "register");
                Navigator.pushNamed(context, appUpdateScreen, arguments: false);
              }
            } else {
              Navigator.pushReplacementNamed(context, editProfileScreen,
                  arguments: "register");
            }
          } else {
            if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
                Constant.session.getBoolData(SessionManager.isUserLogin)) {
              if (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
                  Constant.session.getData(SessionManager.keyLongitude) ==
                      "0") {
                if (Constant.isVersionSystemOn == "1" &&
                    (Version.parse(Constant.currentRequiredAppVersion) >
                        Version.parse(currentAppVersion))) {
                  if (Constant.requiredForceUpdate == "1") {
                    Navigator.pushReplacementNamed(context, mainHomeScreen);
                    Navigator.pushReplacementNamed(context, appUpdateScreen,
                        arguments: true);
                  } else {
                    Navigator.pushReplacementNamed(context, mainHomeScreen);
                    Navigator.pushNamed(context, appUpdateScreen,
                        arguments: false);
                  }
                } else {
                  Navigator.pushReplacementNamed(context, mainHomeScreen);
                }
              } else {
                if (Constant.isVersionSystemOn == "1" &&
                    (Version.parse(Constant.currentRequiredAppVersion) >
                        Version.parse(currentAppVersion))) {
                  if (Constant.requiredForceUpdate == "1") {
                    Navigator.pushReplacementNamed(context, mainHomeScreen);
                    Navigator.pushReplacementNamed(context, appUpdateScreen,
                        arguments: true);
                  } else {
                    Navigator.pushReplacementNamed(context, mainHomeScreen);
                    Navigator.pushNamed(context, appUpdateScreen,
                        arguments: false);
                  }
                } else {
                  Navigator.pushReplacementNamed(context, mainHomeScreen);
                }
              }
            } else {
              if (Constant.isVersionSystemOn == "1" &&
                  (Version.parse(Constant.currentRequiredAppVersion) >
                      Version.parse(currentAppVersion))) {
                if (Constant.requiredForceUpdate == "1") {
                  Navigator.pushReplacementNamed(
                      context, userTypeSelectionScreen);
                  Navigator.pushReplacementNamed(context, appUpdateScreen,
                      arguments: true);
                } else {
                  Navigator.pushReplacementNamed(
                      context, userTypeSelectionScreen);
                  Navigator.pushNamed(context, appUpdateScreen,
                      arguments: false);
                }
              } else {
                Navigator.pushReplacementNamed(
                    context, userTypeSelectionScreen);
              }
            }
          }
        } else if (Platform.isIOS) {
          if (!Constant.session.getBoolData(SessionManager.introSlider)) {
            if ((Constant.isIosVersionSystemOn == "1" ||
                    Constant.currentRequiredIosAppVersion.isNotEmpty) &&
                (Version.parse(Constant.currentRequiredIosAppVersion) >
                    Version.parse(currentAppVersion))) {
              if (Constant.requiredIosForceUpdate == "1") {
                Constant.session
                    .setBoolData(SessionManager.introSlider, true, false);
                Navigator.pushReplacementNamed(context, introSliderScreen);
                Navigator.pushReplacementNamed(context, appUpdateScreen,
                    arguments: true);
              } else {
                Constant.session
                    .setBoolData(SessionManager.introSlider, true, false);
                Navigator.pushReplacementNamed(context, introSliderScreen);
                Navigator.pushNamed(context, appUpdateScreen, arguments: false);
              }
            } else {
              Constant.session
                  .setBoolData(SessionManager.introSlider, true, false);
              Navigator.pushReplacementNamed(context, introSliderScreen);
            }
          } else if (Constant.session.getBoolData(SessionManager.isUserLogin) &&
              Constant.session.getIntData(SessionManager.keyUserStatus) == 2) {
            if (await versionInformationAvailable()) {
              if (Constant.requiredIosForceUpdate == "1") {
                Navigator.pushReplacementNamed(context, editProfileScreen,
                    arguments: "register");
                Navigator.pushReplacementNamed(context, appUpdateScreen,
                    arguments: true);
              } else {
                Navigator.pushReplacementNamed(context, editProfileScreen,
                    arguments: "register");
                Navigator.pushNamed(context, appUpdateScreen, arguments: false);
              }
            } else {
              Navigator.pushReplacementNamed(context, editProfileScreen,
                  arguments: "register");
            }
          } else {
            if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
                Constant.session.getBoolData(SessionManager.isUserLogin)) {
              if (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
                  Constant.session.getData(SessionManager.keyLongitude) ==
                      "0") {
                if (await versionInformationAvailable()) {
                  if (Constant.requiredIosForceUpdate == "1") {
                    Navigator.pushReplacementNamed(context, mainHomeScreen);
                    Navigator.pushReplacementNamed(context, appUpdateScreen,
                        arguments: true);
                  } else {
                    Navigator.pushReplacementNamed(context, mainHomeScreen);
                    Navigator.pushNamed(context, appUpdateScreen,
                        arguments: false);
                  }
                } else {
                  Navigator.pushReplacementNamed(context, mainHomeScreen);
                }
              } else {
                if (await versionInformationAvailable()) {
                  if (Constant.requiredIosForceUpdate == "1") {
                    Navigator.pushReplacementNamed(context, mainHomeScreen);
                    Navigator.pushReplacementNamed(context, appUpdateScreen,
                        arguments: true);
                  } else {
                    Navigator.pushReplacementNamed(context, mainHomeScreen);
                    Navigator.pushNamed(context, appUpdateScreen,
                        arguments: false);
                  }
                } else {
                  Navigator.pushReplacementNamed(context, mainHomeScreen);
                }
              }
            } else {
              if (await versionInformationAvailable()) {
                if (Constant.requiredIosForceUpdate == "1") {
                  Navigator.pushReplacementNamed(
                      context, userTypeSelectionScreen);
                  Navigator.pushReplacementNamed(context, appUpdateScreen,
                      arguments: true);
                } else {
                  Navigator.pushReplacementNamed(
                      context, userTypeSelectionScreen);
                  Navigator.pushNamed(context, appUpdateScreen,
                      arguments: false);
                }
              } else {
                Navigator.pushReplacementNamed(
                    context, userTypeSelectionScreen);
              }
            }
          }
        }
      },
    );
  }

  Future<bool> versionInformationAvailable() async {
    return Constant.isIosVersionSystemOn == "1" &&
        (Version.parse(Constant.currentRequiredIosAppVersion) >
            Version.parse(currentAppVersion));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Consumer<AppSettingsProvider>(
          builder: (context, appSettingsProvider, child) {
            if (languageProvider.languageState == LanguageState.error ||
                appSettingsProvider.settingsState == SettingsState.error) {
              return Scaffold(
                backgroundColor: Theme.of(context).cardColor,
                body: DefaultBlankItemMessageScreen(
                  height: MediaQuery.sizeOf(context).height,
                  image: languageProvider.message.isNotEmpty
                      ? languageProvider.message
                      : appSettingsProvider.message ==
                              Constant.noInternetConnection
                          ? "no_internet_icon"
                          : "something_went_wrong",
                  title: languageProvider.message.isNotEmpty
                      ? languageProvider.message
                      : appSettingsProvider.message ==
                              Constant.noInternetConnection
                          ? "No Internet!"
                          : "Oops! Error",
                  description: languageProvider.message.isNotEmpty
                      ? languageProvider.message
                      : appSettingsProvider.message ==
                              Constant.noInternetConnection
                          ? "Connection lost. Please check your network settings."
                          : "An unexpected error occurred. Please try again later.",
                  buttonTitle: "Try Again",
                  callback: () async {
                    await callAllApis();
                  },
                ),
              );
            } else {
              return Scaffold(
                body: Container(
                  padding: EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: Widgets.defaultImg(image: 'logo'),
                ),
              );
            }
          },
        );
      },
    );
  }
}
