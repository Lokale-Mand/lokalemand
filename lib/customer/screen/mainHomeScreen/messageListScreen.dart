import 'package:lokale_mand/helper/utils/generalImports.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            text: getTranslatedValue(
              context,
              "chat",
            ),
            softWrap: true,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorsRes.mainTextColor,
            ),
          ),
          actions: [
            // setCartCounter(context: context),
          ],
          showBackButton: false),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsetsDirectional.only(
              start: 10,
              end: 10,
              top: 10,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1.5,
                  color: ColorsRes.menuTitleColor.withOpacity(0.1),
                ),
                bottom: BorderSide(
                  width: 1.5,
                  color: ColorsRes.menuTitleColor.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  child: Widgets.setNetworkImg(
                      image: "https://funmauj.b-cdn.net/test/535647.jpg",
                      height: 60,
                      width: 60,
                      boxFit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(100),
                ),
                Widgets.getSizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextLabel(
                        text: "Gerrit Janssen",
                        style: TextStyle(
                            color: ColorsRes.mainTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      CustomTextLabel(
                        text: "Do you have any more potatoes?",
                        style: TextStyle(
                          color: ColorsRes.menuTitleColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CustomTextLabel(
                  text: "16:35",
                  style: TextStyle(
                    color: ColorsRes.menuTitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsetsDirectional.only(
              start: 10,
              end: 10,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.5,
                  color: ColorsRes.menuTitleColor.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  child: Widgets.setNetworkImg(
                      image: "https://funmauj.b-cdn.net/test/535647.jpg",
                      height: 60,
                      width: 60,
                      boxFit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(100),
                ),
                Widgets.getSizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextLabel(
                        text: "Gerrit Janssen",
                        style: TextStyle(
                            color: ColorsRes.mainTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      CustomTextLabel(
                        text: "Do you have any more potatoes?",
                        style: TextStyle(
                          color: ColorsRes.menuTitleColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CustomTextLabel(
                  text: "16:35",
                  style: TextStyle(
                    color: ColorsRes.menuTitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsetsDirectional.only(
              start: 10,
              end: 10,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.5,
                  color: ColorsRes.menuTitleColor.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  child: Widgets.setNetworkImg(
                      image: "https://funmauj.b-cdn.net/test/535647.jpg",
                      height: 60,
                      width: 60,
                      boxFit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(100),
                ),
                Widgets.getSizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextLabel(
                        text: "Gerrit Janssen",
                        style: TextStyle(
                            color: ColorsRes.mainTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      CustomTextLabel(
                        text: "Do you have any more potatoes?",
                        style: TextStyle(
                          color: ColorsRes.menuTitleColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CustomTextLabel(
                  text: "16:35",
                  style: TextStyle(
                    color: ColorsRes.menuTitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsetsDirectional.only(
              start: 10,
              end: 10,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.5,
                  color: ColorsRes.menuTitleColor.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  child: Widgets.setNetworkImg(
                      image: "https://funmauj.b-cdn.net/test/535647.jpg",
                      height: 60,
                      width: 60,
                      boxFit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(100),
                ),
                Widgets.getSizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextLabel(
                        text: "Gerrit Janssen",
                        style: TextStyle(
                            color: ColorsRes.mainTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      CustomTextLabel(
                        text: "Do you have any more potatoes?",
                        style: TextStyle(
                          color: ColorsRes.menuTitleColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CustomTextLabel(
                  text: "16:35",
                  style: TextStyle(
                    color: ColorsRes.menuTitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsetsDirectional.only(
              start: 10,
              end: 10,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.5,
                  color: ColorsRes.menuTitleColor.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  child: Widgets.setNetworkImg(
                      image: "https://funmauj.b-cdn.net/test/535647.jpg",
                      height: 60,
                      width: 60,
                      boxFit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(100),
                ),
                Widgets.getSizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextLabel(
                        text: "Gerrit Janssen",
                        style: TextStyle(
                            color: ColorsRes.mainTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      CustomTextLabel(
                        text: "Do you have any more potatoes?",
                        style: TextStyle(
                          color: ColorsRes.menuTitleColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CustomTextLabel(
                  text: "16:35",
                  style: TextStyle(
                    color: ColorsRes.menuTitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
