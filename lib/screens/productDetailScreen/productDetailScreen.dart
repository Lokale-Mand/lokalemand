import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/models/storeTime.dart';
import 'package:lokale_mand/screens/productDetailScreen/widget/sliderImageWidget.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? title;
  final String id;
  final ProductListItem? productListItem;

  const ProductDetailScreen(
      {Key? key, this.title, required this.id, this.productListItem})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    //fetch productList from api
    Future.delayed(Duration.zero).then((value) async {
      if (mounted) {
        try {
          Map<String, String> params =
              await Constant.getProductsDefaultParams();
          params[ApiAndParams.id] = widget.id;

          await context
              .read<ProductDetailProvider>()
              .getProductDetailProvider(context: context, params: params);
        } catch (_) {}
      }
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PhysicalModel(
        elevation: 10,
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15,
          ),
          topRight: Radius.circular(
            15,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                15,
              ),
              topRight: Radius.circular(
                15,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomTextLabel(
                  jsonKey: "do_you_have_any_questions",
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding: EdgeInsetsDirectional.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorsRes.appColor,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: ColorsRes.appColor,
                      ),
                      Widgets.getSizedBox(width: 10),
                      CustomTextLabel(
                        text:
                            "${getTranslatedValue(context, "chat_with")} ${getTranslatedValue(context, "seller")}",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverAppBar(
              leadingWidth: MediaQuery.sizeOf(context).width,
              leading: Row(
                children: [
                  Widgets.getSizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).cardColor,
                        shape: DesignConfig.setRoundedBorder(100),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Consumer<ProductDetailProvider>(
                      builder: (context, productDetailProvider, _) {
                    return GestureDetector(
                      onTap: () async {
                        if (productDetailProvider.productDetailState ==
                            ProductDetailState.loaded) {
                          ProductData product =
                              productDetailProvider.productData;
                          await GeneralMethods.createDynamicLink(
                            context: context,
                            shareUrl:
                                "${Constant.hostUrl}product/${product.id}",
                            imageUrl: product.imageUrl,
                            title: product.name,
                            description:
                                "<h1>${product.name}</h1><br><br><h2>${product.variants[0].measurement} ${product.variants[0].stockUnitName}</h2>",
                          ).then(
                            (value) async => await Share.share(
                                "${product.name}\n\n$value",
                                subject: "Share app"),
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Card(
                          elevation: 0,
                          color: Theme.of(context).cardColor,
                          shape: DesignConfig.setRoundedBorder(100),
                          child: Icon(
                            Icons.share,
                            color: ColorsRes.mainTextColor,
                          ),
                        ),
                      ),
                    );
                  }),
                  Widgets.getSizedBox(width: 5),
                  Container(
                    height: 50,
                    width: 50,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).cardColor,
                        shape: DesignConfig.setRoundedBorder(100),
                        child: ProductWishListIcon(
                          product: Constant.session.isUserLoggedIn()
                              ? widget.productListItem
                              : null,
                          isListing: false,
                        ),
                      ),
                    ),
                  ),
                  Widgets.getSizedBox(width: 10),
                ],
              ),
              expandedHeight: MediaQuery.sizeOf(context).height * 0.35,
              floating: false,
              pinned: true,
              centerTitle: false,
              backgroundColor: Theme.of(context).cardColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Consumer<ProductDetailProvider>(
                  builder: (context, productDetailProvider, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        productDetailProvider.productDetailState ==
                                ProductDetailState.loaded
                            ? ChangeNotifierProvider<
                                SelectedVariantItemProvider>(
                                create: (context) =>
                                    SelectedVariantItemProvider(),
                                child: ChangeNotifierProvider<
                                    SliderImagesProvider>(
                                  create: (context) => SliderImagesProvider(),
                                  child: ProductSliderImagesWidgets(
                                    sliders: context
                                        .read<ProductDetailProvider>()
                                        .images,
                                  ),
                                ),
                              )
                            : productDetailProvider.productDetailState ==
                                    ProductDetailState.loading
                                ? getSliderShimmer(context: context)
                                : const SizedBox.shrink(),
                      ],
                    );
                  },
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Consumer<ProductDetailProvider>(
                  builder: (context, productDetailProvider, child) {
                    return Column(
                      children: [
                        productDetailProvider.productDetailState ==
                                ProductDetailState.loaded
                            ? ChangeNotifierProvider<
                                SelectedVariantItemProvider>(
                                create: (context) =>
                                    SelectedVariantItemProvider(),
                                child: productDetailWidget(
                                    productDetailProvider.productDetail.data),
                              )
                            : productDetailProvider.productDetailState ==
                                    ProductDetailState.loading
                                ? getProductDetailShimmer(context: context)
                                : const SizedBox.shrink(),
                      ],
                    );
                  },
                );
              }, childCount: 1),
            )
          ],
        ),
      ),
    );
  }

  Widget productDetailWidget(ProductData product) {
    DateTime dateTime = DateTime.now();

    StoreTime storeTime =
        context.read<ProductDetailProvider>().storeTime[dateTime.weekday];

    print("${storeTime.openTime}");

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Constant.size10,
            vertical: Constant.size10,
          ),
          child: Consumer<SelectedVariantItemProvider>(
            builder: (context, selectedVariantItemProvider, _) {
              return product.variants.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomTextLabel(
                          text: product.name,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorsRes.mainTextColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Widgets.getSizedBox(
                          height: Constant.size10,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(end: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomTextLabel(
                                text: double.parse(product
                                            .variants[
                                                selectedVariantItemProvider
                                                    .getSelectedIndex()]
                                            .discountedPrice) !=
                                        0
                                    ? GeneralMethods.getCurrencyFormat(
                                        double.parse(product
                                            .variants[
                                                selectedVariantItemProvider
                                                    .getSelectedIndex()]
                                            .discountedPrice))
                                    : GeneralMethods.getCurrencyFormat(
                                        double.parse(product
                                            .variants[selectedVariantItemProvider.getSelectedIndex()]
                                            .price)),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: ColorsRes.subTitleMainTextColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Widgets.getSizedBox(width: 5),
                              RichText(
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.clip,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: ColorsRes.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationThickness: 2),
                                      text: double.parse(product.variants[0]
                                                  .discountedPrice) !=
                                              0
                                          ? GeneralMethods.getCurrencyFormat(
                                              double.parse(
                                                  product.variants[0].price))
                                          : "",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Widgets.getSizedBox(height: Constant.size10),
                        GestureDetector(
                          onTap: () {
                            if (product.variants.length > 1) {
                              {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: DesignConfig.setRoundedBorderSpecific(
                                      20,
                                      istop: true),
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: EdgeInsetsDirectional.only(
                                          start: Constant.size15,
                                          end: Constant.size15,
                                          top: Constant.size15,
                                          bottom: Constant.size15),
                                      child: Wrap(
                                        children: [
                                          Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                start: Constant.size15,
                                                end: Constant.size15),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                    borderRadius:
                                                        Constant.borderRadius10,
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    child:
                                                        Widgets.setNetworkImg(
                                                            boxFit: BoxFit.fill,
                                                            image: product
                                                                .imageUrl,
                                                            height: 70,
                                                            width: 70)),
                                                Widgets.getSizedBox(
                                                  width: Constant.size10,
                                                ),
                                                Expanded(
                                                  child: CustomTextLabel(
                                                    text: product.name,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: ColorsRes
                                                          .mainTextColor,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsetsDirectional.only(
                                                start: Constant.size15,
                                                end: Constant.size15,
                                                top: Constant.size15,
                                                bottom: Constant.size15),
                                            child: ListView.separated(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  product.variants.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            child: RichText(
                                                              maxLines: 2,
                                                              softWrap: true,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              // maxLines: 1,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: ColorsRes
                                                                            .mainTextColor,
                                                                        decorationThickness:
                                                                            2),
                                                                    text:
                                                                        "${product.variants[index].measurement} ",
                                                                  ),
                                                                  WidgetSpan(
                                                                    child:
                                                                        CustomTextLabel(
                                                                      text: product
                                                                          .variants[
                                                                              index]
                                                                          .stockUnitName,
                                                                      softWrap:
                                                                          true,
                                                                      //superscript is usually smaller in size
                                                                      // textScaleFactor: 0.7,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: ColorsRes
                                                                            .mainTextColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                      text: double.parse(product.variants[index].discountedPrice) !=
                                                                              0
                                                                          ? " | "
                                                                          : "",
                                                                      style: TextStyle(
                                                                          color:
                                                                              ColorsRes.mainTextColor)),
                                                                  TextSpan(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: ColorsRes
                                                                            .grey,
                                                                        decoration:
                                                                            TextDecoration
                                                                                .lineThrough,
                                                                        decorationThickness:
                                                                            2),
                                                                    text: double.parse(product.variants[index].discountedPrice) !=
                                                                            0
                                                                        ? GeneralMethods.getCurrencyFormat(double.parse(product
                                                                            .variants[index]
                                                                            .price))
                                                                        : "",
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          CustomTextLabel(
                                                            text: double.parse(product
                                                                        .variants[
                                                                            index]
                                                                        .discountedPrice) !=
                                                                    0
                                                                ? GeneralMethods.getCurrencyFormat(
                                                                    double.parse(product
                                                                        .variants[
                                                                            index]
                                                                        .discountedPrice))
                                                                : GeneralMethods.getCurrencyFormat(
                                                                    double.parse(product
                                                                        .variants[
                                                                            index]
                                                                        .price)),
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 17,
                                                              color: ColorsRes
                                                                  .appColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    ProductCartButton(
                                                      productId:
                                                          product.id.toString(),
                                                      productVariantId: product
                                                          .variants[index].id
                                                          .toString(),
                                                      count: int.parse(product
                                                                  .variants[
                                                                      index]
                                                                  .status) ==
                                                              0
                                                          ? -1
                                                          : int.parse(product
                                                              .variants[index]
                                                              .cartCount),
                                                      isUnlimitedStock: product
                                                              .isUnlimitedStock ==
                                                          "1",
                                                      maximumAllowedQuantity:
                                                          double.parse(product
                                                              .totalAllowedQuantity
                                                              .toString()),
                                                      availableStock:
                                                          double.parse(product
                                                              .variants[index]
                                                              .stock),
                                                      isGrid: false,
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: Constant.size7),
                                                  child: Divider(
                                                    color: ColorsRes
                                                        .menuTitleColor,
                                                    height: 5,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (product.variants.length > 1) Spacer(),
                              CustomTextLabel(
                                text:
                                    "${product.variants[0].measurement} ${product.variants[0].stockUnitName}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColorsRes.subTitleMainTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              if (product.variants.length > 1) Spacer(),
                              if (product.variants.length > 1)
                                Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: 5, end: 5),
                                  child: Widgets.defaultImg(
                                    image: "ic_drop_down",
                                    height: 10,
                                    width: 10,
                                    boxFit: BoxFit.cover,
                                    iconColor: ColorsRes.mainTextColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink();
            },
          ),
        ),
        Divider(
          color: ColorsRes.menuTitleColor,
          endIndent: 10,
          indent: 10,
        ),
        Container(
          margin: EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Column(
            children: [
              if (product.fssaiLicNo.isNotEmpty)
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: ColorsRes.appColorWhite,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            3,
                          ),
                        ),
                      ),
                      child: Widgets.setNetworkImg(
                        image: product.fssaiLicImg,
                        height: 25,
                      ),
                    ),
                    Widgets.getSizedBox(
                      width: 5,
                    ),
                    CustomTextLabel(
                      jsonKey: "fssai_lic_no",
                      style: TextStyle(
                        color: ColorsRes.subTitleMainTextColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontSize: 12,
                      ),
                    ),
                    Widgets.getSizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: CustomTextLabel(
                        text: product.fssaiLicNo,
                        style: TextStyle(
                          color: ColorsRes.mainTextColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
              if (product.fssaiLicNo.isNotEmpty)
                Widgets.getSizedBox(height: 10),
              HtmlWidget(
                product.description,
                enableCaching: true,
                renderMode: RenderMode.column,
                buildAsync: false,
                textStyle: TextStyle(
                  color: ColorsRes.mainTextColor,
                  decoration: TextDecoration.none,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  getProductDetailShimmer({required BuildContext context}) {
    return CustomShimmer(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
    );
  }

  getSliderShimmer({required BuildContext context}) {
    return CustomShimmer(
      height: MediaQuery.sizeOf(context).height * 0.38,
      width: MediaQuery.sizeOf(context).width,
    );
  }
}
