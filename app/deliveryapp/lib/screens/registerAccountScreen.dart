import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterAccountScreen extends StatefulWidget {
  RegisterAccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterAccountScreen> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController edtUserName = TextEditingController(text: "test");
  late TextEditingController edtEmail = TextEditingController(text: "test.seller@gmail.com");
  late TextEditingController edtMobile = TextEditingController(text: "9876543211");
  late TextEditingController edtPassword = TextEditingController(text: "123");
  late TextEditingController edtConfirmPassword = TextEditingController(text: "123");
  bool isLoading = false;

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
          getTranslatedValue(context, "register"),
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: ListView(
        children: [
          Card(
            shape: DesignConfig.setRoundedBorder(10),
            margin: EdgeInsets.symmetric(
                horizontal: Constant.paddingOrMargin15,
                vertical: Constant.paddingOrMargin15),
            child: Container(
              alignment: AlignmentDirectional.center,
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.paddingOrMargin15,
                  vertical: Constant.paddingOrMargin15),
              child: Form(
                key: _formKey,
                child: ListView(shrinkWrap: true, children: [
                  Container(
                    padding: EdgeInsetsDirectional.all(10),
                    decoration: DesignConfig.boxDecoration(
                        Theme.of(context).scaffoldBackgroundColor, 10),
                    child: Row(
                      children: [
                        Widgets.defaultImg(
                            image: "user_icon",
                            iconColor: ColorsRes.grey,
                            width: 25,
                            height: 25),
                        SizedBox(
                          width: 10.0,
                        ),
                        Flexible(
                          child: TextField(
                            controller: edtUserName,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: ColorsRes.mainTextColor,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintStyle: TextStyle(color: Colors.grey[300]),
                              hintText:
                                  getTranslatedValue(context, "user_name"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Widgets.getSizedBox(height: 15),
                  Container(
                    padding: EdgeInsetsDirectional.all(10),
                    decoration: DesignConfig.boxDecoration(
                        Theme.of(context).scaffoldBackgroundColor, 10),
                    child: Row(
                      children: [
                        Widgets.defaultImg(
                            image: "mail_icon",
                            iconColor: ColorsRes.grey,
                            width: 25,
                            height: 24),
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
                  Widgets.getSizedBox(height: 15),
                  Container(
                    padding: EdgeInsetsDirectional.all(10),
                    decoration: DesignConfig.boxDecoration(
                        Theme.of(context).scaffoldBackgroundColor, 10),
                    child: Row(
                      children: [
                        Widgets.defaultImg(
                            image: "phone_icon",
                            iconColor: ColorsRes.grey,
                            width: 25,
                            height: 24),
                        SizedBox(
                          width: 10.0,
                        ),
                        Flexible(
                          child: TextField(
                            controller: edtMobile,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: TextStyle(
                              color: ColorsRes.mainTextColor,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintStyle: TextStyle(color: Colors.grey[300]),
                              hintText: getTranslatedValue(context, "mobile"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Widgets.getSizedBox(height: 15),
                  Consumer<UserProfileProvider>(
                      builder: (context, userProfileProvider, _) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsetsDirectional.all(10),
                          decoration: DesignConfig.boxDecoration(
                              Theme.of(context).scaffoldBackgroundColor, 10),
                          child: Row(
                            children: [
                              Widgets.defaultImg(
                                  image: "password_icon",
                                  iconColor: ColorsRes.grey,
                                  width: 25,
                                  height: 24),
                              Widgets.getSizedBox(width: 10),
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
                                    hintStyle:
                                        TextStyle(color: Colors.grey[300]),
                                    hintText:
                                        getTranslatedValue(context, "password"),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  userProfileProvider.showHidePassword();
                                },
                                child: Widgets.defaultImg(
                                    image:
                                        userProfileProvider.hidePassword == true
                                            ? "hide_password"
                                            : "show_password",
                                    iconColor: ColorsRes.grey,
                                    width: 25,
                                    height: 24),
                              ),
                            ],
                          ),
                        ),
                        Widgets.getSizedBox(height: 15),
                        Container(
                          padding: EdgeInsetsDirectional.all(10),
                          decoration: DesignConfig.boxDecoration(
                              Theme.of(context).scaffoldBackgroundColor, 10),
                          child: Row(
                            children: [
                              Widgets.defaultImg(
                                  image: "password_icon",
                                  iconColor: ColorsRes.grey,
                                  width: 25,
                                  height: 24),
                              Widgets.getSizedBox(width: 10),
                              Flexible(
                                child: TextField(
                                  controller: edtConfirmPassword,
                                  obscureText: userProfileProvider.hidePassword,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: ColorsRes.mainTextColor,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[300]),
                                    hintText: getTranslatedValue(
                                        context, "confirm_password"),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  userProfileProvider.showHidePassword();
                                },
                                child: Widgets.defaultImg(
                                    image:
                                        userProfileProvider.hidePassword == true
                                            ? "hide_password"
                                            : "show_password",
                                    iconColor: ColorsRes.grey,
                                    width: 25,
                                    height: 24),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  Widgets.getSizedBox(height: 40),
                  Consumer<UserProfileProvider>(
                    builder: (context, userProfileProvider, _) {
                      return Widgets.gradientBtnWidget(
                        context,
                        10,
                        otherWidgets: userProfileProvider.registerState ==
                                RegisterState.loading
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: ColorsRes.appColorWhite),
                              )
                            : Text(
                                getTranslatedValue(context, "register"),
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .merge(
                                      TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500),
                                    ),
                              ),
                        callback: () {
                          if (edtPassword.text.toString().isEmpty) {
                            GeneralMethods.showSnackBarMsg(
                              context,
                              "${getTranslatedValue(context, "enter_valid")} ${getTranslatedValue(context, "password")}",
                            );
                          } else if (edtConfirmPassword.text
                              .toString()
                              .isEmpty) {
                            GeneralMethods.showSnackBarMsg(
                              context,
                              "${getTranslatedValue(context, "enter_valid")} ${getTranslatedValue(context, "confirm_password")}",
                            );
                          } else if (edtPassword.text.toString().compareTo(
                                  edtConfirmPassword.text.toString()) !=
                              0) {
                            GeneralMethods.showSnackBarMsg(
                              context,
                              getTranslatedValue(context,
                                  "password_and_confirm_password_does_not_match"),
                            );
                          } else if (edtUserName.text.toString().isEmpty) {
                            GeneralMethods.showSnackBarMsg(
                              context,
                              "${getTranslatedValue(context, "enter_valid")} ${getTranslatedValue(context, "user_name")}",
                            );
                          } else if (GeneralMethods.validateEmail(
                                edtEmail.text.toString(),
                              ) !=
                              null) {
                            GeneralMethods.showSnackBarMsg(
                              context,
                              "${getTranslatedValue(context, "enter_valid")} ${getTranslatedValue(context, "email")}",
                            );
                          } else if (edtMobile.text.toString().isEmpty ||
                              edtMobile.text.toString().trim().length > 15) {
                            GeneralMethods.showSnackBarMsg(
                              context,
                              "${getTranslatedValue(context, "enter_valid")} ${getTranslatedValue(context, "mobile_number")}",
                            );
                          } else {
                            Map<String, String> params = {};
                            params[ApiAndParams.userName] =
                                edtUserName.text.toString();
                            params[ApiAndParams.email] =
                                edtEmail.text.toString();
                            params[ApiAndParams.mobile] =
                                edtMobile.text.toString();
                            params[ApiAndParams.password] =
                                edtPassword.text.toString();
                            params[ApiAndParams.confirmationPassword] =
                                edtConfirmPassword.text.toString();

                            userProfileProvider
                                .getRegisterUserApiProvider(params, context)
                                .then((value) {
                              if (value is bool) {
                                Navigator.pop(context);
                              }
                            });
                          }
                        },
                      );
                    },
                  ),
                ]),
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
