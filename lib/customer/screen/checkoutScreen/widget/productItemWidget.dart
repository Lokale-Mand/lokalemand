import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/screen/sellerAddProductScreen.dart';
import 'package:provider/provider.dart';

class ProductItemWidget extends StatefulWidget {
  final ProductData productData;
  final int quantity;

  const ProductItemWidget(
      {super.key, required this.productData, required this.quantity});

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  TextEditingController edtProductStock = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      edtProductStock.text = widget.quantity.toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 20, bottom: 20, end: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextLabel(
            jsonKey: "your_products",
            softWrap: true,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: ColorsRes.mainTextColor,
            ),
          ),
          Widgets.getSizedBox(
            height: Constant.size10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Widgets.setNetworkImg(
                  image: widget.productData.imageUrl.toString(),
                  height: 80,
                  width: 80,
                  boxFit: BoxFit.cover,
                ),
              ),
              Widgets.getSizedBox(width: 20),
              Consumer<CartListProvider>(
                  builder: (context, cartListProvider, _) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextLabel(
                        text: widget.productData.name,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(end: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextLabel(
                              text: double.parse(widget.productData.variants[0]
                                          .discountedPrice) !=
                                      0
                                  ? GeneralMethods.getCurrencyFormat(
                                      double.parse(widget.productData
                                          .variants[0].discountedPrice))
                                  : GeneralMethods.getCurrencyFormat(
                                      double.parse(
                                        widget.productData.variants[0].price,
                                      ),
                                    ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorsRes.subTitleMainTextColor,
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: ColorsRes.grey,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 2),
                                    text: double.parse(widget.productData
                                                .variants[0].discountedPrice) !=
                                            0
                                        ? GeneralMethods.getCurrencyFormat(
                                            double.parse(
                                              widget.productData.variants[0]
                                                  .price,
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
                      Widgets.getSizedBox(height: 10),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              try {
                                if (int.parse(edtProductStock.text.toString()) >
                                    0) {
                                  cartListProvider.currentSelectedProduct =
                                      widget.productData.id;
                                  cartListProvider.currentSelectedVariant =
                                      widget.productData.variants[0].id;

                                  Map<String, String> params = {};
                                  params[ApiAndParams.productId] =
                                      widget.productData.id;
                                  params[ApiAndParams.productVariantId] =
                                      widget.productData.variants[0].id;
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
                                          widget.productData.isUnlimitedStock ==
                                              "1",
                                      maximumAllowedQuantity: double.tryParse(
                                          widget
                                              .productData.totalAllowedQuantity
                                              .toString())!,
                                      availableStock: double.tryParse(widget
                                          .productData.variants[0].stock)!,
                                      actionFor: "add",
                                    )
                                        .then(
                                      (value) {
                                        if (value == true) {
                                          Map<String, String> params = {
                                            ApiAndParams.latitude: context
                                                    .read<CheckoutProvider>()
                                                    .selectedAddress
                                                    ?.latitude
                                                    ?.toString() ??
                                                Constant.session.getData(
                                                    SessionManager.keyLatitude),
                                            ApiAndParams.longitude: context
                                                    .read<CheckoutProvider>()
                                                    .selectedAddress
                                                    ?.longitude
                                                    ?.toString() ??
                                                Constant.session.getData(
                                                    SessionManager
                                                        .keyLongitude),
                                            ApiAndParams.isCheckout: "1"
                                          };
                                          context
                                              .read<CheckoutProvider>()
                                              .getOrderChargesProvider(
                                                  context: context,
                                                  params: params);

                                          edtProductStock.text = (int.parse(
                                                      edtProductStock.text
                                                          .toString()) -
                                                  1)
                                              .toString();
                                        }
                                      },
                                    );
                                  });
                                } else {
                                  edtProductStock.text = "0";
                                }
                              } catch (e) {
                                GeneralMethods.showMessage(
                                    context, e.toString(), MessageType.warning);
                              }
                            },
                            icon: Icon(
                              Icons.remove_circle_outline_rounded,
                              color: ColorsRes.appColor,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            child: Container(
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
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              try {
                                cartListProvider.currentSelectedProduct =
                                    widget.productData.id;
                                cartListProvider.currentSelectedVariant =
                                    widget.productData.variants[0].id;

                                Map<String, String> params = {};
                                params[ApiAndParams.productId] =
                                    widget.productData.id;
                                params[ApiAndParams.productVariantId] =
                                    widget.productData.variants[0].id;
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
                                        widget.productData.isUnlimitedStock ==
                                            "1",
                                    maximumAllowedQuantity: double.tryParse(
                                        widget.productData.totalAllowedQuantity
                                            .toString())!,
                                    availableStock: double.tryParse(
                                        widget.productData.variants[0].stock)!,
                                    actionFor: "add",
                                  )
                                      .then(
                                    (value) {
                                      if (value == true) {
                                        Map<String, String> params = {
                                          ApiAndParams.latitude: context
                                                  .read<CheckoutProvider>()
                                                  .selectedAddress
                                                  ?.latitude
                                                  ?.toString() ??
                                              Constant.session.getData(
                                                  SessionManager.keyLatitude),
                                          ApiAndParams.longitude: context
                                                  .read<CheckoutProvider>()
                                                  .selectedAddress
                                                  ?.longitude
                                                  ?.toString() ??
                                              Constant.session.getData(
                                                  SessionManager.keyLongitude),
                                          ApiAndParams.isCheckout: "1"
                                        };
                                        context
                                            .read<CheckoutProvider>()
                                            .getOrderChargesProvider(
                                                context: context,
                                                params: params);

                                        edtProductStock.text = (int.parse(
                                                    edtProductStock.text
                                                            .toString()
                                                            .isEmpty
                                                        ? "0"
                                                        : edtProductStock.text
                                                            .toString()) +
                                                1)
                                            .toString();
                                      }
                                    },
                                  );
                                });
                              } catch (e) {
                                GeneralMethods.showMessage(
                                    context, e.toString(), MessageType.warning);
                              }
                              Map<String, String> params = {
                                ApiAndParams.latitude: context
                                        .read<CheckoutProvider>()
                                        .selectedAddress
                                        ?.latitude
                                        ?.toString() ??
                                    Constant.session
                                        .getData(SessionManager.keyLatitude),
                                ApiAndParams.longitude: context
                                        .read<CheckoutProvider>()
                                        .selectedAddress
                                        ?.longitude
                                        ?.toString() ??
                                    Constant.session
                                        .getData(SessionManager.keyLongitude),
                                ApiAndParams.isCheckout: "1"
                              };
                              context
                                  .read<CheckoutProvider>()
                                  .getOrderChargesProvider(
                                      context: context, params: params);
                            },
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                              color: ColorsRes.appColor,
                              size: 30,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              })
            ],
          )
        ],
      ),
    );
  }
}
