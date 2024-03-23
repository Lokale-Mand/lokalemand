import 'package:dotted_border/dotted_border.dart';
import 'package:lokale_mand/customer/models/chatDetail.dart';
import 'package:lokale_mand/customer/provider/productRatingProvider.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class ProductSubmitRatingWidget extends StatefulWidget {
  final double? size;
  final CustomerChatDetailData order;

  ProductSubmitRatingWidget({
    super.key,
    this.size,
    required this.order,
  });

  @override
  State<ProductSubmitRatingWidget> createState() =>
      _ProductSubmitRatingWidgetState();
}

class _ProductSubmitRatingWidgetState extends State<ProductSubmitRatingWidget> {
  TextEditingController productReview = TextEditingController();
  double rate = 0;
  List<String> selectedProductOtherImages = [];
  List<String> productDeletedOtherImages = [];
  List<String> fileParamsNames = [];

  // List<ItemRatingImages> productRatingImages = [];
  late CustomerChatDetailProductRating ratings;

  @override
  void initState() {
    try {
      ratings = widget.order.productRating!;

      if (ratings != null) {
        productReview.text = ratings.review.toString();
        // productRatingImages = ratings.images ?? [];
        rate = ratings.rate.toString().toDouble;
      } else {
        productReview.text = "";
        rate = 0.0;
      }
    } catch (e) {
      productReview.text = "";
      // productRatingImages = [];
      rate = 0.0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                if (selectedProductOtherImages.isNotEmpty) SizedBox(height: 5),
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
                                    fileName: selectedProductOtherImages[index],
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
                // SizedBox(height: 15),
                // if (productRatingImages.isNotEmpty)
                //   CustomTextLabel(
                //     jsonKey: "exist_attachments",
                //   ),
                // if (productRatingImages.isNotEmpty) SizedBox(height: 5),
                // if (productRatingImages.isNotEmpty)
                //   LayoutBuilder(
                //     builder: (context, constraints) => Wrap(
                //       runSpacing: 15,
                //       spacing: constraints.maxWidth * 0.05,
                //       children: List.generate(
                //         productRatingImages.length,
                //         (index) => Stack(
                //           children: [
                //             Container(
                //               decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(10),
                //                   border: Border.all(
                //                     color: ColorsRes.subTitleMainTextColor,
                //                   ),
                //                   color: Theme.of(context).cardColor),
                //               width: constraints.maxWidth * 0.3,
                //               height: constraints.maxWidth * 0.3,
                //               child: Center(
                //                 child: ClipRRect(
                //                   borderRadius: Constant.borderRadius10,
                //                   clipBehavior: Clip.antiAliasWithSaveLayer,
                //                   child: setNetworkImg(
                //                     image: productRatingImages[index]
                //                         .imageUrl
                //                         .toString(),
                //                     width: 110,
                //                     height: 110,
                //                     boxFit: BoxFit.fill,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             PositionedDirectional(
                //               end: -10,
                //               top: -10,
                //               child: IconButton(
                //                 onPressed: () {
                //                   productDeletedOtherImages.add(
                //                     productRatingImages[index].id.toString(),
                //                   );
                //                   productRatingImages.removeAt(index);
                //                   setState(() {});
                //                 },
                //                 icon: CircleAvatar(
                //                   backgroundColor: ColorsRes.appColorRed,
                //                   maxRadius: 10,
                //                   child: Icon(
                //                     Icons.close_rounded,
                //                     color: ColorsRes.appColorWhite,
                //                     size: 15,
                //                   ),
                //                 ),
                //               ),
                //             )
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
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
                ApiAndParams.productId: widget
                        .order.order?.items?[0].productVariant?.productId
                        .toString() ??
                    "",
                ApiAndParams.userId:
                    widget.order.order?.userId.toString() ?? "",
                ApiAndParams.rate: rate.toString(),
                ApiAndParams.review: productReview.text.toString(),
              };

              if (ratings != null) {
                params[ApiAndParams.id] = ratings.id.toString();
              }

              if (productDeletedOtherImages.isNotEmpty) {
                params[ApiAndParams.deleteImageIds] =
                    productDeletedOtherImages.toList().toString();
              }

              productRatingProvider
                  .addOrUpdateProductRating(
                context: context,
                params: params,
                isAdd: (ratings == null) ? true : false,
              )
                  .then((value) {
                if (value is bool) {
                  Navigator.pop(context, value);
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
                    jsonKey: (ratings == null) ? "add" : "update",
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
