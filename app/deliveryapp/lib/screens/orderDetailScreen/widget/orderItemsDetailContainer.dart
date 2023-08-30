
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
getOrderItemDetailsContainer(
    {required BuildContext context, OrderItems? orderItem}) {
  double price = double.parse(orderItem?.price ?? "0.0");
  double? discountedPrice = double.parse(orderItem?.discountedPrice ?? "0.0");
  return Container(
    padding: EdgeInsets.all(Constant.paddingOrMargin10),
    margin: EdgeInsetsDirectional.only(
      bottom: Constant.paddingOrMargin10,
    ),
    decoration: DesignConfig.boxDecoration(
      Theme.of(context).cardColor,
      10,
    ),
    child: Column(
      children: [
        getItemDetailContainer(
            title: getTranslatedValue(context, "name"),
            value: orderItem?.productName ?? ""),
        Widgets.getSizedBox(
          height: 10,
        ),
        getItemDetailContainer(
            title: getTranslatedValue(context, "variant"),
            value: orderItem?.variantName ?? ""),
        Widgets.getSizedBox(
          height: 10,
        ),
        getItemDetailContainer(
            title: getTranslatedValue(context, "quantity"),
            value: orderItem?.quantity.toString() ?? "1"),
        Widgets.getSizedBox(
          height: 10,
        ),
        getItemDetailContainer(
          title: getTranslatedValue(context, "price"),
          value: GeneralMethods.getCurrencyFormat(
              discountedPrice.compareTo(0.0) == 0 ? price : discountedPrice),
        ),
        Widgets.getSizedBox(
          height: 10,
        ),
        getItemDetailContainer(
          title: getTranslatedValue(context, "tax"),
          value: "${GeneralMethods.getCurrencyFormat(
            (double.parse(orderItem?.taxAmount ?? "0.0")) * (double.parse(orderItem?.quantity ?? "1")),
          )} (Qty x ${orderItem?.taxPercentage ?? 0.0}% Tax)",
        ),
        Widgets.getSizedBox(
          height: 10,
        ),
        getItemDetailContainer(
          title: getTranslatedValue(context, "subtotal"),
          value: GeneralMethods.getCurrencyFormat(double.parse(orderItem?.subTotal ?? "0.0")),
        ),
      ],
    ),
  );
}
