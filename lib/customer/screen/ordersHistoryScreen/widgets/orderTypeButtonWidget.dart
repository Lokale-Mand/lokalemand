import 'package:lokale_mand/helper/utils/generalImports.dart';

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
      child: child,
    );
  }
}
