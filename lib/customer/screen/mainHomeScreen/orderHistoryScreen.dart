import 'package:lokale_mand/customer/models/order.dart';
import 'package:lokale_mand/customer/provider/productRatingProvider.dart';
import 'package:lokale_mand/customer/screen/orderProductSubmitRatingWidget.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with TickerProviderStateMixin {
  late ScrollController scrollController = ScrollController()
    ..addListener(scrollListener);

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<ActiveOrdersProvider>().hasMoreData) {
          context
              .read<ActiveOrdersProvider>()
              .getOrders(params: {}, context: context);
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context
          .read<ActiveOrdersProvider>()
          .getOrders(params: {}, context: context);
    });
  }

  String getOrderedItemNames(List<ProductOrderItem> ProductOrderItem) {
    String itemNames = "";
    for (var i = 0; i < ProductOrderItem.length; i++) {
      if (i == ProductOrderItem.length - 1) {
        itemNames = itemNames + ProductOrderItem[i].productName;
      } else {
        itemNames = "${ProductOrderItem[i].productName}, ";
      }
    }
    return itemNames;
  }

  _buildOrderContainer(Order order, String index) {
    DateTime dateTime = DateTime.parse(order.createdAt.toString());

    List lblOrderStatusDisplayNames = [
      getTranslatedValue(context, "order_status_display_names_awaiting"),
      getTranslatedValue(context, "order_status_display_names_received"),
      getTranslatedValue(context, "order_status_display_names_processed"),
      getTranslatedValue(context, "order_status_display_names_shipped"),
      getTranslatedValue(
          context, "order_status_display_names_out_for_delivery"),
      getTranslatedValue(context, "order_status_display_names_delivered"),
      getTranslatedValue(context, "order_status_display_names_cancelled"),
      getTranslatedValue(context, "order_status_display_names_returned"),
    ];

    late ItemRating? itemRating;

    try {
      if (order.items.first.itemRating?.first != null) {
        itemRating = order.items.first.itemRating?.first;
      }
    } catch (_) {
      itemRating = ItemRating(
          id: "0",
          images: [],
          productId: "0",
          rate: "0",
          review: "",
          status: "",
          updatedAt: "",
          user: null,
          userId: "");
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsetsDirectional.only(
        start: 20,
        end: 20,
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
                  "${order.userName}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorsRes.mainTextColor,
                  ),
                  softWrap: true,
                ),
              ),
              Widgets.getSizedBox(width: 10),
              Text(
                "${dateTime.day}-${dateTime.month}-${dateTime.year}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ColorsRes.mainTextColor,
                ),
                softWrap: true,
              ),
            ],
          ),
          Widgets.getSizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Widgets.setNetworkImg(
                  image: context
                      .read<ActiveOrdersProvider>()
                      .getVariantImageFromOrderId(
                        order.id.toString(),
                      ),
                  height: 75,
                  width: 75,
                  boxFit: BoxFit.cover,
                ),
              ),
              Widgets.getSizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context
                          .read<ActiveOrdersProvider>()
                          .getVariantProductNameFromOrderId(
                            order.id.toString(),
                          ),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: ColorsRes.mainTextColor,
                      ),
                      softWrap: true,
                    ),
                    Widgets.getSizedBox(height: 5),
                    Text(
                      GeneralMethods.getCurrencyFormat(
                        double.parse(
                          order.finalTotal.toString(),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: ColorsRes.mainTextColor,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: ColorsRes.menuTitleColor, width: 1),
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsetsDirectional.only(
                    start: 25, end: 25, top: 3, bottom: 3),
                child: Text(
                  order.items.first.quantity,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ColorsRes.mainTextColor,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  lblOrderStatusDisplayNames[
                      int.parse(order.activeStatus.toString()) - 1],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ColorsRes.mainTextColor,
                  ),
                  softWrap: true,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    if (order.activeStatus.toString() == "6")
                      SizedBox(width: 10),
                    if (order.activeStatus.toString() == "6")
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: (itemRating?.rate.toString() != "0")
                            ? GestureDetector(
                                onTap: () {
                                  if (order.items.first.itemRating?.first !=
                                          null ||
                                      order.activeStatus.toString() == "6") {
                                    openRatingDialog(order).then((value) {
                                      print("value is not null 2 $value");
                                      if (value != null) {
                                        context
                                            .read<ActiveOrdersProvider>()
                                            .orders
                                            .clear();
                                        context
                                            .read<ActiveOrdersProvider>()
                                            .offset = 0;
                                        return context
                                            .read<ActiveOrdersProvider>()
                                            .getOrders(
                                                params: {}, context: context);
                                      }
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rate_rounded,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: 5),
                                    CustomTextLabel(
                                      text: itemRating?.rate.toString(),
                                      style: TextStyle(
                                        color: ColorsRes.subTitleMainTextColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Widgets.gradientBtnWidget(
                                context,
                                5,
                                callback: () {
                                  if (order.activeStatus.toString() == "6") {
                                    openRatingDialog(order).then((value) {
                                      print("value is not null 1 $value");
                                      if (value != null) {
                                        context
                                            .read<ActiveOrdersProvider>()
                                            .orders
                                            .clear();
                                        context
                                            .read<ActiveOrdersProvider>()
                                            .offset = 0;
                                        return context
                                            .read<ActiveOrdersProvider>()
                                            .getOrders(
                                                params: {}, context: context);
                                      }
                                    });
                                  }
                                },
                                otherWidgets: CustomTextLabel(
                                  jsonKey: "write_a_review",
                                  style: TextStyle(
                                    color: ColorsRes.appColorWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                height: 30,
                                width: context.width * 0.30,
                              ),
                      ),
                  ],
                ),
              )
            ],
          ),
          Widgets.getSizedBox(height: 10),
          Container(
            width: MediaQuery.sizeOf(context).width,
            child: CustomTextLabel(
              jsonKey: "your_payment_method",
              style: TextStyle(
                color: ColorsRes.mainTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Widgets.getSizedBox(height: 10),
          Container(
            width: MediaQuery.sizeOf(context).width,
            child: getPaymentOptionWidget(
              context,
              order.paymentMethod,
            ),
          ),
          Widgets.getSizedBox(height: 10),
          Divider(
            color: ColorsRes.menuTitleColor,
          )
        ],
      ),
    );
  }

  Widget _buildOrders() {
    return Consumer<ActiveOrdersProvider>(
      builder: (context, provider, _) {
        if (provider.activeOrdersState == ActiveOrdersState.loaded ||
            provider.activeOrdersState == ActiveOrdersState.loadingMore) {
          return setRefreshIndicator(
              refreshCallback: () async {
                context.read<ActiveOrdersProvider>().orders.clear();
                context.read<ActiveOrdersProvider>().offset = 0;
                context
                    .read<ActiveOrdersProvider>()
                    .getOrders(params: {}, context: context);
              },
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.size10,
                  vertical: Constant.size10,
                ),
                controller: scrollController,
                shrinkWrap: true,
                children: [
                  Column(
                    children: List.generate(
                      provider.orders.length,
                      (index) => _buildOrderContainer(
                          provider.orders[index], index.toString()),
                    ),
                  ),
                  if (provider.activeOrdersState ==
                      ActiveOrdersState.loadingMore)
                    _buildOrderContainerShimmer(),
                ],
              ));
        }
        if (provider.activeOrdersState == ActiveOrdersState.error) {
          return const SizedBox();
        }
        return _buildOrdersHistoryShimmer();
      },
    );
  }

  Widget _buildOrderContainerShimmer() {
    return CustomShimmer(
      height: 140,
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsetsDirectional.only(top: 10),
    );
  }

  Widget _buildOrdersHistoryShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(10, (index) => index)
              .map((e) => _buildOrderContainerShimmer())
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          text: getTranslatedValue(
            context,
            "orders",
          ),
          softWrap: true,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ColorsRes.mainTextColor,
          ),
        ),
        actions: [
          // setCartCounter(context: context),
        ],
        showBackButton: false,
      ),
      body: _buildOrders(),
    );
  }

  Future openRatingDialog(Order order) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: context.height * 0.7),
      shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
      backgroundColor: Theme.of(context).cardColor,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            constraints: BoxConstraints(
              minHeight: context.height * 0.5,
            ),
            padding: EdgeInsetsDirectional.only(
                start: Constant.size15,
                end: Constant.size15,
                top: Constant.size15,
                bottom: Constant.size15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Widgets.defaultImg(
                            image: "ic_arrow_back",
                            iconColor: ColorsRes.mainTextColor,
                            height: 15,
                            width: 15,
                          ),
                        ),
                      ),
                      CustomTextLabel(
                        jsonKey: "ratings",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium!.merge(
                              TextStyle(
                                letterSpacing: 0.5,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: ColorsRes.mainTextColor,
                              ),
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          height: 15,
                          width: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider<ProductRatingProvider>(
                        create: (BuildContext context) {
                          return ProductRatingProvider();
                        },
                      )
                    ],
                    child: OrderProductSubmitRatingWidget(
                      size: 100,
                      order: order,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
