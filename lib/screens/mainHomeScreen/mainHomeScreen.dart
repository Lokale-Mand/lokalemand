import 'package:lokale_mand/helper/utils/generalImports.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => HomeMainScreenState();
}

class HomeMainScreenState extends State<HomeMainScreen> {
  NetworkStatus networkStatus = NetworkStatus.online;

  @override
  void dispose() {
    context
        .read<HomeMainScreenProvider>()
        .scrollController[0]
        .removeListener(() {});
    context
        .read<HomeMainScreenProvider>()
        .scrollController[1]
        .removeListener(() {});
    context
        .read<HomeMainScreenProvider>()
        .scrollController[2]
        .removeListener(() {});
    context
        .read<HomeMainScreenProvider>()
        .scrollController[3]
        .removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    if (mounted) {
      context.read<HomeMainScreenProvider>().setPages();
    }
    Future.delayed(
      Duration.zero,
      () async {
        try {
          await LocalAwesomeNotification().init(context);

          await FirebaseMessaging.instance.getToken().then((token) {
            if (Constant.session.getData(SessionManager.keyFCMToken).isEmpty) {
              Constant.session
                  .setData(SessionManager.keyFCMToken, token!, false);
              registerFcmKey(context: context, fcmToken: token);
            }
          });
          FirebaseMessaging.onBackgroundMessage(
              LocalAwesomeNotification.onBackgroundMessageHandler);
        } catch (ignore) {}

        if (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
            Constant.session.getData(SessionManager.keyLongitude) == "0") {
          Navigator.pushNamed(context, getLocationScreen,
              arguments: "location");
        } else {
          if (context.read<HomeMainScreenProvider>().getCurrentPage() == 0) {
            if (Constant.session
                .getBoolData(SessionManager.keyPopupOfferEnabled)) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog();
                },
              );
            }
          }

          if (Constant.session.isUserLoggedIn()) {
            await getAppNotificationSettingsRepository(
                    params: {}, context: context)
                .then(
              (value) async {
                if (value[ApiAndParams.status].toString() == "1") {
                  late AppNotificationSettings notificationSettings =
                      AppNotificationSettings.fromJson(value);
                  if (notificationSettings.data!.isEmpty) {
                    await updateAppNotificationSettingsRepository(params: {
                      ApiAndParams.statusIds: "1,2,3,4,5,6,7,8",
                      ApiAndParams.mobileStatuses: "1,1,1,1,1,1,1,1",
                      ApiAndParams.mailStatuses: "1,1,1,1,1,1,1,1"
                    }, context: context);
                  }
                }
              },
            );
          }
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeMainScreenProvider>(
      builder: (context, homeMainScreenProvider, child) {
        int currentPage = homeMainScreenProvider.getCurrentPage();
        return Scaffold(
          bottomNavigationBar: homeBottomNavigation(
              homeMainScreenProvider.getCurrentPage(),
              homeMainScreenProvider.selectBottomMenu,
              homeMainScreenProvider.getPages().length,
              context),
          body: networkStatus == NetworkStatus.online
              ? WillPopScope(
                  onWillPop: () {
                    if (currentPage == 0) {
                      return Future.value(true);
                    } else {
                      if (mounted) {
                        if (currentPage == 1) {
                          if (mounted) {
                            setState(
                              () {
                                currentPage = 0;
                              },
                            );
                          }
                        } else {
                          setState(
                            () {
                              currentPage = 0;
                            },
                          );
                        }
                      }
                      return Future.value(false);
                    }
                  },
                  child: IndexedStack(
                    index: currentPage,
                    children: homeMainScreenProvider.getPages(),
                  ),
                )
              : Center(
                  child: CustomTextLabel(
                    jsonKey: "check_internet",
                  ),
                ),
        );
      },
    );
  }

  homeBottomNavigation(int selectedIndex, Function selectBottomMenu,
      int totalPage, BuildContext context) {
    List lblHomeBottomMenu = [
      getTranslatedValue(
        context,
        "home_bottom_menu_home",
      ),
      getTranslatedValue(
        context,
        "home_bottom_menu_category",
      ),
      getTranslatedValue(
        context,
        "home_bottom_menu_wishlist",
      ),
      getTranslatedValue(
        context,
        "home_bottom_menu_profile",
      ),
    ];
    return BottomNavigationBar(
        items: List.generate(
          totalPage,
          (index) => BottomNavigationBarItem(
            backgroundColor: Theme.of(context).cardColor,
            icon: Widgets.getHomeBottomNavigationBarIcons(
                isActive: selectedIndex == index)[index],
            label: lblHomeBottomMenu[index],
          ),
        ),
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        selectedItemColor: ColorsRes.mainTextColor,
        unselectedItemColor: Colors.transparent,
        onTap: (int ind) {
          selectBottomMenu(ind);
        },
        elevation: 5);
  }
}
