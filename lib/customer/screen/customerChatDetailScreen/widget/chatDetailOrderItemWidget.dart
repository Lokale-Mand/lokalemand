import 'package:intl/intl.dart';
import 'package:lokale_mand/customer/models/chatDetail.dart';
import 'package:lokale_mand/customer/provider/productRatingProvider.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/screen/sellerAddProductScreen.dart';

class ChatDetailOrderItemWidget extends StatefulWidget {
  final CustomerChatDetailData? orderData;

  const ChatDetailOrderItemWidget({super.key, required this.orderData});

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


    return Column(
      children: [
        Widgets.getSizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Widgets.setNetworkImg(
                image: widget.orderData?.order?.items?[0].productVariant?.product?.imageUrl?.toString()??"",
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
                    text: widget.orderData?.order?.items?[0].productName ?? "",
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
                          ? GeneralMethods.getCurrencyFormat(double.parse(
                              widget.orderData?.order?.items?[0].price ??
                                  "0.0"))
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
            if (widget.orderData?.productRating?.rate != null ||
                widget.orderData?.order?.activeStatus.toString() == "6")
              Expanded(
                child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: RatingBar.builder(
                    initialRating: double.tryParse(
                          widget.orderData?.productRating?.rate.toString() ??
                              "0.0",
                        ) ??
                        0.0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    maxRating: 5,
                    updateOnDrag: true,
                    itemSize: 20,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      showModalBottomSheet(
                        enableDrag: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          double ratings = widget.orderData?.productRating?.rate
                                  .toString()
                                  .toDouble ??
                              0.0;
                          TextEditingController
                              ratingsMessageTextEditingController =
                              TextEditingController(
                                  text: widget.orderData?.productRating?.review
                                              .toString() ==
                                          "null"
                                      ? ""
                                      : widget.orderData?.productRating?.review
                                          .toString());

                          return ChangeNotifierProvider<ProductRatingProvider>(
                            create: (context) => ProductRatingProvider(),
                            child: Consumer<ProductRatingProvider>(builder:
                                (context, productRatingProvider, child) {
                              return Container(
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                padding: EdgeInsetsDirectional.only(
                                  start: 20,
                                  end: 20,
                                  top: 10,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomTextLabel(
                                        jsonKey: "rate_the_product",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: ColorsRes.mainTextColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Widgets.getSizedBox(height: 10),
                                      RatingBar.builder(
                                        initialRating: double.tryParse(
                                              widget.orderData?.productRating
                                                      ?.rate
                                                      .toString() ??
                                                  "0.0",
                                            ) ??
                                            0.0,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        maxRating: 5,
                                        updateOnDrag: true,
                                        itemSize: 35,
                                        itemCount: 5,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          ratings = rating;
                                        },
                                      ),
                                      Widgets.getSizedBox(height: 10),
                                      Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        constraints: BoxConstraints(
                                          minHeight: 40,
                                          maxHeight: 120,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: ColorsRes.menuTitleColor
                                                .withOpacity(0.2),
                                            width: 2,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextField(
                                            decoration: null,
                                            minLines: 1,
                                            maxLines: 100,
                                            controller:
                                                ratingsMessageTextEditingController,
                                            focusNode: FocusNode(
                                              canRequestFocus: true,
                                            ),
                                            keyboardType: TextInputType.text,
                                          ),
                                        ),
                                      ),
                                      Widgets.getSizedBox(height: 10),
                                      Widgets.gradientBtnWidget(
                                        context,
                                        10,
                                        callback: () {
                                          Map<String, String> params = {
                                            "product_id": widget
                                                    .orderData
                                                    ?.order
                                                    ?.items?[0]
                                                    .productVariant
                                                    ?.productId
                                                    .toString()
                                                    .toString() ??
                                                "",
                                            "user_id": Constant.session.getData(
                                                SessionManager.keyUserId),
                                            "rate": ratings.toString(),
                                            "review":
                                                ratingsMessageTextEditingController
                                                    .text,
                                          };

                                          if (widget.orderData?.productRating
                                                  ?.review
                                                  .toString() !=
                                              "null") {
                                            params["id"] = widget.orderData
                                                    ?.productRating?.id
                                                    .toString() ??
                                                "";
                                          }

                                          productRatingProvider
                                              .addOrUpdateProductRating(
                                                  params: params,
                                                  context: context,
                                                  isAdd: widget
                                                          .orderData
                                                          ?.productRating
                                                          ?.review
                                                          .toString() ==
                                                      "null")
                                              .then((value) =>
                                                  Navigator.pop(context));
                                        },
                                        height: 40,
                                        otherWidgets: productRatingProvider
                                                    .productRatingState ==
                                                ProductRatingState.loading
                                            ? Container(
                                                height: 25,
                                                width: 25,
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      ColorsRes.appColorWhite,
                                                ),
                                              )
                                            : CustomTextLabel(
                                                jsonKey: "rate_now",
                                                style: TextStyle(
                                                  color:
                                                      ColorsRes.appColorWhite,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                      ),
                                      Widgets.getSizedBox(height: 40),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
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
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
