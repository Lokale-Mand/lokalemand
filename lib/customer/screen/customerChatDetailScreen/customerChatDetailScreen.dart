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
    try {
      // prevPageTrigger will have a value equivalent to 70% of the list size.
      var prevPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

      // _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
      if (scrollController.position.pixels >= prevPageTrigger) {
        if (mounted) {
          if (context.read<CustomerChatDetailProvider>().hasMoreData) {
            callApi(isReset: false);
          }
        }
      }
    } catch (s) {}
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
    Future.delayed(Duration.zero).then((value) {
      scrollController.addListener(() {
        scrollListener();
      });

      callApi(isReset: true);
    });
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
      bottomNavigationBar: Consumer<CustomerChatDetailProvider>(
        builder: (context, customerChatListProvider, _) {
          return PhysicalModel(
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
                start: 20,
                end: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 30,
              ),
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
                      constraints: BoxConstraints(
                        minHeight: 40,
                        maxHeight: 120,
                      ),
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
                          minLines: 1,
                          maxLines: 100,
                          controller: chatMessageTextEditingController,
                          style: TextStyle(
                            color: ColorsRes.mainTextColor
                          ),
                        ),
                      ),
                    ),
                  ),
                  Widgets.getSizedBox(width: 10),
                  Row(
                    children: [
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Icon(
                      //     Icons.attach_file_rounded,
                      //     color: ColorsRes.mainTextColor,
                      //     size: 25,
                      //   ),
                      // ),
                      // Widgets.getSizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          if (chatMessageTextEditingController
                              .text.isNotEmpty) {
                            print(chatMessageTextEditingController.text
                                .toString());
                            customerChatListProvider.sendMessageToSeller(
                              params: {
                                "message": chatMessageTextEditingController.text
                                    .toString(),
                                "sender_id": Constant.session
                                    .getData(SessionManager.keyUserId),
                                "receiver_id": widget.sellerId,
                                "sender_type": "1",
                              },
                              context: context,
                            ).then((value) =>
                                chatMessageTextEditingController.clear());
                          }
                        },
                        child:
                            customerChatListProvider.customerSendMessageState ==
                                    CustomerSendMessageState.messageSending
                                ? Container(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(),
                                  )
                                : Icon(
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
          );
        },
      ),
      body: Consumer<CustomerChatDetailProvider>(
        builder: (context, customerChatListProvider, _) {
          return ListView(
            reverse: true,
            controller: scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              customerChatListProvider.customerChatDetailState ==
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
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            CustomerChatDetailData chat =
                                customerChatListProvider.chatDetails[index];

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
                              createdAt =
                                  getTranslatedValue(context, "yesterday");
                            } else {
                              // More than yesterday
                              createdAt =
                                  DateFormat('dd/MM/yyyy').format(dateTime);
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
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
                                                jsonKey:
                                                    "${getTranslatedValue(context, "you_have_request_a_reservation_from")} ${widget.sellerName}:",
                                              ),
                                              ChatDetailOrderItemWidget(
                                                orderData: chat,
                                              )
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Align(
                                                child: CustomTextLabel(
                                                  text: chat.message
                                                      .toString()
                                                      .replaceAll("\\n", "\n")
                                                      .replaceAll("\\t", "\t"),
                                                  style: TextStyle(
                                                    color:
                                                        ColorsRes.mainTextColor,
                                                  ),
                                                  softWrap: true,
                                                ),
                                                alignment: AlignmentDirectional
                                                    .centerStart,
                                              ),
                                              Align(
                                                child: CustomTextLabel(
                                                  text: createdAt.toString(),
                                                  style: TextStyle(
                                                    color: ColorsRes
                                                        .menuTitleColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  softWrap: true,
                                                ),
                                                alignment: AlignmentDirectional
                                                    .centerEnd,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount:
                              customerChatListProvider.chatDetails.length,
                          reverse: true,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        )
                      : DefaultBlankItemMessageScreen(
                          image: "messages",
                          title: "opps_no_message_yet",
                          description: "opps_no_message_yet_description",
                        ),
            ],
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
