import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class CustomTweenAnimation extends StatelessWidget {
  final Widget animationChild;
  final int? durationInSeconds;
  final double beginValue;
  final double endValue;
  final Curve curve;

  const CustomTweenAnimation(
      {Key? key,
        this.durationInSeconds,
        required this.animationChild,
        required this.beginValue,
        required this.endValue, required this.curve})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: beginValue, end: endValue),
      curve: curve,
      duration:
      Duration(seconds: durationInSeconds ?? Constant.animationDuration),
      builder: (context, value, child) => animationChild,
    );
  }
}