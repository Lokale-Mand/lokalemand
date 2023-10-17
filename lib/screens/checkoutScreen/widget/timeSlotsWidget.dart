import 'package:lokale_mand/helper/utils/generalImports.dart';

class GetTimeSlots extends StatelessWidget {
  const GetTimeSlots({super.key});

  @override
  Widget build(BuildContext context) {
    List lblMonthsNames = [
      "months_names_january",
      "months_names_february",
      "months_names_march",
      "months_names_april",
      "months_names_may",
      "months_names_june",
      "months_names_july",
      "months_names_august",
      "months_names_september",
      "months_names_october",
      "months_names_november",
      "months_names_december",
    ];

    List lblWeekDaysNames = [
      "week_days_names_monday",
      "week_days_names_tuesday",
      "week_days_names_wednesday",
      "week_days_names_thursday",
      "week_days_names_friday",
      "week_days_names_saturday",
      "week_days_names_sunday",
    ];
    return context.read<CheckoutProvider>().timeSlotsData?.timeSlotsIsEnabled ==
            "true"
        ? Card(
            color: Theme.of(context).cardColor,
            elevation: 0,
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                  start: Constant.size10,
                  top: Constant.size10,
                  end: Constant.size10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextLabel(
                    jsonKey: "preferred_delivery_time",
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ColorsRes.mainTextColor,
                    ),
                  ),
                  Widgets.getSizedBox(
                    height: Constant.size10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        int.parse(context
                                .read<CheckoutProvider>()
                                .timeSlotsData
                                ?.timeSlotsAllowedDays ??
                            "0"),
                        (index) {
                          late DateTime dateTime;
                          if (int.parse(context
                                      .read<CheckoutProvider>()
                                      .timeSlotsData
                                      ?.timeSlotsDeliveryStartsFrom
                                      .toString() ??
                                  "") ==
                              1) {
                            dateTime = DateTime.now();
                          } else {
                            dateTime = DateTime.now().add(Duration(
                                days: int.parse(context
                                            .read<CheckoutProvider>()
                                            .timeSlotsData
                                            ?.timeSlotsDeliveryStartsFrom ??
                                        "") -
                                    1));
                          }

                          String date =
                              dateTime.add(Duration(days: 0)).day.toString();
                          String month =
                              dateTime.add(Duration(days: 0)).month.toString();
                          String year =
                              dateTime.add(Duration(days: 0)).year.toString();
                          context.read<CheckoutProvider>().selectedDate =
                              "$date-$month-$year";

                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<CheckoutProvider>()
                                  .setSelectedTime(-1);
                              context
                                  .read<CheckoutProvider>()
                                  .setSelectedDate(index);
                              String date = dateTime
                                  .add(Duration(days: index))
                                  .day
                                  .toString();
                              String month = dateTime
                                  .add(Duration(days: index))
                                  .month
                                  .toString();
                              String year = dateTime
                                  .add(Duration(days: index))
                                  .year
                                  .toString();
                              context.read<CheckoutProvider>().selectedDate =
                                  "$date-$month-$year";
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              margin: const EdgeInsetsDirectional.fromSTEB(
                                  0, 5, 10, 5),
                              decoration: BoxDecoration(
                                  color: context
                                              .read<CheckoutProvider>()
                                              .selectedDateId ==
                                          index
                                      ? Constant.session.getBoolData(
                                              SessionManager.isDarkTheme)
                                          ? ColorsRes.appColorBlack
                                              .withOpacity(0.2)
                                          : ColorsRes.appColorWhite
                                              .withOpacity(0.2)
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(0.8),
                                  borderRadius: Constant.borderRadius7,
                                  border: Border.all(
                                    width: context
                                                .read<CheckoutProvider>()
                                                .selectedDateId ==
                                            index
                                        ? 1
                                        : 0.3,
                                    color: context
                                                .read<CheckoutProvider>()
                                                .selectedDateId ==
                                            index
                                        ? ColorsRes.appColor
                                        : ColorsRes.grey,
                                  )),
                              child: Column(
                                children: [
                                  CustomTextLabel(
                                    jsonKey: lblWeekDaysNames[dateTime
                                            .add(Duration(days: index))
                                            .weekday -
                                        1],
                                    style: TextStyle(
                                      color: context
                                                  .read<CheckoutProvider>()
                                                  .selectedDateId ==
                                              index
                                          ? ColorsRes.mainTextColor
                                          : ColorsRes.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                      dateTime
                                          .add(Duration(days: index))
                                          .day
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: context
                                                    .read<CheckoutProvider>()
                                                    .selectedDateId ==
                                                index
                                            ? ColorsRes.mainTextColor
                                            : ColorsRes.grey,
                                      )),
                                  CustomTextLabel(
                                    jsonKey: lblMonthsNames[dateTime
                                            .add(Duration(days: index))
                                            .month -
                                        1],
                                    style: TextStyle(
                                      color: context
                                                  .read<CheckoutProvider>()
                                                  .selectedDateId ==
                                              index
                                          ? ColorsRes.mainTextColor
                                          : ColorsRes.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Widgets.getSizedBox(
                    height: Constant.size5,
                  ),
                  Column(
                    children: List.generate(
                        context
                                .read<CheckoutProvider>()
                                .timeSlotsData
                                ?.timeSlots
                                .length ??
                            0, (index) {
                      var now = DateTime.now();
                      bool isActive = false;
                      bool isToday = context
                                  .read<CheckoutProvider>()
                                  .timeSlotsData
                                  ?.timeSlotsDeliveryStartsFrom ==
                              "1" &&
                          context.read<CheckoutProvider>().selectedDateId == 0;
                      String time = context
                              .read<CheckoutProvider>()
                              .timeSlotsData
                              ?.timeSlots[index]
                              .lastOrderTime
                              .toString() ??
                          "";

                      late DateTime dateTime = now.copyWith(
                          hour: int.parse(time.split(":")[0]),
                          microsecond: int.parse(time.split(":")[1]),
                          second: int.parse(time.split(":")[2]));

                      if (now.isAfter(dateTime)) {
                        if (isToday) {
                          isActive = false;
                        } else {
                          isActive = true;
                        }
                      } else {
                        isActive = true;
                      }

                      return isActive
                          ? GestureDetector(
                              onTap: () {
                                context
                                    .read<CheckoutProvider>()
                                    .setSelectedTime(index);
                              },
                              child: Container(
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  border: BorderDirectional(
                                    bottom: BorderSide(
                                      width: 1,
                                      color: context
                                                  .read<CheckoutProvider>()
                                                  .timeSlotsData
                                                  ?.timeSlots
                                                  .length ==
                                              index + 1
                                          ? Colors.transparent
                                          : ColorsRes.grey.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: Constant.size10),
                                      child: CustomTextLabel(
                                        text: context
                                                .read<CheckoutProvider>()
                                                .timeSlotsData
                                                ?.timeSlots[index]
                                                .title ??
                                            "",
                                        style: TextStyle(
                                          color: ColorsRes.mainTextColor,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Radio(
                                      value: context
                                          .read<CheckoutProvider>()
                                          .selectedTime,
                                      groupValue: index,
                                      activeColor: ColorsRes.appColor,
                                      onChanged: (value) {
                                        context
                                            .read<CheckoutProvider>()
                                            .setSelectedTime(index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container();
                    }),
                  ),
                  Widgets.getSizedBox(
                    height: Constant.size10,
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
