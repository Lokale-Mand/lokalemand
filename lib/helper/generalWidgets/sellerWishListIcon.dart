import 'package:lokale_mand/customer/provider/sellerWishListProvider.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class SellerWishListIcon extends StatelessWidget {
  final String sellerId;

  const SellerWishListIcon({
    Key? key,
    required this.sellerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SellerAddOrRemoveFavoriteProvider>(
      builder: (providerContext, value, child) {
        return GestureDetector(
          onTap: () async {
            if (Constant.session.isUserLoggedIn()) {
              Map<String, String> params = {};
              params[ApiAndParams.sellerId] = sellerId.toString();

              context
                  .read<SellerAddOrRemoveFavoriteProvider>()
                  .getSellerAddOrRemoveFavorite(
                      context: context, params: params, isAdd: true);
            } else {
              Widgets.loginUserAccount(context, "wishlist");
            }
          },
          child: (providerContext
                      .read<SellerAddOrRemoveFavoriteProvider>()
                      .sellerAddRemoveFavoriteState ==
                  SellerAddRemoveFavoriteState.loading)
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
                                  .read<SellerAddOrRemoveFavoriteProvider>()
                                  .favoriteList
                                  .contains(int.parse(sellerId.toString())))
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: (Constant.session.isUserLoggedIn() &&
                              providerContext
                                  .read<SellerAddOrRemoveFavoriteProvider>()
                                  .favoriteList
                                  .contains(int.parse(sellerId.toString())))
                          ? ColorsRes.activeWishListColor
                          : ColorsRes.mainTextColor,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
