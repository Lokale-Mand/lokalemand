

import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        Map<String, String> params = {ApiAndParams.system_type: "2"};
        if (Constant.session
            .getData(SessionManager.keySelectedLanguageId)
            .isEmpty) {
          params[ApiAndParams.is_default] = "1";
        } else {
          params[ApiAndParams.id] =
              Constant.session.getData(SessionManager.keySelectedLanguageId);
        }

        context
            .read<LanguageProvider>()
            .getLanguageDataProvider(
              params: params,
              context: context,
            )
            .then((value) {
          if (Constant.session.isUserLoggedIn()) {
            if (Constant.session.getData(SessionManager.status) == "1") {
              context
                  .read<SettingsProvider>()
                  .getSettingsApiProvider({}, context).then(
                (value) async {
                  Navigator.pushReplacementNamed(context, mainHomeScreen);
                },
              );
            } else {
              if (Constant.session.isSeller()) {
                Navigator.pushReplacementNamed(
                    context, editSellerProfileScreen);
              } else {
                Navigator.pushReplacementNamed(
                    context, editDeliveryBoyProfileScreen);
              }
            }
          } else {
            if (Constant.appLoginType == 1) {
              Constant.session
                  .setData(SessionManager.keyUserType, "seller", false);
              Navigator.pushNamed(context, loginScreen);
            } else if (Constant.appLoginType == 2) {
              Constant.session
                  .setData(SessionManager.keyUserType, "delivery_boy", false);

              Navigator.pushNamed(context, loginScreen);
            } else {
              Navigator.pushReplacementNamed(context, accountTypeScreen);
            }
          }
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsRes.appColor,
      body: Container(
        alignment: Alignment.center,
        child: Widgets.defaultImg(image: 'splash_logo'),
      ),
    );
  }
}
