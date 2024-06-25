import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerOrders.dart';
import 'package:lokale_mand/seller/provider/ordersProvider.dart';

class SellerOrderScreen extends StatefulWidget {
  const SellerOrderScreen({super.key});

  @override
  State<SellerOrderScreen> createState() => _SellerOrderScreenState();
}

class _SellerOrderScreenState extends State<SellerOrderScreen> {
  late ScrollController scrollController = ScrollController();

  List lblOrderStatusDisplayNames = [];

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<SellerOrdersProvider>().hasMoreData) {
          context.read<SellerOrdersProvider>().getSellerOrders(
                context: context,
                statusIndex: context
                    .read<SellerOrdersProvider>()
                    .selectedStatus
                    .toString(),
              );
        }
      }
    }
  }

  @override
  void initState() {
    Map<String, String> params = {};
    params[ApiAndParams.status] = "1";

    scrollController.addListener(scrollListener);
    Future.delayed(
      Duration.zero,
      () {
        context
            .read<SellerOrdersProvider>()
            .getSellerOrders(statusIndex: "0", context: context);
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
      getTranslatedValue(
          context, "order_status_display_names_out_for_delivery"),
      getTranslatedValue(context, "order_status_display_names_delivered"),
      getTranslatedValue(context, "order_status_display_names_cancelled"),
      getTranslatedValue(context, "order_status_display_names_returned"),
    ];
    return Scaffold(
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
      body: setRefreshIndicator(
        refreshCallback: () async {
          context
              .read<SellerOrdersProvider>()
              .getSellerOrders(statusIndex: "0", context: context);
        },
        child: SingleChildScrollView(
          child: Consumer<SellerOrdersProvider>(
            builder: (context, ordersProvider, child) {
              if (ordersProvider.ordersState == SellerOrdersState.loaded ||
                  ordersProvider.ordersState == SellerOrdersState.loadingMore) {
                return Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: ordersProvider.sellerOrdersList.length,
                        itemBuilder: (context, index) {
                          if (index ==
                              ordersProvider.sellerOrdersList.length - 1) {
                            if (ordersProvider.ordersState ==
                                SellerOrdersState.loadingMore) {
                              return _buildOrderContainerShimmer();
                            }
                          }
                          return _buildOrderContainer(
                              ordersProvider.sellerOrdersList[index],
                              index.toString());
                        }),
                  ],
                );
              } else if (ordersProvider.ordersState ==
                  SellerOrdersState.loading) {
                return Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return _buildOrderContainerShimmer();
                        }),
                  ],
                );
              } else {
                return DefaultBlankItemMessageScreen(
                  image: "no_order_icon",
                  title: "opps_no_reservation_yet",
                  description: "opps_no_reservation_yet_description",
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _buildOrderContainer(SellerOrdersListItem order, String index) {
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
        Navigator.pushNamed(
          context,
          orderDetailScreen,
          arguments: order.orderId.toString(),
        );
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
                        .read<SellerOrdersProvider>()
                        .getVariantImageFromOrderId(
                          order.orderId.toString(),
                        ),
                    height: 75,
                    width: 75,
                    boxFit: BoxFit.cover,
                  ),
                ),
                Widgets.getSizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context
                          .read<SellerOrdersProvider>()
                          .getVariantProductNameFromOrderId(
                            order.orderId.toString(),
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
              lblOrderStatusDisplayNames[
                  int.parse(order.activeStatus.toString()) - 1],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ColorsRes.mainTextColor,
              ),
              softWrap: true,
            ),
            if (int.tryParse(order.activeStatus.toString())! == 1)
              Widgets.getSizedBox(height: 10),
            if (int.tryParse(order.activeStatus.toString())! == 1)
              Row(
                children: [
                  ChangeNotifierProvider(
                    create: (context) => SellerOrdersProvider(),
                    child: Expanded(
                      child: Consumer<SellerOrdersProvider>(
                          builder: (context, sellerOrdersProvider, child) {
                        return Widgets.gradientBtnWidget(
                          context,
                          7,
                          callback: () {
                            Map<String, String> params = {};
                            params[ApiAndParams.orderId] =
                                order.id.toString() ?? "0";
                            params[ApiAndParams.statusId] = "2";
                            sellerOrdersProvider
                                .updateSellerOrdersStatusFromList(
                              params: params,
                              context: context,
                              order: order,
                            )
                                .then(
                              (value) {
                                context.read<SellerOrdersProvider>().offset = 0;
                                context
                                    .read<SellerOrdersProvider>()
                                    .getSellerOrders(
                                        statusIndex: "0", context: context);
                              },
                            );
                          },
                          title: getTranslatedValue(context, "accept"),
                          height: 30,
                          color1: Colors.green,
                          color2: Colors.green,
                        );
                      }),
                    ),
                  ),
                  Widgets.getSizedBox(width: 10),
                  ChangeNotifierProvider(
                    create: (context) => SellerOrdersProvider(),
                    child: Expanded(
                      child: Consumer<SellerOrdersProvider>(
                          builder: (context, sellerOrdersProvider, child) {
                        return Widgets.gradientBtnWidget(
                          context,
                          7,
                          callback: () {
                            Map<String, String> params = {};
                            params[ApiAndParams.orderId] =
                                order.id.toString() ?? "0";
                            params[ApiAndParams.statusId] = "7";
                            sellerOrdersProvider
                                .updateSellerOrdersStatusFromList(
                                    params: params,
                                    context: context,
                                    order: order)
                                .then(
                              (value) {
                                context.read<SellerOrdersProvider>().offset = 0;
                                context
                                    .read<SellerOrdersProvider>()
                                    .getSellerOrders(
                                        statusIndex: "0", context: context);
                              },
                            );
                          },
                          title: getTranslatedValue(context, "reject"),
                          height: 30,
                          color1: Colors.red,
                          color2: Colors.red,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            Divider(
              color: ColorsRes.menuTitleColor,
            )
          ],
        ),
      ),
    );
  }

  _buildOrderContainerShimmer() {
    return CustomShimmer(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.25,
      borderRadius: 10,
      margin: EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 10),
    );
  }
}
