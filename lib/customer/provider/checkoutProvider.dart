import 'package:lokale_mand/customer/models/initiateTransaction.dart';
import 'package:lokale_mand/customer/models/paytmTransationToken.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

enum CheckoutTimeSlotsState {
  timeSlotsLoading,
  timeSlotsLoaded,
  timeSlotsError,
}

enum CheckoutAddressState {
  addressLoading,
  addressLoaded,
  addressBlank,
  addressError,
}

enum CheckoutDeliveryChargeState {
  deliveryChargeLoading,
  deliveryChargeLoaded,
  deliveryChargeError,
}

enum CheckoutPaymentMethodsState {
  paymentMethodLoading,
  paymentMethodLoaded,
  paymentMethodError,
}

enum CheckoutPlaceOrderState {
  placeOrderLoading,
  placeOrderLoaded,
  placeOrderError,
}

class CheckoutProvider extends ChangeNotifier {
  CheckoutAddressState checkoutAddressState =
      CheckoutAddressState.addressLoading;

  CheckoutDeliveryChargeState checkoutDeliveryChargeState =
      CheckoutDeliveryChargeState.deliveryChargeLoading;

  CheckoutTimeSlotsState checkoutTimeSlotsState =
      CheckoutTimeSlotsState.timeSlotsLoading;

  CheckoutPaymentMethodsState checkoutPaymentMethodsState =
      CheckoutPaymentMethodsState.paymentMethodLoading;

  CheckoutPlaceOrderState checkoutPlaceOrderState =
      CheckoutPlaceOrderState.placeOrderLoading;

  String message = '';
  bool isPaymentUnderProcessing = false;

  //Address variables
  AddressData? selectedAddress = AddressData();

  // Order Delivery charge variables
  bool? usedWallet;
  double walletUsedAmount = 0.0;
  double availableWalletAmount = 0.0;
  double subTotalAmount = 0.0;
  double totalAmount = 0.0;
  double savedAmount = 0.0;
  double deliveryCharge = 0.0;
  List<SellersInfo>? sellerWiseDeliveryCharges;
  DeliveryChargeData? deliveryChargeData;
  bool? isCodAllowed;

  //Timeslots variables
  TimeSlotsData? timeSlotsData;
  bool isTimeSlotsEnabled = true;
  int selectedDateId = 0;
  String? selectedDate = null;
  int selectedTime = 0;
  String selectedPaymentMethod = "";
  int initiallySelectedIndex = -1;

  //Payment methods variables
  PaymentMethods? paymentMethods;
  PaymentMethodsData? paymentMethodsData;

  //Place order variables
  String placedOrderId = "";
  String razorpayOrderId = "";
  String transactionId = "";
  String payStackReference = "";

  String paytmTxnToken = "";

  int availablePaymentMethods = 0;

  String sellerId = "";
  String storeName = "";
  String storeLogo = "";

  Future setPaymentProcessState(bool value) async {
    isPaymentUnderProcessing = value;
    notifyListeners();
  }

  Future updatePaymentMethodsCount() async {
    availablePaymentMethods++;
  }

  Future resetPaymentMethodsCount() async {
    availablePaymentMethods = 0;
  }

  Future userWalletAmount(bool used) async {
    usedWallet = used;
    if (used) {
      if (availableWalletAmount >= totalAmount) {
        walletUsedAmount = totalAmount;
        availableWalletAmount = availableWalletAmount - totalAmount;
        totalAmount = 0.0;
      } else {
        walletUsedAmount = availableWalletAmount;
        totalAmount = totalAmount - walletUsedAmount;
        availableWalletAmount = 0.0;
      }
    } else {
      availableWalletAmount = walletUsedAmount + availableWalletAmount;
      totalAmount = totalAmount + walletUsedAmount;
      walletUsedAmount = 0.0;
    }
    notifyListeners();
  }

  Future<AddressData?> getSingleAddressProvider(
      {required BuildContext context}) async {
    try {
      Map<String, dynamic> getAddress = (await getAddressApi(
          context: context, params: {ApiAndParams.isDefault: "1"}));
      if (getAddress[ApiAndParams.status].toString() == "1") {
        Address addressData = Address.fromJson(getAddress);
        selectedAddress = addressData.data?[0];

        if (selectedAddress?.cityId?.toString() == "0") {
          isPaymentUnderProcessing = false;
        }
        checkoutAddressState = CheckoutAddressState.addressLoaded;
        notifyListeners();
        return selectedAddress;
      } else {
        checkoutAddressState = CheckoutAddressState.addressBlank;
        isPaymentUnderProcessing = false;
        notifyListeners();
        return selectedAddress;
      }
    } catch (e) {
      message = e.toString();
      checkoutAddressState = CheckoutAddressState.addressError;
      isPaymentUnderProcessing = false;
      notifyListeners();
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      return selectedAddress;
    }
  }

  setSelectedAddress(BuildContext context, var address) async {
    selectedAddress = address;

    checkoutAddressState = CheckoutAddressState.addressLoaded;
    notifyListeners();

    Map<String, String> params = {
      ApiAndParams.cityId: selectedAddress!.cityId.toString(),
      ApiAndParams.latitude: selectedAddress!.latitude.toString(),
      ApiAndParams.longitude: selectedAddress!.longitude.toString(),
      ApiAndParams.isCheckout: "1"
    };
    if (Constant.isPromoCodeApplied) {
      params[ApiAndParams.promoCodeId] = Constant.selectedPromoCodeId;
    }

    if (selectedAddress!.cityId.toString() != "0") {
      await getOrderChargesProvider(
        context: context,
        params: params,
      );
    } else {
      isPaymentUnderProcessing = false;
      message = e.toString();
      checkoutDeliveryChargeState =
          CheckoutDeliveryChargeState.deliveryChargeError;
      checkoutAddressState = CheckoutAddressState.addressLoaded;
      notifyListeners();

      GeneralMethods.showMessage(
          context,
          context
                  .read<LanguageProvider>()
                  .currentLanguage["selected_address_is_not_deliverable"] ??
              "Sorry, We are not delivering on selected address",
          MessageType.warning);
    }
  }

  Future getOrderChargesProvider(
      {required BuildContext context,
      required Map<String, String> params}) async {
    try {
      checkoutDeliveryChargeState =
          CheckoutDeliveryChargeState.deliveryChargeLoading;
      notifyListeners();
      Map<String, dynamic> getCheckoutData =
          (await getCartListApi(context: context, params: params));

      if (getCheckoutData[ApiAndParams.status].toString() == "1") {
        Checkout checkoutData = Checkout.fromJson(getCheckoutData);
        deliveryChargeData = checkoutData.data!;
        isCodAllowed = deliveryChargeData?.codAllowed.toString() != "0";
        subTotalAmount = double.parse(deliveryChargeData?.subTotal ?? "0");
        totalAmount = double.parse(deliveryChargeData?.totalAmount ?? "0");
        deliveryCharge = double.parse(
            deliveryChargeData?.deliveryCharge?.totalDeliveryCharge ?? "0");
        sellerWiseDeliveryCharges =
            deliveryChargeData?.deliveryCharge!.sellersInfo!;

        usedWallet = false;
        walletUsedAmount = 0.0;

        checkoutDeliveryChargeState =
            CheckoutDeliveryChargeState.deliveryChargeLoaded;
        checkoutAddressState = CheckoutAddressState.addressLoaded;
        notifyListeners();
      } else {
        checkoutDeliveryChargeState =
            CheckoutDeliveryChargeState.deliveryChargeError;
        checkoutAddressState = CheckoutAddressState.addressLoaded;
        isPaymentUnderProcessing = false;
        notifyListeners();
        GeneralMethods.showMessage(
          context,
          getCheckoutData["message"],
          MessageType.warning,
        );
      }
    } catch (e) {
      isPaymentUnderProcessing = false;
      message = e.toString();
      checkoutDeliveryChargeState =
          CheckoutDeliveryChargeState.deliveryChargeError;
      checkoutAddressState = CheckoutAddressState.addressLoaded;
      notifyListeners();
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
    }
  }

  Future getTimeSlotsSettings({required BuildContext context}) async {
    try {
      Map<String, dynamic> getTimeSlotsSettings =
          (await getTimeSlotSettingsApi(context: context, params: {}));
      if (getTimeSlotsSettings[ApiAndParams.status].toString() == "1") {
        TimeSlotsSettings timeSlots =
            TimeSlotsSettings.fromJson(getTimeSlotsSettings);
        timeSlotsData = timeSlots.data;
        isTimeSlotsEnabled = timeSlots.data.timeSlotsIsEnabled == "true";

        selectedDateId = 0;
        selectedTime = 0;

        checkoutTimeSlotsState = CheckoutTimeSlotsState.timeSlotsLoaded;
        notifyListeners();
      } else {
        GeneralMethods.showMessage(
          context,
          getTimeSlotsSettings[ApiAndParams.message].toString(),
          MessageType.warning,
        );
        checkoutTimeSlotsState = CheckoutTimeSlotsState.timeSlotsError;
        notifyListeners();
      }
    } catch (e) {
      GeneralMethods.showMessage(
        context,
        context
                .read<LanguageProvider>()
                .currentLanguage["please_add_timeslot_in_admin_panel"] ??
            "Please add timeslot in admin panel!",
        MessageType.warning,
      );
      checkoutTimeSlotsState = CheckoutTimeSlotsState.timeSlotsError;
      notifyListeners();
    }
  }

  setSelectedDate(int index) {
    selectedTime = 0;
    selectedDateId = index;
    if (int.parse(timeSlotsData?.timeSlotsDeliveryStartsFrom ?? "0") > 1) {
      selectedTime = 0;
    }
    notifyListeners();
  }

  setSelectedTime(int index) {
    initiallySelectedIndex = index;
    selectedTime = index;
    notifyListeners();
  }

  setSelectedTimeWithoutNotify(int index) {
    initiallySelectedIndex = index;
    selectedTime = index;
  }

  Future getPaymentMethods({required BuildContext context}) async {
    try {
      Map<String, dynamic> getPaymentMethodsSettings =
          (await getPaymentMethodsSettingsApi(context: context, params: {}));

      if (getPaymentMethodsSettings[ApiAndParams.status].toString() == "1") {
        List<int> decodedBytes = base64
            .decode(getPaymentMethodsSettings[ApiAndParams.data].toString());
        String decodedString = utf8.decode(decodedBytes);
        Map<String, dynamic> map = json.decode(decodedString);
        getPaymentMethodsSettings[ApiAndParams.data] = map;

        paymentMethods = PaymentMethods.fromJson(getPaymentMethodsSettings);
        paymentMethodsData = paymentMethods?.data;

        if (isCodAllowed ?? true) {
          isCodAllowed = true;
        } else {
          isCodAllowed = false;
        }

        if (paymentMethodsData?.codPaymentMethod == "1" &&
            isCodAllowed == true) {
          selectedPaymentMethod = "COD";
        } else if (paymentMethodsData?.razorpayPaymentMethod == "1") {
          selectedPaymentMethod = "Razorpay";
        } else if (paymentMethodsData?.paystackPaymentMethod == "1") {
          selectedPaymentMethod = "Paystack";
        } else if (paymentMethodsData?.stripePaymentMethod == "1") {
          selectedPaymentMethod = "Stripe";
        } else if (paymentMethodsData?.paytmPaymentMethod == "1") {
          selectedPaymentMethod = "Paytm";
        } else if (paymentMethodsData?.paypalPaymentMethod == "1") {
          selectedPaymentMethod = "Paypal";
        }

        checkoutPaymentMethodsState =
            CheckoutPaymentMethodsState.paymentMethodLoaded;
        notifyListeners();
      } else {
        GeneralMethods.showMessage(
          context,
          message,
          MessageType.warning,
        );
        checkoutPaymentMethodsState =
            CheckoutPaymentMethodsState.paymentMethodError;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPaymentMethodsState =
          CheckoutPaymentMethodsState.paymentMethodError;
      notifyListeners();
    }
  }

  Future setSelectedPaymentMethod(String method) async {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  Future placeOrder({required BuildContext context}) async {
    if (timeSlotsData!.timeSlots.isNotEmpty && selectedAddress != null) {
      try {
        isPaymentUnderProcessing = true;

        if (totalAmount == 0.0) {
          selectedPaymentMethod = "Wallet";
        }

        final orderStatus = (selectedPaymentMethod == "COD" ||
                selectedPaymentMethod == "Wallet")
            ? "2"
            : "1";

        Map<String, String> params = {};
        params[ApiAndParams.productVariantId] =
            deliveryChargeData?.productVariantId.toString() ?? "0";
        params[ApiAndParams.quantity] =
            deliveryChargeData?.quantity.toString() ?? "0";
        params[ApiAndParams.total] =
            (deliveryChargeData?.subTotal.toString() ?? "0")
                .toDouble
                .toPrecision(2)
                .toString();
        params[ApiAndParams.deliveryCharge] =
            (deliveryChargeData?.deliveryCharge?.totalDeliveryCharge ?? "0")
                .toDouble
                .toPrecision(2)
                .toString();
        params[ApiAndParams.finalTotal] =
            totalAmount.toString().toDouble.toPrecision(2).toString();
        params[ApiAndParams.paymentMethod] = selectedPaymentMethod.toString();
        params[ApiAndParams.addressId] = selectedAddress!.id.toString();
        if (isTimeSlotsEnabled) {
          params[ApiAndParams.deliveryTime] =
              "$selectedDate ${timeSlotsData?.timeSlots[selectedTime].title}";
        } else {
          params[ApiAndParams.deliveryTime] = "N/A";
        }
        params[ApiAndParams.status] = orderStatus;
        if (Constant.isPromoCodeApplied) {
          params[ApiAndParams.promoCodeId] = Constant.selectedPromoCodeId;
        }

        Map<String, dynamic> getPlaceOrderResponse =
            (await getPlaceOrderApi(context: context, params: params));

        if (getPlaceOrderResponse[ApiAndParams.status].toString() == "1") {
          Map<String, dynamic> chatDetail =
              getPlaceOrderResponse[ApiAndParams.data];

          sellerId = chatDetail["id"].toString();
          storeName = chatDetail["name"].toString();
          storeLogo = chatDetail["logo_url"].toString();

          if (selectedPaymentMethod != "COD") {
            PlacedPrePaidOrder placedPrePaidOrder =
                PlacedPrePaidOrder.fromJson(getPlaceOrderResponse);
            placedOrderId = placedPrePaidOrder.data.orderId.toString();
          }

          if (selectedPaymentMethod == "Razorpay" ||
              selectedPaymentMethod == "Stripe") {
          } else if (selectedPaymentMethod == "Paystack") {
            payStackReference =
                "Charged_From_${GeneralMethods.setFirstLetterUppercase(Platform.operatingSystem)}_${DateTime.now().millisecondsSinceEpoch}";
            transactionId = payStackReference;
          } else if (selectedPaymentMethod == "COD" ||
              selectedPaymentMethod == "Wallet") {
            showOrderPlacedScreen(context);
          } else if (selectedPaymentMethod == "Paytm") {
            initiatePaytmTransaction(context: context).then((value) {
              return value;
            });
          } else if (selectedPaymentMethod == "Paypal") {
            initiatePaypalTransaction(context: context).then((value) {
              return value;
            });
          }

          checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
          notifyListeners();
          return true;
        } else {
          GeneralMethods.showMessage(
            context,
            "${getTranslatedValue(context, "address_missing_alert")}",
            MessageType.warning,
          );
          checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
          isPaymentUnderProcessing = false;
          notifyListeners();
          return false;
        }
      } catch (e) {
        message = e.toString();
        GeneralMethods.showMessage(
          context,
          message,
          MessageType.warning,
        );
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        isPaymentUnderProcessing = false;
        notifyListeners();
        return false;
      }
    } else {
      GeneralMethods.showMessage(
        context,
        context
                .read<LanguageProvider>()
                .currentLanguage["please_add_timeslot_in_admin_panel"] ??
            "Please add timeslot in admin panel!",
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      isPaymentUnderProcessing = false;
    }
    notifyListeners();
    return false;
  }

  Future initiatePaytmTransaction({required BuildContext context}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.orderId] = placedOrderId;
      params[ApiAndParams.amount] = totalAmount.toString();

      Map<String, dynamic> getPaytmTransactionTokenResponse =
          (await getPaytmTransactionTokenApi(context: context, params: params));

      if (getPaytmTransactionTokenResponse[ApiAndParams.status].toString() ==
          "1") {
        PaytmTransactionToken paytmTransactionToken =
            PaytmTransactionToken.fromJson(getPaytmTransactionTokenResponse);
        paytmTxnToken = paytmTransactionToken.data?.txnToken ?? "";
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
      } else {
        deleteAwaitingOrder(context);
        GeneralMethods.showMessage(
          context,
          message,
          MessageType.warning,
        );
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
        return false;
      }
    } catch (e) {
      deleteAwaitingOrder(context);
      message = e.toString();
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
      return false;
    }
  }

  Future initiateRazorpayTransaction({required BuildContext context}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = selectedPaymentMethod.toString();
      params[ApiAndParams.orderId] = placedOrderId;

      Map<String, dynamic> getInitiatedTransactionResponse =
          (await getInitiatedTransactionApi(context: context, params: params));

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() ==
          "1") {
        InitiateTransaction initiateTransaction =
            InitiateTransaction.fromJson(getInitiatedTransactionResponse);
        razorpayOrderId = initiateTransaction.data.transactionId;
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
      } else {
        deleteAwaitingOrder(context);
        GeneralMethods.showMessage(
          context,
          getInitiatedTransactionResponse["message"],
          MessageType.warning,
        );
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
      }
    } catch (e) {
      deleteAwaitingOrder(context);
      message = e.toString();
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }

  showOrderPlacedScreen(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushNamed(
      context,
      chatDetailScreen,
      arguments: [
        sellerId,
        storeName,
        storeLogo,
      ],
    );
  }

  Future initiatePaypalTransaction({required BuildContext context}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = selectedPaymentMethod.toString();
      params[ApiAndParams.orderId] = placedOrderId;

      Map<String, dynamic> getInitiatedTransactionResponse =
          await getInitiatedTransactionApi(context: context, params: params);

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() ==
          "1") {
        Map<String, dynamic> data =
            getInitiatedTransactionResponse[ApiAndParams.data];
        Navigator.pushNamed(context, paypalPaymentScreen,
                arguments: data["paypal_redirect_url"])
            .then((value) {
          if (value == true) {
            showOrderPlacedScreen(context);
          } else {
            deleteAwaitingOrder(context);
            context.read<CheckoutProvider>().deleteAwaitingOrder(context);
            GeneralMethods.showMessage(
              context,
              getTranslatedValue(context, "payment_cancelled_by_user"),
              MessageType.warning,
            );
            return false;
          }
        });
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
      } else {
        deleteAwaitingOrder(context);
        GeneralMethods.showMessage(
          context,
          message,
          MessageType.warning,
        );
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
      }
    } catch (e) {
      deleteAwaitingOrder(context);
      message = e.toString();
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }

  Future addTransaction({required BuildContext context}) async {
    try {
      PackageInfo packageInfo;
      packageInfo = await PackageInfo.fromPlatform();

      Map<String, String> params = {};

      params[ApiAndParams.orderId] = placedOrderId;
      params[ApiAndParams.deviceType] =
          GeneralMethods.setFirstLetterUppercase(Platform.operatingSystem);
      params[ApiAndParams.appVersion] = packageInfo.version;
      params[ApiAndParams.transactionId] = transactionId;
      params[ApiAndParams.paymentMethod] = selectedPaymentMethod.toString();

      Map<String, dynamic> addedTransaction =
          (await getAddTransactionApi(context: context, params: params));
      if (addedTransaction[ApiAndParams.status].toString() == "1") {
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
        showOrderPlacedScreen(context);
      } else {
        GeneralMethods.showMessage(
          context,
          addedTransaction[ApiAndParams.message],
          MessageType.warning,
        );
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }

  Future deleteAwaitingOrder(BuildContext context) async {
    try {
      await deleteAwaitingOrderApi(
          params: {ApiAndParams.orderId: placedOrderId}, context: context);
    } catch (e) {
      GeneralMethods.showMessage(context, e.toString(), MessageType.error);
    }
  }
}
