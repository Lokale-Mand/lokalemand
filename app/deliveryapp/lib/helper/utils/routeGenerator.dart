import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';import 'package:flutter/cupertino.dart';

const String splashScreen = 'splashScreen';
const String accountTypeScreen = 'accountTypeScreen';
const String loginScreen = 'loginScreen';
const String mainHomeScreen = 'mainHomeScreen';
const String webViewScreen = 'webViewScreen';
const String editSellerProfileScreen = 'editSellerProfileScreen';
const String editDeliveryBoyProfileScreen = 'editDeliveryBoyProfileScreen';
const String orderDetail = 'orderDetail';
const String notificationsAndMailSettingsScreenScreen =
    'notificationsAndMailSettingsScreenScreen';
const String registerAccountScreen = 'registerAccountScreen';
const String getLocationScreen = 'getLocationScreen';
const String confirmLocationScreen = 'confirmLocationScreen';
const String htmlEditorScreen = 'htmlEditorScreen';

String currentRoute = splashScreen;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    currentRoute = settings.name ?? "";

    switch (settings.name) {
      case splashScreen:
        return CupertinoPageRoute(
          builder: (_) => SplashScreen(),
        );

      case accountTypeScreen:
        return CupertinoPageRoute(
          builder: (_) => AccountTypeScreen(),
        );

      case loginScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<UserProfileProvider>(
            create: (context) => UserProfileProvider(),
            child: LoginAccountScreen(),
          ),
        );

      case mainHomeScreen:
        return CupertinoPageRoute(
          builder: (_) => MainHomeScreen(),
        );

      case webViewScreen:
        return CupertinoPageRoute(
          builder: (_) => WebViewScreen(dataFor: settings.arguments as String),
        );

      case editSellerProfileScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<UserProfileProvider>(
            create: (context) => UserProfileProvider(),
            child: EditSellerProfileScreen(),
          ),
        );

      case editDeliveryBoyProfileScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<UserProfileProvider>(
            create: (context) => UserProfileProvider(),
            child: EditDeliveryBoyProfileScreen(),
          ),
        );

      case orderDetail:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<OrderDetailProvider>(
            create: (context) => OrderDetailProvider(),
            child: OrderDetailScreen(orderId: settings.arguments as String),
          ),
        );

      case notificationsAndMailSettingsScreenScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<NotificationsSettingsProvider>(
            create: (context) => NotificationsSettingsProvider(),
            child: NotificationsAndMailSettingsScreenScreen(),
          ),
        );

      case registerAccountScreen:
        return CupertinoPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider<UserProfileProvider>(
                create: (context) => UserProfileProvider(),
              ),
              ChangeNotifierProvider<SettingsProvider>(
                create: (context) => SettingsProvider(),
              ),
            ],
            child: RegisterAccountScreen(),
          ),
        );

      case getLocationScreen:
        return CupertinoPageRoute(
          builder: (_) => GetLocation(),
        );

      case confirmLocationScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (context) => CityByLatLongProvider(),
            child: ConfirmLocation(
              address: settings.arguments as GeoAddress,
            ),
          ),
        );

      case htmlEditorScreen:
        return CupertinoPageRoute(
          builder: (_) => HtmlEditorScreen(
            htmlContent: settings.arguments as String,
          ),
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('ERROR'),
          ),
        );
      },
    );
  }
}
