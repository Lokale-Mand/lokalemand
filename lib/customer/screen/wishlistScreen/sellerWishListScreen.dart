import 'package:lokale_mand/customer/models/sellerWishList.dart';
import 'package:lokale_mand/customer/provider/sellerWishListProvider.dart';
import 'package:lokale_mand/helper/generalWidgets/ratingBuilderWidget.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class SellerWishListScreen extends StatefulWidget {
  const SellerWishListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SellerWishListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<SellerWishListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<SellerWishListProvider>().hasMoreData) {
          callApi(isReset: false);
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    Constant.resetTempFilters();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) async {
      //fetch sellerList from api
      scrollController.addListener(scrollListener);

      callApi(isReset: true);
    });
  }

  callApi({required isReset}) async {
    if (Constant.session.isUserLoggedIn()) {
      if (isReset) {
        context.read<SellerWishListProvider>().offset = 0;
        context.read<SellerWishListProvider>().wishlistSellers = [];
      }
      Map<String, String> params = await Constant.getProductsDefaultParams();

      await context
          .read<SellerWishListProvider>()
          .getSellerWishListProvider(context: context, params: params);
    } else {
      setState(() {
        context.read<SellerWishListProvider>().sellerWishListState =
            SellerWishListState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: setRefreshIndicator(
        refreshCallback: () async {
          callApi(isReset: true);
        },
        child: SingleChildScrollView(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          child: sellerWidget(),
        ),
      ),
    );
  }

  sellerWidget() {
    return Consumer<SellerWishListProvider>(
      builder: (context, sellerWishlistProvider, _) {
        List<SellerWishListData> wishlistSellers =
            sellerWishlistProvider.wishlistSellers;
        if (sellerWishlistProvider.sellerWishListState ==
            SellerWishListState.initial) {
          return getProductListShimmer(context: context, isGrid: false);
        } else if (sellerWishlistProvider.sellerWishListState ==
            SellerWishListState.loading) {
          return getProductListShimmer(context: context, isGrid: false);
        } else if (sellerWishlistProvider.sellerWishListState ==
                SellerWishListState.loaded ||
            sellerWishlistProvider.sellerWishListState ==
                SellerWishListState.loadingMore) {
          return Column(
            children: List.generate(wishlistSellers.length, (index) {
              SellerWishListData seller =
                  sellerWishlistProvider.wishlistSellers[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    productListScreen,
                    arguments: [
                      "seller",
                      seller.id.toString(),
                      getTranslatedValue(context, "seller"),
                      seller.seller?.categories.toString(),
                      seller.seller?.storeName.toString(),
                      seller.seller?.logoUrl.toString()
                    ],
                  );
                },
                child: Container(
                  margin: EdgeInsetsDirectional.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Row(
                    children: [
                      Widgets.getSizedBox(width: 10),
                      ClipRRect(
                        child: Widgets.setNetworkImg(
                            image: seller.seller?.logoUrl.toString() ?? "",
                            height: 80,
                            width: 80,
                            boxFit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextLabel(
                                text: seller.seller?.name,
                                softWrap: true,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: ColorsRes.mainTextColor),
                              ),
                              CustomTextLabel(
                                overflow: TextOverflow.ellipsis,
                                jsonKey: seller.seller?.type == "2"
                                    ? "organic_seller"
                                    : "regular_seller",
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColorsRes.appColorGreen,
                                ),
                              ),
                              CustomTextLabel(
                                text: "${seller.distance.toString()} ${getTranslatedValue(context, "km_away")}",
                                softWrap: true,
                                style: TextStyle(
                                  color: ColorsRes.subTitleMainTextColor,
                                  fontSize: 12,
                                ),
                              ),
                              RatingBuilderWidget(
                                averageRating: double.parse(seller.averageRating.toString()),
                                totalRatings: int.parse(seller.ratingCount.toString()),
                                size: 20,
                                spacing: 0,
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      productListScreen,
                                      arguments: [
                                        "seller",
                                        seller.id.toString(),
                                        getTranslatedValue(context, "seller"),
                                        seller.seller?.categories.toString(),
                                        seller.seller?.storeName.toString(),
                                        seller.seller?.logoUrl.toString()
                                      ],
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      CustomTextLabel(
                                        jsonKey: "view",
                                        style: TextStyle(
                                            color: ColorsRes.appColor,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationThickness: 2,
                                            decorationColor:
                                                ColorsRes.appColor),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              // Row(
                              //   children: [
                              //     CustomTextLabel(
                              //       text: "4.5",
                              //       softWrap: true,
                              //       style: TextStyle(
                              //         color: ColorsRes
                              //             .subTitleMainTextColor,
                              //         fontSize: 12,
                              //       ),
                              //     ),
                              //     Widgets.getSizedBox(
                              //       width: 5,
                              //     ),
                              //     RatingBarIndicator(
                              //       rating: 4.5,
                              //       itemCount: 5,
                              //       itemSize: 20.0,
                              //       physics: BouncingScrollPhysics(),
                              //       itemBuilder: (context, _) => Icon(
                              //         Icons.star,
                              //         color: Colors.amber,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        } else {
          return DefaultBlankItemMessageScreen(
            height: MediaQuery.sizeOf(context).height * 0.65,
            title: "empty_seller_wish_list_message",
            description: "empty_seller_wish_list_description",
            image: "no_wishlist_icon",
          );
        }
      },
    );
  }
}
