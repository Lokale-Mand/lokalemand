import 'package:lokale_mand/helper/utils/generalImports.dart';

getPaymentMethods(
    PaymentMethodsData? paymentMethodsData, BuildContext context) {
  return paymentMethodsData != null
      ? Card(
          color: Theme.of(context).cardColor,
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.all(Constant.size10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslatedValue(
                    context,
                    "payment_method",
                  ),
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
                Widgets.getSizedBox(
                  height: Constant.size5,
                ),
                Widgets.getSizedBox(
                  height: Constant.size5,
                ),
                Column(
                  children: [
                    if (paymentMethodsData.codPaymentMethod == "1" &&
                        context.read<CheckoutProvider>().isCodAllowed == true)
                      GestureDetector(
                        onTap: () {
                          if (!context
                              .read<CheckoutProvider>()
                              .isPaymentUnderProcessing) {
                            context
                                .read<CheckoutProvider>()
                                .setSelectedPaymentMethod("COD");
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                          margin:
                              EdgeInsets.symmetric(vertical: Constant.size5),
                          decoration: BoxDecoration(
                            color: context
                                        .read<CheckoutProvider>()
                                        .selectedPaymentMethod ==
                                    "COD"
                                ? Constant.session
                                        .getBoolData(SessionManager.isDarkTheme)
                                    ? ColorsRes.appColorBlack
                                    : ColorsRes.appColorWhite
                                : Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.8),
                            borderRadius: Constant.borderRadius7,
                            border: Border.all(
                              width: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "COD"
                                  ? 1
                                  : 0.3,
                              color: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "COD"
                                  ? ColorsRes.appColor
                                  : ColorsRes.grey,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size10),
                                child: Widgets.defaultImg(
                                    image: "ic_cod", width: 25, height: 25),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size10),
                                child: Text(
                                  getTranslatedValue(
                                    context,
                                    "cash_on_delivery",
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Radio(
                                value: "COD",
                                groupValue: context
                                    .read<CheckoutProvider>()
                                    .selectedPaymentMethod,
                                activeColor: ColorsRes.appColor,
                                onChanged: (value) {
                                  if (!context
                                      .read<CheckoutProvider>()
                                      .isPaymentUnderProcessing) {
                                    context
                                        .read<CheckoutProvider>()
                                        .setSelectedPaymentMethod("COD");
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (paymentMethodsData.razorpayPaymentMethod == "1")
                      GestureDetector(
                        onTap: () {
                          if (!context
                              .read<CheckoutProvider>()
                              .isPaymentUnderProcessing) {
                            context
                                .read<CheckoutProvider>()
                                .setSelectedPaymentMethod("Razorpay");
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                          margin:
                              EdgeInsets.symmetric(vertical: Constant.size5),
                          decoration: BoxDecoration(
                            color: context
                                        .read<CheckoutProvider>()
                                        .selectedPaymentMethod ==
                                    "Razorpay"
                                ? Constant.session
                                        .getBoolData(SessionManager.isDarkTheme)
                                    ? ColorsRes.appColorBlack
                                    : ColorsRes.appColorWhite
                                : Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.8),
                            borderRadius: Constant.borderRadius7,
                            border: Border.all(
                              width: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "Razorpay"
                                  ? 1
                                  : 0.3,
                              color: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "Razorpay"
                                  ? ColorsRes.appColor
                                  : ColorsRes.grey,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size10),
                                child: Widgets.defaultImg(
                                    image: "ic_razorpay",
                                    width: 25,
                                    height: 25),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size10),
                                child: Text(
                                  getTranslatedValue(
                                    context,
                                    "razorpay",
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Radio(
                                value: "Razorpay",
                                groupValue: context
                                    .read<CheckoutProvider>()
                                    .selectedPaymentMethod,
                                activeColor: ColorsRes.appColor,
                                onChanged: (value) {
                                  if (!context
                                      .read<CheckoutProvider>()
                                      .isPaymentUnderProcessing) {
                                    context
                                        .read<CheckoutProvider>()
                                        .setSelectedPaymentMethod("Razorpay");
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (paymentMethodsData.paystackPaymentMethod == "1")
                      GestureDetector(
                        onTap: () {
                          if (!context
                              .read<CheckoutProvider>()
                              .isPaymentUnderProcessing) {
                            context
                                .read<CheckoutProvider>()
                                .setSelectedPaymentMethod("Paystack");
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                          margin:
                              EdgeInsets.symmetric(vertical: Constant.size5),
                          decoration: BoxDecoration(
                            color: context
                                        .read<CheckoutProvider>()
                                        .selectedPaymentMethod ==
                                    "Paystack"
                                ? Constant.session
                                        .getBoolData(SessionManager.isDarkTheme)
                                    ? ColorsRes.appColorBlack
                                    : ColorsRes.appColorWhite
                                : Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.8),
                            borderRadius: Constant.borderRadius7,
                            border: Border.all(
                              width: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "Paystack"
                                  ? 1
                                  : 0.3,
                              color: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "Paystack"
                                  ? ColorsRes.appColor
                                  : ColorsRes.grey,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size10),
                                child: Widgets.defaultImg(
                                    image: "ic_paystack",
                                    width: 25,
                                    height: 25),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size10),
                                child: Text(
                                  getTranslatedValue(
                                    context,
                                    "paystack",
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Radio(
                                value: "Paystack",
                                groupValue: context
                                    .read<CheckoutProvider>()
                                    .selectedPaymentMethod,
                                activeColor: ColorsRes.appColor,
                                onChanged: (value) {
                                  if (!context
                                      .read<CheckoutProvider>()
                                      .isPaymentUnderProcessing) {
                                    context
                                        .read<CheckoutProvider>()
                                        .setSelectedPaymentMethod("Paystack");
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (paymentMethodsData.stripePaymentMethod == "1")
                      GestureDetector(
                        onTap: () {
                          if (!context
                              .read<CheckoutProvider>()
                              .isPaymentUnderProcessing) {
                            context
                                .read<CheckoutProvider>()
                                .setSelectedPaymentMethod("Stripe");
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                          margin:
                              EdgeInsets.symmetric(vertical: Constant.size5),
                          decoration: BoxDecoration(
                            color: context
                                        .read<CheckoutProvider>()
                                        .selectedPaymentMethod ==
                                    "Stripe"
                                ? Constant.session
                                        .getBoolData(SessionManager.isDarkTheme)
                                    ? ColorsRes.appColorBlack
                                    : ColorsRes.appColorWhite
                                : Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.8),
                            borderRadius: Constant.borderRadius7,
                            border: Border.all(
                              width: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "Stripe"
                                  ? 1
                                  : 0.3,
                              color: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "Stripe"
                                  ? ColorsRes.appColor
                                  : ColorsRes.grey,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size10),
                                child: Widgets.defaultImg(
                                    image: "ic_stripe",
                                    width: 25,
                                    height: 25,
                                    iconColor: ColorsRes.mainTextColor),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size10),
                                child: Text(
                                  getTranslatedValue(
                                    context,
                                    "stripe",
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Radio(
                                value: "Stripe",
                                groupValue: context
                                    .read<CheckoutProvider>()
                                    .selectedPaymentMethod,
                                activeColor: ColorsRes.appColor,
                                onChanged: (value) {
                                  if (!context
                                      .read<CheckoutProvider>()
                                      .isPaymentUnderProcessing) {
                                    context
                                        .read<CheckoutProvider>()
                                        .setSelectedPaymentMethod("Stripe");
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (paymentMethodsData.paytmPaymentMethod == "1")
                      GestureDetector(
                        onTap: () {
                          if (!context
                              .read<CheckoutProvider>()
                              .isPaymentUnderProcessing) {
                            context
                                .read<CheckoutProvider>()
                                .setSelectedPaymentMethod("Paytm");
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                          margin:
                              EdgeInsets.symmetric(vertical: Constant.size5),
                          decoration: BoxDecoration(
                            color: context
                                        .read<CheckoutProvider>()
                                        .selectedPaymentMethod ==
                                    "Paytm"
                                ? Constant.session
                                        .getBoolData(SessionManager.isDarkTheme)
                                    ? ColorsRes.appColorBlack
                                    : ColorsRes.appColorWhite
                                : Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.8),
                            borderRadius: Constant.borderRadius7,
                            border: Border.all(
                              width: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "Paytm"
                                  ? 1
                                  : 0.3,
                              color: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "Paytm"
                                  ? ColorsRes.appColor
                                  : ColorsRes.grey,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size10),
                                child: Widgets.defaultImg(
                                    image: "ic_paytm", width: 25, height: 25),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size10),
                                child: Text(
                                  getTranslatedValue(
                                    context,
                                    "Paytm",
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Radio(
                                value: "Paytm",
                                groupValue: context
                                    .read<CheckoutProvider>()
                                    .selectedPaymentMethod,
                                onChanged: (value) {
                                  if (!context
                                      .read<CheckoutProvider>()
                                      .isPaymentUnderProcessing) {
                                    context
                                        .read<CheckoutProvider>()
                                        .setSelectedPaymentMethod("Paytm");
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (paymentMethodsData.paypalPaymentMethod == "1")
                      GestureDetector(
                        onTap: () {
                          if (!context
                              .read<CheckoutProvider>()
                              .isPaymentUnderProcessing) {
                            context
                                .read<CheckoutProvider>()
                                .setSelectedPaymentMethod("Paypal");
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                          margin:
                              EdgeInsets.symmetric(vertical: Constant.size5),
                          decoration: BoxDecoration(
                            color: context
                                        .read<CheckoutProvider>()
                                        .selectedPaymentMethod ==
                                    "Paypal"
                                ? Constant.session
                                        .getBoolData(SessionManager.isDarkTheme)
                                    ? ColorsRes.appColorBlack
                                    : ColorsRes.appColorWhite
                                : Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.8),
                            borderRadius: Constant.borderRadius7,
                            border: Border.all(
                              width: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "Paypal"
                                  ? 1
                                  : 0.3,
                              color: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "Paypal"
                                  ? ColorsRes.appColor
                                  : ColorsRes.grey,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size10),
                                child: Widgets.defaultImg(
                                    image: "ic_paypal", width: 25, height: 25),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size10),
                                child: Text(
                                  getTranslatedValue(
                                    context,
                                    "paypal",
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Radio(
                                value: "Paypal",
                                groupValue: context
                                    .read<CheckoutProvider>()
                                    .selectedPaymentMethod,
                                onChanged: (value) {
                                  if (!context
                                      .read<CheckoutProvider>()
                                      .isPaymentUnderProcessing) {
                                    context
                                        .read<CheckoutProvider>()
                                        .setSelectedPaymentMethod("Paypal");
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        )
      : const SizedBox.shrink();
}
