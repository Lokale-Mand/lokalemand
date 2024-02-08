import 'package:intl/intl.dart';
import 'package:lokale_mand/customer/provider/productRatingProvider.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerChatDetail.dart';
import 'package:lokale_mand/seller/provider/ordersProvider.dart';
import 'package:lokale_mand/seller/screen/sellerAddProductScreen.dart';

class SellerChatDetailOrderItemWidget extends StatefulWidget {
  final SellerChatDetailData? orderData;

  const SellerChatDetailOrderItemWidget({super.key, required this.orderData});

  @override
  State<SellerChatDetailOrderItemWidget> createState() =>
      _SellerChatDetailOrderItemWidgetState();
}

class _SellerChatDetailOrderItemWidgetState
    extends State<SellerChatDetailOrderItemWidget> {
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
                    ignoreGestures: true,
                    maxRating: 5,
                    updateOnDrag: true,
                    itemSize: 20,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {

                    },
                  ),
                ),
              ),
          ],
        ),
        if (int.tryParse(
                widget.orderData?.order?.activeStatus.toString() ?? "0")! <
            1)
          Divider(
            color: ColorsRes.menuTitleColor,
            indent: 10,
            endIndent: 10,
          ),
        if (int.tryParse(
                widget.orderData?.order?.activeStatus.toString() ?? "0")! <
            1)
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
                            widget.orderData?.orderId.toString() ?? "0";
                        params[ApiAndParams.statusId] = "1";
                        sellerOrdersProvider
                            .updateSellerOrdersStatus(
                                params: params,
                                context: context,
                                order: widget.orderData!.order)
                            .then(
                              (value) => Navigator.pop(context, value),
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
                            widget.orderData?.orderId.toString() ?? "0";
                        params[ApiAndParams.statusId] = "7";
                        sellerOrdersProvider
                            .updateSellerOrdersStatus(
                                params: params,
                                context: context,
                                order: widget.orderData!.order)
                            .then(
                              (value) => Navigator.pop(context, value),
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
