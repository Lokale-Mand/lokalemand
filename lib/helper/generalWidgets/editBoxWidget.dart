import 'package:lokale_mand/helper/utils/generalImports.dart';

Widget editBoxWidget(
    BuildContext context,
    TextEditingController edtController,
    Function validationFunction,
    String label,
    String errorLabel,
    TextInputType inputType,
    {Widget? tailIcon,
    bool? isLastField,
    bool? isEditable = true,
    List<TextInputFormatter>? inputFormatters,
    TextInputAction? optionalTextInputAction,
    int? minLines,
    int? maxLines}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        enabled: isEditable,
        style: TextStyle(
          color: ColorsRes.mainTextColor,
        ),
        controller: edtController,
        maxLines: maxLines,
        minLines: minLines,
        textInputAction: optionalTextInputAction ??
            (isLastField == true ? TextInputAction.done : TextInputAction.next),
        decoration: InputDecoration(
          suffixIcon: tailIcon,
          fillColor: Theme.of(context).cardColor,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: ColorsRes.appColor,
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: ColorsRes.menuTitleColor,
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: ColorsRes.appColorRed,
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: ColorsRes.menuTitleColor,
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: ColorsRes.menuTitleColor.withOpacity(0.5),
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          labelText: label,
          labelStyle: TextStyle(color: ColorsRes.menuTitleColor),
          isDense: true,
          floatingLabelStyle: WidgetStateTextStyle.resolveWith(
            (Set<WidgetState> states) {
              final Color color = states.contains(WidgetState.error)
                  ? Theme.of(context).colorScheme.error
                  : ColorsRes.appColor;
              return TextStyle(color: color, letterSpacing: 1.3);
            },
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: inputType,
        inputFormatters: inputFormatters ?? [],
        validator: (String? value) {
          return validationFunction(value ?? "") == null ? null : errorLabel;
        },
      )
    ],
  );
}
