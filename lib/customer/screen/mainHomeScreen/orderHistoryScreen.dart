import 'package:flutter/cupertino.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
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
      context.read<ActiveOrdersProvider>().getOrders(
          params: {}, context: context);
    });
  }

  String getOrderedItemNames(List<OrderItem> orderItems) {
    String itemNames = "";
    for (var i = 0; i < orderItems.length; i++) {
      if (i == orderItems.length - 1) {
        itemNames = itemNames + orderItems[i].productName;
      } else {
        itemNames = "${orderItems[i].productName}, ";
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

    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(
        //   context,
        //   orderDetail,
        //   arguments: order.orderId.toString(),
        // );
      },
      child: Container(
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
                    "10",
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
            Text(
              int.parse(order.activeStatus.toString()) >= 9
                  ? lblOrderStatusDisplayNames[
              int.parse(order.activeStatus.toString()) - 3]
                  : lblOrderStatusDisplayNames[
              int.parse(order.activeStatus.toString())],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ColorsRes.mainTextColor,
              ),
              softWrap: true,
            ),
            Divider(
              color: ColorsRes.menuTitleColor,
            )
          ],
        ),
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
                        provider.orders[index],index.toString()
                      ),
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
}
