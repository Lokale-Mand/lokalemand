import 'package:intl/intl.dart';
import 'package:lokale_mand/customer/models/chatDetail.dart';
import 'package:lokale_mand/customer/provider/customerChatDetailProvider.dart';
import 'package:lokale_mand/customer/screen/customerChatDetailScreen/widget/chatDetailOrderItemWidget.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class CustomerChatDetailScreen extends StatefulWidget {
  final String sellerId;
  final String sellerName;
  final String sellerLogo;

  CustomerChatDetailScreen({
    super.key,
    required this.sellerId,
    required this.sellerName,
    required this.sellerLogo,
  });

  @override
  State<CustomerChatDetailScreen> createState() =>
      _CustomerChatDetailScreenState();
}

class _CustomerChatDetailScreenState extends State<CustomerChatDetailScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController chatMessageTextEditingController =
      TextEditingController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.minScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels <= nextPageTrigger) {
      if (mounted) {
        if (context.read<CustomerChatDetailProvider>().hasMoreData) {
          callApi(isReset: false);
        }
      }
    }
  }

  callApi({required isReset}) async {
    if (Constant.session.isUserLoggedIn()) {
      if (isReset) {
        context.read<CustomerChatDetailProvider>().offset = 0;
        context.read<CustomerChatDetailProvider>().chatDetails = [];
      }

      await context.read<CustomerChatDetailProvider>().getCustomerChatDetail(
          context: context, params: {ApiAndParams.sellerId: widget.sellerId});
    } else {
      setState(() {
        context.read<CustomerChatDetailProvider>().customerChatDetailState =
            CustomerChatDetailState.error;
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => callApi(isReset: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: getAppBar(
        context: context,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Widgets.setNetworkImg(
                image: widget.sellerLogo.toString(),
                height: 35,
                width: 35,
                boxFit: BoxFit.cover,
              ),
            ),
            Widgets.getSizedBox(width: 10),
            CustomTextLabel(
              text: widget.sellerName,
              softWrap: true,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColorsRes.mainTextColor,
              ),
            ),
          ],
        ),
        actions: [
          // setCartCounter(context: context),
        ],
      ),
      bottomNavigationBar: PhysicalModel(
        elevation: 10,
        color: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15,
          ),
          topRight: Radius.circular(
            15,
          ),
        ),
        child: Container(
          padding: EdgeInsetsDirectional.only(
              start: 20, end: 20, top: 20, bottom: 30),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                15,
              ),
              topRight: Radius.circular(
                15,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorsRes.menuTitleColor.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: null,
                      controller: chatMessageTextEditingController,
                    ),
                  ),
                ),
              ),
              Widgets.getSizedBox(width: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.attach_file_rounded,
                      color: ColorsRes.mainTextColor,
                      size: 25,
                    ),
                  ),
                  Widgets.getSizedBox(width: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.send_rounded,
                      color: ColorsRes.mainTextColor,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Consumer<CustomerChatDetailProvider>(
        builder: (context, customerChatListProvider, _) {
          return setRefreshIndicator(
            refreshCallback: () async {
              callApi(isReset: true);
            },
            child: SingleChildScrollView(
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              child: customerChatListProvider.customerChatDetailState ==
                      CustomerChatDetailState.loading
                  ? Column(
                      children: List.generate(
                        10,
                        (index) => CustomShimmer(
                          height: 80,
                          width: MediaQuery.sizeOf(context).width,
                          margin: EdgeInsets.only(bottom: 10),
                        ),
                      ),
                    )
                  : (customerChatListProvider.customerChatDetailState ==
                              CustomerChatDetailState.loadingMore ||
                          customerChatListProvider.customerChatDetailState ==
                              CustomerChatDetailState.loaded)
                      ? ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Column(
                              children: List.generate(
                                customerChatListProvider.chatDetails.length,
                                (index) {
                                  CustomerChatDetailData chat =
                                      customerChatListProvider
                                          .chatDetails[index];

                                  String createdAt = "";

                                  DateTime dateTime =
                                      DateTime.parse(chat.createdAt.toString())
                                          .toLocal();
                                  DateTime now = DateTime.now().toLocal();
                                  DateTime yesterday =
                                      now.subtract(Duration(days: 1));

                                  if (isSameDay(dateTime, now)) {
                                    // Today
                                    createdAt = DateFormat.Hm()
                                        .format(dateTime); // HH:MM format
                                  } else if (isSameDay(dateTime, yesterday)) {
                                    // Yesterday
                                    createdAt = getTranslatedValue(
                                        context, "yesterday");
                                  } else {
                                    // More than yesterday
                                    createdAt = DateFormat('dd/MM/yyyy')
                                        .format(dateTime);
                                  }

                                  return Align(
                                    alignment: (chat.senderType == "1")
                                        ? AlignmentDirectional.centerEnd
                                        : AlignmentDirectional.centerStart,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.sizeOf(context).width *
                                                0.7,
                                      ),
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsetsDirectional.only(
                                          start: 10, end: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: ColorsRes.menuTitleColor,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: ColorsRes.menuTitleColor
                                            .withOpacity(0.02),
                                      ),
                                      child: (chat.order != null ||
                                              chat.orderId != "null")
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomTextLabel(
                                                  text:
                                                      "You have requested a reservation from Felyx:",
                                                ),
                                                ChatDetailOrderItemWidget(
                                                  orderData: chat.order,
                                                )
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Align(
                                                  child: CustomTextLabel(
                                                    text:
                                                        chat.message.toString(),
                                                    style: TextStyle(
                                                      color: ColorsRes
                                                          .mainTextColor,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  alignment:
                                                      AlignmentDirectional
                                                          .centerStart,
                                                ),
                                                Align(
                                                  child: CustomTextLabel(
                                                    text: createdAt.toString(),
                                                    style: TextStyle(
                                                      color: ColorsRes
                                                          .menuTitleColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  alignment:
                                                      AlignmentDirectional
                                                          .centerEnd,
                                                ),
                                              ],
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (customerChatListProvider
                                    .customerChatDetailState ==
                                CustomerChatDetailState.loadingMore)
                              CustomShimmer(
                                height: 80,
                                width: MediaQuery.sizeOf(context).width,
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                          ],
                        )
                      : DefaultBlankItemMessageScreen(
                          image: "messages",
                          title: "opps_no_message_yet",
                          description: "opps_no_message_yet_description",
                        ),
            ),
          );
        },
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
