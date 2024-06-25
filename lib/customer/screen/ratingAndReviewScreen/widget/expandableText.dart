import 'package:lokale_mand/helper/utils/generalImports.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final double max;
  final Color color;

  const ExpandableText(
      {Key? key, required this.text, required this.max, required this.color})
      : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  TextPainter? textPainter;
  bool isOpen = false;
  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    textTheme = TextTheme(
      bodySmall: TextStyle(
        color: widget.color,
      ),
    );
    return isOpen
        ? SizedBox(
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.text,
                      style: TextStyle(
                        color: widget.color,
                      ),
                    ),
                    WidgetSpan(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isOpen = !isOpen;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: BorderDirectional(
                                bottom:
                                    BorderSide(color: ColorsRes.mainTextColor)),
                          ),
                          child: CustomTextLabel(
                            jsonKey: "read_less",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorsRes.mainTextColor,
                            ),
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: ColorsRes.mainTextColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.start,
              maxLines: 2,
              text: TextSpan(children: [
                TextSpan(
                  text: widget.text.substring(
                          0,
                          int.parse(
                              "${(widget.text.length * widget.max).toInt()}")) +
                      "...",
                  style: TextStyle(
                    color: widget.color,
                  ),
                ),
                WidgetSpan(
                  child: InkWell(
                    mouseCursor: SystemMouseCursors.click,
                    onTap: () {
                      setState(
                        () {
                          isOpen = !isOpen;
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: BorderDirectional(
                            bottom: BorderSide(color: ColorsRes.mainTextColor)),
                      ),
                      child: CustomTextLabel(
                        jsonKey: "read_more",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                  ),
                ),
              ]),
            ),
          );
  }
}
