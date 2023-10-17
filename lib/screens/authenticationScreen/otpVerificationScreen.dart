import 'package:lokale_mand/helper/utils/generalImports.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String otpVerificationId;
  final String phoneNumber;
  final FirebaseAuth firebaseAuth;
  final CountryCode selectedCountryCode;
  final String? from;

  const OtpVerificationScreen({
    Key? key,
    required this.otpVerificationId,
    required this.phoneNumber,
    required this.firebaseAuth,
    required this.selectedCountryCode,
    this.from,
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<OtpVerificationScreen> {
  String editOtp = "";
  bool isDark = Constant.session.getBoolData(SessionManager.isDarkTheme);
  int otpLength = 6;
  int otpResendTime = Constant.otpResendSecond + 1;
  Timer? _timer;
  bool isLoading = false;
  String resendOtpVerificationId = "";
  OtpFieldController otpFieldController = OtpFieldController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      if (mounted) {
        otpFieldController.set(['1', '2', '3', '4', '5', '6']);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.size10, vertical: Constant.size20),
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).width * 0.6),
                child: Widgets.defaultImg(
                  image: "logo",
                ),
              ),
            ),
            Card(
              shape: DesignConfig.setRoundedBorder(10),
              margin: EdgeInsets.symmetric(
                  horizontal: Constant.size5, vertical: Constant.size5),
              child: otpWidgets(),
            ),
          ],
        ),
      ),
    );
  }

  otpWidgets() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Constant.size30, horizontal: Constant.size30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        headerWidget(
          getTranslatedValue(
            context,
            "enter_verification_code",
          ),
          getTranslatedValue(
            context,
            "otp_send_message",
          ),
        ),
        CustomTextLabel(
          text: "${widget.selectedCountryCode}-${widget.phoneNumber}",
        ),
        const SizedBox(height: 30),
        otpPinWidget(),
        const SizedBox(height: 30),
        proceedBtn(),
        const SizedBox(height: 30),
        resendOtpWidget(),
      ]),
    );
  }

  resendOtpWidget() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.titleSmall!.merge(
                TextStyle(
                  fontWeight: FontWeight.w400,
                  color: ColorsRes.mainTextColor,
                ),
              ),
          text: "${getTranslatedValue(
            context,
            "did_not_get_code",
          )}\t",
          children: <TextSpan>[
            TextSpan(
                text: _timer != null && _timer!.isActive
                    ? otpResendTime.toString()
                    : getTranslatedValue(
                        context,
                        "resend_otp",
                      ),
                style: TextStyle(
                    color: ColorsRes.appColor, fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (_timer == null || !_timer!.isActive) {
                      firebaseLoginProcess();
                      startResendTimer();
                    }
                  }),
          ],
        ),
      ),
    );
  }

  proceedBtn() {
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
              "verify_and_proceed",
            ),
            callback: () async {
              await checkOtpValidation().then((msg) {
                if (msg != "") {
                  setState(() {
                    isLoading = false;
                  });
                  GeneralMethods.showMessage(context, msg, MessageType.warning);
                } else {
                  setState(() {
                    isLoading = false;
                  });
                  verifyOtp();
                }
              });
            },
          );
  }

  headerWidget(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomTextLabel(
        text: title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: ColorsRes.mainTextColor,
        ),
      ),
      subtitle: CustomTextLabel(
        text: subtitle,
        style: TextStyle(color: ColorsRes.grey),
      ),
    );
  }

  verifyOtp() async {
    setState(() {
      isLoading = true;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: resendOtpVerificationId.isNotEmpty
              ? resendOtpVerificationId
              : widget.otpVerificationId,
          smsCode: editOtp);

      widget.firebaseAuth.signInWithCredential(credential).then((value) {
        User? user = value.user;
        backendApiProcess(user);
      }).catchError((e) {
        GeneralMethods.showMessage(
          context,
          getTranslatedValue(
            context,
            "enter_valid_otp",
          ),
          MessageType.warning,
        );
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  backendApiProcess(User? user) async {
    if (user != null) {
      Constant.session.setData(SessionManager.keyAuthUid, user.uid, false);
      Map<String, String> params = {
        ApiAndParams.mobile: widget.phoneNumber,
        // ApiAndParams.authUid: "123456", // Temp used for testing
        ApiAndParams.authUid: user.uid, // In live this will use
        ApiAndParams.countryCode: widget.selectedCountryCode.dialCode
                ?.replaceAll("+", "")
                .toString() ??
            "",
        // In live this will use
        ApiAndParams.fcmToken:
            Constant.session.getData(SessionManager.keyFCMToken)
      };

      await context
          .read<UserProfileProvider>()
          .loginApi(context: context, params: params)
          .then((value) => getRedirection(value));
    }
  }

  getRedirection(String status) async {
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
  }

  Widget otpPinWidget() {
    return OTPTextField(
      length: otpLength,
      controller: otpFieldController,
      fieldWidth: MediaQuery.sizeOf(context).width * 0.12,
      width: MediaQuery.sizeOf(context).width,
      textFieldAlignment: MainAxisAlignment.spaceEvenly,
      fieldStyle: FieldStyle.box,
      outlineBorderRadius: 10,
      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
      otpFieldStyle: OtpFieldStyle(
          borderColor: ColorsRes.appColor,
          enabledBorderColor: ColorsRes.appColor),
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: ColorsRes.appColor,
        fontWeight: FontWeight.bold,
      ),
      onChanged: (value) {
        editOtp = value;
      },
      onCompleted: (value) {
        editOtp = value;
      },
    );
  }

  Future checkOtpValidation() async {
    bool checkInternet = await GeneralMethods.checkInternet();
    String? msg;
    if (checkInternet) {
      if (editOtp.length == 1) {
        msg = getTranslatedValue(
          context,
          "enter_otp",
        );
      } else if (editOtp.length < otpLength) {
        msg = getTranslatedValue(
          context,
          "enter_valid_otp",
        );
      } else {
        if (isLoading) return;
        setState(() {
          isLoading = true;
        });
        msg = "";
      }
    } else {
      msg = getTranslatedValue(
        context,
        "check_internet",
      );
    }
    return msg;
  }

  firebaseLoginProcess() async {
    if (widget.phoneNumber.isNotEmpty) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: Constant.otpTimeOutSecond),
        phoneNumber:
            '${widget.selectedCountryCode.dialCode} - ${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          if (mounted) {
            isLoading = false;
            setState(() {});
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          if (mounted) {
            isLoading = false;
            setState(() {
              resendOtpVerificationId = verificationId;
            });
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (mounted) {
            isLoading = false;
            setState(() {
              // isLoading = false;
            });
          }
        },
      );
    }
  }

  void startResendTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          if (otpResendTime == 0) {
            timer.cancel();
            Constant.otpResendSecond + 1;
          } else {
            otpResendTime--;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
