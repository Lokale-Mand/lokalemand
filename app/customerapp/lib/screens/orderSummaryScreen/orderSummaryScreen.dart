import 'dart:io' as io;

import 'package:egrocer/helper/utils/generalImports.dart';

class OrderSummaryScreen extends StatefulWidget {
  final Order order;

  const OrderSummaryScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  String getStatusCompleteDate(int currentStatus) {
    if (widget.order.status.isNotEmpty) {
      final statusValue = widget.order.status.where((element) {
        return element.first.toString() == currentStatus.toString();
      }).toList();

      if (statusValue.isNotEmpty) {
        //[2, 04-10-2022 06:13:45am] so fetching last value
        return statusValue.first.last;
      }
    }

    return "";
  }

  @override
  void initState() {
    context.read<CurrentOrderProvider>().order = widget.order;
    super.initState();
  }

  bool _showCancelOrderButton(Order order) {
    bool cancelOrder = false;

    for (var orderItem in order.items) {
      if (orderItem.cancelStatus == "1") {
        cancelOrder = true;
        break;
      }
    }

    return cancelOrder;
  }

  bool _showReturnOrderButton(Order order) {
    bool returnOrder = true;

    for (var orderItem in order.items) {
      if (orderItem.returnStatus == "0") {
        returnOrder = false;
        break;
      }
    }

    return returnOrder;
  }

  Widget _buildReturnOrderButton(
      {required Order order,
      required String orderItemId,
      required double width}) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                ChangeNotifierProvider<UpdateOrderStatusProvider>(
                  create: (context) => UpdateOrderStatusProvider(),
                  child:
                      ReturnOrderDialog(order: order, orderItemId: orderItemId),
                )).then((value) {
          if (value != null) {
            //
            if (value) {
              context.read<CurrentOrderProvider>().updateOrderItem(
                  orderItemId: orderItemId,
                  activeStatus: Constant.orderStatusCode[7]);
            } else {
              GeneralMethods.showMessage(
                context,
                getTranslatedValue(
                  context,
                  "unable_to_return_order",
                ),
                MessageType.warning,
              );
            }
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: width,
        child: CustomTextLabel(
          jsonKey: "return1",
          style: TextStyle(color: ColorsRes.appColor),
        ),
      ),
    );
  }

  Widget _buildCancelOrderButton(
      {required Order order,
      required String orderItemId,
      required double width}) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                ChangeNotifierProvider<UpdateOrderStatusProvider>(
                  create: (context) => UpdateOrderStatusProvider(),
                  child:
                      CancelOrderDialog(order: order, orderItemId: orderItemId),
                )).then((value) {
          if (value) {
            context.read<CurrentOrderProvider>().updateOrderItem(
                orderItemId: orderItemId,
                activeStatus: Constant.orderStatusCode[6]);
          } else {
            GeneralMethods.showMessage(
              context,
              getTranslatedValue(
                context,
                "unable_to_cancel_order",
              ),
              MessageType.warning,
            );
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: width,
        child: CustomTextLabel(
          jsonKey: "cancel",
          style: TextStyle(color: ColorsRes.appColor),
        ),
      ),
    );
  }

  Widget _buildCancelItemButton(OrderItem orderItem) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                ChangeNotifierProvider<UpdateOrderStatusProvider>(
                  create: (context) => UpdateOrderStatusProvider(),
                  child: CancelProductDialog(
                    order: widget.order,
                    orderItemId: orderItem.id.toString(),
                  ),
                )).then((value) {
          //If we get true as value means we need to update this product's status to 7

          if (value) {
            context.read<CurrentOrderProvider>().updateOrderItem(
                orderItemId: orderItem.id.toString(),
                activeStatus: Constant.orderStatusCode[6]);
          } else {
            GeneralMethods.showMessage(
              context,
              getTranslatedValue(
                context,
                "unable_to_cancel_product",
              ),
              MessageType.warning,
            );
          }
        });
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: CustomTextLabel(
          jsonKey: "cancel",
          softWrap: true,
          style: TextStyle(color: ColorsRes.appColorRed),
        ),
      ),
    );
  }

  Widget _buildReturnItemButton(OrderItem orderItem) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                ChangeNotifierProvider<UpdateOrderStatusProvider>(
                  create: (context) => UpdateOrderStatusProvider(),
                  child: ReturnProductDialog(
                      order: widget.order,
                      orderItemId: orderItem.id.toString()),
                )).then((value) {
          //If we get true as value means we need to update this product's status to 8
          if (value != null) {
            if (value) {
              context.read<CurrentOrderProvider>().updateOrderItem(
                  orderItemId: orderItem.id.toString(),
                  activeStatus: Constant.orderStatusCode[7]);
            } else {
              GeneralMethods.showMessage(
                context,
                getTranslatedValue(
                  context,
                  "unable_to_return_product",
                ),
                MessageType.warning,
              );
            }
          }
        });
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: CustomTextLabel(
          jsonKey: "return1",
          softWrap: true,
          style: TextStyle(color: ColorsRes.appColorRed),
        ),
      ),
    );
  }

  Widget _buildOrderStatusContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                CustomTextLabel(
                  jsonKey: "order",
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
                const Spacer(),
                CustomTextLabel(
                  text: "#${widget.order.id}",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.order.activeStatus.isEmpty
                    ? const SizedBox()
                    : CustomTextLabel(
                        text: Constant.getOrderActiveStatusLabelFromCode(
                            widget.order.activeStatus)),
                const SizedBox(
                  height: 5,
                ),
                widget.order.activeStatus.isEmpty
                    ? const SizedBox()
                    : CustomTextLabel(
                        text: getStatusCompleteDate(
                            int.parse(widget.order.activeStatus)),
                        style: TextStyle(
                            color: ColorsRes.subTitleMainTextColor,
                            fontSize: 12.5),
                      ),
              ],
            ),
          ),
          const Divider(),
          Center(
            child: LayoutBuilder(builder: (context, boxConstraints) {
              return TrackMyOrderButton(
                  status: widget.order.status,
                  width: boxConstraints.maxWidth * (0.5));
            }),
          )
        ],
      ),
    );
  }

  Widget _buildOrderItemContainer(OrderItem orderItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: Constant.borderRadius10,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Widgets.setNetworkImg(
                    boxFit: BoxFit.fill,
                    image: orderItem.imageUrl,
                    width: boxConstraints.maxWidth * (0.25),
                    height: boxConstraints.maxWidth * (0.25),
                  ),
                ),
                SizedBox(
                  width: boxConstraints.maxWidth * (0.05),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextLabel(
                        text: orderItem.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextLabel(
                        text: "x ${orderItem.quantity}",
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextLabel(
                        text: "${orderItem.measurement} ${orderItem.unit}",
                        style:
                            TextStyle(color: ColorsRes.subTitleMainTextColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextLabel(
                        text: GeneralMethods.getCurrencyFormat(
                            double.parse(orderItem.price.toString())),
                        style: TextStyle(
                            color: ColorsRes.appColor,
                            fontWeight: FontWeight.w500),
                      ),
                      orderItem.cancelStatus == Constant.orderStatusCode[6]
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                _buildCancelItemButton(orderItem),
                              ],
                            )
                          : const SizedBox(),
                      orderItem.returnStatus == Constant.orderStatusCode[7]
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                _buildReturnItemButton(orderItem),
                              ],
                            )
                          : const SizedBox(),
                      (orderItem.activeStatus == Constant.orderStatusCode[6] ||
                              orderItem.activeStatus ==
                                  Constant.orderStatusCode[7])
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextLabel(
                                  text: Constant
                                      .getOrderActiveStatusLabelFromCode(
                                          orderItem.activeStatus),
                                  style:
                                      TextStyle(color: ColorsRes.appColorRed),
                                )
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            if (_showCancelOrderButton(widget.order) &&
                _showReturnOrderButton(widget.order) &&
                orderItem.activeStatus != "7" &&
                orderItem.activeStatus != "8")
              const Divider(),
            if (orderItem.activeStatus != "7" && orderItem.activeStatus != "8")
              LayoutBuilder(
                builder: (context, boxConstraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _showCancelOrderButton(widget.order)
                          ? _buildCancelOrderButton(
                              order: widget.order,
                              orderItemId: orderItem.id,
                              width: boxConstraints.maxWidth * (0.5),
                            )
                          : _showReturnOrderButton(widget.order)
                              ? _buildReturnOrderButton(
                                  order: widget.order,
                                  orderItemId: orderItem.id,
                                  width: boxConstraints.maxWidth * (0.5),
                                )
                              : const SizedBox(),
                    ],
                  );
                },
              ),
          ],
        );
      }),
    );
  }

  Widget _buildOrderItemsDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextLabel(
          jsonKey: "items",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: ColorsRes.mainTextColor,
          ),
        ),
        Widgets.getSizedBox(
          height: 5,
        ),
        Consumer<CurrentOrderProvider>(
          builder: (context, currentOrderProvider, child) {
            return Column(
              children: currentOrderProvider.order!.items
                  .map((orderItem) => _buildOrderItemContainer(orderItem))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeliveryInformationContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextLabel(
              jsonKey: "delivery_information",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextLabel(
                  jsonKey: "delivery_to",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
                const SizedBox(
                  height: 2.5,
                ),
                CustomTextLabel(
                  text: widget.order.address,
                  style: TextStyle(
                    color: ColorsRes.subTitleMainTextColor,
                    fontSize: 13.0,
                  ),
                ),
                CustomTextLabel(
                  text: widget.order.mobile,
                  style: TextStyle(
                    color: ColorsRes.subTitleMainTextColor,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetails() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextLabel(
              jsonKey: "billing_details",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomTextLabel(
                      jsonKey: "payment_method",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    const Spacer(),
                    CustomTextLabel(text: widget.order.paymentMethod),
                  ],
                ),
                SizedBox(
                  height: Constant.size10,
                ),
                widget.order.transactionId.isEmpty
                    ? const SizedBox()
                    : Column(
                        children: [
                          Row(
                            children: [
                              CustomTextLabel(
                                jsonKey: "transaction_id",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: ColorsRes.mainTextColor,
                                ),
                              ),
                              const Spacer(),
                              CustomTextLabel(
                                text: widget.order.transactionId,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Constant.size10,
                          ),
                        ],
                      ),
                Row(
                  children: [
                    CustomTextLabel(
                      jsonKey: "subtotal",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    const Spacer(),
                    CustomTextLabel(
                      text: GeneralMethods.getCurrencyFormat(
                        double.parse(widget.order.total),
                      ),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.mainTextColor),
                    ),
                  ],
                ),
                if (double.parse(widget.order.promoDiscount) > 0.0)
                  SizedBox(
                    height: Constant.size10,
                  ),
                if (double.parse(widget.order.promoDiscount) > 0.0)
                  Row(
                    children: [
                      CustomTextLabel(
                        text:
                            "${context.read<LanguageProvider>().currentLanguage["promo_code"](widget.order.promoCode)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                      const Spacer(),
                      CustomTextLabel(
                        text: GeneralMethods.getCurrencyFormat(
                          double.parse(
                            widget.order.promoDiscount,
                          ),
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.appColor,
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: Constant.size10,
                ),
                Row(
                  children: [
                    CustomTextLabel(
                      jsonKey: "delivery_charge",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    const Spacer(),
                    CustomTextLabel(
                      text: GeneralMethods.getCurrencyFormat(
                        double.parse(
                          widget.order.deliveryCharge,
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.appColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Constant.size10,
                ),
                Row(
                  children: [
                    CustomTextLabel(
                      jsonKey: "total",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    const Spacer(),
                    CustomTextLabel(
                      text: GeneralMethods.getCurrencyFormat(
                        double.parse(
                          widget.order.finalTotal,
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.appColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(context.read<CurrentOrderProvider>().order);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: getAppBar(
            context: context,
            title: CustomTextLabel(
              jsonKey: "order_summary",
              style: TextStyle(color: ColorsRes.mainTextColor),
            )),
        body: Stack(
          children: [
            PositionedDirectional(
              start: 0,
              end: 0,
              top: 0,
              bottom: 0,
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.only(
                    top: Constant.size10,
                    start: Constant.size10,
                    end: Constant.size10,
                    bottom: Constant.size65),
                child: Column(
                  children: [
                    _buildOrderStatusContainer(),
                    _buildOrderItemsDetails(),
                    _buildDeliveryInformationContainer(),
                    _buildBillDetails()
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              bottom: 10,
              start: 10,
              end: 10,
              child: Consumer<OrderInvoiceProvider>(
                builder: (context, orderInvoiceProvider, child) {
                  return Widgets.gradientBtnWidget(
                    context,
                    10,
                    callback: () {
                      orderInvoiceProvider.getOrderInvoiceApiProvider(
                        params: {
                          ApiAndParams.orderId: widget.order.id.toString()
                        },
                        context: context,
                      ).then(
                        (htmlContent) async {
                          try {
                            if (htmlContent != null) {
                              final appDocDirPath = io.Platform.isAndroid
                                  ? (await ExternalPath
                                      .getExternalStoragePublicDirectory(
                                          ExternalPath.DIRECTORY_DOWNLOADS))
                                  : (await getApplicationDocumentsDirectory())
                                      .path;

                              final targetFileName =
                                  "${getTranslatedValue(context, "app_name")}-${getTranslatedValue(context, "invoice")}#${widget.order.id.toString()}.pdf";

                              io.File file =
                                  io.File("$appDocDirPath/$targetFileName");

                              // Write down the file as bytes from the bytes got from the HTTP request.
                              await file.writeAsBytes(htmlContent,
                                  flush: false);
                              await file.writeAsBytes(htmlContent);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                action: SnackBarAction(
                                  label:
                                      getTranslatedValue(context, "show_file"),
                                  onPressed: () {
                                    OpenFilex.open(file.path);
                                  },
                                ),
                                content: CustomTextLabel(
                                  jsonKey: "file_saved_successfully",
                                  softWrap: true,
                                  style:
                                      TextStyle(color: ColorsRes.mainTextColor),
                                ),
                                duration: const Duration(seconds: 5),
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ));
                            }
                          } catch (_) {}
                        },
                      );
                    },
                    otherWidgets: orderInvoiceProvider.orderInvoiceState ==
                            OrderInvoiceState.loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: ColorsRes.appColorWhite,
                            ),
                          )
                        : CustomTextLabel(
                            jsonKey: "get_Invoice",
                            softWrap: true,
                            style:
                                Theme.of(context).textTheme.titleMedium!.merge(
                                      TextStyle(
                                        color: ColorsRes.appColorWhite,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
