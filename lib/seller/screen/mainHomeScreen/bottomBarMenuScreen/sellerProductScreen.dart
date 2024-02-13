import 'package:lokale_mand/helper/generalWidgets/sellerProductGridItemContainer.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerProductListItem.dart';
import 'package:lokale_mand/seller/provider/sellerProductListProvider.dart';

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
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<SellerProductListProvider>().hasMoreData &&
            context.read<SellerProductListProvider>().sellerProductState !=
                SellerProductState.loadingMore) {
          callApi(isReset: true);
        }
      }
    }
  }

  callApi({required bool isReset}) async {
    try {
      if (isReset) {
        context.read<SellerProductListProvider>().offset = 0;

        context.read<SellerProductListProvider>().products = [];
      }

      Map<String, String> params = await Constant.getSellerProductsDefaultParams();

      params[ApiAndParams.sort] = ApiAndParams.productListSortTypes[
          context.read<SellerProductListProvider>().currentSortByOrderIndex ??
              1];

      await context
          .read<SellerProductListProvider>()
          .getSellerProductListProvider(context: context, params: params);
    } catch (e) {
      GeneralMethods.showMessage(context, e.toString(), MessageType.warning);
    }
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
          Navigator.pushNamed(context, sellerAddOrUpdateProductScreen)
              .then((value) {
            if (value != null && value == true) {
              callApi(isReset: false);
            }
          });
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
          showBackButton: false),
      body: Column(
        children: [
          getSearchWidget(
            context: context,
          ),
          Expanded(
            child: setRefreshIndicator(
              refreshCallback: () async {
                context.read<SellerProductListProvider>().offset = 0;
                context.read<SellerProductListProvider>().products = [];

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
    return Consumer<SellerProductListProvider>(
      builder: (context, sellerProductListProvider, _) {

        List<SellerProductListItem> products =
            sellerProductListProvider.products;
        if (sellerProductListProvider.sellerProductState ==
                ProductState.initial ||
            sellerProductListProvider.sellerProductState ==
                ProductState.loading) {
          return getProductListShimmer(
              context: context,
              isGrid: context
                  .read<ProductChangeListingTypeProvider>()
                  .getListingType());
        } else if (sellerProductListProvider.sellerProductState ==
                SellerProductState.loaded ||
            sellerProductListProvider.sellerProductState ==
                SellerProductState.loadingMore) {
          return Column(
            children: [
              GridView.builder(
                itemCount: products.length,
                padding: EdgeInsetsDirectional.only(
                    start: Constant.size10,
                    end: Constant.size10,
                    bottom: Constant.size10,
                    top: Constant.size5),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return SellerProductGridItemContainer(
                      product: products[index]);
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.8,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
              if (sellerProductListProvider.sellerProductState ==
                  SellerProductState.loadingMore)
                getProductItemShimmer(
                    context: context,
                    isGrid: context
                        .read<ProductChangeListingTypeProvider>()
                        .getListingType()),
            ],
          );
        } else if (sellerProductListProvider.sellerProductState ==
            SellerProductState.empty) {
          return DefaultBlankItemMessageScreen(
            title: "empty_product_list_message",
            description: "empty_product_list_description",
            image: "no_product_icon",
          );
        } else if (sellerProductListProvider.sellerProductState ==
            SellerProductState.loading) {
          return GridView.builder(
            itemCount: 10,
            padding: EdgeInsetsDirectional.only(
                start: Constant.size10,
                end: Constant.size10,
                bottom: Constant.size10,
                top: Constant.size5),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return CustomShimmer(
                borderRadius: 10,
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
        } else {
          return NoInternetConnectionScreen(
            height: MediaQuery.of(context).size.height * 0.65,
            message: sellerProductListProvider.message,
            callback: () {
              callApi(isReset: true);
            },
          );
        }
      },
    );
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
