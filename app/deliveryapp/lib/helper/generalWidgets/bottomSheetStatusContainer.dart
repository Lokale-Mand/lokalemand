
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class BottomSheetStatusContainer extends StatefulWidget {
  final String orderId;
  final String statusId;

  BottomSheetStatusContainer(
      {Key? key, required this.orderId, required this.statusId})
      : super(key: key);

  @override
  State<BottomSheetStatusContainer> createState() =>
      _BottomSheetStatusContainerState();
}

class _BottomSheetStatusContainerState
    extends State<BottomSheetStatusContainer> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      context.read<OrderUpdateProvider>().setSelectedStatus(
            (int.parse(widget.statusId) - 1).toString(),
          );
      await context
          .read<OrderUpdateProvider>()
          .getOrdersStatuses(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderUpdateProvider>(
      builder: (context, ordersProvider, child) {
        return Stack(
          children: [
            Container(
              padding: EdgeInsetsDirectional.only(
                start: Constant.paddingOrMargin15,
                end: Constant.paddingOrMargin15,
                top: Constant.paddingOrMargin15,
                bottom: Constant.paddingOrMargin15,
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      getTranslatedValue(context, "update_order_status"),
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.merge(
                            TextStyle(letterSpacing: 0.5),
                          ),
                    ),
                  ),
                  Widgets.getSizedBox(
                    height: 10,
                  ),
                  if (ordersProvider.ordersStatusState ==
                          OrderUpdateStatusState.loaded ||
                      ordersProvider.ordersStatusState ==
                          OrderUpdateStatusState.updating)
                    Column(
                      children: List.generate(
                          ordersProvider.orderStatusesList.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            ordersProvider.setSelectedStatus(index.toString());
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: Constant.paddingOrMargin10),
                                    child: Text(ordersProvider
                                            .orderStatusesList[index].status ??
                                        ""),
                                  ),
                                ),
                                Radio(
                                  activeColor: ColorsRes.appColor,
                                  value: ordersProvider.selectedOrderStatus,
                                  groupValue: context
                                      .watch<OrderUpdateProvider>()
                                      .orderStatusesList[index]
                                      .id,
                                  onChanged: (value) {
                                    ordersProvider
                                        .setSelectedStatus(index.toString());
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  Widgets.getSizedBox(
                    height: 10,
                  ),
                  if (ordersProvider.ordersStatusState ==
                      OrderUpdateStatusState.loading)
                    Column(
                      children: List.generate(8, (index) {
                        return CustomShimmer(
                          height: 26,
                          width: double.maxFinite,
                          margin: EdgeInsetsDirectional.all(10),
                        );
                      }),
                    ),
                  if (ordersProvider.ordersStatusState ==
                          OrderUpdateStatusState.loaded ||
                      ordersProvider.ordersStatusState ==
                          OrderUpdateStatusState.updating)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Constant.paddingOrMargin10),
                      child: Widgets.gradientBtnWidget(
                        context,
                        10,
                        callback: () {
                          Map<String, String> params = {};
                          params[ApiAndParams.orderId] = widget.orderId;
                          params[ApiAndParams.statusId] =
                              ordersProvider.selectedOrderStatus.toString();
                          ordersProvider
                              .updateOrdersStatus(
                                  params: params, context: context)
                              .then(
                                (value) => Navigator.pop(context,value),
                              );
                        },
                        isSetShadow: false,
                        otherWidgets: Container(
                          child: (ordersProvider.ordersStatusState ==
                                  OrderUpdateStatusState.loaded)
                              ? Text(
                                  getTranslatedValue(
                                    context,
                                    "update_order_status",
                                  ),
                                  softWrap: true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .merge(
                                        TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                )
                              : CircularProgressIndicator(
                                  color: ColorsRes.appColorWhite),
                        ),
                      ),
                    ),
                  if (ordersProvider.ordersStatusState ==
                      OrderUpdateStatusState.loading)
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: Constant.paddingOrMargin10,
                        start: Constant.paddingOrMargin10,
                        end: Constant.paddingOrMargin10,
                      ),
                      child: CustomShimmer(
                        height: 55,
                        width: double.maxFinite,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
