import 'package:lokale_mand/helper/utils/generalImports.dart';

class ProductGridItemContainer extends StatefulWidget {
  final ProductListItem product;
  final String sellerId;
  final String storeLogo;
  final String storeName;

  const ProductGridItemContainer(
      {Key? key,
      required this.product,
      required this.sellerId,
      required this.storeLogo,
      required this.storeName})
      : super(key: key);

  @override
  State<ProductGridItemContainer> createState() => _State();
}

class _State extends State<ProductGridItemContainer> {
  late BuildContext context1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context1 = context;
    ProductListItem product = widget.product;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          productDetailScreen,
          arguments: [
            product.id.toString(),
            product.name,
            product,
            widget.sellerId,
            widget.storeName,
            widget.storeLogo,
          ],
        );
      },
      child: ChangeNotifierProvider<SelectedVariantItemProvider>(
        create: (context) => SelectedVariantItemProvider(),
        child: product.variants!.length > 0
            ? Container(
                padding: EdgeInsetsDirectional.all(5),
                decoration: DesignConfig.boxDecoration(
                  Theme.of(context).scaffoldBackgroundColor,
                  bordercolor: const Color(0xffe3e0e0),
                  borderwidth: 2,
                  isboarder: true,
                  10,
                ),
                child: Container(
                  decoration: DesignConfig.boxDecoration(
                    Colors.transparent,
                    10,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(10),
                                topEnd: Radius.circular(10),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Widgets.setNetworkImg(
                                boxFit: BoxFit.fill,
                                image: product.imageUrl.toString(),
                                height: double.maxFinite,
                                width: double.maxFinite,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Widgets.getSizedBox(height: 5),
                                Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: Constant.size5),
                                  child: CustomTextLabel(
                                    text: product.name.toString(),
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                                ),
                                if (product.variants!.isNotEmpty)
                                  Expanded(
                                    child: ProductVariantDropDownMenuGrid(
                                      from: "",
                                      product: product,
                                      variants: product.variants,
                                      isGrid: true,
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                      // PositionedDirectional(
                      //   end: 5,
                      //   top: 5,
                      //   child: ProductWishListIcon(
                      //     product: product,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
