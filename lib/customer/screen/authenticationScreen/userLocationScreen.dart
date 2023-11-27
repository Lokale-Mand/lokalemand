import 'package:lokale_mand/helper/utils/generalImports.dart';

class UserLocationScreen extends StatefulWidget {
  final email, password;
  final User user;

  const UserLocationScreen({
    Key? key,
    required this.email,
    required this.password,
    required this.user,
  }) : super(key: key);

  @override
  State<UserLocationScreen> createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  CountryCode? selectedCountryCode;
  bool isLoading = false;
  TextEditingController edtFullName = TextEditingController();
  TextEditingController edtPhoneNumber = TextEditingController();
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
          secondCounterText: "2/2",
          thirdCounterText: "next",
          thirdItemVoidCallback: () => backendApiProcess(widget.user),
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
              userDetailsWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  mobileNoWidget() {
    return Row(
      children: [
        const SizedBox(width: 5),
        Icon(
          Icons.phone_android,
          color: ColorsRes.mainTextColor,
        ),
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
            dialogSize: Size(MediaQuery.sizeOf(context).width,
                MediaQuery.sizeOf(context).height * 0.9),
            padding: EdgeInsets.zero,
          ),
        ),
        Icon(
          Icons.keyboard_arrow_down,
          color: ColorsRes.grey,
          size: 15,
        ),
        Widgets.getSizedBox(
          width: Constant.size10,
        ),
        Flexible(
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
    );
  }

  Widget userDetailsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Widgets.getSizedBox(
          height: Constant.size80,
        ),
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
            controller: edtFullName,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(color: Colors.grey[300]),
              hintText: "Lokale Mand",
            ),
          ),
        ),
        // Widgets.getSizedBox(
        //   height: Constant.size20,
        // ),
        // CustomTextLabel(
        //   jsonKey: "location",
        //   style: TextStyle(
        //       color: ColorsRes.mainTextColor, fontWeight: FontWeight.w500),
        // ),
        // Widgets.getSizedBox(
        //   height: Constant.size10,
        // ),
        // GestureDetector(
        //   onTap: () => Navigator.pushNamed(context, getLocationScreen,
        //       arguments: "location"),
        //   child: Container(
        //     padding: EdgeInsetsDirectional.all(10),
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         border: Border.all(
        //           color: ColorsRes.textFieldBorderColor,
        //         ),
        //         color: Theme.of(context).cardColor),
        //     child: Row(
        //       children: [
        //         Icon(
        //           Icons.near_me,
        //           color: ColorsRes.textFieldBorderColor,
        //           size: 25,
        //         ),
        //         Widgets.getSizedBox(
        //           width: 5,
        //         ),
        //         Expanded(
        //           child: TextField(
        //             controller: edtFullName,
        //             keyboardType: TextInputType.name,
        //             style: TextStyle(
        //               color: ColorsRes.mainTextColor,
        //             ),
        //             canRequestFocus: false,
        //             decoration: InputDecoration(
        //               border: InputBorder.none,
        //               isDense: true,
        //               hintStyle: TextStyle(color: Colors.grey[300]),
        //               hintText: "Current Position",
        //             ),
        //           ),
        //         ),
        //         Icon(Icons.arrow_drop_down,
        //             color: ColorsRes.textFieldBorderColor),
        //       ],
        //     ),
        //   ),
        // ),
        // Widgets.getSizedBox(
        //   height: Constant.size10,
        // ),
        // GestureDetector(
        //   onTap: () {
        //     showDialog<void>(
        //       context: context,
        //       builder: (BuildContext context) {
        //         return AlertDialog(
        //           title: CustomTextLabel(
        //             jsonKey: "why_is_this_relevant",
        //           ),
        //           content: const SingleChildScrollView(
        //             child: CustomTextLabel(
        //               jsonKey: "answer_why_is_this_relevant",
        //             ),
        //           ),
        //           actions: <Widget>[
        //             TextButton(
        //               child: CustomTextLabel(jsonKey: "got_it"),
        //               onPressed: () {
        //                 Navigator.of(context).pop();
        //               },
        //             ),
        //           ],
        //         );
        //       },
        //     );
        //   },
        //   child: Row(
        //     children: [
        //       CustomTextLabel(
        //         jsonKey: "why_is_this_relevant",
        //         style: TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w600,
        //           color: ColorsRes.subTitleMainTextColor,
        //           decoration: TextDecoration.underline,
        //         ),
        //       ),
        //       Widgets.getSizedBox(
        //         width: 5,
        //       ),
        //       Icon(
        //         Icons.arrow_forward,
        //         size: 15,
        //         color: ColorsRes.subTitleMainTextColor,
        //       )
        //     ],
        //   ),
        // ),
        // Widgets.getSizedBox(
        //   height: Constant.size20,
        // ),
      ],
    );
  }

  backendApiProcess(User? user) async {
    if (user != null) {
      Constant.session.setData(SessionManager.keyAuthUid, user.uid, false);
      Map<String, String> params = {
        ApiAndParams.email: widget.email,
        ApiAndParams.password: widget.password,
        ApiAndParams.authUid: user.uid,
        ApiAndParams.fcmToken:
            Constant.session.getData(SessionManager.keyFCMToken)
      };

      await context
          .read<UserProfileProvider>()
          .loginApi(context: context, params: params)
          .then((value) => getRedirection());
    }
  }

  getRedirection() async {
    if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
        Constant.session.getBoolData(SessionManager.isUserLogin)) {
      if (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
          Constant.session.getData(SessionManager.keyLongitude) == "0") {
        Navigator.pushReplacementNamed(context, getLocationScreen,
            arguments: "location");
      } else if (Constant.session
          .getData(SessionManager.keyUserName)
          .isNotEmpty) {
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

  @override
  void dispose() {
    edtPhoneNumber.dispose();
    edtFullName.dispose();
    super.dispose();
  }
}
