import 'package:lokale_mand/helper/utils/generalImports.dart';

class SellerLoginAccountScreen extends StatefulWidget {
  final String? from;

  const SellerLoginAccountScreen({Key? key, this.from}) : super(key: key);

  @override
  State<SellerLoginAccountScreen> createState() =>
      _SellerLoginAccountScreenState();
}

class _SellerLoginAccountScreenState extends State<SellerLoginAccountScreen> {
  bool isLoading = false, isPasswordVisible = false;

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
      appBar: getAppBar(context: context, title: SizedBox.shrink()),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              hintStyle:
                  TextStyle(color: ColorsRes.mainTextColor.withOpacity(0.3)),
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
                    hintStyle: TextStyle(
                        color: ColorsRes.mainTextColor.withOpacity(0.3)),
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
        proceedButtonWidget(),
        Widgets.getSizedBox(height: 20),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        Align(
          alignment: AlignmentDirectional.center,
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
                "does_not_have_account",
              )}\t\t",
              children: <TextSpan>[
                TextSpan(
                  text: context
                      .read<LanguageProvider>()
                      .currentLanguage["register"],
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorsRes.appColor,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(
                        context,
                        sellerCreateAccountScreen,
                      );
                    },
                ),
              ],
            ),
          ),
        )
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
    Constant.session.setData(SessionManager.keyEmail, edtEmail.text, false);
    Constant.session
        .setData(SessionManager.keyPassword, edtPassword.text, false);

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
          .read<SellerProfileProvider>()
          .sellerLoginApi(context: context, params: params)
          .then((value) => getRedirection(status: value));
    }
  }

  getRedirection({String? status}) async {
    if (status != null) {
      setState(() {
        isLoading = false;
      });
      if (status == "1") {
        Navigator.pushNamedAndRemoveUntil(
          context,
          sellerMainHomeScreen,
          (route) => false,
        );
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
