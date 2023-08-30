import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
Widget getStatisticsContainer(
    {required BuildContext context,
    required String svgIconName,
    required Color bgColor,
    required String title,
    required String itemCount}) {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: ColorsRes.appColorWhite,
          radius: 35,
          child: Widgets.defaultImg(
            image: svgIconName,
            iconColor: bgColor,
            width: 30,
            height: 30,
          ),
        ),
        Widgets.getSizedBox(height: 15),
        TweenAnimationBuilder<double>(
          duration: Duration(seconds: Constant.animationDuration),
          tween: Tween<double>(begin: 0, end: double.parse(itemCount),),
          builder: (context, value, child) => Text(
            value.toStringAsFixed(0),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: ColorsRes.appColorWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Widgets.getSizedBox(height: 5),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: ColorsRes.appColorWhite,
            fontWeight: FontWeight.w400,
          ),
          softWrap: true,
          maxLines: 1,
        ),
      ],
    ),
  );
}
