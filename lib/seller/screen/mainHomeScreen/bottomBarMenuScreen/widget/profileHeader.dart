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
                radius: 25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Constant.session.isUserLoggedIn()
                      ? Consumer<UserProfileProvider>(
                          builder: (context, value, child) {
                            return Widgets.setNetworkImg(
                              height: 48,
                              width: 48,
                              boxFit: BoxFit.fill,
                              image: Constant.session.getData(
                                SessionManager.keyUserImage,
                              ),
                            );
                          },
                        )
                      : Widgets.defaultImg(
                          height: 48,
                          width: 48,
                          image: "default_user",
                        ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsetsDirectional.only(start: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
              /*ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Consumer<UserProfileProvider>(
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
                    ),
                  ),
                  subtitle: CustomTextLabel(
                    jsonKey: Constant.session.isUserLoggedIn()
                        ? Constant.session.getData(
                            SessionManager.keyPhone,
                          )
                        : "login",
                    style: Theme.of(context).textTheme.bodySmall!.apply(
                          color: ColorsRes.appColor,
                        ),
                  ),
                )*/
            ),
          ]),
          // Align(
          //   alignment: AlignmentDirectional.topEnd,
          //   child: Container(
          //     decoration: DesignConfig.boxGradient(5),
          //     padding: const EdgeInsets.all(5),
          //     margin: const EdgeInsetsDirectional.only(
          //       end: 8,
          //       top: 8,
          //     ),
          //     child: Widgets.defaultImg(
          //       image: "edit_icon",
          //       iconColor: ColorsRes.mainIconColor,
          //       height: 20,
          //       width: 20,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
