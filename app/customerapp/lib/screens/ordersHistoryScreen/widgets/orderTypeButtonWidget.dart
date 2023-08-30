import 'package:egrocer/helper/utils/generalImports.dart';

class OrderTypeButtonWidget extends StatelessWidget {
  final bool isActive;
  final Widget child;
  final EdgeInsetsDirectional? margin;

  const OrderTypeButtonWidget(
      {super.key, required this.isActive, required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsetsDirectional.zero,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isActive == false
            ? Theme.of(context).cardColor
            : ColorsRes.appColor,
      ),
      child: child,
    );
  }
}
