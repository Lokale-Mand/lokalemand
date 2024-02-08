import 'dart:math' as math;

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerCategory.dart';
import 'package:lokale_mand/seller/model/sellerDietary.dart';
import 'package:lokale_mand/seller/model/sellerProductUnit.dart';
import 'package:lokale_mand/seller/provider/sellerAddProductProvider.dart';
import 'package:lokale_mand/seller/provider/sellerCategoryProvider.dart';
import 'package:lokale_mand/seller/provider/sellerDietaryProvider.dart';
import 'package:lokale_mand/seller/provider/sellerProductSliderImagesProvider.dart';
import 'package:lokale_mand/seller/provider/sellerProductUnitProvider.dart';
import 'package:lokale_mand/seller/screen/sellerProductSliderImagesWidget.dart';

class SellerAddOrUpdateProductScreen extends StatefulWidget {
  const SellerAddOrUpdateProductScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SellerAddOrUpdateProductScreen> createState() =>
      _SellerAddOrUpdateProductScreenState();
}

class _SellerAddOrUpdateProductScreenState
    extends State<SellerAddOrUpdateProductScreen> {
  PageController pageController = PageController();
  int currentPage = 0;
  late bool isLoading = false;
  String selectedProductMainImage = "";

  // String htmlDescription = "";
  List<String?> selectedProductOtherImages = [];
  bool stockAvailableStatus = true;
  String selectedDietaryType = "";
  String selectedDietaryId = "";

  String selectedUnitId = "";

  String selectedCategoryId = "";
  TextEditingController edtProductName = TextEditingController();
  TextEditingController edtProductDescription = TextEditingController();
  TextEditingController edtProductPrice = TextEditingController();
  TextEditingController edtProductUnit = TextEditingController();
  TextEditingController edtProductStock = TextEditingController();

//   id:21
//   name: Eiefregwsdwfrde efecwefe efdedescfescfededwedwd
//   slug: eidwdd
//   seller_id:10
//   tags:Frambozen,Frambozen2
//   tax_id: 0
//   brand_id: 0
//   description: <p>1 x 12 eitjes</p>
//   type: packet
//   is_unlimited_stock: 0
//   fssai_lic_no:
//   variant_id[]:5
//   variant_id[]:8
//
//   packet_measurement[]:1
//   packet_measurement[]:11
//
//   packet_price[]:20
//   packet_price[]:11
//
//   discounted_price[]:0
//   discounted_price[]:1
//
//   packet_stock[]:10000
//   packet_stock[]: 11
//
//   packet_stock_unit_id[]:1
//   packet_stock_unit_id[]:1
//
//   packet_status[]:1
//   packet_status[]:1
//
//   loose_stock: 0
//   loose_stock_unit_id: null
//   status: 1
//   category_id: 3
//   product_type: 9
//   manufacturer: null
//   made_in: 0
//   shipping_type: undefined
//   pincode_ids_exc: null
//   return_status: 0
//   return_days: 0
//   cancelable_status: 0
//   till_status: null
//   cod_allowed_status: 0
//   max_allowed_quantity: 1000
//   is_approved: 1
//   tax_included_in_price: 0
//   deleteImageIds:[]

  backendApiProcess() async {
    Map<String, String> params = {
      // "id": " 21",
      "name": edtProductName.text.toString(),
      // "slug": " eidwdd",
      // "seller_id": "10",
      "tags": edtProductName.text.toString(),
      "tax_id": "0",
      "brand_id": "0",
      "description": edtProductDescription.text.toString(),
      "type": "packet",
      "seller_id": Constant.session.getData(SessionManager.keyUserId),
      "is_unlimited_stock": "0",
      "fssai_lic_no": "",
      // "variant_id[]": "5",
      "packet_measurement[]": selectedUnitId,
      "packet_price[]": edtProductPrice.text.toString(),
      "discounted_price[]": "0",
      "packet_stock[]": edtProductStock.text.toString(),
      "packet_stock_unit_id[]": selectedUnitId,
      "packet_status[]": "1",
      "loose_stock": "0",
      "loose_stock_unit_id": "null",
      "status": "1",
      "category_id": selectedCategoryId,
      "product_type": "9",
      "manufacturer": "null",
      "made_in": "0",
      "shipping_type": "undefined",
      "pincode_ids_exc": "null",
      "return_status": "0",
      "return_days": "0",
      "cancelable_status": "0",
      "till_status": "null",
      "cod_allowed_status": "0",
      "max_allowed_quantity": "1000",
      "is_approved": "1",
      "tax_included_in_price": "0",
      "deleteImageIds": "[]",
    };

    List<String> otherImagesParamsNames = [];

    for (int i = 0; i < selectedProductOtherImages.length; i++) {
      otherImagesParamsNames.add("other_images[$i]");
    }

    List<String> fileParamNames = [
      "image",
      ...otherImagesParamsNames,
    ];

    List<String?> fileParamsFilesPath = [
      selectedProductMainImage,
      ...selectedProductOtherImages
    ];

    await context
        .read<SellerAddUpdateProductProvider>()
        .addOrUpdateProducts(
            params: params,
            fileParamsNames: fileParamNames,
            fileParamsFilesPath: fileParamsFilesPath,
            context: context,
            isAdd: true)
        .then((value) async {
      if (value != null) {
        Navigator.pop(context, true);
      }
    });
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    Future.delayed(Duration.zero).then((value) async {
      await Future.wait([
        context
            .read<SellerCategoryListProvider>()
            .getCategoryApiProviderForRegistration(context: context),
        context
            .read<SellerDietaryListProvider>()
            .getDietaryApiProvider(context: context)
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottomNavigationBar: Container(
          constraints: BoxConstraints(
            maxHeight: 60,
          ),
          padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
          child: StepperCounter(
            firstCounterText: "back",
            firstItemVoidCallback: () {
              if (currentPage == 0) {
                Navigator.pop(context);
              } else {
                currentPage--;
                pageController.animateToPage(currentPage,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              }
            },
            secondCounterText: "${currentPage + 1}/6",
            thirdCounterText: currentPage == 5 ? "I'm ready!" : "next",
            thirdItemVoidCallback: () => pageChangeValidation(currentPage),
          ),
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            currentPage = value;
            setState(() {});
          },
          controller: pageController,
          children: [
            // 1. CATEGORY SCREEN
            Container(
              padding: EdgeInsetsDirectional.all(15),
              alignment: Alignment.center,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    productCategorySelectionWidgets(),
                  ],
                ),
              ),
            ),
            // 2. PRODUCT NAME AND DESCRIPTION SCREEN
            Container(
              padding: EdgeInsetsDirectional.all(15),
              alignment: Alignment.center,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    productDescription(),
                  ],
                ),
              ),
            ),
            // 3. PRODUCT PRICE AND OTHER DETAILS SCREEN
            Container(
              padding: EdgeInsetsDirectional.all(15),
              alignment: Alignment.center,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    productVariantDetails(),
                  ],
                ),
              ),
            ),
            // 4. DIETARY TYPE SCREEN
            Container(
              padding: EdgeInsetsDirectional.all(15),
              alignment: Alignment.center,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    productDietarySelectionWidgets(),
                  ],
                ),
              ),
            ),
            // 5. PRODUCT PHOTOS SCREEN
            Container(
              padding: EdgeInsetsDirectional.all(10),
              alignment: Alignment.center,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    productImagesSelectionWidgets(),
                  ],
                ),
              ),
            ),
            // 6. PRODUCT FINAL VIEW SCREEN
            productFinalPreview(),
          ],
        ));
  }

  pageChangeValidation(int currentPage) {
    switch (currentPage) {
      case 0:
        // 1. CATEGORY SCREEN
        categorySelectionValidation();
      case 1:
        // 2. PRODUCT NAME AND DESCRIPTION SCREEN
        productDescriptionValidation();
      case 2:
        // 3. PRODUCT PRICE AND OTHER DETAILS SCREEN
        productVariantDetailValidation();
      case 3:
        // 4. DIETARY TYPE SCREEN
        dietarySelectionValidation();
      case 4:
        // 5. PRODUCT PHOTOS SCREEN
        productImageSelectionValidation();
      case 5:
        // 6. PRODUCT FINAL VIEW SCREEN
        backendApiProcess();
      default:
        GeneralMethods.showMessage(
            context, "something_went_wrong", MessageType.warning);
    }
  }

  Widget productCategorySelectionWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        //Store Name
        CustomTextLabel(
          jsonKey: "product_category_selection_title",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: ColorsRes.mainTextColor,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        //Category Selection Widget
        Consumer<SellerCategoryListProvider>(
          builder: (context, sellerCategoryListProvider, child) {
            if (sellerCategoryListProvider.sellerCategoryState ==
                SellerCategoryState.loaded) {
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(
                  sellerCategoryListProvider.categories.length,
                  (index) {
                    CategoryData category =
                        sellerCategoryListProvider.categories[index];
                    return GestureDetector(
                      onTap: () {
                        sellerCategoryListProvider.categorySingleSelection(
                            id: category.id.toString());
                        selectedCategoryId = category.id.toString();
                      },
                      child: Container(
                        margin: EdgeInsetsDirectional.only(bottom: 15),
                        padding: EdgeInsetsDirectional.all(15),
                        decoration: BoxDecoration(
                          color: (sellerCategoryListProvider
                                      .selectedCategoryIdsList.isNotEmpty &&
                                  category.id ==
                                      sellerCategoryListProvider
                                          .selectedCategoryIdsList[0])
                              ? ColorsRes.appColor
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: ColorsRes.appColor,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.storefront,
                              color: (sellerCategoryListProvider
                                          .selectedCategoryIdsList.isNotEmpty &&
                                      category.id ==
                                          sellerCategoryListProvider
                                              .selectedCategoryIdsList[0])
                                  ? ColorsRes.appColorWhite
                                  : ColorsRes.appColor,
                              size: 35,
                            ),
                            Widgets.getSizedBox(width: 20),
                            Expanded(
                              child: CustomTextLabel(
                                text: sellerCategoryListProvider
                                    .categories[index].name,
                                style: TextStyle(
                                  color: (sellerCategoryListProvider
                                              .selectedCategoryIdsList
                                              .isNotEmpty &&
                                          category.id ==
                                              sellerCategoryListProvider
                                                  .selectedCategoryIdsList[0])
                                      ? ColorsRes.appColorWhite
                                      : ColorsRes.appColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (sellerCategoryListProvider
                                    .selectedCategoryIdsList.isNotEmpty &&
                                category.id ==
                                    sellerCategoryListProvider
                                        .selectedCategoryIdsList[0])
                              Icon(
                                Icons.check_circle,
                                color: ColorsRes.appColorWhite,
                                size: 35,
                              )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (sellerCategoryListProvider.sellerCategoryState ==
                SellerCategoryState.loading) {
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(
                  5,
                  (index) {
                    return CustomShimmer(
                      margin: EdgeInsetsDirectional.only(bottom: 10),
                      height: 75,
                      borderRadius: 10,
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  Widget productDietarySelectionWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        //Store Name
        CustomTextLabel(
          jsonKey: "product_dietary_type_title",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: ColorsRes.mainTextColor,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        //Category Selection Widget
        Consumer<SellerDietaryListProvider>(
          builder: (context, sellerDietaryListProvider, child) {
            if (sellerDietaryListProvider.sellerDietaryState ==
                SellerDietaryState.loaded) {
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(
                  sellerDietaryListProvider.dietaries.length,
                  (index) {
                    DietaryData dietary =
                        sellerDietaryListProvider.dietaries[index];
                    return GestureDetector(
                      onTap: () {
                        sellerDietaryListProvider.dietarySingleSelection(
                          id: dietary.id.toString(),
                          name: dietary.name.toString(),
                        );

                        selectedDietaryType = sellerDietaryListProvider
                            .selectedDietaryNamesList[0];
                        selectedDietaryId =
                            sellerDietaryListProvider.selectedDietaryIdsList[0];
                      },
                      child: Container(
                        margin: EdgeInsetsDirectional.only(bottom: 15),
                        padding: EdgeInsetsDirectional.all(15),
                        decoration: BoxDecoration(
                          color: (sellerDietaryListProvider
                                      .selectedDietaryIdsList.isNotEmpty &&
                                  dietary.id ==
                                      sellerDietaryListProvider
                                          .selectedDietaryIdsList[0])
                              ? ColorsRes.appColor
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: ColorsRes.appColor,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.storefront,
                              color: (sellerDietaryListProvider
                                          .selectedDietaryIdsList.isNotEmpty &&
                                      dietary.id ==
                                          sellerDietaryListProvider
                                              .selectedDietaryIdsList[0])
                                  ? Theme.of(context).cardColor
                                  : ColorsRes.appColor,
                              size: 35,
                            ),
                            Widgets.getSizedBox(width: 20),
                            Expanded(
                              child: CustomTextLabel(
                                text: sellerDietaryListProvider
                                    .dietaries[index].name,
                                style: TextStyle(
                                  color: (sellerDietaryListProvider
                                              .selectedDietaryIdsList
                                              .isNotEmpty &&
                                          dietary.id ==
                                              sellerDietaryListProvider
                                                  .selectedDietaryIdsList[0])
                                      ? Theme.of(context).cardColor
                                      : ColorsRes.appColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (sellerDietaryListProvider
                                    .selectedDietaryIdsList.isNotEmpty &&
                                dietary.id ==
                                    sellerDietaryListProvider
                                        .selectedDietaryIdsList[0])
                              Icon(
                                Icons.check_circle,
                                color: ColorsRes.appColorWhite,
                                size: 35,
                              )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (sellerDietaryListProvider.sellerDietaryState ==
                SellerDietaryState.loading) {
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(
                  5,
                  (index) {
                    return CustomShimmer(
                      margin: EdgeInsetsDirectional.only(bottom: 10),
                      height: 75,
                      borderRadius: 10,
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  Widget productImagesSelectionWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Store Name
        CustomTextLabel(
          jsonKey: "product_photos_title",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: ColorsRes.mainTextColor,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        CustomTextLabel(
          jsonKey: "product_photos_sub_title",
          style: TextStyle(
            fontSize: 15,
            color: ColorsRes.menuTitleColor,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        //Product Main Image
        CustomTextLabel(
          jsonKey: "product_main_image",
          style: TextStyle(
            color: ColorsRes.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        Row(
          children: [
            if (selectedProductMainImage.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorsRes.textFieldBorderColor,
                    ),
                    color: Theme.of(context).cardColor),
                height: 105,
                width: 105,
                child: Center(
                  child: imgWidget(selectedProductMainImage),
                ),
              ),
            if (selectedProductMainImage.isNotEmpty)
              Widgets.getSizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  // Single file path
                  FilePicker.platform
                      .pickFiles(
                          allowMultiple: false,
                          allowCompression: true,
                          type: FileType.image,
                          lockParentWindow: true)
                      .then((value) {
                    selectedProductMainImage = value!.paths.first.toString();
                    setState(() {});
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
                            jsonKey: "upload_logo_file_here",
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
            ),
          ],
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        //Product Other Image
        CustomTextLabel(
          jsonKey: "product_other_images",
          style: TextStyle(
            color: ColorsRes.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        GestureDetector(
          onTap: () async {
            // Single file path
            FilePicker.platform
                .pickFiles(
              allowMultiple: true,
              allowCompression: true,
              type: FileType.image,
              lockParentWindow: true,
            )
                .then((value) {
              selectedProductOtherImages = value!.paths;
              setState(() {});
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
                      jsonKey: "upload_logo_file_here",
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
        if (selectedProductOtherImages.isNotEmpty)
          Widgets.getSizedBox(
            height: Constant.size15,
          ),
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            runSpacing: 15,
            spacing: constraints.maxWidth * 0.05,
            children: List.generate(
              selectedProductOtherImages.length,
              (index) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorsRes.textFieldBorderColor,
                    ),
                    color: Theme.of(context).cardColor),
                width: constraints.maxWidth * 0.3,
                height: constraints.maxWidth * 0.3,
                child: Center(
                  child: imgWidget(selectedProductOtherImages[index]!),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget productDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Store Name
        CustomTextLabel(
          jsonKey: "product_description_title",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: ColorsRes.mainTextColor,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        //Store Name
        CustomTextLabel(
          jsonKey: "product_name",
          style: TextStyle(
            color: ColorsRes.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        Container(
          padding: EdgeInsetsDirectional.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorsRes.textFieldBorderColor,
              ),
              color: Theme.of(context).cardColor),
          child: TextField(
            controller: edtProductName,
            keyboardType: TextInputType.name,
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
                  .currentLanguage["product_name_hint"],
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        //Store Name
        CustomTextLabel(
          jsonKey: "product_description",
          style: TextStyle(
            color: ColorsRes.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        Container(
          padding: EdgeInsetsDirectional.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorsRes.textFieldBorderColor,
              ),
              color: Theme.of(context).cardColor),
          child: TextField(
            textInputAction: TextInputAction.newline,
            controller: edtProductDescription,
            keyboardType: TextInputType.name,
            minLines: 1,
            maxLines: 10000,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: ColorsRes.menuTitleColor,
              ),
              hintText: context
                      .read<LanguageProvider>()
                      .currentLanguage["product_description_hint"] ??
                  "",
            ),
          ),
        ),
        // Container(
        //   constraints: BoxConstraints(
        //     minWidth: MediaQuery.sizeOf(context).width,
        //     minHeight: 65,
        //   ),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     border: Border.all(
        //       color: ColorsRes.textFieldBorderColor,
        //     ),
        //     color: Theme.of(context).cardColor,
        //   ),
        //   child: Stack(
        //     children: [
        //       Container(
        //         padding: EdgeInsetsDirectional.all(10),
        //         child: HtmlWidget(
        //           htmlDescription.isEmpty
        //               ? context
        //                       .read<LanguageProvider>()
        //                       .currentLanguage["product_description_hint"] ??
        //                   ""
        //               : htmlDescription,
        //           enableCaching: true,
        //           renderMode: RenderMode.column,
        //           buildAsync: false,
        //           textStyle: TextStyle(color: ColorsRes.mainTextColor),
        //         ),
        //       ),
        //       PositionedDirectional(
        //         top: 0,
        //         end: 0,
        //         child: IconButton(
        //           onPressed: () {
        //             Navigator.pushNamed(context, htmlEditorScreen,
        //                     arguments: htmlDescription)
        //                 .then((value) {
        //               if (value != null) {
        //                 htmlDescription = value.toString();
        //                 setState(() {});
        //               }
        //             });
        //           },
        //           icon: Icon(
        //             Icons.edit,
        //             color: ColorsRes.appColor,
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget productVariantDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Store Name
        CustomTextLabel(
          jsonKey: "product_variant_title",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: ColorsRes.mainTextColor,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        //Store Name
        CustomTextLabel(
          jsonKey: "product_price",
          style: TextStyle(
            color: ColorsRes.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        Container(
          padding: EdgeInsetsDirectional.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorsRes.textFieldBorderColor,
              ),
              color: Theme.of(context).cardColor),
          child: TextField(
            controller: edtProductPrice,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
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
              hintText: getTranslatedValue(context, "product_price_hint"),
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        //Store Name
        CustomTextLabel(
          jsonKey: "product_unit_title",
          style: TextStyle(
            color: ColorsRes.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        Container(
          padding: EdgeInsetsDirectional.only(start: 10,end: 10,top: 5,bottom: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorsRes.textFieldBorderColor,
              ),
              color: Theme.of(context).cardColor),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: edtProductUnit,
                  keyboardType: TextInputType.none,
                  enabled: false,
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
                        .currentLanguage["product_unit_hint"],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    shape:
                        DesignConfig.setRoundedBorderSpecific(20, istop: true),
                    builder: (BuildContext context) {
                      return ChangeNotifierProvider(
                        create: (context) => SellerProductUnitListProvider(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsetsDirectional.only(
                              start: 15, end: 15, top: 15, bottom: 15),
                          child: Wrap(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: 10, end: 10),
                                child: Text(
                                  getTranslatedValue(context, "units"),
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: ColorsRes.menuTitleColor),
                                ),
                              ),
                              Container(
                                color: Theme.of(context).cardColor,
                                padding: EdgeInsetsDirectional.only(
                                    start: 10, end: 10, top: 10, bottom: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      constraints:
                                          BoxConstraints(minHeight: 120),
                                      padding: EdgeInsetsDirectional.all(20),
                                      child: Consumer<
                                          SellerProductUnitListProvider>(
                                        builder: (context,
                                            sellerProductUnitListProvider,
                                            child) {
                                          if (!sellerProductUnitListProvider
                                              .startedApiCalling) {
                                            sellerProductUnitListProvider
                                                    .sellerProductUnitState =
                                                SellerProductUnitState.loading;
                                            sellerProductUnitListProvider
                                                .getProductUnitApiProvider(
                                                    context: context);
                                            sellerProductUnitListProvider
                                                    .startedApiCalling =
                                                !sellerProductUnitListProvider
                                                    .startedApiCalling;
                                          }
                                          if (sellerProductUnitListProvider
                                                  .sellerProductUnitState ==
                                              SellerProductUnitState.loaded) {
                                            return ListView(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              children: List.generate(
                                                sellerProductUnitListProvider
                                                    .productUnits.length,
                                                (index) {
                                                  ProductUnitData productUnit =
                                                      sellerProductUnitListProvider
                                                          .productUnits[index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      sellerProductUnitListProvider
                                                          .productUnitSingleSelection(
                                                              id: productUnit.id
                                                                  .toString(),
                                                              name: productUnit
                                                                  .name
                                                                  .toString());

                                                      edtProductUnit.text =
                                                          sellerProductUnitListProvider
                                                              .selectedProductUnitNamesList[0];
                                                      selectedUnitId =
                                                          sellerProductUnitListProvider
                                                              .selectedProductUnitIdsList[0];

                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsetsDirectional
                                                              .only(bottom: 15),
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .all(15),
                                                      decoration: BoxDecoration(
                                                        color: (sellerProductUnitListProvider
                                                                    .selectedProductUnitIdsList
                                                                    .isNotEmpty &&
                                                                productUnit
                                                                        .id ==
                                                                    sellerProductUnitListProvider
                                                                            .selectedProductUnitIdsList[
                                                                        0])
                                                            ? ColorsRes.appColor
                                                            : Theme.of(context)
                                                                .cardColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: ColorsRes
                                                              .appColor,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.storefront,
                                                            color: (sellerProductUnitListProvider
                                                                        .selectedProductUnitIdsList
                                                                        .isNotEmpty &&
                                                                    productUnit
                                                                            .id ==
                                                                        sellerProductUnitListProvider.selectedProductUnitIdsList[
                                                                            0])
                                                                ? ColorsRes
                                                                    .appColorWhite
                                                                : ColorsRes
                                                                    .appColor,
                                                            size: 35,
                                                          ),
                                                          Widgets.getSizedBox(
                                                              width: 20),
                                                          Expanded(
                                                            child:
                                                                CustomTextLabel(
                                                              text: sellerProductUnitListProvider
                                                                  .productUnits[
                                                                      index]
                                                                  .name,
                                                              style: TextStyle(
                                                                color: (sellerProductUnitListProvider
                                                                            .selectedProductUnitIdsList
                                                                            .isNotEmpty &&
                                                                        productUnit.id ==
                                                                            sellerProductUnitListProvider.selectedProductUnitIdsList[
                                                                                0])
                                                                    ? ColorsRes
                                                                        .appColorWhite
                                                                    : ColorsRes
                                                                        .appColor,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                          if (sellerProductUnitListProvider
                                                                  .selectedProductUnitIdsList
                                                                  .isNotEmpty &&
                                                              productUnit.id ==
                                                                  sellerProductUnitListProvider
                                                                      .selectedProductUnitIdsList[0])
                                                            Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color: ColorsRes
                                                                  .appColorWhite,
                                                              size: 35,
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          } else if (sellerProductUnitListProvider
                                                  .sellerProductUnitState ==
                                              SellerProductUnitState.loading) {
                                            return ListView(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              children: List.generate(
                                                5,
                                                (index) {
                                                  return CustomShimmer(
                                                    margin:
                                                        EdgeInsetsDirectional
                                                            .only(bottom: 10),
                                                    height: 75,
                                                    borderRadius: 10,
                                                  );
                                                },
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              child: Center(
                                                child: CustomTextLabel(
                                                  jsonKey:
                                                      "variant_blank_message",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: ColorsRes.menuTitleColor,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        //Store Name
        CustomTextLabel(
          jsonKey: "product_current_stock_availability_title",
          style: TextStyle(
            color: ColorsRes.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        Row(
          children: [
            FlutterSwitch(
              width: 80,
              value: stockAvailableStatus,
              showOnOff: true,
              activeColor: Theme.of(context).cardColor,
              inactiveColor: Theme.of(context).cardColor,
              activeTextColor: ColorsRes.appColor,
              toggleColor: ColorsRes.appColor,
              inactiveTextColor: ColorsRes.appColor,
              activeText: "Yes",
              inactiveText: "No",
              onToggle: (val) {
                setState(() {
                  stockAvailableStatus = val;
                });
              },
            ),
            Spacer()
          ],
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        //Store Name
        CustomTextLabel(
          jsonKey: "product_current_stock_title",
          style: TextStyle(
            color: ColorsRes.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                try {
                  if (edtProductStock.text.toString() != "0") {
                    edtProductStock.text =
                        (int.parse(edtProductStock.text.toString()) - 1)
                            .toString();
                    setState(() {});
                  }
                } catch (e) {
                  GeneralMethods.showMessage(
                      context, e.toString(), MessageType.warning);
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
                padding: EdgeInsetsDirectional.only(start: 10, end: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
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
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                try {
                  edtProductStock.text = (int.parse(
                              edtProductStock.text.toString().isEmpty
                                  ? "0"
                                  : edtProductStock.text.toString()) +
                          1)
                      .toString();
                  setState(() {});
                } catch (e) {
                  GeneralMethods.showMessage(
                      context, e.toString(), MessageType.warning);
                }
              },
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: ColorsRes.appColor,
                size: 40,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget productFinalPreview() {
    List<String?> images = [
      selectedProductMainImage,
      ...selectedProductOtherImages,
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.40,
            pinned: true,
            centerTitle: true,
            title: CustomTextLabel(
              jsonKey: "product_variant_title",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: ColorsRes.mainTextColor,
              ),
            ),
            backgroundColor: Theme.of(context).cardColor,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: ChangeNotifierProvider(
                create: (context) => SellerSliderImagesProvider(),
                builder: (context, child) {
                  return SellerProductSliderImagesWidgets(
                    sliders: images,
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextLabel(
                            jsonKey: edtProductName.text,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: ColorsRes.mainTextColor,
                            ),
                          ),
                          CustomTextLabel(
                            text: "€${edtProductPrice.text}",
                            style: TextStyle(
                              fontSize: 24,
                              color: ColorsRes.mainTextColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Widgets.getSizedBox(height: 10),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: stockAvailableStatus
                                ? Colors.green
                                : Colors.red,
                            radius: 5,
                          ),
                          SizedBox(width: 10),
                          CustomTextLabel(
                            text:
                                "${edtProductStock.text} ${edtProductUnit.text} ${context.read<LanguageProvider>().currentLanguage["in_stock"]}",
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorsRes.subTitleMainTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Widgets.getSizedBox(height: 10),
                      CustomTextLabel(
                        text:
                            "${context.read<LanguageProvider>().currentLanguage["dietary_type"]}:${selectedDietaryType}",
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorsRes.mainTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Widgets.getSizedBox(height: 10),
                      Divider(
                        color: ColorsRes.menuTitleColor,
                      ),
                      Widgets.getSizedBox(height: 10),
                      HtmlWidget(
                        edtProductDescription.text.toString(),
                        enableCaching: true,
                        renderMode: RenderMode.column,
                        buildAsync: false,
                        textStyle: TextStyle(
                          color: ColorsRes.mainTextColor,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  imgWidget(String fileName) {
    return GestureDetector(
      onTap: () {
        try {
          OpenFilex.open(fileName);
        } catch (e) {
          GeneralMethods.showMessage(
              context, e.toString(), MessageType.warning);
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
                width: 90,
                height: 90,
                fit: BoxFit.fill,
              ),
            ),
    );
  }

  // 1. CATEGORY SCREEN VALIDATION
  void categorySelectionValidation() async {
    try {
      if (context
          .read<SellerCategoryListProvider>()
          .selectedCategoryIdsList
          .isEmpty) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "please_select_category"),
            MessageType.warning);
      } else {
        currentPage++;
        pageController.animateToPage(currentPage,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    } catch (e) {
      GeneralMethods.showMessage(context, e.toString(), MessageType.warning);
    }
  }

  // 2. PRODUCT NAME AND DESCRIPTION SCREEN VALIDATION
  void productDescriptionValidation() async {
    try {
      if (edtProductName.text.isEmpty) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "product_name_validation_message"),
            MessageType.warning);
      } else if (edtProductDescription.text.isEmpty) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(
                context, "product_description_validation_message"),
            MessageType.warning);
      } else {
        currentPage++;
        pageController.animateToPage(currentPage,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    } catch (e) {
      GeneralMethods.showMessage(context, e.toString(), MessageType.warning);
    }
  }

  // 3. PRODUCT PRICE AND OTHER DETAILS SCREEN
  void productVariantDetailValidation() async {
    try {
      if (edtProductPrice.text.isEmpty) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "product_price_validation_title"),
            MessageType.warning);
      } else if (edtProductUnit.text.isEmpty) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "product_unit_validation_title"),
            MessageType.warning);
      } else if (edtProductStock.text.isEmpty) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "product_stock_validation_title"),
            MessageType.warning);
      } else {
        currentPage++;
        pageController.animateToPage(currentPage,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    } catch (e) {
      GeneralMethods.showMessage(context, e.toString(), MessageType.warning);
    }
  }

  // 4. DIETARY TYPE SCREEN
  void dietarySelectionValidation() async {
    try {
      if (context
          .read<SellerDietaryListProvider>()
          .selectedDietaryIdsList
          .isEmpty) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "please_select_dietary_type"),
            MessageType.warning);
      } else {
        currentPage++;
        pageController.animateToPage(currentPage,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    } catch (e) {
      GeneralMethods.showMessage(context, e.toString(), MessageType.warning);
    }
  }

  // 5. PRODUCT PHOTOS SCREEN VALIDATION
  void productImageSelectionValidation() async {
    try {
      if (selectedProductMainImage.isEmpty) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "please_select_main_image"),
            MessageType.warning);
      } else {
        currentPage++;
        pageController.animateToPage(currentPage,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    } catch (e) {
      GeneralMethods.showMessage(context, e.toString(), MessageType.warning);
    }
  }

  @override
  void dispose() {
    edtProductName.dispose();
    pageController.dispose();
    super.dispose();
  }
}

class CustomNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only digits (0-9) and ignore decimal values without a point
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (RegExp(r'^[0-9]*$').hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
    return newValue;
  }
}
