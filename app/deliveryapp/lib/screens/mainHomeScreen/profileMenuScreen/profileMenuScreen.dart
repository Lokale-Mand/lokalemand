


import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List profileMenus = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        setProfileMenuList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    setProfileMenuList();

    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: Text(
          getTranslatedValue(context, "title_profile"),
          softWrap: true,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            profileHeader(
              context: context,
              name: Constant.session.getData(SessionManager.name),
              mobile: Constant.session.getData(SessionManager.mobile),
            ),
            SizedBox(height: 1),
            Flexible(
              child: Card(
                child: profileMenuWidget(profileMenus: profileMenus),
              ),
            )
          ],
        ),
      ),
    );
  }

  setProfileMenuList() {
    profileMenus = [];
    profileMenus = [
      {
        "icon": "theme_icon",
        "label": getTranslatedValue(context, "change_theme"),
        "clickFunction": Widgets.themeDialog,
      },
      {
        "icon": "translate_icon",
        "label": getTranslatedValue(context, "change_language"),
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
/*
        {
          "icon": "notification_icon",
          "label": getTranslatedValue(context,"lblNotification,
          "clickFunction": (context) {
            Navigator.pushNamed(context, notificationListScreen);
          },
          "isResetLabel": false
        },

        {
          "icon": "transaction_icon",
          "label": getTranslatedValue(context,"lblTransactionHistory,
          "clickFunction": (context) {
            Navigator.pushNamed(context, transactionListScreen);
          },
          "isResetLabel": false
        },*/
      {
        "icon": "settings",
        "label": getTranslatedValue(context, "settings"),
        "clickFunction": (context) {
          Navigator.pushNamed(
              context, notificationsAndMailSettingsScreenScreen);
        },
        "isResetLabel": false
      },
      {
        "icon": "rate_icon",
        "label": getTranslatedValue(context, "rate_us"),
        "clickFunction": (BuildContext context) {
          launchUrl(
              Uri.parse(Platform.isAndroid
                  ? Constant.playStoreUrl
                  : Constant.appStoreUrl),
              mode: LaunchMode.externalApplication);
        },
      },
/*      {
        "icon": "share_icon",
        "label": getTranslatedValue(context,"lblShareApp,
        "clickFunction": (BuildContext context) {
          String shareAppMessage = getTranslatedValue(context,"lblShareAppMessage;
          if (Platform.isAndroid) {
            shareAppMessage = "$shareAppMessage${Constant.playStoreUrl}";
          } else if (Platform.isIOS) {
            shareAppMessage = "$shareAppMessage${Constant.appStoreUrl}";
          }
          Share.share(shareAppMessage, subject: "Share app");
        },
      }*/
      {
        "icon": "terms_icon",
        "label": getTranslatedValue(context, "terms_of_service"),
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(context, "terms_of_service"),
          );
        }
      },
      {
        "icon": "privacy_icon",
        "label": getTranslatedValue(context, "privacy_policy"),
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(context, "privacy_policy"),
          );
        }
      },
      {
        "icon": "logout_icon",
        "label": getTranslatedValue(context, "logout"),
        "clickFunction": Constant.session.logoutUser,
        "isResetLabel": false
      },
      // {
      //   "icon": "delete_user_account_icon",
      //   "label": getTranslatedValue(context, "delete_user_account"),
      //   "clickFunction": Constant.session.deleteUserAccount,
      //   "isResetLabel": false
      // },
    ];

    setState(() {});
  }
}
