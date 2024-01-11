import 'package:intl/intl.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerChatList.dart';
import 'package:lokale_mand/seller/provider/sellerChatListProvider.dart';

class SellerChatListScreen extends StatefulWidget {
  final ScrollController scrollController;

  const SellerChatListScreen({super.key, required this.scrollController});

  @override
  State<SellerChatListScreen> createState() => _SellerChatListScreenState();
}

class _SellerChatListScreenState extends State<SellerChatListScreen> {
  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger =
        0.7 * widget.scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (widget.scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<SellerChatListProvider>().hasMoreData) {
          callApi(isReset: false);
        }
      }
    }
  }

  callApi({required isReset}) async {
    if (Constant.session.isUserLoggedIn()) {
      if (isReset) {
        context.read<SellerChatListProvider>().offset = 0;
        context.read<SellerChatListProvider>().chats = [];
      }

      await context
          .read<SellerChatListProvider>()
          .getSellerChatList(context: context, params: {});
    } else {
      setState(() {
        context.read<SellerChatListProvider>().sellerChatListState =
            SellerChatListState.error;
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
      body: Consumer<SellerChatListProvider>(
        builder: (context, sellerChatListProvider, _) {
          return setRefreshIndicator(
            refreshCallback: () async {
              callApi(isReset: true);
            },
            child: SingleChildScrollView(
              controller: widget.scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              child: sellerChatListProvider.sellerChatListState ==
                      SellerChatListState.loading
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
                  : (sellerChatListProvider.sellerChatListState ==
                              SellerChatListState.loadingMore ||
                          sellerChatListProvider.sellerChatListState ==
                              SellerChatListState.loaded)
                      ? ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Column(
                              children: List.generate(
                                sellerChatListProvider.chats.length,
                                (index) {
                                  SellerChatListData chat =
                                      sellerChatListProvider.chats[index];

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
                                        sellerChatDetailScreen,
                                        arguments: [
                                          chat.customerId.toString(),
                                          chat.customerName.toString(),
                                          chat.customerLogo,
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
                                            color: ColorsRes.menuTitleColor
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
                                                image: chat.customerLogo.toString(),
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
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                CustomTextLabel(
                                                  text:
                                                  chat.customerName.toString(),
                                                  style: TextStyle(
                                                      color:
                                                      ColorsRes.mainTextColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Widgets.getSizedBox(height: 5),
                                                CustomTextLabel(
                                                  text: chat.message.toString(),
                                                  style: TextStyle(
                                                    color:
                                                    ColorsRes.menuTitleColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
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
                            if (sellerChatListProvider.sellerChatListState ==
                                SellerChatListState.loadingMore)
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
