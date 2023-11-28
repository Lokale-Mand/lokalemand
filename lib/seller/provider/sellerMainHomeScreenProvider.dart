import 'package:lokale_mand/helper/utils/generalImports.dart';

class SellerMainHomeScreenProvider extends ChangeNotifier {
  int currentPage = 0;

  List<ScrollController> scrollController = [
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
        child: SellerOrderScreen(
          // scrollController: scrollController[0],
        ),
      ),
      SellerMessageScreen(
        // scrollController: scrollController[1],
      ),
      SellerProductScreen(
        // scrollController: scrollController[2],
      ),
      SellerMenuScreen(
        // scrollController: scrollController[2],
      )
    ];
  }

  //change current screen based on bottom menu selection
  selectBottomMenu(int index) {
    try {
      if (index == currentPage) {
        scrollController[currentPage].animateTo(0,
            duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
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
