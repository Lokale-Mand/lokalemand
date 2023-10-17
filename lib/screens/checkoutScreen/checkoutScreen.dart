import 'package:lokale_mand/helper/utils/generalImports.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late AddressData? selectedAddress;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then(
      (value) async {
        await context
            .read<CheckoutProvider>()
            .getSingleAddressProvider(context: context)
            .then(
          (selectedAddress) async {
            Map<String, String> params = {
              ApiAndParams.latitude: selectedAddress?.latitude?.toString() ??
                  Constant.session.getData(SessionManager.keyLatitude),
              ApiAndParams.longitude: selectedAddress?.longitude?.toString() ??
                  Constant.session.getData(SessionManager.keyLongitude),
              ApiAndParams.isCheckout: "1"
            };

            if (Constant.selectedPromoCodeId != "0") {
              params[ApiAndParams.promoCodeId] = Constant.selectedPromoCodeId;
            }

            await context
                .read<CheckoutProvider>()
                .getOrderChargesProvider(
                  context: context,
                  params: params,
                )
                .then(
              (value) async {
                await context
                    .read<CheckoutProvider>()
                    .getTimeSlotsSettings(context: context);

                await context
                    .read<CheckoutProvider>()
                    .getPaymentMethods(context: context)
                    .then(
                  (value) {
                    StripeService.secret = context
                            .read<CheckoutProvider>()
                            .paymentMethods
                            ?.data
                            .stripeSecretKey ??
                        "";
                    StripeService.init(
                        context
                                .read<CheckoutProvider>()
                                .paymentMethods
                                ?.data
                                .stripePublicKey ??
                            "",
                        "");
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (context.read<CheckoutProvider>().isPaymentUnderProcessing) {
          GeneralMethods.showMessage(
              context,
              getTranslatedValue(context,
                  "you_can_not_go_back_until_payment_cancel_or_success"),
              MessageType.warning);
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: "checkout",
            softWrap: true,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          onTap: () async {
            if (context.read<CheckoutProvider>().isPaymentUnderProcessing) {
              GeneralMethods.showMessage(
                  context,
                  getTranslatedValue(context,
                      "you_can_not_go_back_until_payment_cancel_or_success"),
                  MessageType.warning);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        body: Consumer<CheckoutProvider>(
          builder: (context, checkoutProvider, _) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      if (checkoutProvider.checkoutAddressState ==
                              CheckoutAddressState.addressLoading &&
                          checkoutProvider.checkoutTimeSlotsState ==
                              CheckoutTimeSlotsState.timeSlotsLoading &&
                          checkoutProvider.checkoutPaymentMethodsState ==
                              CheckoutPaymentMethodsState.paymentMethodLoading)
                        getCheckoutShimmer(),
                      if (checkoutProvider.checkoutPaymentMethodsState ==
                              CheckoutPaymentMethodsState.paymentMethodLoaded &&
                          (checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsLoaded ||
                              checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsError) &&
                          (checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressLoaded ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressBlank ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressError))
                        getAddressWidget(context),
                      if (checkoutProvider.checkoutPaymentMethodsState ==
                              CheckoutPaymentMethodsState.paymentMethodLoaded &&
                          (checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsLoaded ||
                              checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsError) &&
                          (checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressLoaded ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressBlank ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressError))
                        GetTimeSlots(),
                      if (checkoutProvider.checkoutPaymentMethodsState ==
                              CheckoutPaymentMethodsState.paymentMethodLoaded &&
                          (checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsLoaded ||
                              checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsError) &&
                          (checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressLoaded ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressBlank ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressError))
                        getPaymentMethods(
                            checkoutProvider.paymentMethodsData, context),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      if (checkoutProvider.checkoutPaymentMethodsState ==
                              CheckoutPaymentMethodsState.paymentMethodLoaded &&
                          (checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsLoaded ||
                              checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsError) &&
                          (checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressLoaded ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressBlank ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressError) &&
                          checkoutProvider.checkoutDeliveryChargeState ==
                              CheckoutDeliveryChargeState
                                  .deliveryChargeLoaded &&
                          checkoutProvider.selectedAddress?.id != null)
                        getDeliveryCharges(context),
                      if (checkoutProvider.checkoutDeliveryChargeState ==
                          CheckoutDeliveryChargeState.deliveryChargeLoading)
                        getDeliveryChargeShimmer(),
                      PlaceOrderButtonWidget(
                        context: context,
                        isEnabled: checkoutProvider
                                    .checkoutPaymentMethodsState ==
                                CheckoutPaymentMethodsState
                                    .paymentMethodLoaded &&
                            (checkoutProvider.checkoutTimeSlotsState ==
                                    CheckoutTimeSlotsState.timeSlotsLoaded ||
                                checkoutProvider.checkoutTimeSlotsState ==
                                    CheckoutTimeSlotsState.timeSlotsError) &&
                            (checkoutProvider.checkoutAddressState ==
                                    CheckoutAddressState.addressBlank ||
                                checkoutProvider.checkoutAddressState ==
                                    CheckoutAddressState.addressError) &&
                            checkoutProvider.selectedAddress != AddressData(),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  getCheckoutShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomShimmer(
          margin: EdgeInsetsDirectional.all(Constant.size10),
          borderRadius: 7,
          width: double.maxFinite,
          height: 150,
        ),
        const CustomShimmer(
          width: 250,
          height: 25,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              10,
              (index) {
                return const CustomShimmer(
                  width: 50,
                  height: 80,
                  borderRadius: 10,
                  margin: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
                );
              },
            ),
          ),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: 250,
          height: 25,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
      ],
    );
  }

  getDeliveryChargeShimmer() {
    return Padding(
      padding: EdgeInsets.all(Constant.size10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: CustomShimmer(
                  height: 20,
                  borderRadius: 7,
                ),
              ),
              Widgets.getSizedBox(
                width: Constant.size10,
              ),
              const Expanded(
                child: CustomShimmer(
                  height: 20,
                  width: 80,
                  borderRadius: 7,
                ),
              )
            ],
          ),
          Widgets.getSizedBox(
            height: Constant.size7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: CustomShimmer(
                  height: 20,
                  borderRadius: 7,
                ),
              ),
              Widgets.getSizedBox(
                width: Constant.size10,
              ),
              const Expanded(
                child: CustomShimmer(
                  height: 20,
                  borderRadius: 7,
                ),
              )
            ],
          ),
          Widgets.getSizedBox(
            height: Constant.size7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: CustomShimmer(
                  height: 22,
                  borderRadius: 7,
                ),
              ),
              Widgets.getSizedBox(
                width: Constant.size10,
              ),
              const Expanded(
                child: CustomShimmer(
                  height: 22,
                  borderRadius: 7,
                ),
              )
            ],
          ),
          Widgets.getSizedBox(
            height: Constant.size7,
          ),
        ],
      ),
    );
  }
}
