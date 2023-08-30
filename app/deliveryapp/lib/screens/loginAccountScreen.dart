
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class LoginAccountScreen extends StatefulWidget {
  LoginAccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginAccountScreen> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<LoginAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController edtEmail = TextEditingController(text: Constant.session.isSeller() == true ? "seller@gmail.com" : "delivery@gmail.com");
  late TextEditingController edtPassword = TextEditingController(text: "123456");
  bool isLoading = false, isAcceptedTerms = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: Text(
          getTranslatedValue(context, "login"),
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin10, vertical: Constant.paddingOrMargin20),
            child: Widgets.defaultImg(image: "logo", iconColor: ColorsRes.appColor),
          ),
          Card(
            shape: DesignConfig.setRoundedBorder(10),
            margin: EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin15, vertical: Constant.paddingOrMargin15),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin15, vertical: Constant.paddingOrMargin15),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.all(10),
                      decoration: DesignConfig.boxDecoration(Theme.of(context).scaffoldBackgroundColor, 10),
                      child: Row(
                        children: [
                          Widgets.defaultImg(image: "mail_icon", iconColor: ColorsRes.grey, width: 25, height: 24),
                          SizedBox(
                            width: 10.0,
                          ),
                          Flexible(
                            child: TextField(
                              controller: edtEmail,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: ColorsRes.mainTextColor,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintStyle: TextStyle(color: Colors.grey[300]),
                                hintText: getTranslatedValue(context, "email"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Consumer<UserProfileProvider>(builder: (context, userProfileProvider, _) {
                      return Container(
                        padding: EdgeInsetsDirectional.all(10),
                        decoration: DesignConfig.boxDecoration(Theme.of(context).scaffoldBackgroundColor, 10),
                        child: Row(
                          children: [
                            Widgets.defaultImg(image: "password_icon", iconColor: ColorsRes.grey, width: 25, height: 24),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: TextField(
                                controller: edtPassword,
                                obscureText: userProfileProvider.hidePassword,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: ColorsRes.mainTextColor,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintStyle: TextStyle(color: Colors.grey[300]),
                                  hintText: getTranslatedValue(context, "password"),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                userProfileProvider.showHidePassword();
                              },
                              child: Widgets.defaultImg(image: userProfileProvider.hidePassword == true ? "hide_password" : "show_password", iconColor: ColorsRes.grey, width: 25, height: 24),
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: ColorsRes.appColor,
                          value: isAcceptedTerms,
                          onChanged: (bool? val) {
                            setState(() {
                              isAcceptedTerms = val!;
                            });
                          },
                        ),
                        //padding: const EdgeInsets.only(top: 15.0),
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.titleSmall!.merge(
                                    const TextStyle(fontWeight: FontWeight.w400),
                                  ),
                              text: "${getTranslatedValue(context, "agreement_message_1")}\t",
                              children: <TextSpan>[
                                TextSpan(
                                    text: getTranslatedValue(context, "terms_of_service"),
                                    style: TextStyle(
                                      color: ColorsRes.appColor,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(context, webViewScreen, arguments: getTranslatedValue(context, "terms_of_service"));
                                      }),
                                TextSpan(text: "\t${getTranslatedValue(context, "and")}\t"),
                                TextSpan(
                                    text: getTranslatedValue(context, "privacy_policy"),
                                    style: TextStyle(
                                      color: ColorsRes.appColor,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(context, webViewScreen, arguments: getTranslatedValue(context, "privacy_policy"));
                                      }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Widgets.getSizedBox(height: 40),
                    Consumer<UserProfileProvider>(
                      builder: (context, userProfileProvider, _) {
                        return Widgets.gradientBtnWidget(
                          context,
                          10,
                          otherWidgets: userProfileProvider.loginState == LoginState.loading
                              ? Center(
                                  child: CircularProgressIndicator(color: ColorsRes.appColorWhite),
                                )
                              : Text(
                                  getTranslatedValue(context, "login"),
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.titleMedium!.merge(
                                        TextStyle(color: Colors.white, letterSpacing: 0.5, fontWeight: FontWeight.w500),
                                      ),
                                ),
                          callback: () {
                            if (!isAcceptedTerms) {
                              GeneralMethods.showSnackBarMsg(context, getTranslatedValue(context, "accept_terms_condition_message"));
                            } else if (edtPassword.text.toString().isEmpty) {
                              GeneralMethods.showSnackBarMsg(
                                context,
                                "${getTranslatedValue(context, "enter_valid")} ${getTranslatedValue(context, "password")}",
                              );
                            } else if (edtEmail.text.toString().isEmpty ||
                                GeneralMethods.validateEmail(
                                      edtEmail.text.toString(),
                                    ) !=
                                    null) {
                              GeneralMethods.showSnackBarMsg(
                                context,
                                "${getTranslatedValue(context, "enter_valid")} ${getTranslatedValue(context, "email")}",
                              );
                            } else {
                              Map<String, String> params = {};
                              Constant.session.setData(SessionManager.password, edtPassword.text.toString(), false);
                              params[ApiAndParams.email] = edtEmail.text.toString();
                              params[ApiAndParams.password] = edtPassword.text.toString();
                              params[ApiAndParams.type] = Constant.session.isSeller() ? "3" : "4";
                              params[ApiAndParams.fcmToken] = Constant.session.getData(SessionManager.keyFCMToken);

                              userProfileProvider.loginApiProvider(params, context).then(
                                (value) async {
                                  if (value!.isNotEmpty) {
                                    if(Constant.session.getData(SessionManager.appThemeName).isEmpty) {
                                      Constant.session.setData(
                                          SessionManager.appThemeName,
                                          Constant.themeList[0],
                                          true);
                                    }
                                    Constant.session.setUserData(value).then(
                                      (value) {
                                        Navigator.of(context).pushNamedAndRemoveUntil(mainHomeScreen, (Route<dynamic> route) => false);
                                      },
                                    );
                                  }
                                },
                              );
                            }
                          },
                        );
                      },
                    ),
                    Widgets.getSizedBox(height: 40),
                    Consumer<UserProfileProvider>(
                      builder: (context, userProfileProvider, _) {
                        return Widgets.gradientBtnWidget(
                          context,
                          10,
                          otherWidgets: Text(
                            getTranslatedValue(context, "register"),
                            softWrap: true,
                            style: Theme.of(context).textTheme.titleMedium!.merge(
                                  TextStyle(color: Colors.white, letterSpacing: 0.5, fontWeight: FontWeight.w500),
                                ),
                          ),
                          callback: () {
                            Navigator.of(context).pushNamed(registerAccountScreen);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
