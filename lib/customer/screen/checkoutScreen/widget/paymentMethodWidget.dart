import 'package:lokale_mand/helper/utils/generalImports.dart';

getPaymentMethods(
    PaymentMethodsData? paymentMethodsData, BuildContext context) {
  context.read<CheckoutProvider>().resetPaymentMethodsCount();
  if (paymentMethodsData?.codPaymentMethod == "1" &&
      context.read<CheckoutProvider>().isCodAllowed == true) {
    context.read<CheckoutProvider>().updatePaymentMethodsCount();
  }
  if (paymentMethodsData?.razorpayPaymentMethod == "1") {
    context.read<CheckoutProvider>().updatePaymentMethodsCount();
  }
  if (paymentMethodsData?.paystackPaymentMethod == "1") {
    context.read<CheckoutProvider>().updatePaymentMethodsCount();
  }
  if (paymentMethodsData?.stripePaymentMethod == "1") {
    context.read<CheckoutProvider>().updatePaymentMethodsCount();
  }
  if (paymentMethodsData?.paytmPaymentMethod == "1") {
    context.read<CheckoutProvider>().updatePaymentMethodsCount();
  }
  if (paymentMethodsData?.paypalPaymentMethod == "1") {
    context.read<CheckoutProvider>().updatePaymentMethodsCount();
  }

  if (paymentMethodsData != null) {
    return context.watch<CheckoutProvider>().availablePaymentMethods == 0
        ? Container()
        : Container(
            decoration:
                DesignConfig.boxDecoration(Theme.of(context).cardColor, 10),
            padding: const EdgeInsets.all(10),
            margin: EdgeInsetsDirectional.only(
              start: 10,
              end: 10,
              bottom: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextLabel(
                  jsonKey: "payment_method",
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
                Widgets.getSizedBox(
                  height: Constant.size10,
                ),
                CustomTextLabel(
                  jsonKey: "payment_method_description",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Widgets.getSizedBox(
                  height: Constant.size10,
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
                              EdgeInsets.symmetric(vertical: Constant.size7),
                          child: Row(
                            children: [
                              Widgets.defaultImg(
                                  image: "ic_cod", width: 35, height: 35),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: Constant.size10),
                                  child: Text(
                                    getTranslatedValue(
                                      context,
                                      "cash_on_delivery",
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                                ),
                              ),
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
                              EdgeInsets.symmetric(vertical: Constant.size7),
                          child: Row(
                            children: [
                              Widgets.defaultImg(
                                  image: "ic_razorpay", width: 35, height: 35),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: Constant.size10),
                                  child: Text(
                                    getTranslatedValue(
                                      context,
                                      "razorpay",
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                                ),
                              ),
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
                              EdgeInsets.symmetric(vertical: Constant.size7),
                          child: Row(
                            children: [
                              Widgets.defaultImg(
                                  image: "ic_paystack", width: 35, height: 35),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: Constant.size10),
                                  child: Text(
                                    getTranslatedValue(
                                      context,
                                      "paystack",
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                                ),
                              ),
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
                              EdgeInsets.symmetric(vertical: Constant.size7),
                          child: Row(
                            children: [
                              Widgets.defaultImg(
                                  image: "ic_stripe",
                                  width: 35,
                                  height: 35,
                                  iconColor: ColorsRes.mainTextColor),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: Constant.size10),
                                  child: Text(
                                    getTranslatedValue(
                                      context,
                                      "stripe",
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                                ),
                              ),
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
                              EdgeInsets.symmetric(vertical: Constant.size7),
                          child: Row(
                            children: [
                              Widgets.defaultImg(
                                  image: "ic_paytm", width: 35, height: 35),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: Constant.size10),
                                  child: Text(
                                    getTranslatedValue(
                                      context,
                                      "Paytm",
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                                ),
                              ),
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
                              EdgeInsets.symmetric(vertical: Constant.size7),
                          child: Row(
                            children: [
                              Widgets.defaultImg(
                                  image: "ic_paypal", width: 35, height: 35),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: Constant.size10),
                                  child: Text(
                                    getTranslatedValue(
                                      context,
                                      "paypal",
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                                ),
                              ),
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
          );
  } else {
    return const SizedBox.shrink();
  }
}
