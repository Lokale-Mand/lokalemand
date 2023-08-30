import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class AccountTypeScreen extends StatefulWidget {
  AccountTypeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountTypeScreen> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<AccountTypeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PositionedDirectional(
          bottom: 0,
          start: 0,
          end: 0,
          top: 0,
          child: Image.asset(
            Constant.getAssetsPath(0, "bg.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        PositionedDirectional(
          bottom: 0,
          start: 0,
          end: 0,
          top: 0,
          child: Image.asset(
            Constant.getAssetsPath(0, "bg_overlay.png"),
            fit: BoxFit.fill,
          ),
        ),
        PositionedDirectional(
          bottom: 0,
          start: 0,
          end: 0,
          top: 0,
          child: Padding(
            padding: EdgeInsetsDirectional.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Widgets.getSizedBox(height: 30),
                Text(
                  getTranslatedValue(context, "login_type_page_title"),
                  softWrap: true,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: ColorsRes.appColorWhite,
                      fontWeight: FontWeight.w500),
                ),
                Widgets.getSizedBox(
                  height: 10,
                ),
                Text(
                  getTranslatedValue(context, "login_type_page_description"),
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: ColorsRes.appColorWhite,
                      fontWeight: FontWeight.w300),
                ),
                Spacer(),
                Text(
                  getTranslatedValue(context, "login_as"),
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: ColorsRes.appColorWhite,
                      fontWeight: FontWeight.w400),
                ),
                Widgets.getSizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Widgets.gradientBtnWidget(
                        context,
                        10,
                        isSetShadow: false,
                        otherWidgets: Text(
                          getTranslatedValue(context, "seller"),
                          softWrap: true,
                          style: Theme.of(context).textTheme.titleMedium!.merge(
                                TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        ),
                        callback: () {
                          Constant.session.setData(
                              SessionManager.keyUserType, "seller", false);
                          Navigator.pushNamed(context, loginScreen);
                        },
                      ),
                    ),
                    Widgets.getSizedBox(width: 10),
                    Expanded(
                      child: Widgets.gradientBtnWidget(
                        context,
                        10,
                        isSetShadow: false,
                        otherWidgets: Text(
                          getTranslatedValue(context, "delivery_boy"),
                          softWrap: true,
                          style: Theme.of(context).textTheme.titleMedium!.merge(
                                TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500),
                              ),
                        ),
                        callback: () {
                          Constant.session.setData(SessionManager.keyUserType,
                              "delivery_boy", false);

                          Navigator.pushNamed(context, loginScreen);
                        },
                      ),
                    ),
                  ],
                ),
                Widgets.getSizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
