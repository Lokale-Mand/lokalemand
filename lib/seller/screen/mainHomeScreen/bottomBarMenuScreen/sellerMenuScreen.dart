import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/screen/mainHomeScreen/bottomBarMenuScreen/widget/profileHeader.dart';

class SellerMenuScreen extends StatefulWidget {
  const SellerMenuScreen({super.key});

  @override
  State<SellerMenuScreen> createState() => _SellerMenuScreenState();
}

class _SellerMenuScreenState extends State<SellerMenuScreen> {
  List personalDataMenu = [];
  List storeDataMenu = [];
  List legalDataMenu = [];
  List settingsDataMenu = [];
  List deleteAccountMenuItem = [];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      setLegalDataMenuList();
      setSettingsDataMenuList();
      setPersonalDataMenuList();
      setDeleteMenuItem();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: "profile",
            softWrap: true,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorsRes.mainTextColor,
            ),
          ),
          showBackButton: false,
        ),
        body: Consumer<UserProfileProvider>(
          builder: (context, userProfileProvider, _) {
            setStoreDataMenuList();
            setLegalDataMenuList();
            setSettingsDataMenuList();
            setPersonalDataMenuList();
            setDeleteMenuItem();
            return ListView(
              padding: EdgeInsetsDirectional.all(20),
              children: [
                SellerProfileHeader(),
                // Divider(color: ColorsRes.menuTitleColor),
                // Widgets.getSizedBox(height: 5),
                // CustomTextLabel(
                //   jsonKey: "store",
                //   softWrap: true,
                //   overflow: TextOverflow.ellipsis,
                //   style: TextStyle(
                //     fontWeight: FontWeight.w600,
                //     fontSize: 12,
                //     color: ColorsRes.menuTitleColor,
                //   ),
                // ),
                // MenuListItems(storeDataMenu),
                Widgets.getSizedBox(height: 5),
                if (Constant.session.isUserLoggedIn())
                  Divider(color: ColorsRes.menuTitleColor),
                if (Constant.session.isUserLoggedIn())
                  Widgets.getSizedBox(height: 5),
                if (Constant.session.isUserLoggedIn())
                  CustomTextLabel(
                    jsonKey: "personal_data",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: ColorsRes.menuTitleColor,
                    ),
                  ),
                if (Constant.session.isUserLoggedIn())
                  Widgets.getSizedBox(height: 15),
                if (Constant.session.isUserLoggedIn())
                  MenuListItems(personalDataMenu),
                Divider(color: ColorsRes.menuTitleColor),
                Widgets.getSizedBox(height: 15),
                CustomTextLabel(
                  jsonKey: "legal",
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: ColorsRes.menuTitleColor,
                  ),
                ),
                MenuListItems(legalDataMenu),
                Widgets.getSizedBox(height: 15),
                Divider(color: ColorsRes.menuTitleColor),
                Widgets.getSizedBox(height: 15),
                CustomTextLabel(
                  jsonKey: "settings",
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: ColorsRes.menuTitleColor,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.only(top: 10, start: 10, end: 10),
                  child: Row(
                    children: [
                      CustomTextLabel(
                        jsonKey: "change_theme",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 20,
                        width: 30,
                        child: Switch(
                          value: Constant.session
                              .getBoolData(SessionManager.isDarkTheme),
                          onChanged: (value) {
                            if (value) {
                              Constant.session.setBoolData(
                                  SessionManager.isDarkTheme, value, true);
                              Constant.session.setData(
                                  SessionManager.appThemeName,
                                  Constant.themeList[2],
                                  true);
                            } else {
                              Constant.session.setBoolData(
                                  SessionManager.isDarkTheme, value, true);
                              Constant.session.setData(
                                  SessionManager.appThemeName,
                                  Constant.themeList[1],
                                  true);
                            }
                          },
                          activeThumbImage:
                              AssetImage(Constant.getAssetsPath(0, "dark.png")),
                          inactiveThumbImage: AssetImage(
                              Constant.getAssetsPath(0, "light.png")),
                        ),
                      ),
                    ],
                  ),
                ),
                MenuListItems(settingsDataMenu),
                CustomMenuListItems(deleteAccountMenuItem),
                Widgets.getSizedBox(height: 5),
              ],
            );
          },
        ),
      ),
    );
  }

  setStoreDataMenuList() {
    storeDataMenu = [];
    storeDataMenu = [
      {
        "icon": "notification_icon",
        "label": "open_a_shop",
        "clickFunction": (context) {},
        "isResetLabel": false
      },
    ];
  }

  setPersonalDataMenuList() {
    personalDataMenu = [];
    personalDataMenu = [
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "notification_icon",
          "label": "notification",
          "clickFunction": (context) {
            Navigator.pushNamed(context, notificationListScreen);
          },
          "isResetLabel": false
        },
      // if (Constant.session.isUserLoggedIn())
      //   {
      //     "icon": "transaction_icon",
      //     "label": "transaction_history",
      //     "clickFunction": (context) {
      //       Navigator.pushNamed(context, transactionListScreen);
      //     },
      //     "isResetLabel": false
      //   },
    ];
  }

  setSettingsDataMenuList() {
    settingsDataMenu = [];
    settingsDataMenu = [
      if (context.read<LanguageProvider>().languages.length > 1)
        {
          "icon": "translate_icon",
          "label": "change_language",
          "clickFunction": (context) {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Theme.of(context).cardColor,
              shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    BottomSheetLanguageListContainer(),
                  ],
                );
              },
            );
          },
          "isResetLabel": true,
        },
      // if (Constant.session.isUserLoggedIn())
      //   {
      //     "icon": "settings",
      //     "label": "settings",
      //     "clickFunction": (context) {
      //       Navigator.pushNamed(
      //           context, notificationsAndMailSettingsScreenScreen);
      //     },
      //     "isResetLabel": false
      //   },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "logout_icon",
          "label": "logout",
          "clickFunction": Constant.session.logoutUser,
          "isResetLabel": false
        },
    ];
  }

  setDeleteMenuItem(){
    deleteAccountMenuItem = [];
    deleteAccountMenuItem = [
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "delete_user_account_icon",
          "label": "delete_user_account",
          "clickFunction": Constant.session.deleteUserAccount,
          "isResetLabel": false
        },
    ];
  }

  setLegalDataMenuList() {
    legalDataMenu = [];
    legalDataMenu = [
      {
        "icon": "contact_icon",
        "label": "contact_us",
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(
              context,
              "contact_us",
            ),
          );
        }
      },
      {
        "icon": "about_icon",
        "label": "about_us",
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(
              context,
              "about_us",
            ),
          );
        },
        "isResetLabel": false
      },
      {
        "icon": "rate_icon",
        "label": "rate_us",
        "clickFunction": (BuildContext context) {
          launchUrl(
              Uri.parse(Platform.isAndroid
                  ? Constant.playStoreUrl
                  : Constant.appStoreUrl),
              mode: LaunchMode.externalApplication);
        },
      },
      {
        "icon": "share_icon",
        "label": "share_app",
        "clickFunction": (BuildContext context) {
          String shareAppMessage = getTranslatedValue(
            context,
            "share_app_message",
          );
          if (Platform.isAndroid) {
            shareAppMessage = "$shareAppMessage${Constant.playStoreUrl}";
          } else if (Platform.isIOS) {
            shareAppMessage = "$shareAppMessage${Constant.appStoreUrl}";
          }
          Share.share(shareAppMessage, subject: "Share app");
        },
      },
      {
        "icon": "faq_icon",
        "label": "faq",
        "clickFunction": (context) {
          Navigator.pushNamed(context, faqListScreen);
        }
      },
      {
        "icon": "terms_icon",
        "label": "terms_and_conditions",
        "clickFunction": (context) {
          Navigator.pushNamed(context, webViewScreen,
              arguments: getTranslatedValue(
                context,
                "terms_and_conditions",
              ));
        }
      },
      {
        "icon": "privacy_icon",
        "label": "policies",
        "clickFunction": (context) {
          Navigator.pushNamed(context, webViewScreen,
              arguments: getTranslatedValue(
                context,
                "policies",
              ));
        }
      },
    ];
  }

  Widget MenuListItems(List menu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        menu.length,
        (index) => Padding(
          padding: EdgeInsetsDirectional.only(top: 10, start: 10, end: 10),
          child: GestureDetector(
            onTap: () {
              menu[index]['clickFunction'](context);
            },
            child: CustomTextLabel(
              jsonKey: menu[index]['label'],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget CustomMenuListItems(List menu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        menu.length,
        (index) => Padding(
          padding: EdgeInsetsDirectional.only(top: 10, start: 10, end: 10),
          child: GestureDetector(
            onTap: () {
              menu[index]['clickFunction'](context);
            },
            child: CustomTextLabel(
              jsonKey: menu[index]['label'],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: ColorsRes.appColorRed,
              ),
            ),
          ),
        ),
      ),
    );
  }

//   ORIGINAL MENU
//   setProfileMenuList() {
//     profileMenus = [];
//     profileMenus = [
//       {
//         "icon": "theme_icon",
//         "label": "change_theme",
//         "clickFunction": Widgets.themeDialog,
//       },
//       if (context.read<LanguageProvider>().languages.length > 1)
//         {
//           "icon": "translate_icon",
//           "label": "change_language",
//           "clickFunction": (context) {
//             showModalBottomSheet<void>(
//               context: context,
//               isScrollControlled: true,
//               shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
//               builder: (BuildContext context) {
//                 return Wrap(
//                   children: [
//                     BottomSheetLanguageListContainer(),
//                   ],
//                 );
//               },
//             );
//           },
//           "isResetLabel": true,
//         },
//       if (Constant.session.isUserLoggedIn())
//         {
//           "icon": "settings",
//           "label": "settings",
//           "clickFunction": (context) {
//             Navigator.pushNamed(
//                 context, notificationsAndMailSettingsScreenScreen);
//           },
//           "isResetLabel": false
//         },
//       if (Constant.session.isUserLoggedIn())
//         {
//           "icon": "notification_icon",
//           "label": "notification",
//           "clickFunction": (context) {
//             Navigator.pushNamed(context, notificationListScreen);
//           },
//           "isResetLabel": false
//         },
//       if (Constant.session.isUserLoggedIn())
//         {
//           "icon": "transaction_icon",
//           "label": "transaction_history",
//           "clickFunction": (context) {
//             Navigator.pushNamed(context, transactionListScreen);
//           },
//           "isResetLabel": false
//         },
// /*      if (isUserLogin)
//         {
//           "icon": "refer_friend_icon",
//           "label": "refer_and_earn",
//           "clickFunction": ReferAndEarn(),
//           "isResetLabel": false
//         },*/
//       {
//         "icon": "contact_icon",
//         "label": "contact_us",
//         "clickFunction": (context) {
//           Navigator.pushNamed(
//             context,
//             webViewScreen,
//             arguments: getTranslatedValue(
//               context,
//               "contact_us",
//             ),
//           );
//         }
//       },
//       {
//         "icon": "about_icon",
//         "label": "about_us",
//         "clickFunction": (context) {
//           Navigator.pushNamed(
//             context,
//             webViewScreen,
//             arguments: getTranslatedValue(
//               context,
//               "about_us",
//             ),
//           );
//         },
//         "isResetLabel": false
//       },
//       {
//         "icon": "rate_icon",
//         "label": "rate_us",
//         "clickFunction": (BuildContext context) {
//           launchUrl(
//               Uri.parse(Platform.isAndroid
//                   ? Constant.playStoreUrl
//                   : Constant.appStoreUrl),
//               mode: LaunchMode.externalApplication);
//         },
//       },
//       {
//         "icon": "share_icon",
//         "label": "share_app",
//         "clickFunction": (BuildContext context) {
//           String shareAppMessage = getTranslatedValue(
//             context,
//             "share_app_message",
//           );
//           if (Platform.isAndroid) {
//             shareAppMessage = "$shareAppMessage${Constant.playStoreUrl}";
//           } else if (Platform.isIOS) {
//             shareAppMessage = "$shareAppMessage${Constant.appStoreUrl}";
//           }
//           Share.share(shareAppMessage, subject: "Share app");
//         },
//       },
//       {
//         "icon": "faq_icon",
//         "label": "faq",
//         "clickFunction": (context) {
//           Navigator.pushNamed(context, faqListScreen);
//         }
//       },
//       {
//         "icon": "terms_icon",
//         "label": "terms_and_conditions",
//         "clickFunction": (context) {
//           Navigator.pushNamed(context, webViewScreen,
//               arguments: getTranslatedValue(
//                 context,
//                 "terms_and_conditions",
//               ));
//         }
//       },
//       {
//         "icon": "privacy_icon",
//         "label": "policies",
//         "clickFunction": (context) {
//           Navigator.pushNamed(context, webViewScreen,
//               arguments: getTranslatedValue(
//                 context,
//                 "policies",
//               ));
//         }
//       },
//       if (Constant.session.isUserLoggedIn())
//         {
//           "icon": "logout_icon",
//           "label": "logout",
//           "clickFunction": Constant.session.logoutUser,
//           "isResetLabel": false
//         },
//       if (Constant.session.isUserLoggedIn())
//         {
//           "icon": "delete_user_account_icon",
//           "label": "delete_user_account",
//           "clickFunction": Constant.session.deleteUserAccount,
//           "isResetLabel": false
//         },
//     ];
//   }
}
