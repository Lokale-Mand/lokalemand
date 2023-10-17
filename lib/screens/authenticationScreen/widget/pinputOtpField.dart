import 'package:lokale_mand/helper/utils/generalImports.dart';

class PinputOtpField extends StatefulWidget {
  PinputOtpField({Key? key}) : super(key: key);

  @override
  State<PinputOtpField> createState() => _PinputOtpFieldState();
}

class _PinputOtpFieldState extends State<PinputOtpField> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color focusedBorderColor = Colors.transparent;
    Color fillColor = Colors.transparent;
    Color borderColor = Colors.transparent;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 50,
      textStyle: TextStyle(
        color: ColorsRes.mainTextColor,
        fontWeight: FontWeight.w500
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10,
        ),
        border: Border.all(
          color: borderColor,
        ),
      ),
    );

    /// Optionally you can use form to validate the Pinput
    return Form(
      key: formKey,
      child: Directionality(
        // Specify direction if desired
        textDirection: TextDirection.ltr,
        child: Pinput(
          autofillHints: ['0','0','0','0','0','0'],
          length: 6,
          controller: pinController,
          focusNode: focusNode,
          pinAnimationType: PinAnimationType.fade,
          senderPhoneNumber: "9876543210",
          enableSuggestions: true,
          androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
          listenForMultipleSmsOnAndroid: true,
          defaultPinTheme: defaultPinTheme,
          validator: (value) {
            return null;
          },
          // onClipboardFound: (value) {
          //   debugPrint('onClipboardFound: $value');
          //   pinController.setText(value);
          // },
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          onCompleted: (pin) {
            debugPrint('onCompleted: $pin');
          },
          onChanged: (value) {
            debugPrint('onChanged: $value');
          },
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: 9,
                ),
                width: 22,
                height: 1,
                color: focusedBorderColor,
              ),
            ],
          ),
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              borderRadius: BorderRadius.circular(
                7,
              ),
              border: Border.all(color: focusedBorderColor),
            ),
          ),
          submittedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              color: fillColor,
              borderRadius: BorderRadius.circular(
                7,
              ),
              border: Border.all(
                color: focusedBorderColor,
              ),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          showCursor: false,
        ),
      ),
    );
  }
}
