import 'package:lokale_mand/helper/utils/generalImports.dart';

class SellerMenuScreen extends StatefulWidget {
  const SellerMenuScreen({super.key});

  @override
  State<SellerMenuScreen> createState() => _SellerMenuScreenState();
}

class _SellerMenuScreenState extends State<SellerMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomTextLabel(
          text: "MENU SCREEN",
          style: TextStyle(
            color: ColorsRes.appColor,
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
