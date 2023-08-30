
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class BottomSheetDeliveryBoysContainer extends StatefulWidget {
  final String orderId;
  final String deliveryBoyId;

  BottomSheetDeliveryBoysContainer(
      {Key? key, required this.orderId, required this.deliveryBoyId})
      : super(key: key);

  @override
  State<BottomSheetDeliveryBoysContainer> createState() =>
      _BottomSheetDeliveryBoysContainerState();
}

class _BottomSheetDeliveryBoysContainerState
    extends State<BottomSheetDeliveryBoysContainer> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      context.read<DeliveryBoysProvider>().selectedDeliveryBoy =
          widget.deliveryBoyId;
      await context.read<DeliveryBoysProvider>().getDeliveryBoys(
          selectedDeliveryBoyIndex: int.parse(
            widget.deliveryBoyId.toString(),
          ),
          context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryBoysProvider>(
      builder: (context, deliveryBoysProvider, child) {
        return Container(
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
                  getTranslatedValue(
                    context,
                    "update_delivery_boy",
                  ),
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
              if (deliveryBoysProvider.deliveryBoysState ==
                      DeliveryBoysState.loaded ||
                  deliveryBoysProvider.deliveryBoysState ==
                      DeliveryBoysState.loadingMore ||
                  deliveryBoysProvider.deliveryBoysState ==
                      DeliveryBoysState.updating)
                Column(
                  children: List.generate(
                      deliveryBoysProvider.deliveryBoysList.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        deliveryBoysProvider.setSelectedIndex(
                          deliveryBoysProvider.deliveryBoysList[index].id
                              .toString(),
                        );
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.paddingOrMargin10),
                                child: Text(
                                    "${deliveryBoysProvider.deliveryBoysList[index].name ?? ""}(${getTranslatedValue(context, "pending_orders")} - ${deliveryBoysProvider.deliveryBoysList[index].pendingOrderCount ?? "0"})"),
                              ),
                            ),
                            Radio(
                              activeColor: ColorsRes.appColor,
                              value: context
                                  .watch<DeliveryBoysProvider>()
                                  .selectedDeliveryBoy,
                              groupValue: deliveryBoysProvider
                                  .deliveryBoysList[index].id
                                  .toString(),
                              onChanged: (value) {
                                deliveryBoysProvider.setSelectedIndex(
                                  deliveryBoysProvider
                                      .deliveryBoysList[index].id
                                      .toString(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              if (deliveryBoysProvider.deliveryBoysState ==
                  DeliveryBoysState.loading)
                Column(
                  children: List.generate(8, (index) {
                    return CustomShimmer(
                      height: 30,
                      width: double.maxFinite,
                      margin: EdgeInsetsDirectional.all(10),
                    );
                  }),
                ),
              Widgets.getSizedBox(
                height: 10,
              ),
              if (deliveryBoysProvider.deliveryBoysState ==
                      DeliveryBoysState.updating ||
                  deliveryBoysProvider.deliveryBoysState ==
                      DeliveryBoysState.loaded)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Constant.paddingOrMargin10),
                  child: Widgets.gradientBtnWidget(
                    context,
                    10,
                    callback: () {
                      Map<String, String> params = {};
                      params[ApiAndParams.orderId] = widget.orderId;
                      params[ApiAndParams.deliveryBoyId] =
                          deliveryBoysProvider.selectedDeliveryBoy.toString();

                      deliveryBoysProvider
                          .updateOrdersDeliveryBoy(
                              params: params, context: context)
                          .then(
                            (value) => Navigator.pop(context, value),
                          );
                    },
                    isSetShadow: false,
                    otherWidgets: Container(
                      child: (deliveryBoysProvider.deliveryBoysState ==
                              DeliveryBoysState.updating)
                          ? CircularProgressIndicator(
                              color: ColorsRes.appColorWhite)
                          : (deliveryBoysProvider.deliveryBoysState ==
                                  DeliveryBoysState.loaded)
                              ? Text(
                                  getTranslatedValue(
                                    context,
                                    "update_delivery_boy",
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
                              : Container(),
                    ),
                  ),
                ),
              if (deliveryBoysProvider.deliveryBoysState ==
                  DeliveryBoysState.loading)
                Padding(
                  padding: EdgeInsetsDirectional.only(
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
        );
      },
    );
  }
}
