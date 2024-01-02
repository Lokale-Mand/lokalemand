import 'package:lokale_mand/helper/utils/generalImports.dart';

getDeliveryCharges(BuildContext context) {
  return Container(
    decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 10),
    padding: const EdgeInsets.all(10),
    margin: EdgeInsetsDirectional.only(
      start: 10,
      end: 10,
      bottom: 10,
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
              text: context
                  .read<CheckoutProvider>()
                  .subTotalAmount
                  .toString()
                  .currency,
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
                      color: Theme.of(context).scaffoldBackgroundColor,
                      surfaceTintColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
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
                                          "seller_wise_delivery_charges_details",
                                      softWrap: true,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16,
                                          color:
                                              ColorsRes.subTitleMainTextColor),
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
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorsRes.mainTextColor,
                                      ),
                                    ),
                                    CustomTextLabel(
                                      text: context
                                          .read<CheckoutProvider>()
                                          .sellerWiseDeliveryCharges?[index - 1]
                                          .deliveryCharge
                                          .toString()
                                          .currency,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorsRes.mainTextColor),
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
              text: context
                  .read<CheckoutProvider>()
                  .deliveryCharge
                  .toString()
                  .currency,
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
                    "${context.read<LanguageProvider>().currentLanguage["discount"] ?? "discount"}(${Constant.selectedCoupon})",
                softWrap: true,
                style: TextStyle(
                  fontSize: 14,
                  color: ColorsRes.mainTextColor,
                ),
              ),
              CustomTextLabel(
                text:
                    "-${context.read<CheckoutProvider>().deliveryChargeData?.promocodeDetails?.discount.toString().currency}",
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
              text: context
                  .read<CheckoutProvider>()
                  .totalAmount
                  .toString()
                  .currency,
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
