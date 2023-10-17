import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lottie/lottie.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({Key? key}) : super(key: key);

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) =>
        context.read<CartListProvider>().clearCart(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(Constant.size10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                Constant.getAssetsPath(3, "order_success_tick_animation"),
                height: MediaQuery.sizeOf(context).width * 0.4,
                width: MediaQuery.sizeOf(context).width * 0.4,
                repeat: false,
              ),
              Widgets.getSizedBox(
                height: Constant.size20,
              ),
              CustomTextLabel(
                jsonKey: "order_place_message",
                softWrap: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall!.merge(
                      TextStyle(
                        color: ColorsRes.mainTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
              ),
              Widgets.getSizedBox(
                height: Constant.size20,
              ),
              CustomTextLabel(
                jsonKey: "order_place_description",
                softWrap: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.merge(
                      TextStyle(
                          letterSpacing: 0.5, color: ColorsRes.mainTextColor),
                    ),
              ),
              Widgets.getSizedBox(
                height: Constant.size20,
              ),
              FittedBox(
                child: Widgets.gradientBtnWidget(
                  context,
                  5,
                  callback: () {
                    Navigator.of(context).popUntil(
                      (Route<dynamic> route) => route.isFirst,
                    );
                  },
                  otherWidgets: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomTextLabel(
                      jsonKey: "continue_shopping",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: ColorsRes.appColorWhite,
                            fontSize: 16,
                          ),
                    ),
                  ),
                ),
              ),
              Widgets.getSizedBox(
                height: Constant.size20,
              ),
              FittedBox(
                child: Widgets.gradientBtnWidget(
                  context,
                  5,
                  callback: () {
                    Navigator.of(context).popUntil(
                      (Route<dynamic> route) => route.isFirst,
                    );
                    Navigator.pushNamed(context, orderHistoryScreen);
                  },
                  otherWidgets: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomTextLabel(
                      jsonKey: "view_all_orders",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: ColorsRes.appColorWhite,
                            fontSize: 16,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
