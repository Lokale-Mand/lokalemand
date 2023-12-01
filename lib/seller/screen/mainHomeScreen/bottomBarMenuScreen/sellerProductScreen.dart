import 'package:lokale_mand/helper/utils/generalImports.dart';

class SellerProductScreen extends StatefulWidget {
  const SellerProductScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SellerProductScreen> createState() => _SellerProductScreenState();
}

class _SellerProductScreenState extends State<SellerProductScreen> {
  bool isFilterApplied = false;
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
//     if (scrollController.position.pixels > nextPageTrigger) {
//       if (mounted) {
//         if (context.read<ProductListProvider>().hasMoreData &&
//             context.read<ProductListProvider>().productState !=
//                 ProductState.loadingMore) {
//           callApi(isReset: false);
//         }
//       }
//     }
  }

  callApi({required bool isReset}) async {
    // try {
    //   if (isReset) {
    //     context.read<ProductListProvider>().offset = 0;
    //
    //     context.read<ProductListProvider>().products = [];
    //   }
    //
    //   Map<String, String> params = await Constant.getProductsDefaultParams();
    //
    //   params[ApiAndParams.sort] = ApiAndParams.productListSortTypes[
    //       context.read<ProductListProvider>().currentSortByOrderIndex];
    //
    //   await context
    //       .read<ProductListProvider>()
    //       .getProductListProvider(context: context, params: params);
    // } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    //fetch productList from api
    Future.delayed(Duration.zero).then((value) async {
      scrollController.addListener(scrollListener);
      callApi(isReset: true);
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    Constant.resetTempFilters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List lblSortingDisplayList = [
      "sorting_display_list_default",
      "sorting_display_list_newest_first",
      "sorting_display_list_oldest_first",
      "sorting_display_list_price_high_to_low",
      "sorting_display_list_price_low_to_high",
      "sorting_display_list_discount_high_to_low",
      "sorting_display_list_popularity"
    ];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(side: BorderSide.none),
        onPressed: () {
          Navigator.pushNamed(context, sellerAddOrUpdateProductScreen);
        },
        isExtended: true,
        child: Icon(
          Icons.add,
          color: ColorsRes.appColorWhite,
          size: 35,
        ),
      ),
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          text: getTranslatedValue(
            context,
            "products",
          ),
          softWrap: true,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ColorsRes.mainTextColor,
          ),
        ),
        actions: [
          // setCartCounter(context: context),
        ],
      ),
      body: Column(
        children: [
          getSearchWidget(
            context: context,
          ),
          Expanded(
            child: setRefreshIndicator(
              refreshCallback: () async {
                // context.read<ProductListProvider>().offset = 0;
                // context.read<ProductListProvider>().products = [];

                callApi(isReset: true);
              },
              child: SingleChildScrollView(
                controller: scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                child: productWidget(),
              ),
            ),
          )
        ],
      ),
    );
  }

  productWidget() {
    // return Consumer<ProductListProvider>(
    //   builder: (context, productListProvider, _) {
    //     List<ProductListItem> products = productListProvider.products;
    //     if (productListProvider.productState == ProductState.initial ||
    //         productListProvider.productState == ProductState.loading) {
    //       return getProductListShimmer(
    //           context: context,
    //           isGrid: context
    //               .read<ProductChangeListingTypeProvider>()
    //               .getListingType());
    //     } else if (productListProvider.productState == ProductState.loaded ||
    //         productListProvider.productState == ProductState.loadingMore) {
    //       return Column(
    //         children: [
    //           context
    //                       .read<ProductChangeListingTypeProvider>()
    //                       .getListingType() ==
    //                   true
    //               ? /* GRID VIEW UI */ GridView.builder(
    //                   itemCount: products.length,
    //                   padding: EdgeInsetsDirectional.only(
    //                       start: Constant.size10,
    //                       end: Constant.size10,
    //                       bottom: Constant.size10,
    //                       top: Constant.size5),
    //                   shrinkWrap: true,
    //                   physics: const NeverScrollableScrollPhysics(),
    //                   itemBuilder: (BuildContext context, int index) {
    //                     return ProductGridItemContainer(
    //                         product: products[index]);
    //                   },
    //                   gridDelegate:
    //                       const SliverGridDelegateWithFixedCrossAxisCount(
    //                     childAspectRatio: 1,
    //                     crossAxisCount: 2,
    //                     crossAxisSpacing: 10,
    //                     mainAxisSpacing: 10,
    //                   ),
    //                 )
    //               : /* LIST VIEW UI */ Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: List.generate(products.length, (index) {
    //                     return ProductListItemContainer(
    //                         product: products[index]);
    //                   }),
    //                 ),
    //           if (productListProvider.productState == ProductState.loadingMore)
    //             getProductItemShimmer(
    //                 context: context,
    //                 isGrid: context
    //                     .read<ProductChangeListingTypeProvider>()
    //                     .getListingType()),
    //         ],
    //       );
    //     } else if (productListProvider.productState == ProductState.empty) {
    //       return DefaultBlankItemMessageScreen(
    //         title: "empty_product_list_message",
    //         description: "empty_product_list_description",
    //         image: "no_product_icon",
    //       );
    //     } else {
    //       return NoInternetConnectionScreen(
    //         height: MediaQuery.of(context).size.height * 0.65,
    //         message: productListProvider.message,
    //         callback: () {
    //           callApi(isReset: false);
    //         },
    //       );
    //     }
    //   },
    // );
    return Container();
  }

  Future<Map<String, String>> setFilterParams(
      Map<String, String> params) async {
    params[ApiAndParams.maxPrice] = Constant.currentRangeValues.end.toString();
    params[ApiAndParams.minPrice] =
        Constant.currentRangeValues.start.toString();
    params[ApiAndParams.brandIds] =
        getFiltersItemsList(Constant.selectedBrands.toSet().toList());

    List<String> sizes = await getSizeListSizesAndIds(Constant.selectedSizes)
        .then((value) => value[0]);
    List<String> unitIds = await getSizeListSizesAndIds(Constant.selectedSizes)
        .then((value) => value[1]);

    params[ApiAndParams.sizes] = getFiltersItemsList(sizes);
    params[ApiAndParams.unitIds] = getFiltersItemsList(unitIds);

    return params;
  }

  Future<List<List<String>>> getSizeListSizesAndIds(List sizeList) async {
    List<String> sizes = [];
    List<String> unitIds = [];

    for (int i = 0; i < sizeList.length; i++) {
      if (i % 2 == 0) {
        sizes.add(sizeList[i].toString().split("-")[0]);
      } else {
        unitIds.add(sizeList[i].toString().split("-")[1]);
      }
    }
    return [sizes, unitIds];
  }

  String getFiltersItemsList(List<String> param) {
    String ids = "";
    for (int i = 0; i < param.length; i++) {
      ids += "${param[i]}${i == (param.length - 1) ? "" : ","}";
    }
    return ids;
  }
}
