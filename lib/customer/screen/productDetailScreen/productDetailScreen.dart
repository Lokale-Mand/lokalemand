import 'package:intl/intl.dart';
import 'package:lokale_mand/customer/models/productRating.dart';
import 'package:lokale_mand/customer/provider/productRatingListProvider.dart';
import 'package:lokale_mand/customer/screen/productDetailScreen/widget/sliderImageWidget.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/screen/sellerAddProductScreen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? title;
  final String id;
  final ProductListItem? productListItem;
  final String sellerId;
  final String storeLogo;
  final String storeName;

  const ProductDetailScreen(
      {Key? key,
      this.title,
      required this.id,
      this.productListItem,
      required this.sellerId,
      required this.storeLogo,
      required this.storeName})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  TextEditingController edtProductStock = TextEditingController();

  @override
  void initState() {
    super.initState();
    //fetch productList from api
    Future.delayed(Duration.zero).then((value) async {
      if (mounted) {
        try {
          Map<String, String> params =
              await Constant.getProductsDefaultParams();
          params[ApiAndParams.id] = widget.id.toString();

          List<Future> futures = [
            context
                .read<ProductDetailProvider>()
                .getProductDetailProvider(context: context, params: params),
            context.read<ProductRatingListProvider>().getProductRatingList(
                context: context, params: {"product_id": widget.id.toString()})
          ];

          await Future.wait(futures);
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
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    chatDetailScreen,
                    arguments: [
                      widget.sellerId.toString(),
                      widget.storeName.toString(),
                      widget.storeLogo,
                    ],
                  );
                },
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
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
                                        double.parse(
                                          product
                                              .variants[
                                                  selectedVariantItemProvider
                                                      .getSelectedIndex()]
                                              .price,
                                        ),
                                      ),
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
                                                product.variants[0].price,
                                              ),
                                            )
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
                        Widgets.getSizedBox(height: Constant.size10),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                try {
                                  if (edtProductStock.text.isEmpty) {
                                    edtProductStock.text = "0";
                                  } else if (int.parse(
                                          edtProductStock.text.toString()) >
                                      0) {
                                    edtProductStock.text = (int.parse(
                                                edtProductStock.text
                                                    .toString()) -
                                            1)
                                        .toString();
                                  } else {
                                    edtProductStock.text = "0";
                                  }
                                  setState(() {});
                                } catch (e) {
                                  GeneralMethods.showMessage(context,
                                      e.toString(), MessageType.warning);
                                }
                              },
                              icon: Icon(
                                Icons.remove_circle_outline_rounded,
                                color: ColorsRes.appColor,
                                size: 40,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 40,
                                padding: EdgeInsetsDirectional.only(
                                    start: 10, end: 10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(
                                    color: ColorsRes.textFieldBorderColor,
                                  ),
                                  color: Theme.of(context).cardColor,
                                ),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: edtProductStock,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CustomNumberTextInputFormatter()
                                  ],
                                  style: TextStyle(
                                    color: ColorsRes.mainTextColor,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    hintStyle: TextStyle(
                                      color: ColorsRes.menuTitleColor,
                                    ),
                                    hintText: context
                                        .read<LanguageProvider>()
                                        .currentLanguage["product_stock_hint"],
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      edtProductStock.text = value;
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                try {
                                  edtProductStock.text = (int.parse(
                                              edtProductStock.text
                                                      .toString()
                                                      .isEmpty
                                                  ? "0"
                                                  : edtProductStock.text
                                                      .toString()) +
                                          1)
                                      .toString();
                                  setState(() {});
                                } catch (e) {
                                  GeneralMethods.showMessage(context,
                                      e.toString(), MessageType.warning);
                                }
                              },
                              icon: Icon(
                                Icons.add_circle_outline_rounded,
                                color: ColorsRes.appColor,
                                size: 40,
                              ),
                            )
                          ],
                        ),
                        if (edtProductStock.text.toString().isNotEmpty &&
                            int.parse(edtProductStock.text.toString()) > 0)
                          Widgets.getSizedBox(height: Constant.size10),
                        if (edtProductStock.text.toString().isNotEmpty &&
                            int.parse(edtProductStock.text.toString()) > 0)
                          Consumer<CartListProvider>(
                            builder: (context, cartListProvider, child) {
                              return Widgets.gradientBtnWidget(
                                context,
                                10,
                                callback: () async {
                                  if (Constant.session.isUserLoggedIn()) {
                                    cartListProvider.currentSelectedProduct =
                                        product.id;
                                    cartListProvider.currentSelectedVariant =
                                        product.variants[0].id;

                                    Map<String, String> params = {};
                                    params[ApiAndParams.productId] = product.id;
                                    params[ApiAndParams.productVariantId] =
                                        product.variants[0].id;
                                    params[ApiAndParams.qty] =
                                        edtProductStock.text.toString();
                                    await cartListProvider
                                        .clearCart(context: context)
                                        .then((value) async {
                                      await cartListProvider
                                          .addRemoveCartItem(
                                        context: context,
                                        params: params,
                                        isUnlimitedStock:
                                            product.isUnlimitedStock == "1",
                                        maximumAllowedQuantity: double.tryParse(
                                            product.totalAllowedQuantity
                                                .toString())!,
                                        availableStock: double.tryParse(
                                            product.variants[0].stock)!,
                                        actionFor: "add",
                                      )
                                          .then(
                                        (value) {
                                          if (value == true) {
                                            Navigator.pushNamed(
                                                context, checkoutScreen,
                                                arguments: [
                                                  product,
                                                  edtProductStock.text
                                                      .toString(),
                                                ]);
                                          }
                                        },
                                      );
                                    });
                                  } else {
                                    Widgets.loginUserAccount(context, "cart");
                                  }
                                },
                                height: 50,
                                title: getTranslatedValue(
                                    context, "reserve_product"),
                              );
                            },
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
              if (context.read<ProductRatingListProvider>().totalData != 0)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Constant.size10),
                  child: Divider(
                    color: ColorsRes.menuTitleColor,
                    height: 5,
                  ),
                ),
              if (context.read<ProductRatingListProvider>().totalData != 0)
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Constant.size10),
                      child: CustomTextLabel(
                        jsonKey: "reviews",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Spacer(),
                    CustomTextLabel(
                      text: product.averageRating,
                    ),
                    Widgets.getSizedBox(
                      width: 5,
                    ),
                    RatingBar.builder(
                      initialRating:
                          double.tryParse(product.averageRating.toString()) ??
                              0.0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      maxRating: 5,
                      updateOnDrag: true,
                      itemSize: 15,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    CustomTextLabel(
                      text: " (${product.ratingCount})",
                    ),
                  ],
                ),
              Consumer<ProductRatingListProvider>(
                builder: (context, productRatingListProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      productRatingListProvider.totalData,
                      (index) {
                        ProductRatingData rating =
                            productRatingListProvider.ratings[index];

                        String createdAt = "";

                        DateTime dateTime =
                            DateTime.parse(rating.updatedAt.toString())
                                .toLocal();
                        DateTime now = DateTime.now().toLocal();
                        DateTime yesterday = now.subtract(Duration(days: 1));

                        if (isSameDay(dateTime, now)) {
                          // Today
                          createdAt =
                              DateFormat.Hm().format(dateTime); // HH:MM format
                        } else if (isSameDay(dateTime, yesterday)) {
                          // Yesterday
                          createdAt = getTranslatedValue(context, "yesterday");
                        } else {
                          // More than yesterday
                          createdAt = DateFormat('dd/MM/yyyy').format(dateTime);
                        }

                        return Container(
                          padding:
                              EdgeInsetsDirectional.only(bottom: 10, top: 10),
                          decoration: BoxDecoration(
                            border: BorderDirectional(
                              bottom: BorderSide(
                                color: ColorsRes.menuTitleColor,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    child: Widgets.setNetworkImg(
                                      image: rating.user?.profile?.toString() ??
                                          "",
                                      height: 40,
                                      width: 40,
                                      boxFit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  Widgets.getSizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomTextLabel(
                                        text:
                                            rating.user?.name?.toString() ?? "",
                                        style: TextStyle(
                                          color: ColorsRes.mainTextColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Widgets.getSizedBox(height: 5),
                                      CustomTextLabel(
                                        text: createdAt,
                                        style: TextStyle(
                                          color: ColorsRes.menuTitleColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Widgets.getSizedBox(height: 5),
                                      RatingBar.builder(
                                        initialRating: double.tryParse(
                                                rating.rate.toString()) ??
                                            0.0,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        maxRating: 5,
                                        updateOnDrag: true,
                                        itemSize: 12,
                                        itemCount: 5,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Widgets.getSizedBox(height: 5),
                              CustomTextLabel(
                                text: rating.review?.toString() ?? "",
                                style: TextStyle(
                                  color: ColorsRes.mainTextColor,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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
