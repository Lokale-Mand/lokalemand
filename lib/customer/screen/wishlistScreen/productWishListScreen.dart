import 'package:lokale_mand/helper/utils/generalImports.dart';

class ProductWishListScreen extends StatefulWidget {
  const ProductWishListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductWishListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductWishListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<ProductWishListProvider>().hasMoreData) {
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
      //fetch productList from api
      scrollController.addListener(scrollListener);

      callApi(isReset: true);
    });
  }

  callApi({required isReset}) async {
    if (Constant.session.isUserLoggedIn()) {
      if (isReset) {
        context.read<ProductWishListProvider>().offset = 0;
        context.read<ProductWishListProvider>().wishlistProducts = [];
      }
      Map<String, String> params = await Constant.getProductsDefaultParams();

      await context
          .read<ProductWishListProvider>()
          .getProductWishListProvider(context: context, params: params);
    } else {
      setState(() {
        context.read<ProductWishListProvider>().productWishListState =
            ProductWishListState.error;
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
          child: productWidget(),
        ),
      ),
    );
  }

  productWidget() {
    return Consumer<ProductWishListProvider>(
      builder: (context, productWishlistProvider, _) {
        List<ProductListItem> wishlistProducts =
            productWishlistProvider.wishlistProducts;
        if (productWishlistProvider.productWishListState ==
            ProductWishListState.initial) {
          return getProductListShimmer(
              context: context,
              isGrid: context
                  .read<ProductChangeListingTypeProvider>()
                  .getListingType());
        } else if (productWishlistProvider.productWishListState ==
            ProductWishListState.loading) {
          return getProductListShimmer(
              context: context,
              isGrid: context
                  .read<ProductChangeListingTypeProvider>()
                  .getListingType());
        } else if (productWishlistProvider.productWishListState ==
                ProductWishListState.loaded ||
            productWishlistProvider.productWishListState ==
                ProductWishListState.loadingMore) {
          return Column(
            children: [
              GridView.builder(
                itemCount: wishlistProducts.length,
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.size10, vertical: Constant.size10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ProductGridItemContainer(
                    product: wishlistProducts[index],
                    sellerId: '',
                    storeLogo: '',
                    storeName: '',
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.8,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
              if (productWishlistProvider.productWishListState ==
                  ProductWishListState.loadingMore)
                getProductItemShimmer(
                    context: context,
                    isGrid: context
                        .read<ProductChangeListingTypeProvider>()
                        .getListingType()),
            ],
          );
        } else {
          return DefaultBlankItemMessageScreen(
            height: MediaQuery.sizeOf(context).height * 0.65,
            title: "empty_wish_list_message",
            description: "empty_wish_list_description",
            image: "no_wishlist_icon",
          );
        }
      },
    );
  }
}
