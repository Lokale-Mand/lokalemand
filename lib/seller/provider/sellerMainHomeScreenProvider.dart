import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/provider/ordersProvider.dart';
import 'package:lokale_mand/seller/provider/sellerChatListProvider.dart';
import 'package:lokale_mand/seller/provider/sellerProductListProvider.dart';

class SellerMainHomeScreenProvider extends ChangeNotifier {
  int currentPage = 0;

  List<ScrollController> scrollController = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController()
  ];

  //total pageListing
  List<Widget> pages = [];

  setPages() {
    pages = [
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ProductListProvider>(
            create: (context) {
              return ProductListProvider();
            },
          ),
          ChangeNotifierProvider<SellerListProvider>(
            create: (context) {
              return SellerListProvider();
            },
          ),
        ],
        child: HomeScreen(
          scrollController: scrollController[0],
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => SellerOrdersProvider(),
        child: SellerOrderScreen(),
      ),
      ChangeNotifierProvider<SellerChatListProvider>(
        create: (context) {
          return SellerChatListProvider();
        },
        child: SellerChatListScreen(
          scrollController: scrollController[1],
        ),
      ),
      ChangeNotifierProvider<SellerProductListProvider>(
        create: (context) {
          return SellerProductListProvider();
        },
        child: SellerProductScreen(),
      ),
      SellerMenuScreen(),
    ];
  }

  //change current screen based on bottom menu selection
  selectBottomMenu(int index) {
    try {
      if (index == currentPage) {
        scrollController[currentPage].animateTo(0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut);
      }

      currentPage = index;
    } catch (_) {}
    notifyListeners();
  }

  getCurrentPage() {
    return currentPage;
  }

  getPages() {
    return pages;
  }
}
