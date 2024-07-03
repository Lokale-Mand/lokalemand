import 'package:lokale_mand/helper/utils/generalImports.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  State<UserTypeSelectionScreen> createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      try {
        if (Constant.session.getData(SessionManager.keyFCMToken).isEmpty) {
          await LocalAwesomeNotification().init(context);

          await FirebaseMessaging.instance.getToken().then((token) {
            Constant.session.setData(SessionManager.keyFCMToken, token!, false);
          });
        }
        FirebaseMessaging.onBackgroundMessage(
            LocalAwesomeNotification.onBackgroundMessageHandler);
      } catch (ignore) {}
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PositionedDirectional(
            bottom: 0,
            end: 0,
            start: 0,
            top: 0,
            child: Widgets.setLocalAssetsImage(
              image: "background.png",
              boxFit: BoxFit.fill,
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            end: 0,
            start: 0,
            top: 0,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  CustomTextLabel(
                    jsonKey: "user_type_screen_title",
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                      color: ColorsRes.appColorWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      wordSpacing: 3,
                      height: 1.1,
                    ),
                  ),
                  Spacer(),
                  CustomTextLabel(
                    jsonKey: "user_type_selection_title",
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                      color: ColorsRes.appColorBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      wordSpacing: 3,
                      height: 1.1,
                    ),
                  ),
                  Widgets.getSizedBox(
                    height: 10,
                  ),
                  Widgets.gradientBtnWidget(
                    context,
                    10,
                    callback: () {
                      Navigator.pushNamed(context, sellerLoginAccountScreen);
                    },
                    otherWidgets: Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: 25,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.storefront_outlined,
                            color: ColorsRes.appColorWhite,
                            size: 30,
                          ),
                          Widgets.getSizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: CustomTextLabel(
                              jsonKey: "user_type_food_producer",
                              textAlign: TextAlign.start,
                              softWrap: true,
                              maxLines: 1,
                              style: TextStyle(
                                color: ColorsRes.appColorWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                wordSpacing: 3,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Widgets.getSizedBox(
                    height: 10,
                  ),
                  Widgets.gradientBtnWidget(
                    context,
                    10,
                    callback: () {
                      Navigator.pushNamed(context, loginScreen);
                    },
                    otherWidgets: Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: 25,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.emoji_people_rounded,
                            color: ColorsRes.appColorWhite,
                            size: 30,
                          ),
                          Widgets.getSizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: CustomTextLabel(
                              jsonKey: "user_type_buyer",
                              textAlign: TextAlign.start,
                              softWrap: true,
                              maxLines: 1,
                              style: TextStyle(
                                color: ColorsRes.appColorWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                wordSpacing: 3,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Widgets.getSizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
