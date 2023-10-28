import 'package:lokale_mand/helper/utils/generalImports.dart';

class ProductWishListIcon extends StatelessWidget {
  final bool? isListing;
  final ProductListItem? product;

  const ProductWishListIcon({
    Key? key,
    this.isListing,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductAddOrRemoveFavoriteProvider>(
      builder: (providerContext, value, child) {
        return GestureDetector(
          onTap: () async {
            if (Constant.session.isUserLoggedIn()) {
              Map<String, String> params = {};
              params[ApiAndParams.productId] = product?.id.toString() ?? "0";

              await providerContext
                  .read<ProductAddOrRemoveFavoriteProvider>()
                  .getProductAddOrRemoveFavorite(
                      params: params,
                      context: context,
                      productId: int.parse(product?.id ?? "0"))
                  .then((value) {
                if (value) {
                  context
                      .read<ProductWishListProvider>()
                      .addRemoveFavoriteProduct(product);
                }
              });
            } else {
              Widgets.loginUserAccount(context, "wishlist");
            }
          },
          child: (providerContext
                          .read<ProductAddOrRemoveFavoriteProvider>()
                          .productAddRemoveFavoriteState ==
                      ProductAddRemoveFavoriteState.loading &&
                  providerContext
                          .read<ProductAddOrRemoveFavoriteProvider>()
                          .stateId ==
                      (int.parse(product?.id ?? "0")))
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: Widgets.getLoadingIndicator(),
                )
              : Container(
                  height: 50,
                  width: 50,
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).cardColor,
                    shape: DesignConfig.setRoundedBorder(100),
                    child: Icon(
                      (Constant.session.isUserLoggedIn() &&
                              providerContext
                                  .read<ProductAddOrRemoveFavoriteProvider>()
                                  .favoriteList
                                  .contains(
                                      int.parse(product?.id.toString() ?? "0")))
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: (Constant.session.isUserLoggedIn() &&
                              providerContext
                                  .read<ProductAddOrRemoveFavoriteProvider>()
                                  .favoriteList
                                  .contains(
                                      int.parse(product?.id.toString() ?? "0")))
                          ? ColorsRes.activeWishListColor
                          : ColorsRes.mainTextColor,
                    ),
                  ),
                ), /*Container(
                  height: 24,
                  width: 24,
                  child: Widgets.getDarkLightIcon(
                    iconColor: ColorsRes.appColor,
                      isActive: Constant.session.isUserLoggedIn()
                          ? providerContext
                              .read<ProductAddOrRemoveFavoriteProvider>()
                              .favoriteList
                              .contains(int.parse(product?.id.toString() ?? "0"))
                          : false,
                    image: "wishlist",
                  ),
                ),*/
        );
      },
    );
  }
}
