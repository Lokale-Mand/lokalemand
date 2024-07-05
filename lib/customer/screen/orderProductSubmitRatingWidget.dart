import 'package:dotted_border/dotted_border.dart';
import 'package:lokale_mand/customer/models/order.dart';
import 'package:lokale_mand/customer/provider/productRatingProvider.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class OrderProductSubmitRatingWidget extends StatefulWidget {
  final double? size;
  final Order order;

  OrderProductSubmitRatingWidget({
    super.key,
    this.size,
    required this.order,
  });

  @override
  State<OrderProductSubmitRatingWidget> createState() =>
      _OrderProductSubmitRatingWidgetState();
}

class _OrderProductSubmitRatingWidgetState
    extends State<OrderProductSubmitRatingWidget> {
  TextEditingController productReview = TextEditingController();
  double rate = 0;
  List<String> selectedProductOtherImages = [];
  List<String> productDeletedOtherImages = [];
  List<String> fileParamsNames = [];

  // List<ItemRatingImages> productRatingImages = [];
  late ItemRating? ratings;

  @override
  void initState() {
    try {
      ratings = widget.order.items.first.itemRating?.first;

      if (ratings != null) {
        productReview.text = ratings?.review.toString() ?? "";
        // productRatingImages = ratings.images ?? [];
        rate = ratings?.rate.toString().toDouble ?? 0.0;
      } else {
        productReview.text = "";
        rate = 0.0;
      }
    } catch (e) {
      ratings = null;
      productReview.text = "";
      // productRatingImages = [];
      rate = 0.0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ratings != null) {
      print(">>>>>>>>>>>>>>>>>>>>>>>>>1");
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: RatingBar.builder(
                      onRatingUpdate: (value) {
                        rate = value;
                      },
                      allowHalfRating: false,
                      initialRating: rate,
                      glow: false,
                      itemCount: 5,
                      itemBuilder: (context, index) => Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      unratedColor: ColorsRes.menuTitleColor,
                    ),
                  ),
                  SizedBox(height: Constant.size15),
                  editBoxWidget(
                    context,
                    productReview,
                    GeneralMethods.optionalValidation,
                    getTranslatedValue(
                      context,
                      "review",
                    ),
                    getTranslatedValue(
                      context,
                      "write_your_reviews_here",
                    ),
                    TextInputType.multiline,
                    optionalTextInputAction: TextInputAction.newline,
                    maxLines: 4,
                    minLines: 1,
                  ),
                  SizedBox(height: Constant.size15),
                  CustomTextLabel(
                    jsonKey: "attachments",
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () async {
                      GeneralMethods.hasStoragePermissionGiven().then((value) {
                        if (value) {
                          // Single file path
                          FilePicker.platform
                              .pickFiles(
                            allowMultiple: true,
                            allowCompression: true,
                            type: FileType.image,
                            lockParentWindow: true,
                          )
                              .then(
                            (value) {
                              for (int i = 0; i < value!.files.length; i++) {
                                selectedProductOtherImages
                                    .add(value.files[i].path.toString());
                                fileParamsNames.add("image[$i]");
                              }
                              setState(() {});
                            },
                          );
                        }
                      });
                    },
                    child: DottedBorder(
                      dashPattern: [5],
                      strokeWidth: 2,
                      strokeCap: StrokeCap.round,
                      color: ColorsRes.menuTitleColor,
                      radius: Radius.circular(10),
                      borderType: BorderType.RRect,
                      child: Container(
                        height: 100,
                        color: Colors.transparent,
                        padding: EdgeInsetsDirectional.all(10),
                        child: Center(
                          child: Column(
                            children: [
                              Widgets.defaultImg(
                                image: "upload",
                                iconColor: ColorsRes.menuTitleColor,
                                height: 40,
                                width: 40,
                              ),
                              CustomTextLabel(
                                jsonKey: "upload_images_here",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ColorsRes.menuTitleColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  if (selectedProductOtherImages.isNotEmpty)
                    CustomTextLabel(
                      jsonKey: "new_attachments",
                    ),
                  if (selectedProductOtherImages.isNotEmpty)
                    SizedBox(height: 5),
                  if (selectedProductOtherImages.isNotEmpty)
                    LayoutBuilder(
                      builder: (context, constraints) => Wrap(
                        runSpacing: 15,
                        spacing: constraints.maxWidth * 0.05,
                        children: List.generate(
                          selectedProductOtherImages.length,
                          (index) => Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ColorsRes.subTitleMainTextColor,
                                  ),
                                  color: Theme.of(context).cardColor,
                                ),
                                width: constraints.maxWidth * 0.3,
                                height: constraints.maxWidth * 0.3,
                                child: Center(
                                  child: imgWidget(
                                      fileName:
                                          selectedProductOtherImages[index],
                                      width: 105,
                                      height: 105),
                                ),
                              ),
                              PositionedDirectional(
                                end: -10,
                                top: -10,
                                child: IconButton(
                                  onPressed: () {
                                    selectedProductOtherImages.removeAt(index);
                                    fileParamsNames.removeAt(index);
                                    setState(() {});
                                  },
                                  icon: CircleAvatar(
                                    backgroundColor: ColorsRes.appColorRed,
                                    maxRadius: 10,
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: ColorsRes.appColorWhite,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
          Consumer<ProductRatingProvider>(
              builder: (context, productRatingProvider, _) {
            return Widgets.gradientBtnWidget(
              context,
              10,
              height: 45,
              callback: () {
                Map<String, String> params = {
                  ApiAndParams.productId:
                      widget.order.items.first.productId.toString(),
                  ApiAndParams.userId: widget.order.userId.toString(),
                  ApiAndParams.rate: rate.toString(),
                  ApiAndParams.review: productReview.text.toString(),
                  ApiAndParams.id: ratings?.id.toString() ?? "0"
                };

                if (productDeletedOtherImages.isNotEmpty) {
                  params[ApiAndParams.deleteImageIds] =
                      productDeletedOtherImages.toList().toString();
                }

                productRatingProvider
                    .addOrUpdateProductRating(
                  context: context,
                  params: params,
                  isAdd: false,
                )
                    .then((value) {
                  if (value is bool) {
                    Navigator.pop(context, true);
                  } else {
                    Navigator.pop(context, null);
                  }
                });
              },
              otherWidgets: productRatingProvider.productRatingState ==
                      ProductRatingState.loading
                  ? Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: ColorsRes.appColorWhite,
                      ),
                    )
                  : CustomTextLabel(
                      jsonKey: "add",
                      style: TextStyle(
                        fontSize: 18,
                        color: ColorsRes.appColorWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            );
          }),
          SizedBox(height: Constant.size15),
        ],
      );
    }
    else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: RatingBar.builder(
                      onRatingUpdate: (value) {
                        rate = value;
                      },
                      allowHalfRating: false,
                      initialRating: 0,
                      glow: false,
                      itemCount: 5,
                      itemBuilder: (context, index) => Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      unratedColor: ColorsRes.menuTitleColor,
                    ),
                  ),
                  SizedBox(height: Constant.size15),
                  editBoxWidget(
                    context,
                    productReview,
                    GeneralMethods.optionalValidation,
                    getTranslatedValue(
                      context,
                      "review",
                    ),
                    getTranslatedValue(
                      context,
                      "write_your_reviews_here",
                    ),
                    TextInputType.multiline,
                    optionalTextInputAction: TextInputAction.newline,
                    maxLines: 4,
                    minLines: 1,
                  ),
                  SizedBox(height: Constant.size15),
                  CustomTextLabel(
                    jsonKey: "attachments",
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () async {
                      GeneralMethods.hasStoragePermissionGiven().then((value) {
                        if (value) {
                          // Single file path
                          FilePicker.platform
                              .pickFiles(
                            allowMultiple: true,
                            allowCompression: true,
                            type: FileType.image,
                            lockParentWindow: true,
                          )
                              .then(
                            (value) {
                              for (int i = 0; i < value!.files.length; i++) {
                                selectedProductOtherImages
                                    .add(value.files[i].path.toString());
                                fileParamsNames.add("image[$i]");
                              }
                              setState(() {});
                            },
                          );
                        }
                      });
                    },
                    child: DottedBorder(
                      dashPattern: [5],
                      strokeWidth: 2,
                      strokeCap: StrokeCap.round,
                      color: ColorsRes.menuTitleColor,
                      radius: Radius.circular(10),
                      borderType: BorderType.RRect,
                      child: Container(
                        height: 100,
                        color: Colors.transparent,
                        padding: EdgeInsetsDirectional.all(10),
                        child: Center(
                          child: Column(
                            children: [
                              Widgets.defaultImg(
                                image: "upload",
                                iconColor: ColorsRes.menuTitleColor,
                                height: 40,
                                width: 40,
                              ),
                              CustomTextLabel(
                                jsonKey: "upload_images_here",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ColorsRes.menuTitleColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  if (selectedProductOtherImages.isNotEmpty)
                    CustomTextLabel(
                      jsonKey: "new_attachments",
                    ),
                  if (selectedProductOtherImages.isNotEmpty)
                    SizedBox(height: 5),
                  if (selectedProductOtherImages.isNotEmpty)
                    LayoutBuilder(
                      builder: (context, constraints) => Wrap(
                        runSpacing: 15,
                        spacing: constraints.maxWidth * 0.05,
                        children: List.generate(
                          selectedProductOtherImages.length,
                          (index) => Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ColorsRes.subTitleMainTextColor,
                                  ),
                                  color: Theme.of(context).cardColor,
                                ),
                                width: constraints.maxWidth * 0.3,
                                height: constraints.maxWidth * 0.3,
                                child: Center(
                                  child: imgWidget(
                                      fileName:
                                          selectedProductOtherImages[index],
                                      width: 105,
                                      height: 105),
                                ),
                              ),
                              PositionedDirectional(
                                end: -10,
                                top: -10,
                                child: IconButton(
                                  onPressed: () {
                                    selectedProductOtherImages.removeAt(index);
                                    fileParamsNames.removeAt(index);
                                    setState(() {});
                                  },
                                  icon: CircleAvatar(
                                    backgroundColor: ColorsRes.appColorRed,
                                    maxRadius: 10,
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: ColorsRes.appColorWhite,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
          Consumer<ProductRatingProvider>(
              builder: (context, productRatingProvider, _) {
            return Widgets.gradientBtnWidget(
              context,
              10,
              height: 45,
              callback: () {
                Map<String, String> params = {
                  ApiAndParams.productId:
                      widget.order.items.first.productId.toString(),
                  ApiAndParams.userId: widget.order.userId.toString(),
                  ApiAndParams.rate: rate.toString(),
                  ApiAndParams.review: productReview.text.toString(),
                  ApiAndParams.id: ratings?.id.toString() ?? "0"
                };

                if (productDeletedOtherImages.isNotEmpty) {
                  params[ApiAndParams.deleteImageIds] =
                      productDeletedOtherImages.toList().toString();
                }

                productRatingProvider
                    .addOrUpdateProductRating(
                  context: context,
                  params: params,
                  isAdd: true,
                )
                    .then((value) {
                  if (value is bool) {
                    Navigator.pop(context, true);
                  } else {
                    Navigator.pop(context, null);
                  }
                });
              },
              otherWidgets: productRatingProvider.productRatingState ==
                      ProductRatingState.loading
                  ? Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: ColorsRes.appColorWhite,
                      ),
                    )
                  : CustomTextLabel(
                      jsonKey: "add",
                      style: TextStyle(
                        fontSize: 18,
                        color: ColorsRes.appColorWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            );
          }),
          SizedBox(height: Constant.size15),
        ],
      );
    }
  }

  imgWidget({required String fileName, double? height, double? width}) {
    return GestureDetector(
      onTap: () {
        try {
          OpenFilex.open(fileName);
        } catch (e) {
          GeneralMethods.showMessage(context, e.toString(), MessageType.error);
        }
      },
      child: fileName.split(".").last == "pdf"
          ? Center(
              child: Widgets.defaultImg(
                image: "pdf",
                height: 50,
                width: 50,
              ),
            )
          : ClipRRect(
              borderRadius: Constant.borderRadius10,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image(
                image: FileImage(
                  File(
                    fileName,
                  ),
                ),
                width: width ?? 90,
                height: height ?? 90,
                fit: BoxFit.fill,
              ),
            ),
    );
  }
}
