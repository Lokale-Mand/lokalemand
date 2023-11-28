import 'package:lokale_mand/helper/utils/generalImports.dart';

class SellerMessageScreen extends StatefulWidget {
  const SellerMessageScreen({super.key});

  @override
  State<SellerMessageScreen> createState() => _SellerMessageScreenState();
}

class _SellerMessageScreenState extends State<SellerMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomTextLabel(
          text: "MESSAGE SCREEN",
          style: TextStyle(
            color: ColorsRes.appColor,
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
