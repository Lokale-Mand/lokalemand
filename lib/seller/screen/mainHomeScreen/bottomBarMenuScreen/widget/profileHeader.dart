import 'package:lokale_mand/helper/utils/generalImports.dart';

class SellerProfileHeader extends StatelessWidget {
  const SellerProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Constant.session.isUserLoggedIn()
              ? editProfileScreen
              : userTypeSelectionScreen,
          arguments: "header",
        );
      },
      child: Stack(
        children: [
          Row(children: [
            Container(
              child: CircleAvatar(
                backgroundColor: ColorsRes.menuTitleColor,
                radius: 42,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Constant.session.isUserLoggedIn()
                      ? Consumer<UserProfileProvider>(
                          builder: (context, value, child) {
                            return Widgets.setNetworkImg(
                              height: 80,
                              width: 80,
                              boxFit: BoxFit.fill,
                              image: Constant.session.getData(
                                SessionManager.keyUserImage,
                              ),
                            );
                          },
                        )
                      : Widgets.defaultImg(
                          height: 80,
                          width: 80,
                          image: "default_user",
                        ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 84,
                padding: EdgeInsetsDirectional.only(start: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Consumer<UserProfileProvider>(
                      builder: (context, userProfileProvide, _) =>
                          CustomTextLabel(
                        text: Constant.session.isUserLoggedIn()
                            ? userProfileProvide.getUserDetailBySessionKey(
                                isBool: false,
                                key: SessionManager.keyUserName,
                              )
                            : getTranslatedValue(
                                context,
                                "welcome",
                              ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                    ),
                    Widgets.getSizedBox(height: 5),
                    CustomTextLabel(
                      jsonKey: Constant.session.isUserLoggedIn()
                          ? Constant.session.getData(
                              SessionManager.keyPhone,
                            )
                          : "login",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorsRes.menuTitleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
