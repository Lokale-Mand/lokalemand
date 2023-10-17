/*
      1 -> Payment pending
      2 -> Received
      3 -> Processed
      4 -> Shipped
      5 -> Out For Delivery
      6 -> Delivered
      7 -> Cancelled
      8 -> Returned
*/

import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/screens/orderSummaryScreen/widgets/orderTrackerItemContainer.dart';

class OrderTrackingHistoryBottomSheet extends StatelessWidget {
  final List<List> listOfStatus;

  const OrderTrackingHistoryBottomSheet(
      {super.key, required this.listOfStatus});

  @override
  Widget build(BuildContext context) {
    int getTrackerLength() {
      int length = 5;
      bool isAwaitingStatusAvailable = false;
      bool isReturnedOrCancelledStatusAvailable = false;

      if (listOfStatus.first.first.toString() == "1") {
        isAwaitingStatusAvailable = true;
      } else {
        isAwaitingStatusAvailable = false;
      }

      if (listOfStatus.last.first.toString() == "6" ||
          listOfStatus.last.first.toString() == "7") {
        isReturnedOrCancelledStatusAvailable = true;
      } else {
        isReturnedOrCancelledStatusAvailable = false;
      }

      if (isAwaitingStatusAvailable) {
        length++;
      }

      if (isReturnedOrCancelledStatusAvailable) {
        length++;
      }

      return length;
    }

    return ListView(
      shrinkWrap: true,
      children: [
        Widgets.getSizedBox(
          height: 20,
        ),
        Center(
          child: CustomTextLabel(
            jsonKey: "change_language",
            softWrap: true,
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .titleMedium!
                .merge(
              TextStyle(
                letterSpacing: 0.5,
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: 10,
            end: 10,
            bottom: 10,
          ),
          child: ListView(
            shrinkWrap: true,
            children: List.generate(getTrackerLength(), (index) {
              return OrderTrackerItemContainer(
                index: index,
                isLast: index == getTrackerLength() - 1,
                listOfStatus: listOfStatus,
              );
            }),
          ),
        ),
      ],
    );
  }
}
