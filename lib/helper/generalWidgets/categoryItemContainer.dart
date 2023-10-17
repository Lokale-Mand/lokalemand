import 'package:lokale_mand/helper/utils/generalImports.dart';

class CategoryItemContainer extends StatelessWidget {
  final CategoryItem category;
  final VoidCallback voidCallBack;

  const CategoryItemContainer(
      {Key? key, required this.category, required this.voidCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: voidCallBack,
      child: Container(
        decoration: DesignConfig.boxDecoration(
            Theme.of(context).scaffoldBackgroundColor, 8),
        child: Column(children: [
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
        ]),
      ),
    );
  }
}
