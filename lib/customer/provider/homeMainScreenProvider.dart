import 'package:lokale_mand/customer/provider/customerChatListProvider.dart';
import 'package:lokale_mand/customer/screen/mainHomeScreen/orderHistoryScreen.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class HomeMainScreenProvider extends ChangeNotifier {
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
        child: HomeScreen(
          scrollController: scrollController[0],
        ),
      ),
      ChangeNotifierProvider<ActiveOrdersProvider>(
        create: (context) {
          return ActiveOrdersProvider();
        },
        child: OrderHistoryScreen(
        ),
      ),
      // ProductWishListScreen(
      //   scrollController: scrollController[2],
      // ),
      ChangeNotifierProvider<CustomerChatListProvider>(
        create: (context) {
          return CustomerChatListProvider();
        },
        child: CustomerChatListScreen(
          scrollController: scrollController[2],
        ),
      ),
      // ProductWishListScreen(
      //   scrollController: scrollController[2],
      // ),
      ProfileScreen(
        scrollController: scrollController[3],
      )
    ];
  }

  //change current screen based on bottom menu selection
  selectBottomMenu(int index) {
    try {
      if (index == currentPage) {
        scrollController[currentPage].animateTo(0,
            duration: const Duration(milliseconds: 400), curve: Curves.linear);
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
