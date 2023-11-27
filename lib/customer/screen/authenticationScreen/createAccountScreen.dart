import 'package:lokale_mand/helper/utils/generalImports.dart';

class CreateAccountScreen extends StatefulWidget {
  final String? from;

  const CreateAccountScreen({Key? key, this.from}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  CountryCode? selectedCountryCode;
  bool isLoading = false, isPasswordVisible = false;
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
          secondCounterText: "1/2",
          thirdCounterText: "next",
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
                color: Colors.grey[300],
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
          child: TextField(
            controller: edtDuplicatePassword,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              value: isPasswordVisible,
              activeColor: ColorsRes.appColor,
              onChanged: (bool? val) {
                setState(
                  () {
                    isPasswordVisible = val!;
                  },
                );
              },
            ),
            Expanded(
              child: CustomTextLabel(
                jsonKey: isPasswordVisible ? "hide_password" : "show_password",
              ),
            ),
          ],
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
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
          CountryCodePicker(
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
            dialogSize: Size(MediaQuery.sizeOf(context).width,
                MediaQuery.sizeOf(context).height * 0.9),
            showDropDownButton: true,
            padding: EdgeInsets.zero,
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
                hintStyle: TextStyle(color: Colors.grey[300]),
                hintText: "9999999999",
              ),
            ),
          )
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
