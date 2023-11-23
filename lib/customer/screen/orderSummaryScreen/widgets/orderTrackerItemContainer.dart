import 'package:lokale_mand/helper/utils/generalImports.dart';

class OrderTrackerItemContainer extends StatelessWidget {
  final List<List> listOfStatus;
  final int index;
  final bool isLast;

  const OrderTrackerItemContainer(
      {super.key,
      required this.index,
      required this.isLast,
      required this.listOfStatus});

  @override
  Widget build(BuildContext context) {
    List statusImages = [
      "status_icon_awaiting_payment",
      "status_icon_received",
      "status_icon_process",
      "status_icon_shipped",
      "status_icon_out_for_delivery",
      "status_icon_delivered",
      "status_icon_cancel",
      "status_icon_returned",
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              child: CircleAvatar(
                child: Widgets.defaultImg(
                  image: statusImages[index],
                  height: 22,
                  width: 22,
                  iconColor: (listOfStatus.length > index)
                      ? ColorsRes.mainTextColor
                      : ColorsRes.subTitleMainTextColor,
                ),
                radius: 20,
                backgroundColor: (listOfStatus.length > index)
                    ? ColorsRes.appColor
                    : ColorsRes.subTitleMainTextColor,
              ),
              radius: 25,
              backgroundColor: (listOfStatus.length > index)
                  ? ColorsRes.appColorDark
                  : ColorsRes.subTitleMainTextColor,
            ),
            if (!isLast)
              Container(
                height: 50,
                width: 10,
                color: (!isLast)
                    ? (listOfStatus.length > index + 1)
                        ? ColorsRes.appColor
                        : ColorsRes.subTitleMainTextColor
                    : ColorsRes.appColor,
              )
          ],
        ),
        Widgets.getSizedBox(
          width: 20,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: CustomTextLabel(
              //Your order has been received on 13-06-2023 10:25 PM
              text: (listOfStatus.length > index)
                  ? "Your order has been ${Constant.getOrderActiveStatusLabelFromCode(listOfStatus[index].first.toString())} on ${listOfStatus[index].last.toString()}"
                  : Constant.getOrderActiveStatusLabelFromCode(
                      (index + listOfStatus.length + 1).toString()),
              softWrap: true,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
