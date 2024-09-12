import 'package:lokale_mand/helper/utils/generalImports.dart';

class PlaceOrderButtonWidget extends StatefulWidget {
  final BuildContext context;

  const PlaceOrderButtonWidget({Key? key, required this.context})
      : super(key: key);

  @override
  State<PlaceOrderButtonWidget> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<PlaceOrderButtonWidget> {
  final Razorpay _razorpay = Razorpay();
  late String razorpayKey = "";
  late String paystackKey = "";
  late double amount = 0.00;
  late PaystackPlugin paystackPlugin;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      paystackPlugin = PaystackPlugin();

      _razorpay.on(
          Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorPayPaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleRazorPayPaymentError);
      _razorpay.on(
          Razorpay.EVENT_EXTERNAL_WALLET, _handleRazorPayExternalWallet);
    });
  }

  void _handleRazorPayPaymentSuccess(PaymentSuccessResponse response) {
    context.read<CheckoutProvider>().transactionId =
        response.paymentId.toString();
    context.read<CheckoutProvider>().addTransaction(context: context);
  }

  void _handleRazorPayPaymentError(PaymentFailureResponse response) {
    context.read<CheckoutProvider>().deleteAwaitingOrder(context);
    context.read<CheckoutProvider>().setPaymentProcessState(false);
    GeneralMethods.showMessage(
        context, response.message.toString(), MessageType.warning);
  }

  void _handleRazorPayExternalWallet(ExternalWalletResponse response) {
    context.read<CheckoutProvider>().setPaymentProcessState(false);
    GeneralMethods.showMessage(
        context, response.toString(), MessageType.warning);
  }

  void openRazorPayGateway() async {
    final options = {
      'key': razorpayKey, //this should be come from server
      'order_id': context.read<CheckoutProvider>().razorpayOrderId,
      'prefill': {
        'contact': Constant.session.getData(SessionManager.keyPhone),
        'email': Constant.session.getData(SessionManager.keyEmail)
      },
    };

    _razorpay.open(options);
  }

  // Using package flutter_paystack
  Future openPaystackPaymentGateway() async {
    await paystackPlugin.initialize(
        publicKey: context
                .read<CheckoutProvider>()
                .paymentMethodsData
                ?.paystackPublicKey ??
            "0");

    Charge charge = Charge()
      ..amount = (context.read<CheckoutProvider>().totalAmount * 100).toInt()
      ..currency = context
              .read<CheckoutProvider>()
              .paymentMethodsData
              ?.paystackCurrencyCode ??
          ""
      ..reference = context.read<CheckoutProvider>().payStackReference
      ..email = Constant.session.getData(SessionManager.keyEmail);

    CheckoutResponse response = await paystackPlugin.checkout(
      context,
      fullscreen: false,
      logo: Widgets.defaultImg(
        height: 50,
        width: 50,
        image: "logo",
      ),
      method: CheckoutMethod.card,
      charge: charge,
    );

    if (response.status) {
      context.read<CheckoutProvider>().addTransaction(context: context);
    } else {
      context.read<CheckoutProvider>().deleteAwaitingOrder(context);
      context.read<CheckoutProvider>().setPaymentProcessState(false);
    }
  }

  //Paytm Payment Gateway
  openPaytmPaymentGateway() async {
    try {
      GeneralMethods.sendApiRequest(
              apiName: ApiAndParams.apiPaytmTransactionToken,
              params: {
                ApiAndParams.orderId:
                    context.read<CheckoutProvider>().placedOrderId,
                ApiAndParams.amount:
                    context.read<CheckoutProvider>().totalAmount.toString()
              },
              isPost: false,
              context: context)
          .then((value) async {
        await Paytm.payWithPaytm(
                mId: context
                        .read<CheckoutProvider>()
                        .paymentMethodsData
                        ?.paytmMerchantId ??
                    "",
                orderId: context.read<CheckoutProvider>().placedOrderId,
                txnToken: context.read<CheckoutProvider>().paytmTxnToken,
                txnAmount:
                    context.read<CheckoutProvider>().totalAmount.toString(),
                callBackUrl:
                    '${context.read<CheckoutProvider>().paymentMethodsData?.paytmMode == "sandbox" ? 'https://securegw-stage.paytm.in' : 'https://securegw.paytm.in'}/theia/paytmCallback?ORDER_ID=${context.read<CheckoutProvider>().placedOrderId}',
                staging: context
                        .read<CheckoutProvider>()
                        .paymentMethodsData
                        ?.paytmMode ==
                    "sandbox",
                appInvokeEnabled: false)
            .then((value) {
          Map<dynamic, dynamic> response = value["response"];
          if (response["STATUS"] == "TXN_SUCCESS") {
            context.read<CheckoutProvider>().transactionId =
                response["TXNID"].toString();
            context.read<CheckoutProvider>().addTransaction(context: context);
          } else {
            context.read<CheckoutProvider>().deleteAwaitingOrder(context);
            GeneralMethods.showMessage(
                context, response["STATUS"], MessageType.warning);

            context.read<CheckoutProvider>().setPaymentProcessState(false);
          }
        });
      });
    } catch (e) {
      GeneralMethods.showMessage(context, e.toString(), MessageType.warning);
      context.read<CheckoutProvider>().setPaymentProcessState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutProvider>(
      builder: (context, checkoutProvider, child) {
        bool isAddressDeliverable =
            checkoutProvider.selectedAddress?.cityId.toString() == "0";
        bool isAddressEmpty = checkoutProvider.selectedAddress == null;
        return Container(
          height: 55,
          padding: EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 20),
          child: Widgets.gradientBtnWidget(
            context,
            5,
            callback: () async {
              if (checkoutProvider.availablePaymentMethods == 0) {
                GeneralMethods.showMessage(
                    context,
                    getTranslatedValue(context, "payment_method_not_available"),
                    MessageType.warning);
              } else if (isAddressDeliverable) {
                GeneralMethods.showMessage(
                    context,
                    getTranslatedValue(
                        context, "selected_address_is_not_deliverable"),
                    MessageType.warning);
              } else if (isAddressEmpty) {
                GeneralMethods.showMessage(
                    context,
                    getTranslatedValue(context, "add_address_first"),
                    MessageType.warning);
              } else if (checkoutProvider.checkoutTimeSlotsState ==
                  CheckoutTimeSlotsState.timeSlotsError) {
                GeneralMethods.showMessage(
                    context,
                    getTranslatedValue(
                        context, "please_add_timeslot_in_admin_panel"),
                    MessageType.warning);
              } else {
                if (checkoutProvider.selectedPaymentMethod == "COD" ||
                    checkoutProvider.selectedPaymentMethod == "Wallet") {
                  checkoutProvider.placeOrder(context: context);
                } else if (checkoutProvider.selectedPaymentMethod ==
                    "Razorpay") {
                  razorpayKey = context
                          .read<CheckoutProvider>()
                          .paymentMethodsData
                          ?.razorpayKey ??
                      "0";
                  amount = context.read<CheckoutProvider>().totalAmount;
                  context
                      .read<CheckoutProvider>()
                      .placeOrder(context: context)
                      .then((value) {
                    if (value) {
                      context
                          .read<CheckoutProvider>()
                          .initiateRazorpayTransaction(context: context)
                          .then((value) => openRazorPayGateway());
                    }
                  });
                } else if (checkoutProvider.selectedPaymentMethod ==
                    "Paystack") {
                  amount = context.read<CheckoutProvider>().totalAmount;
                  context
                      .read<CheckoutProvider>()
                      .placeOrder(context: context)
                      .then((value) {
                    if (value) {
                      return openPaystackPaymentGateway();
                    }
                  });
                } else if (checkoutProvider.selectedPaymentMethod == "Stripe") {
                  amount = context.read<CheckoutProvider>().totalAmount;

                  context
                      .read<CheckoutProvider>()
                      .placeOrder(context: context)
                      .then((value) {
                    if (value) {
                      StripeService.payWithPaymentSheet(
                        amount: int.parse((amount * 100).toStringAsFixed(0)),
                        isTestEnvironment: true,
                        awaitedOrderId: checkoutProvider.placedOrderId,
                        context: context,
                        currency: context
                                .read<CheckoutProvider>()
                                .paymentMethods
                                ?.data
                                .stripeCurrencyCode ??
                            "0",
                      ).then((value) {
                        if (!value.success!) {
                          context
                              .read<CheckoutProvider>()
                              .deleteAwaitingOrder(context);

                          context
                              .read<CheckoutProvider>()
                              .setPaymentProcessState(false);
                          GeneralMethods.showMessage(
                              context,
                              getTranslatedValue(
                                  context, "payment_cancelled_by_user"),
                              MessageType.warning);
                        }
                      });
                    }
                  });
                } else if (checkoutProvider.selectedPaymentMethod == "Paytm") {
                  amount = context.read<CheckoutProvider>().totalAmount;

                  context
                      .read<CheckoutProvider>()
                      .placeOrder(context: context)
                      .then((value) {
                    if (value is bool) {
                      context
                          .read<CheckoutProvider>()
                          .setPaymentProcessState(false);
                      GeneralMethods.showMessage(
                          context,
                          getTranslatedValue(context, "something_went_wrong"),
                          MessageType.warning);
                    } else {
                      openPaytmPaymentGateway();
                    }
                  });
                } else if (checkoutProvider.selectedPaymentMethod == "Paypal") {
                  amount = context.read<CheckoutProvider>().totalAmount;
                  context
                      .read<CheckoutProvider>()
                      .placeOrder(context: context)
                      .then((value) {
                    if (value is bool) {
                      context
                          .read<CheckoutProvider>()
                          .setPaymentProcessState(false);
                    }
                  });
                }
              }
            },
            otherWidgets: (checkoutProvider.checkoutDeliveryChargeState ==
                    CheckoutDeliveryChargeState.deliveryChargeLoading)
                ? CustomShimmer(
                    height: 40,
                    borderRadius: 10,
                  )
                : (context.read<CheckoutProvider>().isPaymentUnderProcessing)
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsetsDirectional.all(4),
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: ColorsRes.appColorWhite,
                        ),
                      )
                    : context.read<CheckoutProvider>().isPaymentUnderProcessing
                        ? Container(
                            alignment: Alignment.center,
                            padding: EdgeInsetsDirectional.all(4),
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              color: ColorsRes.appColorWhite,
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: CustomTextLabel(
                              jsonKey: isAddressDeliverable
                                  ? "address_is_not_deliverable"
                                  : isAddressEmpty
                                      ? "add_address_first"
                                      : "reserve_product",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .merge(
                                    TextStyle(
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w500,
                                      color: (isAddressDeliverable &&
                                              isAddressEmpty)
                                          ? ColorsRes.mainTextColor
                                          : ColorsRes.appColorWhite,
                                      fontSize: 16,
                                    ),
                                  ),
                            ),
                          ),
            color1: (!isAddressDeliverable && !isAddressEmpty)
                ? ColorsRes.gradient1
                : ColorsRes.grey,
            color2: (!isAddressDeliverable && !isAddressEmpty)
                ? ColorsRes.gradient2
                : ColorsRes.grey,
          ),
        );
      },
    );
  }
}
