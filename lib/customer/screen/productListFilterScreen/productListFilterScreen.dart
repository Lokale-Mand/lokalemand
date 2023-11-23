import 'package:lokale_mand/helper/utils/generalImports.dart';

class ProductListFilterScreen extends StatefulWidget {
  final List<Brands> brands;
  final List<Sizes> sizes;
  final double maxPrice;
  final double minPrice;

  const ProductListFilterScreen({
    Key? key,
    required this.brands,
    required this.sizes,
    required this.maxPrice,
    required this.minPrice,
  }) : super(key: key);

  @override
  State<ProductListFilterScreen> createState() =>
      _ProductListFilterScreenState();
}

class _ProductListFilterScreenState extends State<ProductListFilterScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      await setTempValues().then((value) => context
          .read<ProductFilterProvider>()
          .currentRangeValues = RangeValues(widget.minPrice, widget.maxPrice));
      context.read<ProductFilterProvider>().setCurrentIndex(0);
      context
          .read<ProductFilterProvider>()
          .setMinMaxPriceRange(widget.minPrice, widget.maxPrice);
    });
  }

  Future<bool> setTempValues() async {
    context.read<ProductFilterProvider>().currentRangeValues =
        Constant.currentRangeValues;
    context.read<ProductFilterProvider>().selectedBrands =
        Constant.selectedBrands;
    context.read<ProductFilterProvider>().selectedSizes =
        Constant.selectedSizes;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List lblFilterTypesList = [
      "filter_types_list_brand",
      "filter_types_list_pack_size",
      "filter_types_list_price",
    ];
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: "filter",
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: PopScope(
        onPopInvoked: (didPop) {
          Navigator.pop(context, false);
        },
        child: Stack(
          children: [
            //Filter list screen
            PositionedDirectional(
              top: 10,
              bottom: 10,
              start: 10,
              end: (MediaQuery.sizeOf(context).width * 0.6) - 10,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children:
                          List.generate(lblFilterTypesList.length, (index) {
                        return (index == 2 &&
                                widget.minPrice == widget.maxPrice)
                            ? const SizedBox.shrink()
                            : ListTile(
                                onTap: () {
                                  context
                                      .read<ProductFilterProvider>()
                                      .setCurrentIndex(index);
                                },
                                selected: context
                                        .watch<ProductFilterProvider>()
                                        .currentSelectedFilterIndex ==
                                    index,
                                selectedTileColor: Theme.of(context).cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(10),
                                    bottomStart: Radius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                                title: CustomTextLabel(
                                  jsonKey: lblFilterTypesList[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                ),
                                splashColor: ColorsRes.appColorLight,
                              );
                      }),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<ProductFilterProvider>().resetAllFilters();
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsetsDirectional.only(end: 10, bottom: 32),
                      child: CustomTextLabel(
                        jsonKey: "clean_all",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: ColorsRes.mainTextColor,
                              fontSize: 15,
                            ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            //Filter list's values screen
            PositionedDirectional(
              top: 0,
              bottom: 0,
              start: MediaQuery.sizeOf(context).width * 0.4,
              end: 0,
              child: Container(
                decoration:
                    DesignConfig.boxDecoration(Theme.of(context).cardColor, 8),
                margin: EdgeInsetsDirectional.only(
                    start: 5, top: 10, bottom: 10, end: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: context
                                  .watch<ProductFilterProvider>()
                                  .currentSelectedFilterIndex ==
                              0
                          ? getBrandWidget(widget.brands, context)
                          : context
                                      .watch<ProductFilterProvider>()
                                      .currentSelectedFilterIndex ==
                                  1
                              ? getSizeWidget(widget.sizes, context)
                              : widget.minPrice != widget.maxPrice
                                  ? getPriceRangeWidget(
                                      widget.minPrice, widget.maxPrice, context)
                                  : const SizedBox.shrink(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        width: double.maxFinite,
                        height: 45,
                        margin: const EdgeInsets.all(20),
                        // padding: const EdgeInsets.all(20),
                        decoration: DesignConfig.boxGradient(10),
                        child: Center(
                          child: CustomTextLabel(
                            jsonKey: "apply",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: ColorsRes.appColorWhite,
                                  fontSize: 15,
                                ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
