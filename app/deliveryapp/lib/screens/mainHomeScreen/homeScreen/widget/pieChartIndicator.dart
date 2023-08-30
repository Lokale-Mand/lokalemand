import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class Indicator extends StatefulWidget {
  final Color color;
  final Color textColor;
  final String text;
  final String count;

  Indicator({
    Key? key,
    required this.color,
    required this.textColor,
    required this.text,
    required this.count,
  }) : super(key: key);

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  Widget build(BuildContext context) {
    return widget.count != "0"
        ? Row(
            children: <Widget>[
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
              ),
              Widgets.getSizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  widget.text,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
              )
            ],
          )
        : Container();
  }
}
