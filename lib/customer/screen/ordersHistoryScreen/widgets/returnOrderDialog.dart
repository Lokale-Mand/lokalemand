import 'package:lokale_mand/customer/models/order.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class ReturnOrderDialog extends StatelessWidget {
  final Order order;
  final String orderItemId;

  const ReturnOrderDialog({
    required this.order,
    required this.orderItemId,
    Key? key,
  }) : super(key: key);

  void onReturnOrderSuccess(BuildContext context) {
    //Need to pass true so we can update order item status
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (context.read<UpdateOrderStatusProvider>().getUpdateOrderStatus() !=
            UpdateOrderStatus.inProgress) {
          Navigator.pop(context);
        }
      },
      child: AlertDialog(
        title: CustomTextLabel(
          jsonKey: "sure_to_return_order",
        ),
        actions: [
          Consumer<UpdateOrderStatusProvider>(builder: (context, provider, _) {
            if (provider.getUpdateOrderStatus() ==
                UpdateOrderStatus.inProgress) {
              return const Center(
                child: CustomCircularProgressIndicator(),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: CustomTextLabel(
                    jsonKey: "no",
                    style: TextStyle(color: ColorsRes.mainTextColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<UpdateOrderStatusProvider>()
                        .updateStatus(
                            order: order,
                            orderItemId: orderItemId,
                            status: Constant.orderStatusCode[7],
                            context: context)
                        .then((value) => Navigator.pop(context, value));
                  },
                  child: CustomTextLabel(
                    jsonKey: "yes",
                    style: TextStyle(color: ColorsRes.appColor),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
