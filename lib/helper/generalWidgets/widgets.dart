import 'package:lokale_mand/helper/utils/generalImports.dart';

class Widgets {
  static Widget gradientBtnWidget(BuildContext context, double borderRadius,
      {required Function callback,
      String title = "",
      Widget? otherWidgets,
      double? height,
      Color? color1,
      Color? color2}) {
    return GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
        height: height ?? 65,
        alignment: Alignment.center,
        decoration: DesignConfig.boxGradient(
          borderRadius,
          color1: color1,
          color2: color2,
        ),
        child: otherWidgets ??= CustomTextLabel(
          text: title,
          softWrap: true,
          style: Theme.of(context).textTheme.titleMedium!.merge(TextStyle(
              color: ColorsRes.mainIconColor,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  static Widget defaultImg(
      {double? height,
      double? width,
      required String image,
      Color? iconColor,
      BoxFit? boxFit,
      EdgeInsetsDirectional? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: iconColor != null
          ? SvgPicture.asset(
              Constant.getAssetsPath(1, image),
              width: width,
              height: height,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              fit: boxFit ?? BoxFit.contain,
              matchTextDirection: true,
            )
          : SvgPicture.asset(
              Constant.getAssetsPath(1, image),
              width: width,
              height: height,
              fit: boxFit ?? BoxFit.contain,
              matchTextDirection: true,
            ),
    );
  }

  static Widget getDarkLightIcon({
    double? height,
    double? width,
    required String image,
    Color? iconColor,
    BoxFit? boxFit,
    EdgeInsetsDirectional? padding,
    bool? isActive,
  }) {
    String active = (isActive ??= false) == true ? "_active" : "";

    String dark =
        (Constant.session.getBoolData(SessionManager.isDarkTheme)) == true
            ? "_dark"
            : "";

    return defaultImg(
        height: height,
        width: width,
        image: "${image}${active}${dark}_icon",
        iconColor: iconColor,
        boxFit: boxFit,
        padding: padding);
  }

  static List getHomeBottomNavigationBarIcons({required bool isActive}) {
    if (Constant.session.getBoolData(SessionManager.isSeller)) {
      return [
        Icon(Icons.map_rounded),
        Icon(Icons.table_rows_outlined),
        Icon(Icons.chat_bubble_outline_rounded),
        Icon(Icons.storefront_sharp),
        Icon(Icons.person_outline),
      ];
    } else {
      return [
        Icon(Icons.map_rounded),
        Icon(Icons.chat_bubble_outline_rounded),
        Icon(Icons.person_outline),
      ];
    }
  }

  static Widget setNetworkImg({
    double? height,
    double? width,
    String image = "placeholder",
    Color? iconColor,
    BoxFit? boxFit,
  }) {
    return image.trim().isEmpty
        ? defaultImg(
            image: "placeholder",
            height: height,
            width: width,
            boxFit: boxFit,
          )
        : FadeInImage.assetNetwork(
            image: image,
            width: width,
            height: height,
            fit: boxFit,
            placeholderFit: BoxFit.cover,
            placeholder: Constant.getAssetsPath(
              0,
              "placeholder.png",
            ),
            imageErrorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              return defaultImg(
                  image: "placeholder",
                  width: width,
                  height: height,
                  boxFit: boxFit);
            },
          );
  }

  static Widget setLocalAssetsImage({
    double? height,
    double? width,
    String image = "placeholder.png",
    BoxFit? boxFit,
  }) {
    return Image.asset(
      Constant.getAssetsPath(0, image),
      fit: boxFit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          Constant.getAssetsPath(
            0,
            "placeholder.png",
          ),
        );
      },
    );
  }

  static openBottomSheetDialog(
      BuildContext context, String title, var sheetWidget) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.all(20),
                  child: Center(
                    child: CustomTextLabel(
                      text: title,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.merge(
                            TextStyle(
                              letterSpacing: 0.5,
                              color: ColorsRes.mainTextColor,
                            ),
                          ),
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.only(
                        start: 20, end: 8, bottom: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: sheetWidget(context),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static themeDialog(BuildContext context) async {
    return openBottomSheetDialog(
        context,
        getTranslatedValue(
          context,
          "change_theme",
        ),
        Widgets.themeListView);
  }

  static textFieldWidget(
      TextEditingController edtcontrl,
      Function? validatorfunc,
      String lbl,
      TextInputType txttype,
      String errmsg,
      BuildContext context,
      {bool ishidetext = false,
      Function? tapCallback,
      Widget? ticon,
      Widget? sicon,
      bool iseditable = true,
      int? minlines,
      int? maxlines,
      FocusNode? currfocus,
      FocusNode? nextfocus,
      BoxConstraints? prefixIconConstaint,
      Color? bgcolor,
      String? hint,
      double borderRadius = 0,
      bool floatingLbl = true,
      EdgeInsetsGeometry? contentPadding}) {
    return TextFormField(
      enabled: iseditable,
      obscureText: ishidetext,
      style: Theme.of(context).textTheme.titleMedium!.merge(TextStyle(
          color:
              iseditable == true ? ColorsRes.mainTextColor : ColorsRes.grey)),
      textAlign: TextAlign.start,
      minLines: minlines ?? 1,
      maxLines: maxlines,
      focusNode: currfocus,
      onFieldSubmitted: (term) {
        if (currfocus != null) {
          currfocus.unfocus();
        }
        if (nextfocus != null) {
          FocusScope.of(context).requestFocus(nextfocus);
        }
      },
      controller: edtcontrl,
      keyboardType: txttype,
      validator: (val) => validatorfunc!(val, errmsg),
      decoration: InputDecoration(
        errorStyle: TextStyle(color: ColorsRes.appColorRed),
        hintText: hint,
        suffixIcon: ticon,
        prefixIcon: sicon,
        prefixIconConstraints: prefixIconConstaint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: contentPadding,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        fillColor: bgcolor,
        filled: bgcolor == null ? false : true,
      ),
      onTap: tapCallback == null ? null : tapCallback(),
    );
  }

  static themeListView(BuildContext context) {
    List lblThemeDisplayNames = [
      "theme_display_names_system_default",
      "theme_display_names_light",
      "theme_display_names_dark",
    ];

    return List.generate(Constant.themeList.length, (index) {
      String themeDisplayName = lblThemeDisplayNames[index];
      String themeName = Constant.themeList[index];

      return ListTile(
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        onTap: () {
          Navigator.pop(context);
          if (Constant.session.getData(SessionManager.appThemeName) !=
              themeName) {
            Constant.session
                .setData(SessionManager.appThemeName, themeName, true);

            Constant.session.setBoolData(
                SessionManager.isDarkTheme,
                index == 0
                    ? PlatformDispatcher.instance.platformBrightness ==
                        Brightness.dark
                    : index == 1
                        ? false
                        : true,
                true);
          }
        },
        leading: Icon(
          Constant.session.getData(SessionManager.appThemeName) == themeName
              ? Icons.radio_button_checked
              : Icons.radio_button_off,
          color: ColorsRes.appColor,
        ),
        title: CustomTextLabel(
          jsonKey: themeDisplayName,
          softWrap: true,
        ),
      );
    });
  }

  static getSizedBox({double? height, double? width}) {
    return SizedBox(height: height ?? 0, width: width ?? 0);
  }

  static getProductVariantDropdownBorderBoxDecoration() {
    return BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border(
            bottom:
                BorderSide(color: ColorsRes.subTitleMainTextColor, width: 0.5),
            top: BorderSide(color: ColorsRes.subTitleMainTextColor, width: 0.5),
            right:
                BorderSide(color: ColorsRes.subTitleMainTextColor, width: 0.5),
            left: BorderSide(
                color: ColorsRes.subTitleMainTextColor, width: 0.5)));
  }

  static getProductListingCartIconButton(
      {required BuildContext context, required int count}) {
    return Widgets.gradientBtnWidget(
      context,
      5,
      callback: () {},
      otherWidgets: Widgets.defaultImg(
        image: "cart_icon",
        width: 20,
        height: 20,
        padding: const EdgeInsetsDirectional.all(5),
        iconColor: ColorsRes.mainIconColor,
      ),
    );
  }

  static Widget getLoadingIndicator() {
    return CircularProgressIndicator(
      backgroundColor: Colors.transparent,
      color: ColorsRes.appColor,
      strokeWidth: 2,
    );
  }

  static void loginUserAccount(BuildContext buildContext, String from) {
    showDialog<String>(
      context: buildContext,
      builder: (BuildContext context) => AlertDialog(
        content: CustomTextLabel(
          jsonKey: from == "cart"
              ? "required_login_message_for_cart"
              : "required_login_message_for_wish_list",
          softWrap: true,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomTextLabel(
              jsonKey: "cancel",
              softWrap: true,
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pushNamed(context, userTypeSelectionScreen,
                  arguments: "add_to_cart");
            },
            child: CustomTextLabel(
              jsonKey: "ok",
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class CustomShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;

  const CustomShimmer(
      {Key? key, this.height, this.width, this.borderRadius, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: true,
      baseColor: ColorsRes.shimmerBaseColor,
      highlightColor: ColorsRes.shimmerHighlightColor,
      child: Container(
        width: width,
        margin: margin ?? EdgeInsets.zero,
        height: height ?? 10,
        decoration: BoxDecoration(
            color: ColorsRes.shimmerContentColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 10)),
      ),
    );
  }
}

// CategorySimmer
Widget getCategoryShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ??
        EdgeInsets.symmetric(
          horizontal: Constant.size10,
          vertical: Constant.size10,
        ),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        borderRadius: 8,
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      childAspectRatio: 0.8,
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
  );
}

// BrandSimmer
Widget getBrandShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ??
        EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size10),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        borderRadius: 8,
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
  );
}

AppBar getAppBar(
    {required BuildContext context,
    Widget? appBarLeading,
    bool? centerTitle,
    required Widget title,
    List<Widget>? actions,
    Color? backgroundColor,
    bool? showBackButton,
    GestureTapCallback? onTap}) {
  return AppBar(
    leading: showBackButton ?? true
        ? GestureDetector(
            onTap: onTap ??
                () {
                  Navigator.pop(context);
                },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  child: Widgets.defaultImg(
                    image: "ic_arrow_back",
                    iconColor: ColorsRes.mainTextColor,
                  ),
                ),
              ),
            ),
          )
        : null,
    automaticallyImplyLeading: true,
    elevation: 0,
    title: title,
    centerTitle: centerTitle ?? true,
    surfaceTintColor: Colors.transparent,
    backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
    actions: actions ?? [],
  );
}

class ScrollGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());
  }
}

Widget getProductListShimmer(
    {required BuildContext context, required bool isGrid}) {
  return isGrid
      ? GridView.builder(
          itemCount: 6,
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size10, vertical: Constant.size10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return const CustomShimmer(
              width: double.maxFinite,
              height: double.maxFinite,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        )
      : Column(
          children: List.generate(20, (index) {
            return const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
              child: CustomShimmer(
                width: double.maxFinite,
                height: 125,
              ),
            );
          }),
        );
}

Widget getProductItemShimmer(
    {required BuildContext context, required bool isGrid}) {
  return isGrid
      ? GridView.builder(
          itemCount: 2,
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size10, vertical: Constant.size10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return const CustomShimmer(
              width: double.maxFinite,
              height: double.maxFinite,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        )
      : const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
          child: CustomShimmer(
            width: double.maxFinite,
            height: 125,
          ),
        );
}

//Search widgets for the multiple screen
Widget getSearchWidget({
  required BuildContext context,
  VoidCallback? trailingCallBack,
  VoidCallback? leadingCallBack,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, productSearchScreen);
    },
    child: Container(
      height: 55,
      margin: EdgeInsetsDirectional.all(10),
      decoration: DesignConfig.boxDecoration(
        Theme.of(context).scaffoldBackgroundColor,
        bordercolor: ColorsRes.menuTitleColor,
        borderwidth: 2,
        isboarder: true,
        15,
      ),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.search,
              color: ColorsRes.mainTextColor,
              size: 30,
            ),
            onPressed: leadingCallBack ?? null,
          ),
          CustomTextLabel(
            jsonKey: context
                .read<LanguageProvider>()
                .currentLanguage["product_search_hint"],
            style: TextStyle(color: ColorsRes.menuTitleColor),
          ),
          Spacer(),
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.filter_list_rounded,
              color: ColorsRes.mainTextColor,
              size: 30,
            ),
            onPressed: trailingCallBack ?? null,
          ),
        ],
      ),
    ),
  );
}

setRefreshIndicator(
    {required RefreshCallback refreshCallback, required Widget child}) {
  return RefreshIndicator(onRefresh: refreshCallback, child: child);
}

setCartCounter({required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      // GeneralMethods.showMessage(context, "text", MessageType.warning);
      if (Constant.session.isUserLoggedIn()) {
        Navigator.pushNamed(context, cartScreen);
      } else {
        Widgets.loginUserAccount(context, "cart");
      }
    },
    child: Container(
      margin: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Widgets.defaultImg(
              height: 24,
              width: 24,
              iconColor: ColorsRes.appColor,
              image: "cart_icon"),
          Consumer<CartListProvider>(
              builder: (context, cartListProvider, child) {
            return context.read<CartListProvider>().cartList.isNotEmpty
                ? PositionedDirectional(
                    end: 0,
                    top: 0,
                    child: SizedBox(
                      height: 12,
                      width: 12,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: ColorsRes.appColor,
                        child: CustomTextLabel(
                          text: context
                              .read<CartListProvider>()
                              .cartList
                              .length
                              .toString(),
                          softWrap: true,
                          style: TextStyle(
                            color: ColorsRes.mainIconColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    ),
  );
}

getOutOfStockWidget(
    {required double height,
    required double width,
    double? textSize,
    required BuildContext context}) {
  return Container(
    alignment: AlignmentDirectional.center,
    decoration: BoxDecoration(
      borderRadius: Constant.borderRadius10,
      color: Colors.black.withOpacity(0.3),
    ),
    child: FittedBox(
      fit: BoxFit.none,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: Constant.borderRadius5,
          color: Colors.black,
        ),
        child: CustomTextLabel(
          jsonKey: "out_of_stock",
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: textSize ?? 18,
              fontWeight: FontWeight.w400,
              color: ColorsRes.appColorRed),
        ),
      ),
    ),
  );
}
