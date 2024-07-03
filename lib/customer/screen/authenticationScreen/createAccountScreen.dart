import 'package:lokale_mand/helper/generalWidgets/customCheckbox.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class CreateAccountScreen extends StatefulWidget {
  final String? from;

  const CreateAccountScreen({Key? key, this.from}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  CountryCode? selectedCountryCode;
  bool isLoading = false,
      isAcceptedTerms = false,
      isPasswordVisible = false,
      isConfirmPasswordVisible = false;
  TextEditingController edtEmail = TextEditingController();
  TextEditingController edtPassword = TextEditingController();
  TextEditingController edtDuplicatePassword = TextEditingController();
  TextEditingController edtFullName = TextEditingController();
  TextEditingController edtPhoneNumber = TextEditingController();
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
      bottomNavigationBar: Container(
        constraints: BoxConstraints(
          maxHeight: 60,
        ),
        padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
        child: StepperCounter(
          firstCounterText: "back",
          firstItemVoidCallback: () => Navigator.pop(context),
          // secondCounterText: "1/2",
          thirdCounterText: "ready",
          thirdItemVoidCallback: () => createAccountProcess(),
        ),
      ),
      body: Container(
        padding: EdgeInsetsDirectional.all(20),
        alignment: Alignment.center,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              createAccountWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget createAccountWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextLabel(
          jsonKey: "create_your_account",
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
          jsonKey: "full_name",
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
          child: TextField(
            controller: edtFullName,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(
                color: ColorsRes.mainTextColor.withOpacity(0.3),
              ),
              hintText: "Lokale Mand",
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        CustomTextLabel(
          jsonKey: "mobile",
          style: TextStyle(
            color: ColorsRes.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        mobileNoWidget(),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        CustomTextLabel(
          jsonKey: "email",
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
          child: TextField(
            controller: edtEmail,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(color: ColorsRes.mainTextColor.withOpacity(0.3)),
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
                    hintStyle: TextStyle(color: ColorsRes.mainTextColor.withOpacity(0.3)),
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
          height: Constant.size20,
        ),
        CustomTextLabel(
          jsonKey: "duplicate_password",
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
                  controller: edtDuplicatePassword,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                  ),
                  obscureText: isConfirmPasswordVisible ? false : true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: TextStyle(color: ColorsRes.mainTextColor.withOpacity(0.3)),
                    hintText: "******",
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(
                    () {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    },
                  );
                },
                child: Icon(
                  isConfirmPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: ColorsRes.subTitleMainTextColor,
                ),
              ),
            ],
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size50,
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
      ],
    );
  }

  mobileNoWidget() {
    return Container(
      padding: EdgeInsetsDirectional.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: ColorsRes.textFieldBorderColor,
          ),
          color: Theme.of(context).cardColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IgnorePointer(
            ignoring: isLoading,
            child: CountryCodePicker(
              onInit: (countryCode) {
                selectedCountryCode = countryCode;
              },
              onChanged: (countryCode) {
                selectedCountryCode = countryCode;
              },
              initialSelection: Constant.initialCountryCode,
              textOverflow: TextOverflow.ellipsis,
              showCountryOnly: false,
              alignLeft: false,
              backgroundColor: Theme.of(context).cardColor,
              textStyle: TextStyle(color: ColorsRes.mainTextColor),
              dialogBackgroundColor: Theme.of(context).cardColor,
              dialogSize: Size(context.width, context.height),
              barrierColor: ColorsRes.subTitleMainTextColor,
              padding: EdgeInsets.zero,
              searchDecoration: InputDecoration(
                iconColor: ColorsRes.subTitleMainTextColor,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  BorderSide(color: ColorsRes.subTitleMainTextColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  BorderSide(color: ColorsRes.subTitleMainTextColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  BorderSide(color: ColorsRes.subTitleMainTextColor),
                ),
                focusColor: Theme.of(context).scaffoldBackgroundColor,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: ColorsRes.subTitleMainTextColor,
                ),
              ),
              searchStyle: TextStyle(
                color: ColorsRes.subTitleMainTextColor,
              ),
              dialogTextStyle: TextStyle(
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: ColorsRes.grey,
            size: 15,
          ),
          SizedBox(
            width: Constant.size10,
          ),
          Expanded(
            child: TextField(
              controller: edtPhoneNumber,
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
                hintStyle: TextStyle(color: ColorsRes.mainTextColor.withOpacity(0.3)),
                hintText: "9999999999",
              ),
            ),
          ),
        ],
      ),
    );
  }

  void createAccountProcess() async {
    try {
      if (edtEmail.text.isEmpty &&
          GeneralMethods.validateEmail(edtEmail.text) != null) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "enter_valid_email"),
            MessageType.warning);
      } else if (edtPassword.text.contains(" ") ||
          edtDuplicatePassword.text.contains(" ")) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "password_should_not_contain_space"),
            MessageType.warning);
      } else if (edtPassword.text != edtDuplicatePassword.text) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(
                context, "password_and_confirm_password_does_not_matching"),
            MessageType.warning);
      } else if (!isAcceptedTerms) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "accept_terms_and_condition"),
            MessageType.warning);
      } else {
        UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: edtEmail.text,
          password: edtPassword.text,
        );

        User? user = userCredential.user;

        await user?.sendEmailVerification().onError(
          (error, stackTrace) {
            GeneralMethods.showMessage(
              context,
              stackTrace.toString(),
              MessageType.warning,
            );
            return null;
          },
        ).then((value) => backendApiProcess(user));
      }
    } catch (e) {
      GeneralMethods.showMessage(context, e.toString(), MessageType.warning);
    }
  }

  backendApiProcess(User? user) async {
    if (user != null) {
      Constant.session.setData(SessionManager.keyAuthUid, user.uid, false);
      Map<String, String> params = {
        ApiAndParams.name: edtFullName.text.toString(),
        ApiAndParams.email: edtEmail.text.toString(),
        ApiAndParams.password: edtPassword.text.toString(),
        ApiAndParams.authUid: user.uid,
        ApiAndParams.mobile: edtPhoneNumber.text.toString(),
        ApiAndParams.countryCode: selectedCountryCode?.code.toString() ?? "",
        ApiAndParams.fcmToken:
            Constant.session.getData(SessionManager.keyFCMToken),
      };

      await context
          .read<UserProfileProvider>()
          .loginApi(context: context, params: params)
          .then((value) {
        GeneralMethods.showMessage(
          context,
          getTranslatedValue(context, "you_will_received_verification_mail"),
          MessageType.warning,
        );
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    edtPassword.dispose();
    edtDuplicatePassword.dispose();
    edtEmail.dispose();
    edtPhoneNumber.dispose();
    edtFullName.dispose();
    super.dispose();
  }
}
