import 'package:lokale_mand/customer/models/chatDetail.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/screen/sellerAddProductScreen.dart';

class ChatDetailOrderItemWidget extends StatefulWidget {
  final CustomerChatDetailOrder? orderData;

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
          widget.orderData?.items?[0].quantity.toString() ?? "0";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 20, bottom: 20, end: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Widgets.setNetworkImg(
              image: widget.orderData?.items?[0].imageUrl.toString() ?? "",
              height: 40,
              width: 40,
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
                  text: widget.orderData?.items?[0].productName ?? "",
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
                                widget.orderData?.items?[0].price ?? "0.0") !=
                            0
                        ? GeneralMethods.getCurrencyFormat(double.parse(
                            widget.orderData?.items?[0].price ?? "0.0"))
                        : GeneralMethods.getCurrencyFormat(
                            double.parse(
                              widget.orderData?.items?[0].price ?? "0.0",
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
                Widgets.getSizedBox(height: 10),
                Container(
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
