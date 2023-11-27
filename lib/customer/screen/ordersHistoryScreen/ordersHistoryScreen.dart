import 'package:lokale_mand/customer/screen/ordersHistoryScreen/activeOrdersHistoryScreen.dart';
import 'package:lokale_mand/customer/screen/ordersHistoryScreen/widgets/orderTypeButtonWidget.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  int currentIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      ChangeNotifierProvider<ActiveOrdersProvider>(
        create: (context) => ActiveOrdersProvider(),
        child: const ActiveOrdersHistoryScreen(),
      ),
      ChangeNotifierProvider<PreviousOrdersProvider>(
        create: (context) => PreviousOrdersProvider(),
        child: const PreviousOrdersHistoryScreen(),
      )
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: "orders_history",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorsRes.mainTextColor,
            ),
          ),
          showBackButton: true),
      body: Column(
        children: [
          OrderTypeButtonWidget(
            isActive: false,
            margin: EdgeInsetsDirectional.only(
              start: 10,
              end: 10,
              top: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    child: OrderTypeButtonWidget(
                      isActive: currentIndex == 0,
                      child: Center(
                        child: CustomTextLabel(
                          jsonKey: "active_orders",
                          softWrap: true,
                          style: TextStyle(
                            color: currentIndex == 0
                                ? ColorsRes.appColorWhite
                                : ColorsRes.mainTextColor,
                          ),
                        ),
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
                    child: OrderTypeButtonWidget(
                      isActive: currentIndex == 1,
                      child: Center(
                        child: CustomTextLabel(
                          jsonKey: "previous_orders",
                          softWrap: true,
                          style: TextStyle(
                            color: currentIndex == 1
                                ? ColorsRes.appColorWhite
                                : ColorsRes.mainTextColor,
                          ),
                        ),
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
