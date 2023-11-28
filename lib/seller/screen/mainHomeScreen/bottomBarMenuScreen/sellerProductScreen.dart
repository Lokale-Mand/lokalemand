import 'package:lokale_mand/helper/utils/generalImports.dart';

class SellerProductScreen extends StatefulWidget {
  const SellerProductScreen({super.key});

  @override
  State<SellerProductScreen> createState() => _SellerProductScreenState();
}

class _SellerProductScreenState extends State<SellerProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomTextLabel(
          text: "PRODUCTS SCREEN",
          style: TextStyle(
            color: ColorsRes.appColor,
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
