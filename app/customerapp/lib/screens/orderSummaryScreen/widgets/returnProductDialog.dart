import 'package:egrocer/helper/utils/generalImports.dart';

class ReturnProductDialog extends StatelessWidget {
  final Order order;
  final String orderItemId;

  const ReturnProductDialog({
    required this.order,
    required this.orderItemId,
    Key? key,
  }) : super(key: key);

  void onReturnProductSuccess(BuildContext context) {
    //Need to pass true so we can update order item status
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (context.read<UpdateOrderStatusProvider>().getUpdateOrderStatus() ==
            UpdateOrderStatus.inProgress) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: AlertDialog(
        title: CustomTextLabel(
          jsonKey:"sure_to_return_product",
          softWrap: true,
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
                    jsonKey:"no",
                    softWrap: true,
                    style: TextStyle(color: ColorsRes.mainTextColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<UpdateOrderStatusProvider>().updateStatus(
                        order: order,
                        orderItemId: orderItemId,
                        status: Constant.orderStatusCode[7],
                        context: context);
                  },
                  child: CustomTextLabel(
                    jsonKey:"yes",
                    softWrap: true,
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
