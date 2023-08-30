import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
Widget editBoxWidget(
    {required BuildContext context,
    required TextEditingController edtController,
    required Function validationFunction,
    required String label,
    required TextInputType inputType,
    Widget? tailIcon,
    bool? isEditable = true}) {
  return Widgets.textFieldWidget(
    edtController,
    validationFunction,
    label,
    inputType,
    "${getTranslatedValue(context, "enter_valid")} $label",
    context,
    floatingLbl: false,
    borderRadius: 8,
    iseditable: isEditable ?? true,
    hint: label,
    ticon: tailIcon ?? SizedBox.shrink(),
    bgcolor: Theme.of(context).scaffoldBackgroundColor,
    contentPadding: EdgeInsets.symmetric(
        vertical: Constant.paddingOrMargin18,
        horizontal: Constant.paddingOrMargin8),
  );
}
