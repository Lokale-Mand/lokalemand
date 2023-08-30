import 'package:egrocer/helper/utils/generalImports.dart';

class QuickUseWidget extends StatelessWidget {
  const QuickUseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Constant.session.isUserLoggedIn()
        ? Padding(
            padding:
                const EdgeInsetsDirectional.only(start: 10, end: 10, top: 10),
            child: Row(
              children: [
                Expanded(
                  child: buttonWidget(
                    Container(
                      decoration: DesignConfig.boxDecoration(
                          ColorsRes.appColorLightHalfTransparent, 5),
                      padding: const EdgeInsets.all(8),
                      child: Widgets.defaultImg(
                          image: "orders",
                          iconColor: ColorsRes.appColor,
                          height: 20,
                          width: 20),
                    ),
                    "all_orders",
                    onClickAction: () {
                      Navigator.pushNamed(
                        context,
                        orderHistoryScreen,
                      );
                    },
                    padding: const EdgeInsetsDirectional.only(
                      end: 5,
                    ),
                  ),
                ),
                Expanded(
                  child: buttonWidget(
                    Container(
                      decoration: DesignConfig.boxDecoration(
                          ColorsRes.appColorLightHalfTransparent, 5),
                      padding: const EdgeInsets.all(8),
                      child: Widgets.defaultImg(
                          image: "addresses",
                          iconColor: ColorsRes.appColor,
                          height: 20,
                          width: 20),
                    ),
                    "address",
                    onClickAction: () => Navigator.pushNamed(
                      context,
                      addressListScreen,
                      arguments: "",
                    ),
                    padding: const EdgeInsetsDirectional.only(
                      start: 5,
                      end: 5,
                    ),
                  ),
                ),
                Expanded(
                  child: buttonWidget(
                    Container(
                      decoration: DesignConfig.boxDecoration(
                          ColorsRes.appColorLightHalfTransparent, 5),
                      padding: const EdgeInsets.all(8),
                      child: Widgets.defaultImg(
                          image: "cart_icon",
                          iconColor: ColorsRes.appColor,
                          height: 20,
                          width: 20),
                    ),
                    "cart",
                    onClickAction: () {
                      if (Constant.session.isUserLoggedIn()) {
                        Navigator.pushNamed(context, cartScreen);
                      } else {
                        Widgets.loginUserAccount(context, "cart");
                      }
                    },
                    padding: const EdgeInsetsDirectional.only(
                      start: 5,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
