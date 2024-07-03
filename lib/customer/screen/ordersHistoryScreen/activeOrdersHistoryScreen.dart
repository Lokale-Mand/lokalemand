import 'package:lokale_mand/customer/models/order.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class ActiveOrdersHistoryScreen extends StatefulWidget {
  const ActiveOrdersHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ActiveOrdersHistoryScreen> createState() =>
      _ActiveOrdersHistoryScreenState();
}

class _ActiveOrdersHistoryScreenState extends State<ActiveOrdersHistoryScreen>
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
          params: {ApiAndParams.type: ApiAndParams.active}, context: context);
    });
  }

  String getOrderedItemNames(List<ProductOrderItem> ProductOrderItem) {
    String itemNames = "";
    for (var i = 0; i < ProductOrderItem.length; i++) {
      if (i == ProductOrderItem.length - 1) {
        itemNames = itemNames + ProductOrderItem[i].productName!;
      } else {
        itemNames = "${ProductOrderItem[i].productName}, ";
      }
    }
    return itemNames;
  }

  Widget _buildOrderDetailsContainer(Order order) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, orderDetailScreen,
            arguments: [order, context]).then((value) {
          if (value != null) {
            context.read<ActiveOrdersProvider>().updateOrder(value as Order);
          }
        });
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.size10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomTextLabel(
                      text: "${getTranslatedValue(
                        context,
                        "order",
                      )} #${order.id}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.mainTextColor),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, orderDetailScreen,
                            arguments: [order, context]).then((value) {
                          if (value != null) {
                            context
                                .read<ActiveOrdersProvider>()
                                .updateOrder(value as Order);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent)),
                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextLabel(
                              jsonKey: "view_details",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: ColorsRes.subTitleMainTextColor),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12.0,
                              color: ColorsRes.subTitleMainTextColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                CustomTextLabel(
                  text: "${getTranslatedValue(
                    context,
                    "placed_order_on",
                  )} ${GeneralMethods.formatDate(DateTime.parse(order.createdAt!))}",
                  style: TextStyle(
                      fontSize: 12.5, color: ColorsRes.subTitleMainTextColor),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                CustomTextLabel(
                  text: getOrderedItemNames(order.items!),
                  style: TextStyle(
                    fontSize: 12.5,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextLabel(
                    jsonKey: "total",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: ColorsRes.mainTextColor,
                    ),
                  ),
                ),
                CustomTextLabel(
                  text: GeneralMethods.getCurrencyFormat(
                      double.parse(order.finalTotal!)),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ColorsRes.mainTextColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderContainer(Order order) {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.size10),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(vertical: Constant.size5),
      child: Column(
        children: [
          _buildOrderDetailsContainer(order),
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
                        provider.orders[index],
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
      body: _buildOrders(),
    );
  }
}
