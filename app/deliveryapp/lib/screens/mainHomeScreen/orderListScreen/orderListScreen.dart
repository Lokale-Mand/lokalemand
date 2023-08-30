import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late ScrollController scrollController = ScrollController()..addListener(activeOrdersScrollListener);
  List lblOrderStatusDisplayNames = [];

  void activeOrdersScrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<OrdersProvider>().hasMoreData) {
          context.read<OrdersProvider>().getOrders(
                context: context,
                statusIndex: context.read<OrdersProvider>().selectedStatus.toString(),
              );
        }
      }
    }
  }

  @override
  void initState() {
    Map<String, String> params = {};
    params[ApiAndParams.status] = "1";

    Future.delayed(
      Duration.zero,
      () {
        context.read<OrdersProvider>().getOrders(statusIndex: "0", context: context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    lblOrderStatusDisplayNames = [
      getTranslatedValue(context, "order_status_display_names_all"),
      getTranslatedValue(context, "order_status_display_names_awaiting"),
      getTranslatedValue(context, "order_status_display_names_received"),
      getTranslatedValue(context, "order_status_display_names_processed"),
      getTranslatedValue(context, "order_status_display_names_shipped"),
      getTranslatedValue(context, "order_status_display_names_out_for_delivery"),
      getTranslatedValue(context, "order_status_display_names_delivered"),
      getTranslatedValue(context, "order_status_display_names_cancelled"),
      getTranslatedValue(context, "order_status_display_names_returned"),
    ];
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: Text(
            "Orders",
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          centerTitle: true),
      body: Column(children: [
        Container(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(lblOrderStatusDisplayNames.length, (index) {
              return GestureDetector(
                onTap: () async {
                  if (mounted) {
                    await context.read<OrdersProvider>().changeOrderSelectedStatus(index).then((value) async {
                      if (value) {
                        await context.read<OrdersProvider>().getOrders(statusIndex: index.toString(), context: context);
                      }
                    });
                  }
                },
                child: getOrderStatusContainer(
                  isActive: context.watch<OrdersProvider>().selectedStatus == index,
                  svgIconName: Constant.orderStatusIcons[index],
                  context: context,
                  title: lblOrderStatusDisplayNames[index].toString(),
                ),
              );
            }),
          ),
        ),
        Consumer<OrdersProvider>(
          builder: (context, ordersProvider, child) {
            if (ordersProvider.ordersState == OrdersState.loaded || ordersProvider.ordersState == OrdersState.loadingMore) {
              return Expanded(
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: ordersProvider.sellerOrdersList.length,
                    itemBuilder: (context, index) {
                      if (index == ordersProvider.sellerOrdersList.length - 1) {
                        if (ordersProvider.ordersState == OrdersState.loadingMore) {
                          return _buildOrderContainerShimmer();
                        }
                      }
                      return _buildOrderContainer(ordersProvider.sellerOrdersList[index]);
                    }),
              );
            } else if (ordersProvider.ordersState == OrdersState.loaded || ordersProvider.ordersState == OrdersState.loading) {
              return Expanded(
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return _buildOrderContainerShimmer();
                    }),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        )
      ]),
    );
  }

  _buildOrderContainer(SellerOrdersListItem order) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          orderDetail,
          arguments: order.orderId.toString(),
        );
      },
      child: Container(
        padding: EdgeInsets.all(Constant.paddingOrMargin10),
        margin: EdgeInsetsDirectional.only(start: Constant.paddingOrMargin10, bottom: Constant.paddingOrMargin10, end: Constant.paddingOrMargin10),
        decoration: DesignConfig.boxDecoration(
          Theme.of(context).cardColor,
          10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "ID #${order.id}",
                    softWrap: true,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Widgets.getSizedBox(width: 10),
                Text(
                  GeneralMethods.getCurrencyFormat(
                    double.parse(
                      order.finalTotal.toString(),
                    ),
                  ),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorsRes.appColor),
                  softWrap: true,
                ),
              ],
            ),
            Widgets.getSizedBox(
              height: 10,
            ),
            Divider(height: 1, color: ColorsRes.grey, thickness: 0),
            Widgets.getSizedBox(
              height: 10,
            ),
            Text(
              getTranslatedValue(context, "payment_method"),
              style: TextStyle(fontSize: 14, color: ColorsRes.grey),
              softWrap: true,
            ),
            Widgets.getSizedBox(height: 2),
            Text(
              "${order.paymentMethod}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              softWrap: true,
            ),
            Widgets.getSizedBox(height: 20),
            Text(
              getTranslatedValue(context, "delivery_time"),
              style: TextStyle(fontSize: 14, color: ColorsRes.grey),
              softWrap: true,
            ),
            Widgets.getSizedBox(height: 2),
            Text(
              "${order.deliveryTime ?? ""}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              softWrap: true,
            ),
            Widgets.getSizedBox(
              height: 10,
            ),
            Divider(height: 1, color: ColorsRes.grey, thickness: 0),
            Widgets.getSizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
                        builder: (BuildContext context) {
                          return ChangeNotifierProvider(
                            create: (context) => DeliveryBoysProvider(),
                            child: Wrap(
                              children: [BottomSheetDeliveryBoysContainer(orderId: order.id.toString(), deliveryBoyId: "${order.deliveryBoyId.toString().isEmpty ? "0" : order.deliveryBoyId.toString()}")],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      margin: EdgeInsetsDirectional.only(end: 5),
                      padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorsRes.appColor, width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslatedValue(context, "delivery_boy"),
                                  style: TextStyle(fontSize: 14, color: ColorsRes.grey),
                                  softWrap: true,
                                ),
                                Widgets.getSizedBox(height: 2),
                                Text(
                                  "${(order.deliveryBoyName == null || order.deliveryBoyName == "null") ? getTranslatedValue(context, "not_assign") : order.deliveryBoyName}",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
                        builder: (BuildContext context) {
                          return ChangeNotifierProvider(
                            create: (context) => OrderUpdateProvider(),
                            child: Wrap(
                              children: [
                                BottomSheetStatusContainer(
                                  orderId: order.id.toString(),
                                  statusId: order.activeStatus ?? "0",
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin5),
                      margin: EdgeInsetsDirectional.only(start: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorsRes.appColor, width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslatedValue(context, "status"),
                                  style: TextStyle(fontSize: 14, color: ColorsRes.grey),
                                  softWrap: true,
                                ),
                                Widgets.getSizedBox(height: 2),
                                Text(
                                  lblOrderStatusDisplayNames[int.parse(order.activeStatus ?? "0")].toString(),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildOrderContainerShimmer() {
    return CustomShimmer(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      borderRadius: 10,
      margin: EdgeInsetsDirectional.only(start: Constant.paddingOrMargin10, end: Constant.paddingOrMargin10, bottom: Constant.paddingOrMargin10),
    );
  }
}
