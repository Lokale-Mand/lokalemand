import 'package:lokale_mand/helper/generalWidgets/customCheckbox.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class LoginAccount extends StatefulWidget {
  final String? from;

  const LoginAccount({Key? key, this.from}) : super(key: key);

  @override
  State<LoginAccount> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<LoginAccount> {
  bool isLoading = false, isAcceptedTerms = false, isPasswordVisible = false;

  TextEditingController edtEmail = TextEditingController();
  TextEditingController edtPassword = TextEditingController();
  bool isDark = Constant.session.getBoolData(SessionManager.isDarkTheme);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: getAppBar(
        context: context,
        title: Container(),
        actions: [
          skipLoginText(),
        ],
      ),
      body: Container(
        padding: EdgeInsetsDirectional.all(20),
        alignment: Alignment.center,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              loginWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  proceedButtonWidget() {
    return isLoading
        ? Container(
            height: 55,
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          )
        : Widgets.gradientBtnWidget(
            context,
            10,
            title: getTranslatedValue(
              context,
              "login",
            ).toUpperCase(),
            height: 55,
            callback: () async {
              setLoader(true);
              if (edtEmail.text.isEmpty ||
                  GeneralMethods.validateEmail(edtEmail.text) != null) {
                setLoader(false);
                GeneralMethods.showMessage(
                    context,
                    getTranslatedValue(context, "enter_valid_email"),
                    MessageType.warning);
              } else if (edtPassword.text.isEmpty) {
                setLoader(false);
                GeneralMethods.showMessage(
                    context,
                    getTranslatedValue(context, "enter_valid_password"),
                    MessageType.warning);
              } else if (edtPassword.text.contains(" ")) {
                setLoader(false);
                GeneralMethods.showMessage(
                    context,
                    getTranslatedValue(
                        context, "password_should_not_contain_space"),
                    MessageType.warning);
              } else if (!isAcceptedTerms) {
                setLoader(false);
                GeneralMethods.showMessage(
                    context,
                    getTranslatedValue(context, "accept_terms_and_condition"),
                    MessageType.warning);
              } else {
                try {
                  UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: edtEmail.text,
                    password: edtPassword.text,
                  );

                  User? user = userCredential.user;
                  if (user != null && !user.emailVerified) {
                    setLoader(false);
                    GeneralMethods.showMessage(
                        context,
                        getTranslatedValue(context,
                            "please_complete_mail_verification_first_from_mail"),
                        MessageType.warning);
                  } else {
                    backendApiProcess(user);
                  }
                } catch (e) {
                  setLoader(false);
                  GeneralMethods.showMessage(
                      context, e.toString(), MessageType.warning);
                }
              }
            },
          );
  }

  setLoader(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  skipLoginText() {
    return GestureDetector(
      onTap: () async {
        if (isLoading == false) {
          Constant.session
              .setBoolData(SessionManager.keySkipLogin, true, false);
          await getRedirection();
        }
      },
      child: Container(
        alignment: AlignmentDirectional.centerEnd,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomTextLabel(
              jsonKey: "skip_login",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color:
                      isLoading == false ? ColorsRes.appColor : ColorsRes.grey,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: ColorsRes.appColor,
            )
          ],
        ),
      ),
    );
  }

  Widget loginWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextLabel(
          jsonKey: "login_account",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: ColorsRes.mainTextColor,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        CustomTextLabel(
          jsonKey: "email",
          style: TextStyle(
              color: ColorsRes.mainTextColor, fontWeight: FontWeight.w500),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        Container(
          padding: EdgeInsetsDirectional.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorsRes.textFieldBorderColor,
              ),
              color: Theme.of(context).cardColor),
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
              hintText: "lokale-mand@mail.com",
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        CustomTextLabel(
          jsonKey: "password",
          style: TextStyle(
            color: ColorsRes.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        Container(
          padding: EdgeInsetsDirectional.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorsRes.textFieldBorderColor,
              ),
              color: Theme.of(context).cardColor),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: edtPassword,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                  ),
                  obscureText: isPasswordVisible ? false : true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    hintText: "******",
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(
                    () {
                      isPasswordVisible = !isPasswordVisible;
                    },
                  );
                },
                child: Icon(
                  isPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: ColorsRes.subTitleMainTextColor,
                ),
              ),
            ],
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        Container(
          alignment: AlignmentDirectional.centerEnd,
          child: RichText(
            softWrap: true,
            text: TextSpan(
              style: Theme.of(context).textTheme.titleSmall!.merge(
                    TextStyle(
                      fontWeight: FontWeight.w400,
                      color: ColorsRes.mainTextColor,
                    ),
                  ),
              text: "${getTranslatedValue(
                context,
                "verification_mail_expired",
              )}\t",
              children: <TextSpan>[
                TextSpan(
                  text: getTranslatedValue(context, "click_here"),
                  style: TextStyle(
                      color: ColorsRes.appColor,
                      decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => resendVerificationEmail(
                        edtEmail.text.toString(), edtPassword.text.toString()),
                ),
              ],
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCheckbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              value: isAcceptedTerms,
              activeColor: ColorsRes.appColor,
              onChanged: (bool? val) {
                setState(
                  () {
                    isAcceptedTerms = val!;
                  },
                );
              },
            ),
            Expanded(
              child: RichText(
                softWrap: true,
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleSmall!.merge(
                        TextStyle(
                          fontWeight: FontWeight.w400,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                  text: "${getTranslatedValue(
                    context,
                    "agreement_message_1",
                  )}\t",
                  children: <TextSpan>[
                    TextSpan(
                      text: context
                          .read<LanguageProvider>()
                          .currentLanguage["terms_of_service"],
                      style: TextStyle(
                        color: ColorsRes.appColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            webViewScreen,
                            arguments: getTranslatedValue(
                              context,
                              "terms_and_conditions",
                            ),
                          );
                        },
                    ),
                    TextSpan(
                        text: "\t${getTranslatedValue(
                          context,
                          "and",
                        )}\t",
                        style: TextStyle(
                          color: ColorsRes.mainTextColor,
                        )),
                    TextSpan(
                      text: context
                          .read<LanguageProvider>()
                          .currentLanguage["privacy_policy"],
                      style: TextStyle(
                        color: ColorsRes.appColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            webViewScreen,
                            arguments: getTranslatedValue(
                              context,
                              "privacy_policy",
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        proceedButtonWidget(),
        Widgets.getSizedBox(height: 20),
        Widgets.gradientBtnWidget(
          context,
          10,
          title: getTranslatedValue(
            context,
            "register",
          ).toUpperCase(),
          height: 55,
          callback: () {
            Navigator.pushNamed(
              context,
              createAccountScreen,
            );
          },
        ),
      ],
    );
  }

  Future<void> resendVerificationEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .onError(
            (error, stackTrace) => GeneralMethods.showMessage(
              context,
              stackTrace.toString(),
              MessageType.warning,
            ),
          );

      if (userCredential.user != null) {
        if (!userCredential.user!.emailVerified) {
          await userCredential.user!.sendEmailVerification();
          print("Verification email sent to $email");
        } else {
          print("Email is already verified.");
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  backendApiProcess(User? user) async {
    if (user != null) {
      Constant.session.setData(SessionManager.keyAuthUid, user.uid, false);
      Map<String, String> params = {
        ApiAndParams.email: edtEmail.text.toString(),
        ApiAndParams.password: edtPassword.text.toString(),
        ApiAndParams.authUid: user.uid,
        ApiAndParams.fcmToken:
            Constant.session.getData(SessionManager.keyFCMToken)
      };

      await context
          .read<UserProfileProvider>()
          .loginApi(context: context, params: params)
          .then((value) => getRedirection(status: value));
    }
  }

  getRedirection({String? status}) async {
    Constant.session.setData(SessionManager.keyEmail, edtEmail.text, false);
    Constant.session
        .setData(SessionManager.keyPassword, edtPassword.text, false);

    if (status != null) {
      setState(() {
        isLoading = false;
      });
      if (status == "2") {
        Navigator.of(context)
            .pushNamed(editProfileScreen, arguments: widget.from ?? "register");
      } else {
        if (widget.from == "add_to_cart") {
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
            Constant.session.getBoolData(SessionManager.isUserLogin)) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            mainHomeScreen,
            (Route<dynamic> route) => false,
          );
        }
      }
    } else {
      if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
          Constant.session.getBoolData(SessionManager.isUserLogin)) {
        if (Constant.session.getData(SessionManager.keyUserName).isNotEmpty) {
          Navigator.pushReplacementNamed(
            context,
            mainHomeScreen,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            mainHomeScreen,
            (route) => false,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    edtPassword.dispose();
    edtEmail.dispose();
    super.dispose();
  }
}
