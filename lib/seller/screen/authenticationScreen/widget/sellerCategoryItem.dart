import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerCategory.dart';

class SellerCategoryItemContainer extends StatelessWidget {
  final CategoryData category;
  final VoidCallback voidCallBack;
  final bool isSelected;

  const SellerCategoryItemContainer(
      {Key? key,
      required this.category,
      required this.voidCallBack,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: voidCallBack,
      child: Container(
        decoration: DesignConfig.boxDecoration(
            Theme.of(context).scaffoldBackgroundColor, 8),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).width,
                      width: MediaQuery.sizeOf(context).height,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Widgets.setNetworkImg(
                          boxFit: BoxFit.cover,
                          image: category.imageUrl ?? "",
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: 4, end: 4),
                      child: CustomTextLabel(
                        text: category.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                )
              ],
            ),
            if (isSelected)
              PositionedDirectional(
                top: 0,
                start: 0,
                bottom: 0,
                end: 0,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  height: MediaQuery.sizeOf(context).width,
                  width: MediaQuery.sizeOf(context).height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorsRes.appColor.withOpacity(0.5),
                  ),
                  child: Icon(
                    Icons.check,
                    color: ColorsRes.appColorWhite,
                    size: 50,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
