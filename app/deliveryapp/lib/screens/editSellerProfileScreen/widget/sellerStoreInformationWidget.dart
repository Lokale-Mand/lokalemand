import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';import 'package:html_editor_enhanced/html_editor.dart';
import 'package:flutter/material.dart';

class SellerStoreInformationWidget extends StatefulWidget {
  final Map<String, String> personalData;
  final Map<String, String> personalDataFile;

  const SellerStoreInformationWidget(
      {Key? key, required this.personalData, required this.personalDataFile})
      : super(key: key);

  @override
  State<SellerStoreInformationWidget> createState() => SellerStoreInformationWidgetState();
}

class SellerStoreInformationWidgetState extends State<SellerStoreInformationWidget> {
  late TextEditingController edtCategoryIds,
      edtStoreName,
      edtStoreUrl,
      edtStoreLogo,
      edtStoreDescription,
      edtTaxName,
      edtTaxNumber,
      /*edtCommission,*/
      edtSelectCity;

  final formKey = GlobalKey<FormState>();
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();

  @override
  void initState() {
      edtCategoryIds = TextEditingController(
        text: widget.personalData[ApiAndParams.categories] == null
            ? Constant.session.getData(SessionManager.categories)
            : widget.personalData[ApiAndParams.categories],
      );
      edtStoreName = TextEditingController(
        text: widget.personalData[ApiAndParams.store_name] == null
            ? Constant.session.getData(SessionManager.store_name)
            : widget.personalData[ApiAndParams.store_name],
      );
      edtStoreUrl = TextEditingController(
        text: widget.personalData[ApiAndParams.store_url] == null
            ? Constant.session.getData(SessionManager.store_url)
            : widget.personalData[ApiAndParams.store_url],
      );
      edtStoreLogo = TextEditingController(
        text: widget.personalDataFile[ApiAndParams.store_logo] == null
            ? Constant.session.getData(SessionManager.logo_url)
            : widget.personalDataFile[ApiAndParams.store_logo],
      );
      edtStoreDescription = TextEditingController(
        text: widget.personalData[ApiAndParams.store_description] == null
            ? Constant.session.getData(SessionManager.store_description)
            : widget.personalData[ApiAndParams.store_description],
      );

      /*edtCommission = TextEditingController(
      text: widget.personalData[ApiAndParams.commission] == null
          ? Constant.session.getData(SessionManager.commission)
          : widget.personalData[ApiAndParams.commission],
      );*/
      edtTaxName = TextEditingController(
        text: widget.personalData[ApiAndParams.tax_name] == null
            ? Constant.session.getData(SessionManager.tax_name)
            : widget.personalData[ApiAndParams.tax_name],
      );
      edtTaxNumber = TextEditingController(
        text: widget.personalData[ApiAndParams.tax_number] == null
            ? Constant.session.getData(SessionManager.tax_number)
            : widget.personalData[ApiAndParams.tax_number],
      );

      edtSelectCity = TextEditingController(
        text: widget.personalData[ApiAndParams.state] == null
            ? Constant.session.getData(SessionManager.city_id)
            : widget.personalData[ApiAndParams.state],
      );


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: DesignConfig.setRoundedBorder(7),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Constant.paddingOrMargin10,
          vertical: Constant.paddingOrMargin10,
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranslatedValue(context, "store_information"),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              Divider(
                height: 15,
              ),
              ChangeNotifierProvider(
                create: (context) => CategoryListProvider(),
                child: editBoxWidget(
                  context: context,
                  edtController: edtCategoryIds,
                  validationFunction: GeneralMethods.emptyValidation,
                  label: getTranslatedValue(context, "category_ids"),
                  inputType: TextInputType.none,
                  tailIcon: GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        shape: DesignConfig.setRoundedBorderSpecific(20,
                            istop: true),
                        builder: (BuildContext context) {
                          return ChangeNotifierProvider(
                            create: (context) => CategoryListProvider(),
                            child: Container(
                              padding: EdgeInsetsDirectional.only(
                                  start: Constant.paddingOrMargin15,
                                  end: Constant.paddingOrMargin15,
                                  top: Constant.paddingOrMargin15,
                                  bottom: Constant.paddingOrMargin15),
                              child: Wrap(
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: Constant.paddingOrMargin10,
                                        end: Constant.paddingOrMargin10),
                                    child: Text(
                                      getTranslatedValue(
                                          context, "select_categories"),
                                      softWrap: true,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsetsDirectional.only(
                                        start: Constant.paddingOrMargin10,
                                        end: Constant.paddingOrMargin10,
                                        top: Constant.paddingOrMargin10,
                                        bottom: Constant.paddingOrMargin10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Consumer<CategoryListProvider>(
                                          builder: (context,
                                              categoryListProvider, _) {
                                            if (!categoryListProvider
                                                .startedApiCalling) {
                                              if (edtCategoryIds.text
                                                      .toString()
                                                      .length >
                                                  0) {
                                                categoryListProvider
                                                    .selectedCategories
                                                    .clear();
                                                categoryListProvider
                                                        .selectedCategories =
                                                    edtCategoryIds.text
                                                        .split(",");
                                              }

                                              categoryListProvider
                                                      .categoryState =
                                                  CategoryState.loading;
                                              categoryListProvider
                                                  .getCategoryApiProviderForRegistration(
                                                      context: context);
                                              categoryListProvider
                                                      .startedApiCalling =
                                                  !categoryListProvider
                                                      .startedApiCalling;
                                            }
                                            return categoryListProvider
                                                        .categoryState ==
                                                    CategoryState.loaded
                                                ? GridView.builder(
                                                    itemCount:
                                                        categoryListProvider
                                                            .categories.length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      CategoryData category =
                                                          categoryListProvider
                                                                  .categories[
                                                              index];

                                                      categoryListProvider
                                                              .subCategoriesList[
                                                          categoryListProvider
                                                                  .selectedCategoryIdsList[
                                                              categoryListProvider
                                                                      .selectedCategoryIdsList
                                                                      .length -
                                                                  1]] = categoryListProvider
                                                          .categories;

                                                      return CategoryItemContainer(
                                                        category: category,
                                                        voidCallBack: () {
                                                          categoryListProvider
                                                              .addOrRemoveCategoryFromSelection(
                                                                  category.id
                                                                      .toString());
                                                        },
                                                      );
                                                    },
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            childAspectRatio:
                                                                0.8,
                                                            crossAxisCount: 3,
                                                            crossAxisSpacing:
                                                                10,
                                                            mainAxisSpacing:
                                                                10),
                                                  )
                                                : categoryListProvider
                                                            .categoryState ==
                                                        CategoryState.loading
                                                    ? getCategoryShimmer(
                                                        context: context,
                                                        count: 6,
                                                        padding:
                                                            EdgeInsets.zero,
                                                      )
                                                    : SizedBox.shrink();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Consumer<CategoryListProvider>(
                                    builder:
                                        (context, categoryListProvider, child) {
                                      return Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 10, end: 10),
                                        child: Widgets.gradientBtnWidget(
                                          context,
                                          10,
                                          title: getTranslatedValue(
                                              context, "done"),
                                          callback: () {
                                            edtCategoryIds.text =
                                                categoryListProvider
                                                    .selectedCategories
                                                    .toString()
                                                    .replaceAll("]", "")
                                                    .replaceAll(" ", "")
                                                    .replaceAll("[", "");

                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(10),
                      child: Widgets.defaultImg(
                        image: "select_categories",
                        iconColor: ColorsRes.appColor,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Widgets.getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtStoreName,
                validationFunction: GeneralMethods.emptyValidation,
                label: getTranslatedValue(context, "store_name"),
                inputType: TextInputType.text,
              ),
              Widgets.getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtStoreUrl,
                validationFunction: GeneralMethods.optionalFieldValidation,
                label: getTranslatedValue(context, "store_url"),
                inputType: TextInputType.text,
              ),
              Widgets.getSizedBox(
                height: 10,
              ),
/*              editBoxWidget(
                context: context,
                edtController: edtCommission,
                validationFunction: GeneralMethods.percentageValidation,
                label: getTranslatedValue(context, "commission"),
                inputType: TextInputType.number,
              ),
              Widgets.getSizedBox(
                height: 10,
              ),*/
              editBoxWidget(
                context: context,
                edtController: edtTaxName,
                validationFunction: GeneralMethods.emptyValidation,
                label: getTranslatedValue(context, "tax_name"),
                inputType: TextInputType.text,
              ),
              Widgets.getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtTaxNumber,
                validationFunction: GeneralMethods.emptyValidation,
                label: getTranslatedValue(context, "tax_number"),
                inputType: TextInputType.text,
              ),
              Widgets.getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtStoreLogo,
                validationFunction: GeneralMethods.emptyValidation,
                label: getTranslatedValue(context, "store_logo"),
                inputType: TextInputType.none,
                tailIcon: GestureDetector(
                  onTap: () {
                    // Single file path
                    GeneralMethods.getFileFromDevice().then(
                      (value) {
                        edtStoreLogo.text = value;
                      },
                    );
                  },
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(10),
                    child: Widgets.defaultImg(
                      image: "file_icon",
                      iconColor: ColorsRes.appColor,
                    ),
                  ),
                ),
              ),
              Widgets.getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtStoreDescription,
                validationFunction: GeneralMethods.emptyValidation,
                label: getTranslatedValue(context, "store_description"),
                inputType: TextInputType.none,
                tailIcon: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, htmlEditorScreen,
                            arguments: edtStoreDescription.text.toString())
                        .then((value) {
                      edtStoreDescription.text = value.toString();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(10),
                    child: Widgets.defaultImg(
                      image: "description_icon",
                      iconColor: ColorsRes.appColor,
                    ),
                  ),
                ),
              ),
              Widgets.getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtSelectCity,
                validationFunction: GeneralMethods.emptyValidation,
                label: getTranslatedValue(context, "select_city"),
                inputType: TextInputType.none,
                tailIcon: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, getLocationScreen).then(
                      (value) {
                        widget.personalData
                            .addAll(value as Map<String, String>);
                        edtSelectCity.text =
                            value[ApiAndParams.formatted_address] ?? "";
                      },
                    );
                  },
                  icon: Icon(
                    Icons.my_location_rounded,
                    color: ColorsRes.appColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
