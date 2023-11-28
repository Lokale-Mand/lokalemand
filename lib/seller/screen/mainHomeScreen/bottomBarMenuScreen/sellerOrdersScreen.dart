import 'package:lokale_mand/helper/utils/generalImports.dart';

class SellerOrderScreen extends StatefulWidget {
  const SellerOrderScreen({super.key});

  @override
  State<SellerOrderScreen> createState() => _SellerOrderScreenState();
}

class _SellerOrderScreenState extends State<SellerOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomTextLabel(
          text: "ORDER SCREEN",
          style: TextStyle(
            color: ColorsRes.appColor,
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
