import 'package:lokale_mand/helper/utils/generalImports.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProductSearchScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductSearchScreen> {
  // search provider controller
  final TextEditingController edtSearch = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();

  //give delay to live search
  Timer? delayTimer;

  ScrollController scrollController = ScrollController();

  scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (context.read<ProductSearchProvider>().hasMoreData) {
        Map<String, String> params = await Constant.getProductsDefaultParams();

        params[ApiAndParams.search] = edtSearch.text.trim();
        params[ApiAndParams.sellerId] =
            Constant.session.getData(SessionManager.keyUserId);

        await context
            .read<ProductSearchProvider>()
            .getProductSearchProvider(context: context, params: params);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    edtSearch.addListener(searchTextListener);
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }

  void searchTextListener() {
    if (edtSearch.text.isEmpty) {
      delayTimer?.cancel();
    }

    if (delayTimer?.isActive ?? false) delayTimer?.cancel();

    delayTimer = Timer(const Duration(milliseconds: 500), () {
      if (edtSearch.text.isNotEmpty) {
        if (edtSearch.text.length !=
            context.read<ProductSearchProvider>().searchedTextLength) {
          callApi(isReset: true);
          context.read<ProductSearchProvider>().setSearchLength(edtSearch.text);
        }
      }
    });
  }

  callApi({required bool isReset}) async {
    if (isReset) {
      context.read<ProductSearchProvider>().offset = 0;

      context.read<ProductSearchProvider>().products = [];
    }

    Map<String, String> params = await Constant.getProductsDefaultParams();

    params[ApiAndParams.sort] = ApiAndParams.productListSortTypes[
        context.read<ProductSearchProvider>().currentSortByOrderIndex];
    params[ApiAndParams.search] = edtSearch.text.trim().toString();

    await context
        .read<ProductSearchProvider>()
        .getProductSearchProvider(context: context, params: params);
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
      "sorting_display_list_popularity",
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: "search",
            softWrap: true,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorsRes.mainTextColor,
            ),
          ),
          actions: [setCartCounter(context: context)]),
      body: Stack(
        children: [
          Column(
            children: [
              searchWidget(),
              Widgets.getSizedBox(
                height: Constant.size5,
              ),
              if (context.watch<ProductSearchProvider>().products.length > 0)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constant.size5),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pushNamed(
                              context,
                              productListFilterScreen,
                              arguments: [
                                context
                                    .read<ProductSearchProvider>()
                                    .productList
                                    .brands,
                                double.parse(context
                                    .read<ProductSearchProvider>()
                                    .productList
                                    .maxPrice),
                                double.parse(context
                                    .read<ProductSearchProvider>()
                                    .productList
                                    .minPrice),
                                context
                                    .read<ProductSearchProvider>()
                                    .productList
                                    .sizes
                              ],
                            ).then((value) async {
                              if (value == true) {
                                context.read<ProductSearchProvider>().offset =
                                    0;
                                context.read<ProductSearchProvider>().products =
                                    [];

                                callApi(isReset: true);
                              }
                            });
                          },
                          child: Card(
                              color: Theme.of(context).cardColor,
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Widgets.defaultImg(
                                      image: "filter_icon",
                                      height: 17,
                                      width: 17,
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 7, bottom: 7, end: 7),
                                      iconColor:
                                          Theme.of(context).primaryColor),
                                  CustomTextLabel(
                                    jsonKey: "filter",
                                    softWrap: true,
                                  )
                                ],
                              )),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              shape: DesignConfig.setRoundedBorderSpecific(20,
                                  istop: true),
                              builder: (BuildContext context1) {
                                return Wrap(
                                  children: [
                                    Container(
                                      padding: EdgeInsetsDirectional.only(
                                          start: Constant.size15,
                                          end: Constant.size15,
                                          top: Constant.size15,
                                          bottom: Constant.size15),
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              PositionedDirectional(
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Widgets.defaultImg(
                                                      image: "ic_arrow_back",
                                                      iconColor: ColorsRes
                                                          .mainTextColor,
                                                      height: 15,
                                                      width: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: CustomTextLabel(
                                                  jsonKey: "sort_by",
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .merge(
                                                        TextStyle(
                                                          letterSpacing: 0.5,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: ColorsRes
                                                              .mainTextColor,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Widgets.getSizedBox(height: 10),
                                          Column(
                                            children: List.generate(
                                              ApiAndParams
                                                  .productListSortTypes.length,
                                              (index) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    context
                                                        .read<
                                                            ProductSearchProvider>()
                                                        .products = [];

                                                    context
                                                        .read<
                                                            ProductSearchProvider>()
                                                        .offset = 0;

                                                    context
                                                        .read<
                                                            ProductSearchProvider>()
                                                        .currentSortByOrderIndex = index;

                                                    callApi(isReset: true);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .all(10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        context
                                                                    .read<
                                                                        ProductSearchProvider>()
                                                                    .currentSortByOrderIndex ==
                                                                index
                                                            ? Icon(
                                                                Icons
                                                                    .radio_button_checked,
                                                                color: ColorsRes
                                                                    .appColor,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .radio_button_off,
                                                                color: ColorsRes
                                                                    .appColor,
                                                              ),
                                                        Widgets.getSizedBox(
                                                            width: 10),
                                                        Expanded(
                                                          child:
                                                              CustomTextLabel(
                                                            jsonKey:
                                                                lblSortingDisplayList[
                                                                    index],
                                                            softWrap: true,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .merge(
                                                                  TextStyle(
                                                                    letterSpacing:
                                                                        0.5,
                                                                    fontSize:
                                                                        16,
                                                                    color: ColorsRes
                                                                        .mainTextColor,
                                                                  ),
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            color: Theme.of(context).cardColor,
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Widgets.defaultImg(
                                    image: "sorting_icon",
                                    height: 17,
                                    width: 17,
                                    padding: const EdgeInsetsDirectional.only(
                                        top: 7, bottom: 7, end: 7),
                                    iconColor: Theme.of(context).primaryColor),
                                CustomTextLabel(
                                  jsonKey: "sort_by",
                                  softWrap: true,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<ProductChangeListingTypeProvider>()
                                .changeListingType();
                          },
                          child: Card(
                              color: Theme.of(context).cardColor,
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Widgets.defaultImg(
                                      image: context
                                                  .watch<
                                                      ProductChangeListingTypeProvider>()
                                                  .getListingType() ==
                                              false
                                          ? "grid_view_icon"
                                          : "list_view_icon",
                                      height: 17,
                                      width: 17,
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 7, bottom: 7, end: 7),
                                      iconColor:
                                          Theme.of(context).primaryColor),
                                  CustomTextLabel(
                                    text: context
                                                .watch<
                                                    ProductChangeListingTypeProvider>()
                                                .getListingType() ==
                                            false
                                        ? getTranslatedValue(
                                            context,
                                            "grid_view",
                                          )
                                        : getTranslatedValue(
                                            context,
                                            "list_view",
                                          ),
                                    softWrap: true,
                                  )
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: context
                            .read<ProductSearchProvider>()
                            .searchedTextLength >
                        0
                    ? setRefreshIndicator(
                        refreshCallback: () async {
                          if (context
                                  .read<ProductSearchProvider>()
                                  .searchedTextLength >
                              0) {
                            context.read<ProductSearchProvider>().offset = 0;
                            context.read<ProductSearchProvider>().products = [];
                          }

                          callApi(isReset: true);
                        },
                        child: ListView(
                          controller: scrollController,
                          children: [
                            productWidget(),
                          ],
                        ),
                      )
                    : ListView(
                        controller: scrollController,
                        children: [
                          productWidget(),
                        ],
                      ),
              ),
            ],
          ),
          Consumer<ProductSearchProvider>(
            builder: (context, productSearchProvider, child) {
              return productSearchProvider.isSearchingByVoice == true
                  ? Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                      color: Colors.transparent,
                      alignment: AlignmentDirectional.center,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 40, horizontal: 10),
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: MediaQuery.sizeOf(context).height * 0.6,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(Constant.size10),
                        ),
                        alignment: AlignmentDirectional.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: AlignmentDirectional.topEnd,
                              child: IconButton(
                                splashRadius: 0.1,
                                onPressed: () {
                                  setState(() {
                                    context
                                        .read<ProductSearchProvider>()
                                        .enableDisableSearchByVoice(false);
                                  });
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomTextLabel(
                                      jsonKey: "voice_search_product_message",
                                      softWrap: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                  Widgets.getSizedBox(
                                    height: Constant.size20,
                                  ),
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: ColorsRes.appColor,
                                    child: GestureDetector(
                                      onLongPress: () async {
                                        if (await Permission
                                            .microphone.status.isGranted) {
                                          _initSpeech().then(
                                              (value) => _startListening());
                                        } else {
                                          Permission.microphone.request();
                                        }
                                      },
                                      onLongPressUp: () {
                                        _stopListening();
                                      },
                                      child: Icon(
                                        Icons.mic_rounded,
                                        size: 60,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }

  //Start search widget
  searchWidget() {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(
          horizontal: Constant.size10, vertical: Constant.size10),
      child: Row(children: [
        Expanded(
          child: Container(
            decoration: DesignConfig.boxDecoration(
                Theme.of(context).scaffoldBackgroundColor, 10),
            child: ListTile(
              title: TextField(
                autofocus: true,
                style: TextStyle(
                  color: ColorsRes.mainTextColor,
                ),
                controller: edtSearch,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: context
                      .read<LanguageProvider>()
                      .currentLanguage["product_search_hint"],
                ),
              ),
              // onChanged: onSearchTextChanged,
              contentPadding: const EdgeInsetsDirectional.only(start: 10),
              trailing: IconButton(
                padding: EdgeInsets.zero,
                icon: Consumer<ProductSearchProvider>(
                  builder: (context, productSearchProvider, _) {
                    return edtSearch.text.isNotEmpty
                        ? Icon(Icons.close)
                        : Icon(Icons.search);
                  },
                ),
                onPressed: () async {
                  if (edtSearch.text.trim().length > 0) {
                    edtSearch.clear();
                    context.read<ProductSearchProvider>().setSearchLength("");
                  }
                },
              ),
            ),
          ),
        ),
        SizedBox(width: Constant.size10),
        Consumer<ProductSearchProvider>(
          builder: (context, productSearchProvider, child) {
            return GestureDetector(
              onTap: () {
                productSearchProvider.enableDisableSearchByVoice(true);
              },
              child: Container(
                decoration: DesignConfig.boxGradient(10),
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.size14, vertical: Constant.size14),
                child: Widgets.defaultImg(
                  image: "voice_search_icon",
                  iconColor: ColorsRes.mainIconColor,
                ),
              ),
            );
          },
        )
      ]),
    );
  }

  //callback of voice search
  voiceToTextResult(String text) {
    edtSearch.text = text;
  }

  //End search widget

  productWidget() {
    return Consumer<ProductSearchProvider>(
      builder: (context, productSearchProvider, _) {
        List<ProductListItem> products = productSearchProvider.products;

        if (productSearchProvider.productSearchState ==
            ProductSearchState.loading) {
          return getProductListShimmer(
              context: context,
              isGrid: context
                  .read<ProductChangeListingTypeProvider>()
                  .getListingType());
        } else if (productSearchProvider.productSearchState ==
                ProductSearchState.loaded ||
            productSearchProvider.productSearchState ==
                ProductSearchState.loadingMore) {
          return Column(
            children: [
              context
                          .read<ProductChangeListingTypeProvider>()
                          .getListingType() ==
                      true
                  ? /* GRID VIEW UI */ GridView.builder(
                      itemCount: products.length,
                      padding: EdgeInsetsDirectional.only(
                          start: Constant.size10,
                          end: Constant.size10,
                          bottom: Constant.size10,
                          top: Constant.size5),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductGridItemContainer(
                          product: products[index],
                          sellerId: '',
                          storeLogo: '',
                          storeName: '',
                        );
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.8,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    )
                  : /* LIST VIEW UI */ Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(products.length, (index) {
                        return ProductListItemContainer(
                            product: products[index]);
                      }),
                    ),
              if (productSearchProvider.productSearchState ==
                  ProductSearchState.loadingMore)
                getProductItemShimmer(
                    context: context,
                    isGrid: context
                        .read<ProductChangeListingTypeProvider>()
                        .getListingType()),
            ],
          );
        } else if (productSearchProvider.productSearchState ==
                ProductSearchState.initial ||
            context.read<ProductSearchProvider>().searchedTextLength == 0) {
          return DefaultBlankItemMessageScreen(
            title: "",
            description: "enter_text_to_search_the_products",
            image: "no_search_found_icon",
          );
        } else if (productSearchProvider.productSearchState ==
            ProductSearchState.empty) {
          return DefaultBlankItemMessageScreen(
            title: "empty_product_list_message",
            description: "empty_product_list_description",
            image: "no_product_icon",
          );
        } else {
          return NoInternetConnectionScreen(
              height: MediaQuery.sizeOf(context).height * 0.65,
              message: productSearchProvider.message,
              callback: () {
                callApi(isReset: false);
              });
        }
      },
    );
  }

//  Speech to text service

  /// This has to happen only once per app
  Future<void> _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 60),
    );
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      edtSearch.text = result.recognizedWords;
      context.read<ProductSearchProvider>().enableDisableSearchByVoice(false);
    });
  }
}
