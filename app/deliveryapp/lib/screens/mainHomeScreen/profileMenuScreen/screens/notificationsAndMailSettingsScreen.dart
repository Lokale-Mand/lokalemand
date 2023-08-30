import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class NotificationsAndMailSettingsScreenScreen extends StatefulWidget {
  const NotificationsAndMailSettingsScreenScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsAndMailSettingsScreenScreen> createState() => _NotificationsAndMailSettingsScreenScreenState();
}

class _NotificationsAndMailSettingsScreenScreenState extends State<NotificationsAndMailSettingsScreenScreen> {
  List<String> lblOrderStatusDisplayNames = [];
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        context.read<NotificationsSettingsProvider>().getNotificationSettingsApiProvider(params: {}, context: context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    lblOrderStatusDisplayNames = [
      getTranslatedValue(context, "order_status_display_names_awaiting"),
      getTranslatedValue(context, "order_status_display_names_received"),
      getTranslatedValue(context, "order_status_display_names_processed"),
      getTranslatedValue(context, "order_status_display_names_shipped"),
      getTranslatedValue(context, "order_status_display_names_out_for_delivery"),
      getTranslatedValue(context, "order_status_display_names_delivered"),
      getTranslatedValue(context, "order_status_display_names_cancelled"),
      getTranslatedValue(context, "order_status_display_names_returned"),
    ];

    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: Text(
          getTranslatedValue(context, "settings"),
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin10),
            child: Text(
              getTranslatedValue(context, "notifications_settings"),
              style: TextStyle(color: ColorsRes.appColor, fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ),
          Consumer<NotificationsSettingsProvider>(
            builder: (context, notificationsSettingsProvider, _) {
              if (notificationsSettingsProvider.notificationsSettingsState == NotificationsSettingsState.loaded) {
                return Column(
                  children: List.generate(notificationsSettingsProvider.notificationSettingsDataList.length, (index) => _buildSettingItemContainer(index)),
                );
              } else if (notificationsSettingsProvider.notificationsSettingsState == NotificationsSettingsState.loading) {
                return Column(
                  children: List.generate(8, (index) => _buildSettingItemShimmer()),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          Consumer<NotificationsSettingsProvider>(
            builder: (context, notificationsSettingsProvider, _) {
              return Padding(
                padding: EdgeInsetsDirectional.only(start: Constant.paddingOrMargin10, end: Constant.paddingOrMargin10, bottom: Constant.paddingOrMargin10),
                child: Widgets.gradientBtnWidget(
                  context,
                  Constant.paddingOrMargin10,
                  callback: () {
                    context.read<NotificationsSettingsProvider>().updateNotificationSettingsApiProvider(context: context);
                  },
                  isSetShadow: false,
                  otherWidgets: notificationsSettingsProvider.notificationsSettingsUpdateState == NotificationsSettingsUpdateState.loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: ColorsRes.appColorWhite,
                          ),
                        )
                      : Text(
                          getTranslatedValue(context, "update_settings"),
                          softWrap: true,
                          style: Theme.of(context).textTheme.titleMedium!.merge(
                                TextStyle(color: Colors.white, letterSpacing: 0.5, fontWeight: FontWeight.w500),
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
        NotificationSettingsData notificationSettingsData = notificationsSettingsProvider.notificationSettingsDataList[index];
        return Card(
          color: Theme.of(context).cardColor,
          margin: EdgeInsetsDirectional.only(start: Constant.paddingOrMargin10, end: Constant.paddingOrMargin10, bottom: Constant.paddingOrMargin10),
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: Constant.paddingOrMargin10, end: Constant.paddingOrMargin10, top: Constant.paddingOrMargin5, bottom: Constant.paddingOrMargin5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    lblOrderStatusDisplayNames[int.parse(notificationSettingsData.orderStatusId ?? "0")].toString(),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      getTranslatedValue(context, "mail"),
                    ),
                    Switch(
                      value: notificationsSettingsProvider.mailSettings[index] == 1,
                      onChanged: (value) {
                        notificationsSettingsProvider.changeMailSetting(index: index, status: value == true ? 1 : 0);
                      },
                      activeColor: ColorsRes.appColor,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      getTranslatedValue(context, "mobile"),
                    ),
                    Switch(
                      value: notificationsSettingsProvider.mobileSettings[index] == 1,
                      onChanged: (value) {
                        notificationsSettingsProvider.changeMobileSetting(index: index, status: value == true ? 1 : 0);
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
      margin: EdgeInsetsDirectional.only(start: Constant.paddingOrMargin10, end: Constant.paddingOrMargin10, bottom: Constant.paddingOrMargin10),
    );
  }
}
