import 'package:egrocer/helper/utils/generalImports.dart';

class NotificationsAndMailSettingsScreenScreen extends StatefulWidget {
  const NotificationsAndMailSettingsScreenScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsAndMailSettingsScreenScreen> createState() =>
      _NotificationsAndMailSettingsScreenScreenState();
}

class _NotificationsAndMailSettingsScreenScreenState
    extends State<NotificationsAndMailSettingsScreenScreen> {
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        context
            .read<NotificationsSettingsProvider>()
            .getAppNotificationSettingsApiProvider(
                params: {}, context: context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey:"settings",
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.all(Constant.size10),
            child: CustomTextLabel(
              jsonKey:"notifications_settings",
              style: TextStyle(
                  color: ColorsRes.appColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          Consumer<NotificationsSettingsProvider>(
            builder: (context, notificationsSettingsProvider, _) {
              if (notificationsSettingsProvider.notificationsSettingsState ==
                  NotificationsSettingsState.loaded) {
                return Column(
                  children: List.generate(
                      notificationsSettingsProvider
                          .notificationSettingsDataList.length,
                      (index) => _buildSettingItemContainer(index)),
                );
              } else if (notificationsSettingsProvider
                      .notificationsSettingsState ==
                  NotificationsSettingsState.loading) {
                return Column(
                  children:
                      List.generate(8, (index) => _buildSettingItemShimmer()),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          Consumer<NotificationsSettingsProvider>(
            builder: (context, notificationsSettingsProvider, _) {
              return Padding(
                padding: EdgeInsetsDirectional.only(
                    start: Constant.size10,
                    end: Constant.size10,
                    bottom: Constant.size10),
                child: Widgets.gradientBtnWidget(
                  context,
                  Constant.size10,
                  callback: () {
                    context
                        .read<NotificationsSettingsProvider>()
                        .updateAppNotificationSettingsApiProvider(
                            context: context);
                  },
                 
                  otherWidgets: notificationsSettingsProvider
                              .notificationsSettingsUpdateState ==
                          NotificationsSettingsUpdateState.loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: ColorsRes.mainTextColor,
                          ),
                        )
                      : CustomTextLabel(
                          jsonKey: "update",
                          softWrap: true,
                          style: Theme.of(context).textTheme.titleMedium!.merge(
                                TextStyle(
                                    color: ColorsRes.appColorWhite,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500),
                              ),
                        ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  _buildSettingItemContainer(int index) {
    return Consumer<NotificationsSettingsProvider>(
      builder: (context, notificationsSettingsProvider, _) {
        AppNotificationSettingsData notificationSettingsData =
            notificationsSettingsProvider.notificationSettingsDataList[index];
        List lblOrderStatusDisplayNames = [
          getTranslatedValue(
              context, "order_status_display_names_awaiting_payment"),
          getTranslatedValue(context, "order_status_display_names_received"),
          getTranslatedValue(context, "order_status_display_names_processed"),
          getTranslatedValue(context, "order_status_display_names_shipped"),
          getTranslatedValue(
              context, "order_status_display_names_out_for_delivery"),
          getTranslatedValue(context, "order_status_display_names_delivered"),
          getTranslatedValue(context, "order_status_display_names_cancelled"),
          getTranslatedValue(context, "order_status_display_names_returned"),
        ];
        return Card(
          color: Theme.of(context).cardColor,
          margin: EdgeInsetsDirectional.only(
              start: Constant.size10,
              end: Constant.size10,
              bottom: Constant.size10),
          child: Padding(
            padding: EdgeInsetsDirectional.only(
                start: Constant.size10,
                end: Constant.size10,
                top: Constant.size5,
                bottom: Constant.size5),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextLabel(
                    text: lblOrderStatusDisplayNames[(int.parse(
                            notificationSettingsData.orderStatusId ?? "1")) -
                        1],
                  ),
                ),
                Column(
                  children: [
                    CustomTextLabel(
                      jsonKey:"mail",
                    ),
                    Switch(
                      value:
                          notificationsSettingsProvider.mailSettings[index] ==
                              1,
                      onChanged: (value) {
                        notificationsSettingsProvider.changeMailSetting(
                            index: index, status: value == true ? 1 : 0);
                      },
                      activeColor: ColorsRes.appColor,
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomTextLabel(
                      jsonKey:"mobile",
                    ),
                    Switch(
                      value:
                          notificationsSettingsProvider.mobileSettings[index] ==
                              1,
                      onChanged: (value) {
                        notificationsSettingsProvider.changeMobileSetting(
                            index: index, status: value == true ? 1 : 0);
                      },
                      activeColor: ColorsRes.appColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildSettingItemShimmer() {
    return CustomShimmer(
      width: MediaQuery.of(context).size.width,
      height: 80,
      borderRadius: 5,
      margin: EdgeInsetsDirectional.only(
          start: Constant.size10,
          end: Constant.size10,
          bottom: Constant.size10),
    );
  }
}
