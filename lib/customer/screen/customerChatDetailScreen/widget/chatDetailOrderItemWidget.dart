import 'package:intl/intl.dart';
import 'package:lokale_mand/customer/models/chatDetail.dart';
import 'package:lokale_mand/customer/provider/productRatingProvider.dart';
import 'package:lokale_mand/customer/screen/customerChatDetailScreen/widget/productSubmitRatingWidget.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/screen/sellerAddProductScreen.dart';

class ChatDetailOrderItemWidget extends StatefulWidget {
  final CustomerChatDetailData? orderData;
  final VoidCallback voidCallback;

  ChatDetailOrderItemWidget({
    super.key,
    required this.orderData,
    required this.voidCallback,
  });

  @override
  State<ChatDetailOrderItemWidget> createState() =>
      _ChatDetailOrderItemWidgetState();
}

class _ChatDetailOrderItemWidgetState extends State<ChatDetailOrderItemWidget> {
  TextEditingController edtProductStock = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      edtProductStock.text =
          widget.orderData?.order?.items?[0].quantity.toString() ?? "0";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String createdAt = "";

    DateTime dateTime =
        DateTime.parse(widget.orderData?.createdAt.toString() ?? "").toLocal();
    DateTime now = DateTime.now().toLocal();
    DateTime yesterday = now.subtract(Duration(days: 1));

    if (isSameDay(dateTime, now)) {
      // Today
      createdAt = DateFormat.Hm().format(dateTime); // HH:MM format
    } else if (isSameDay(dateTime, yesterday)) {
      // Yesterday
      createdAt = getTranslatedValue(context, "yesterday");
    } else {
      // More than yesterday
      createdAt = DateFormat('dd/MM/yyyy').format(dateTime);
    }
    
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(
        //   context,
        //   orderDetailScreen,
        //   arguments: widget.orderData?.order,
        // );
      },
      child: Column(
        children: [
          Widgets.getSizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Widgets.setNetworkImg(
                  image: widget.orderData?.order?.items?[0].productVariant
                          ?.product?.imageUrl
                          ?.toString() ??
                      "",
                  height: 50,
                  width: 50,
                  boxFit: BoxFit.cover,
                ),
              ),
              Widgets.getSizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextLabel(
                      text:
                          widget.orderData?.order?.items?[0].productName ?? "",
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: 5),
                      child: CustomTextLabel(
                        text: double.parse(
                                    widget.orderData?.order?.items?[0].price ??
                                        "0.0") !=
                                0
                            ? GeneralMethods.getCurrencyFormat(
                                double.parse(
                                    widget.orderData?.order?.items?[0].price ??
                                        "0.0"),
                              )
                            : GeneralMethods.getCurrencyFormat(
                                double.parse(
                                  widget.orderData?.order?.items?[0].price ??
                                      "0.0",
                                ),
                              ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorsRes.subTitleMainTextColor,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Widgets.getSizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsetsDirectional.only(start: 10, end: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(
                      color: ColorsRes.textFieldBorderColor,
                    ),
                    color: Theme.of(context).cardColor,
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: edtProductStock,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CustomNumberTextInputFormatter()
                    ],
                    enabled: false,
                    style: TextStyle(
                      color: ColorsRes.mainTextColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintStyle: TextStyle(
                        color: ColorsRes.menuTitleColor,
                      ),
                      hintText: context
                          .read<LanguageProvider>()
                          .currentLanguage["product_stock_hint"],
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        edtProductStock.text = value;
                      }
                    },
                  ),
                ),
              ),
              if (widget.orderData!.productRating != null ||
                  widget.orderData?.order?.activeStatus.toString() == "6")
                SizedBox(width: 10),
              if (widget.orderData!.productRating != null ||
                  widget.orderData?.order?.activeStatus.toString() == "6")
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: (widget.orderData!.productRating != null)
                      ? (widget.orderData!.productRating?.rate.toString() !=
                              "0")
                          ? GestureDetector(
                              onTap: () {
                                if (widget.orderData!.productRating != null ||
                                    widget.orderData?.order?.activeStatus
                                            .toString() ==
                                        "6") {
                                  openRatingDialog().then((value) {
                                    widget.voidCallback;
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
                                    text: (widget.orderData!.productRating !=
                                            null)
                                        ? widget.orderData!.productRating?.rate
                                            .toString()
                                        : "0",
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
                                if (widget.orderData!.productRating != null ||
                                    widget.orderData?.order?.activeStatus
                                            .toString() ==
                                        "6") {
                                  openRatingDialog().then((value) {
                                    widget.voidCallback;
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
                            )
                      : Widgets.gradientBtnWidget(
                          context,
                          5,
                          callback: () {
                            if (widget.orderData!.productRating != null ||
                                widget.orderData?.order?.activeStatus
                                        .toString() ==
                                    "6") {
                              openRatingDialog().then((value) {
                                widget.voidCallback;
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
          Widgets.getSizedBox(height: 10),
          Divider(color: ColorsRes.subTitleMainTextColor.withOpacity(0.2)),
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
              widget.orderData?.order?.paymentMethod ?? "",
            ),
          ),
          Widgets.getSizedBox(height: 10),
          Align(
            child: CustomTextLabel(
              text: createdAt.toString(),
              style: TextStyle(
                color: ColorsRes.menuTitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            alignment: AlignmentDirectional.centerEnd,
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future openRatingDialog() {
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
                    child: ProductSubmitRatingWidget(
                      size: 100,
                      order: widget.orderData!,
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
