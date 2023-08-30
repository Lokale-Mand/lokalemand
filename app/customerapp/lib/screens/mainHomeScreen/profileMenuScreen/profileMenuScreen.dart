import 'package:egrocer/helper/utils/generalImports.dart';

class ProfileScreen extends StatefulWidget {
  final ScrollController scrollController;

  const ProfileScreen({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List profileMenus = [];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => setProfileMenuList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: "profile",
            softWrap: true,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          showBackButton: false,
        ),
        body: Consumer<UserProfileProvider>(
          builder: (context, userProfileProvider, _) {
            setProfileMenuList();
            return ListView(
              controller: widget.scrollController,
              children: [
                ProfileHeader(),
                QuickUseWidget(),
                Card(
                  margin: const EdgeInsetsDirectional.all(10),
                  child: Column(
                    children: List.generate(
                      profileMenus.length,
                      (index) => Theme(
                        data: ThemeData(
                          splashColor: ColorsRes.appColorLightHalfTransparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: ListTile(
                          onTap: () {
                            profileMenus[index]['clickFunction'](context);
                          },
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          leading: Container(
                            decoration: DesignConfig.boxDecoration(
                                ColorsRes.appColorLightHalfTransparent, 5),
                            padding: const EdgeInsets.all(8),
                            child: Widgets.defaultImg(
                                image: profileMenus[index]['icon'],
                                iconColor: ColorsRes.appColor,
                                height: 20,
                                width: 20),
                          ),
                          title: CustomTextLabel(
                            jsonKey: profileMenus[index]['label'],
                            style:
                                Theme.of(context).textTheme.bodyMedium!.merge(
                                      TextStyle(
                                        letterSpacing: 0.5,
                                        color: ColorsRes.mainTextColor,
                                      ),
                                    ),
                          ),
                          trailing: Icon(
                            Icons.navigate_next,
                            color: ColorsRes.subTitleMainTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  setProfileMenuList() {
    profileMenus = [];
    profileMenus = [
      {
        "icon": "theme_icon",
        "label": "change_theme",
        "clickFunction": Widgets.themeDialog,
      },
      if (context.read<LanguageProvider>().languages.length > 1)
        {
          "icon": "translate_icon",
          "label": "change_language",
          "clickFunction": (context) {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
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
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "settings",
          "label": "settings",
          "clickFunction": (context) {
            Navigator.pushNamed(
                context, notificationsAndMailSettingsScreenScreen);
          },
          "isResetLabel": false
        },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "notification_icon",
          "label": "notification",
          "clickFunction": (context) {
            Navigator.pushNamed(context, notificationListScreen);
          },
          "isResetLabel": false
        },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "transaction_icon",
          "label": "transaction_history",
          "clickFunction": (context) {
            Navigator.pushNamed(context, transactionListScreen);
          },
          "isResetLabel": false
        },
/*      if (isUserLogin)
        {
          "icon": "refer_friend_icon",
          "label": "refer_and_earn",
          "clickFunction": ReferAndEarn(),
          "isResetLabel": false
        },*/
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
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "logout_icon",
          "label": "logout",
          "clickFunction": Constant.session.logoutUser,
          "isResetLabel": false
        },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "delete_user_account_icon",
          "label": "delete_user_account",
          "clickFunction": Constant.session.deleteUserAccount,
          "isResetLabel": false
        },
    ];
  }
}