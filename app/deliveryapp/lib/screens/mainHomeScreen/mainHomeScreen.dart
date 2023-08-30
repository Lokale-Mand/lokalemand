
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';

class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<MainHomeScreen> {
  NetworkStatus networkStatus = NetworkStatus.Online;
  int currentPage = 0;
  List lblHomeBottomMenu = [];

  //total pageListing
  List<Widget> pages = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    checkConnectionState();

    if (Constant.session.isSeller() == true) {
      pages = [
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => DashboardProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => SettingsProvider(),
            ),
          ],
          child: HomeScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrdersProvider(),
          child: OrderListScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryListProvider(),
          child: CategoryListScreen(),
        ),
        ProfileScreen()
      ];
    } else {
      pages = [
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => OrdersProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => DashboardProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => SettingsProvider(),
            ),
          ],
          child: HomeScreen(),
        ),
        ProfileScreen()
      ];
    }
    super.initState();
  }

  //internet connection checking
  checkConnectionState() async {
    networkStatus = await GeneralMethods.checkInternet()
        ? NetworkStatus.Online
        : NetworkStatus.Offline;
    Connectivity().onConnectivityChanged.listen((status) {
      if (mounted) {
        setState(() {
          networkStatus = GeneralMethods.getNetworkStatus(status);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (Constant.session.isSeller()) {
      lblHomeBottomMenu = [
        getTranslatedValue(
          context,
          "home_bottom_menu_home",
        ),
        getTranslatedValue(
          context,
          "home_bottom_menu_orders",
        ),
        getTranslatedValue(
          context,
          "home_bottom_menu_category",
        ),
        getTranslatedValue(
          context,
          "home_bottom_menu_profile",
        ),
      ];
    } else {
      lblHomeBottomMenu = [
        getTranslatedValue(
          context,
          "home_bottom_menu_home",
        ),
        getTranslatedValue(
          context,
          "home_bottom_menu_profile",
        ),
      ];
    }
    return Scaffold(
      bottomNavigationBar: Widgets.homeBottomNavigation(
        context: context,
        selectBottomMenu: selectBottomMenu,
        totalPage: pages.length,
        selectedIndex: currentPage,
        lblHomeBottomMenu: lblHomeBottomMenu,
      ),
      body: networkStatus == NetworkStatus.Online
          ? WillPopScope(
              onWillPop: () {
                if (currentPage == 0) {
                  return Future.value(true);
                } else {
                  if (mounted) {
                    setState(() {
                      currentPage = 0;
                    });
                  }
                  return Future.value(false);
                }
              },
              child: IndexedStack(
                index: currentPage,
                children: pages,
              ),
            )
          : Center(
              child: Text(
                getTranslatedValue(context, "check_internet"),
              ),
            ),
    );
  }

  //change current screen based on bottom menu selection
  selectBottomMenu(int index) {
    if (mounted) {
      currentPage = index;
      setState(() {});
    }
  }
}
