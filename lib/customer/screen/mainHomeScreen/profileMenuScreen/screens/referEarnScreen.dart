import 'dart:math' as math;

import 'package:lokale_mand/helper/utils/generalImports.dart';

class ReferAndEarn extends StatefulWidget {
  const ReferAndEarn({Key? key}) : super(key: key);

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  bool isCreatingLink = false;

  List workflowlist = [];

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        workflowlist = [
          {
            "icon": "refer_step_1",
            "info": getTranslatedValue(
              context,
              "invite_friends_to_signup",
            )
          },
          {
            "icon": "refer_step_2",
            "info": getTranslatedValue(
              context,
              "friends_download_app",
            )
          },
          {
            "icon": "refer_step_3",
            "info": getTranslatedValue(
              context,
              "friends_place_first_order",
            )
          },
          {
            "icon": "refer_step_4",
            "info": getTranslatedValue(
              context,
              "you_will_get_reward_after_delivered",
            ),
          },
        ];
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
            jsonKey:"refer_and_earn",
            softWrap: true,
            style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: Stack(
        children: [
          ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.size10, vertical: Constant.size10),
              children: [
                topImage(),
                infoWidget(),
                howWorksWidget(),
                referCodeWidget()
              ]),
          if (isCreatingLink == true)
            PositionedDirectional(
              top: 0,
              end: 0,
              start: 0,
              bottom: 0,
              child: Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(child: CircularProgressIndicator())),
            )
        ],
      ),
    );
  }

  referCodeWidget() {
    return Card(
      elevation: 0,
      shape: DesignConfig.setRoundedBorder(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constant.size10, vertical: Constant.size15),
            child: CustomTextLabel(
              jsonKey:"your_referral_code",
              softWrap: true,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .merge(const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ),
          const Divider(
            height: 1,
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(
                  text: Constant.session
                      .getData(SessionManager.keyReferralCode)
                      .toString()));
              GeneralMethods.showMessage(
                context,
                getTranslatedValue(
                  context,
                  "refer_code_copied",
                ),
                MessageType.success,
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.size10, vertical: Constant.size20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    decoration: DesignConfig.boxDecoration(
                        ColorsRes.appColor.withOpacity(0.2), 10),
                    child: DashedRect(
                      color: ColorsRes.appColor,
                      strokeWidth: 1.0,
                      gap: 10,
                    ),
                  ),
                  Row(children: [
                    const SizedBox(width: 12),
                    Expanded(
                        child: CustomTextLabel(
                      text: Constant.session
                          .getData(SessionManager.keyReferralCode)
                          .toString(),
                      softWrap: true,
                    )),
                    CustomTextLabel(
                      jsonKey:"tap_to_copy",
                      softWrap: true,
                      style: TextStyle(color: ColorsRes.appColor),
                    ),
                    const SizedBox(width: 12),
                  ])
                ],
              ),
            ),
          ),
          SizedBox(height: Constant.size10),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: Constant.size10),
              child: btnWidget()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  btnWidget() {
    return Widgets.gradientBtnWidget(context, 10, callback: () {
      if (isCreatingLink == false) {
        setState(() {
          isCreatingLink = true;
        });
        shareCode();
      }
    },
        otherWidgets: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Widgets.defaultImg(
              image: "share_icon",
              iconColor: ColorsRes.mainIconColor,
            ),
            const SizedBox(width: 8),
            CustomTextLabel(
              jsonKey:"refer_now",
              softWrap: true,
              style: Theme.of(context).textTheme.titleMedium!.merge(TextStyle(
                  color: ColorsRes.mainTextColor,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500)),
            )
          ],
        ));
  }

  shareCode() async {
    String prefixMessage = getTranslatedValue(
      context,
      "refer_and_earn_share_prefix_message",
    );
    String shareMessage = await GeneralMethods.createDynamicLink(
      context: context,
      shareUrl:
          "${Constant.hostUrl}refer/${Constant.session.getData(SessionManager.keyReferralCode).toString()}",
    );
    await Share.share("$prefixMessage $shareMessage",
        subject: "Refer and earn app");

    setState(() {
      isCreatingLink = false;
    });
  }

  topImage() {
    return Card(
      elevation: 0,
      shape: DesignConfig.setRoundedBorder(8),
      child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Constant.size8,
          ),
          child: Widgets.defaultImg(image: "refer_and_earn")),
    );
  }

  infoWidget() {
    String maxEarnAmount = Constant.referEarnMethod == "percentage"
        ? "${Constant.maximumReferEarnAmount}%"
        : GeneralMethods.getCurrencyFormat(
            double.parse(Constant.maximumReferEarnAmount));
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: DesignConfig.setRoundedBorder(8),
      child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Constant.size8,
          ),
          child: Column(children: [
            infoItem("${getTranslatedValue(
              context,
              "refer_and_earn_share_display_message_1_postfix",
            )} $maxEarnAmount ${getTranslatedValue(
              context,
              "refer_and_earn_share_display_message_1_prefix",
            )}"),
            infoItem("${getTranslatedValue(
              context,
              "refer_and_earn_share_display_message_2",
            )} ${GeneralMethods.getCurrencyFormat(double.parse(Constant.minimumReferEarnOrderAmount))}."),
            infoItem("${getTranslatedValue(
              context,
              "refer_and_earn_share_display_message_3",
            )} $maxEarnAmount."),
          ])),
    );
  }

  infoItem(String text) {
    return ListTile(
      dense: true,
      horizontalTitleGap: 10,
      minLeadingWidth: Constant.size10,
      leading: Icon(Icons.brightness_1, color: ColorsRes.appColor, size: 15),
      title: CustomTextLabel(
        text: text,
        softWrap: true,
      ),
    );
  }

  howWorksWidget() {
    return Card(
      elevation: 0,
      color: ColorsRes.appColor,
      shape: DesignConfig.setRoundedBorder(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size10, vertical: Constant.size15),
          child: CustomTextLabel(
            jsonKey:"how_it_works",
            softWrap: true,
            style: Theme.of(context).textTheme.titleMedium!.merge(TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ColorsRes.mainTextColor,
                )),
          ),
        ),
        const Divider(
          height: 1,
          color: Colors.white38,
        ),
        ListView.separated(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size8, vertical: Constant.size10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: workflowlist.length,
          separatorBuilder: ((context, index) {
            return Container(
                margin: EdgeInsetsDirectional.only(
                    top: 3, bottom: 5, start: index % 2 == 0 ? 5 : 17),
                alignment: Alignment.centerLeft,
                child: index % 2 == 0
                    ? Widgets.defaultImg(image: "rf_arrow_right")
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Widgets.defaultImg(image: "rf_arrow_right")));
          }),
          itemBuilder: ((context, index) => Row(children: [
                CircleAvatar(
                    backgroundColor: Colors.black,
                    child:
                        Widgets.defaultImg(image: workflowlist[index]['icon'])),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomTextLabel(
                    text: workflowlist[index]['info'],
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyLarge!.merge(
                        TextStyle(
                            color: ColorsRes.mainTextColor,
                            letterSpacing: 0.5)),
                  ),
                )
              ])),
        )
      ]),
    );
  }
}
