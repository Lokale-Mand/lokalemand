import 'package:lokale_mand/customer/provider/sellerWishListProvider.dart';
import 'package:lokale_mand/customer/screen/ordersHistoryScreen/widgets/orderTypeButtonWidget.dart';
import 'package:lokale_mand/customer/screen/wishlistScreen/sellerWishListScreen.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class WishListScreenScreen extends StatefulWidget {
  const WishListScreenScreen({super.key});

  @override
  State<WishListScreenScreen> createState() => _WishListScreenScreenState();
}

class _WishListScreenScreenState extends State<WishListScreenScreen> {
  int currentIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      ChangeNotifierProvider<SellerWishListProvider>(
        create: (context) => SellerWishListProvider(),
        child: const SellerWishListScreen(),
      ),
      ChangeNotifierProvider<ProductWishListProvider>(
        create: (context) => ProductWishListProvider(),
        child: const ProductWishListScreen(),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: "favorite",
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          showBackButton: true),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          OrderTypeButtonWidget(
                            isActive: currentIndex == 0,
                            child: Center(
                              child: CustomTextLabel(
                                jsonKey: "stores",
                                softWrap: true,
                                style: TextStyle(
                                  color: currentIndex == 0
                                      ? ColorsRes.mainTextColor
                                      : ColorsRes.menuTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: currentIndex == 0
                                ? ColorsRes.appColor
                                : ColorsRes.menuTitleColor,
                            height: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 1;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          OrderTypeButtonWidget(
                            isActive: currentIndex == 1,
                            child: Center(
                              child: CustomTextLabel(
                                jsonKey: "products",
                                softWrap: true,
                                style: TextStyle(
                                  color: currentIndex == 1
                                      ? ColorsRes.mainTextColor
                                      : ColorsRes.menuTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: currentIndex == 1
                                ? ColorsRes.appColor
                                : ColorsRes.menuTitleColor,
                            height: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: pages,
            ),
          ),
        ],
      ),
    );
  }
}
