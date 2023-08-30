import 'package:egrocer/helper/utils/generalImports.dart';

getDeliveryCharges(BuildContext context) {
  return Container(
    padding: EdgeInsetsDirectional.all(Constant.size10),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: Constant.borderRadius10,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextLabel(
          jsonKey: "order_summary",
          softWrap: true,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorsRes.mainTextColor,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size5,
        ),
        Widgets.getSizedBox(
          height: Constant.size5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextLabel(
              jsonKey: "subtotal",
              softWrap: true,
              style: TextStyle(
                fontSize: 14,
                color: ColorsRes.mainTextColor,
              ),
            ),
            CustomTextLabel(
              text: GeneralMethods.getCurrencyFormat(
                  context.read<CheckoutProvider>().subTotalAmount),
              softWrap: true,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorsRes.mainTextColor,
              ),
            )
          ],
        ),
        Widgets.getSizedBox(
          height: Constant.size7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomTextLabel(
                  jsonKey: "delivery_charge",
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
                GestureDetector(
                  onTapDown: (details) async {
                    await showMenu(
                      color: Theme.of(context).cardColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      )),
                      context: context,
                      position: RelativeRect.fromLTRB(
                        details.globalPosition.dx,
                        details.globalPosition.dy - 60,
                        details.globalPosition.dx,
                        details.globalPosition.dy,
                      ),
                      items: List.generate(
                        (context
                                    .read<CheckoutProvider>()
                                    .sellerWiseDeliveryCharges
                                    ?.length ??
                                0) +
                            1,
                        (index) => PopupMenuItem(
                          child: index == 0
                              ? Column(
                                  children: [
                                    CustomTextLabel(
                                      jsonKey:
                                          "seller_wise_delivery_charges_detail",
                                      softWrap: true,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomTextLabel(
                                      text: context
                                              .read<CheckoutProvider>()
                                              .sellerWiseDeliveryCharges?[
                                                  index - 1]
                                              .sellerName
                                              .toString() ??
                                          "0",
                                      softWrap: true,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    CustomTextLabel(
                                      text: GeneralMethods.getCurrencyFormat(
                                        double.parse(
                                          context
                                                  .read<CheckoutProvider>()
                                                  .sellerWiseDeliveryCharges?[
                                                      index - 1]
                                                  .deliveryCharge
                                                  .toString() ??
                                              "0",
                                        ),
                                      ),
                                      softWrap: true,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      elevation: 8.0,
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 2,
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            CustomTextLabel(
              text: GeneralMethods.getCurrencyFormat(
                  context.read<CheckoutProvider>().deliveryCharge),
              softWrap: true,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorsRes.mainTextColor,
              ),
            )
          ],
        ),
        if (Constant.isPromoCodeApplied)
          Widgets.getSizedBox(
            height: Constant.size7,
          ),
        if (Constant.isPromoCodeApplied)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextLabel(
                text:
                    "${context.read<LanguageProvider>().currentLanguage["discount"]}(${Constant.selectedCoupon})",
                softWrap: true,
                style: TextStyle(
                  fontSize: 17,
                  color: ColorsRes.mainTextColor,
                ),
              ),
              CustomTextLabel(
                text: "-${GeneralMethods.getCurrencyFormat(
                  double.parse(
                    context
                            .read<CheckoutProvider>()
                            .deliveryChargeData
                            ?.promocodeDetails
                            ?.discount ??
                        "0",
                  ),
                )}",
                softWrap: true,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorsRes.mainTextColor,
                ),
              )
            ],
          ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextLabel(
              jsonKey: "total",
              softWrap: true,
              style: TextStyle(
                fontSize: 14,
                color: ColorsRes.mainTextColor,
              ),
            ),
            CustomTextLabel(
              text: GeneralMethods.getCurrencyFormat(
                  context.read<CheckoutProvider>().totalAmount),
              softWrap: true,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorsRes.appColor,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
