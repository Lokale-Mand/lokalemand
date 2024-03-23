import 'package:intl/intl.dart';
import 'package:lokale_mand/customer/models/customerChatList.dart';
import 'package:lokale_mand/customer/provider/customerChatListProvider.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class CustomerChatListScreen extends StatefulWidget {
  final ScrollController scrollController;

  const CustomerChatListScreen({super.key, required this.scrollController});

  @override
  State<CustomerChatListScreen> createState() => _CustomerChatListScreenState();
}

class _CustomerChatListScreenState extends State<CustomerChatListScreen> {
  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger =
        0.7 * widget.scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (widget.scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<CustomerChatListProvider>().hasMoreData) {
          callApi(isReset: false);
        }
      }
    }
  }

  callApi({required isReset}) async {
    if (Constant.session.isUserLoggedIn()) {
      if (isReset) {
        context.read<CustomerChatListProvider>().offset = 0;
        context.read<CustomerChatListProvider>().chats = [];
      }

      await context
          .read<CustomerChatListProvider>()
          .getCustomerChatList(context: context, params: {});
    } else {
      setState(() {
        context.read<CustomerChatListProvider>().customerChatListState =
            CustomerChatListState.error;
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
        title: CustomTextLabel(
          text: getTranslatedValue(
            context,
            "chat",
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
      body: Consumer<CustomerChatListProvider>(
        builder: (context, customerChatListProvider, _) {
          print(">>> ${customerChatListProvider.customerChatListState}");
          return setRefreshIndicator(
            refreshCallback: () async {
              callApi(isReset: true);
            },
            child: SingleChildScrollView(
              controller: widget.scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              child: customerChatListProvider.customerChatListState ==
                      CustomerChatListState.loading
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
                  : (customerChatListProvider.customerChatListState ==
                              CustomerChatListState.loadingMore ||
                          customerChatListProvider.customerChatListState ==
                              CustomerChatListState.loaded)
                      ? ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Column(
                              children: List.generate(
                                customerChatListProvider.chats.length,
                                (index) {
                                  CustomerChatListData chat =
                                      customerChatListProvider.chats[index];

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

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        chatDetailScreen,
                                        arguments: [
                                          chat.sellerId.toString(),
                                          chat.sellerName.toString(),
                                          chat.sellerLogo,
                                          (chat.rating != null &&
                                                  chat.rating!.isNotEmpty)
                                              ? chat.rating![0]
                                              : null,
                                          chat.isEligibleRating != "0",
                                        ],
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsetsDirectional.only(
                                        start: 10,
                                        end: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: index == 0
                                              ? BorderSide(
                                                  width: 1.5,
                                                  color: ColorsRes
                                                      .menuTitleColor
                                                      .withOpacity(0.1),
                                                )
                                              : BorderSide.none,
                                          bottom: BorderSide(
                                            width: 1.5,
                                            color: ColorsRes.menuTitleColor
                                                .withOpacity(0.1),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            child: Widgets.setNetworkImg(
                                                image:
                                                    chat.sellerLogo.toString(),
                                                height: 60,
                                                width: 60,
                                                boxFit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          Widgets.getSizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomTextLabel(
                                                  text: chat.sellerName
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: ColorsRes
                                                          .mainTextColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Widgets.getSizedBox(height: 5),
                                                CustomTextLabel(
                                                  text: chat.message.toString(),
                                                  style: TextStyle(
                                                    color: ColorsRes
                                                        .menuTitleColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomTextLabel(
                                            text: createdAt.toString(),
                                            style: TextStyle(
                                              color: ColorsRes.menuTitleColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (customerChatListProvider
                                    .customerChatListState ==
                                CustomerChatListState.loadingMore)
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
