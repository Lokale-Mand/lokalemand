import 'package:dotted_border/dotted_border.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lokale_mand/helper/generalWidgets/customCheckbox.dart';
import 'package:lokale_mand/helper/generalWidgets/customRadio.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerCategory.dart';
import 'package:lokale_mand/seller/model/sellerCityByLatLong.dart';
import 'package:lokale_mand/seller/provider/sellerCategoryProvider.dart';
import 'package:lokale_mand/seller/screen/authenticationScreen/widget/sellerCategoryItem.dart';

class SellerCreateAccountScreen extends StatefulWidget {
  const SellerCreateAccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SellerCreateAccountScreen> createState() =>
      _SellerCreateAccountScreenState();
}

enum SellerType { RegularSeller, OrganicSeller }

class _SellerCreateAccountScreenState extends State<SellerCreateAccountScreen> {
  PageController pageController = PageController();
  int currentPage = 0;
  bool isLoading = false,
      isPasswordVisible = false,
      isConfirmPasswordVisible = false;
  bool isDark = Constant.session.getBoolData(SessionManager.isDarkTheme);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late SellerCityByLatLongData cityByLatLongData;

  //PERSONAL DETAILS CONTROLLERS
  TextEditingController edtBankName = TextEditingController();
  TextEditingController edtBankAcNumber = TextEditingController();
  TextEditingController edtBankAcName = TextEditingController();
  TextEditingController edtBankIbanSwiftCode = TextEditingController();
  TextEditingController edtNidNumber = TextEditingController();
  String selectedAddressProofPath = "";
  String selectedNationalIdPath = "";

  SellerType sellerType = SellerType.RegularSeller;

  //STORE DETAILS CONTROLLERS
  String selectedLogoPath = "";
  TextEditingController edtStoreName = TextEditingController();
  TextEditingController edtStoreLocation = TextEditingController();
  TextEditingController edtStoreDescription = TextEditingController();
  TextEditingController edtStoreCategories = TextEditingController();
  String selectedCategoriesIds = "";
  String cityId = "";
  String latitude = "";
  String longitude = "";

  //User Account Details
  CountryCode? selectedCountryCode;
  TextEditingController edtEmail = TextEditingController();
  TextEditingController edtPassword = TextEditingController();
  TextEditingController edtDuplicatePassword = TextEditingController();
  TextEditingController edtFullName = TextEditingController();
  TextEditingController edtPhoneNumber = TextEditingController();

  //STORE HOURS DETAILS CONTROLLERS
  List<StoreTime> storeTime = [
    StoreTime(
        day: "0", storeOpen: "false", openTime: "00:00", closeTime: "00:00"),
    StoreTime(
        day: "1", storeOpen: "false", openTime: "00:00", closeTime: "00:00"),
    StoreTime(
        day: "2", storeOpen: "false", openTime: "00:00", closeTime: "00:00"),
    StoreTime(
        day: "3", storeOpen: "false", openTime: "00:00", closeTime: "00:00"),
    StoreTime(
        day: "4", storeOpen: "false", openTime: "00:00", closeTime: "00:00"),
    StoreTime(
        day: "5", storeOpen: "false", openTime: "00:00", closeTime: "00:00"),
    StoreTime(
        day: "6", storeOpen: "false", openTime: "00:00", closeTime: "00:00"),
  ];

  backendApiProcess() async {
    // Convert List<Model> to List<Map<String, dynamic>>
    List<Map<String, dynamic>> jsonList =
        storeTime.map((model) => model.toJson()).toList();

    // Convert List<Map<String, dynamic>> to JSON string
    String jsonString = jsonEncode(jsonList);

    Map<String, String> params = {
      "name": edtFullName.text.toString(),
      "email": edtEmail.text.toString(),
      "mobile": edtPhoneNumber.text.toString(),
      "password": edtPassword.text.toString(),
      "confirm_password": edtDuplicatePassword.text.toString(),
      "store_name": edtStoreName.text.toString(),
      'categories_ids': selectedCategoriesIds,
      "pan_number": edtNidNumber.text.toString(),
      "city_id": cityId.toString(),
      "latitude": latitude,
      "longitude": longitude,
      "bank_name": edtBankName.text.toString(),
      "account_number": edtBankName.text.toString(),
      "ifsc_code": edtBankIbanSwiftCode.text.toString(),
      "account_name": edtBankAcNumber.text.toString(),
      "commission": "0",
      "require_products_approval": "0",
      "view_order_otp": "0",
      "assign_delivery_boy": "0",
      "status": "1",
      "store_hours": jsonString,
      "type": sellerType == SellerType.RegularSeller ? "1" : "2",
    };

    List<String> fileParamNames = [
      "store_logo",
      "national_id_card",
      "address_proof",
    ];
    List<String> fileParamsFilesPath = [
      selectedLogoPath,
      selectedNationalIdPath,
      selectedAddressProofPath
    ];

    await context
        .read<SellerRegisterProvider>()
        .registerSellerApiProvider(
            context: context,
            params: params,
            fileParamsFilesPath: fileParamsFilesPath,
            fileParamsNames: fileParamNames)
        .then((value) async {
      if (value != null) {
        UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: edtEmail.text,
          password: edtPassword.text,
        );

        User? user = userCredential.user;

        await user?.sendEmailVerification().onError(
          (error, stackTrace) {
            GeneralMethods.showMessage(
              context,
              stackTrace.toString(),
              MessageType.warning,
            );
            return null;
          },
        );
        Navigator.pop(context);
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
            secondCounterText: "${currentPage + 1}/4",
            thirdCounterText: currentPage == 3 ? "I'm ready!" : "next",
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
            //USER DETAILS PAGE
            Container(
              padding: EdgeInsetsDirectional.all(10),
              alignment: Alignment.center,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    createAccountWidgets(),
                  ],
                ),
              ),
            ),
            //STORE DETAILS PAGE
            Container(
              padding: EdgeInsetsDirectional.all(10),
              alignment: Alignment.center,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    storeDetailsWidgets(),
                  ],
                ),
              ),
            ),
            //STORE TIME DETAILS PAGE
            Container(
              padding: EdgeInsetsDirectional.all(10),
              alignment: Alignment.center,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    storeHoursWidgets(),
                  ],
                ),
              ),
            ),
            //PERSONAL DETAILS PAGE
            Container(
              padding: EdgeInsetsDirectional.all(10),
              alignment: Alignment.center,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    personalInformationWidget(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  pageChangeValidation(int currentPage) {
    switch (currentPage) {
      case 0:
        userDetailsValidation();
      case 1:
        storeDetailsValidation();
      case 2:
        storeHoursValidation();
      case 3:
        personalInformationValidation();
      default:
        GeneralMethods.showMessage(
            context, "something_went_wrong", MessageType.warning);
    }
  }

  Widget createAccountWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextLabel(
          jsonKey: "create_your_account",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: ColorsRes.mainTextColor,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        CustomTextLabel(
          jsonKey: "full_name",
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
            controller: edtFullName,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(
                color: Colors.grey[300],
              ),
              hintText: "Lokale Mand",
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        CustomTextLabel(
          jsonKey: "mobile",
          style: TextStyle(
            color: ColorsRes.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size10,
        ),
        mobileNoWidget(),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        CustomTextLabel(
          jsonKey: "email",
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
            controller: edtEmail,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(color: Colors.grey[300]),
              hintText: "lokale-mand@mail.com",
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        CustomTextLabel(
          jsonKey: "password",
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
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: edtPassword,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                  ),
                  obscureText: isPasswordVisible ? false : true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    hintText: "******",
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(
                    () {
                      isPasswordVisible = !isPasswordVisible;
                    },
                  );
                },
                child: Icon(
                  isPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        CustomTextLabel(
          jsonKey: "duplicate_password",
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
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: edtDuplicatePassword,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                  ),
                  obscureText: isConfirmPasswordVisible ? false : true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    hintText: "******",
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(
                    () {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    },
                  );
                },
                child: Icon(
                  isConfirmPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
      ],
    );
  }

  Widget storeDetailsWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Store Name
        CustomTextLabel(
          jsonKey: "about_store_title",
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
          jsonKey: "store_name",
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
            controller: edtStoreName,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(
                color: Colors.grey[300],
              ),
              hintText: "Lokale Mand",
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        CustomTextLabel(
          jsonKey: "store_type",
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
            Expanded(
              child: GestureDetector(
                onTap: () {
                  sellerType = SellerType.RegularSeller;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsetsDirectional.all(8),
                  child: Row(
                    children: [
                      CustomRadio(
                        inactiveColor: ColorsRes.subTitleMainTextColor,
                        value: sellerType,
                        groupValue: SellerType.RegularSeller,
                        activeColor: ColorsRes.appColor,
                        onChanged: (value) {
                          sellerType = SellerType.RegularSeller;
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: CustomTextLabel(
                          jsonKey: "regular_seller",
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  sellerType = SellerType.OrganicSeller;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsetsDirectional.all(8),
                  child: Row(
                    children: [
                      CustomRadio(
                        inactiveColor: ColorsRes.subTitleMainTextColor,
                        value: sellerType,
                        groupValue: SellerType.OrganicSeller,
                        activeColor: ColorsRes.appColor,
                        onChanged: (value) {
                          sellerType = SellerType.OrganicSeller;
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: CustomTextLabel(
                          jsonKey: "organic_seller",
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
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
        //Store Location and Store Categories
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Store Location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextLabel(
                    jsonKey: "store_location",
                    style: TextStyle(
                      color: ColorsRes.mainTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Widgets.getSizedBox(
                    height: Constant.size10,
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.all(8),
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
                            controller: edtStoreLocation,
                            keyboardType: TextInputType.none,
                            canRequestFocus: false,
                            style: TextStyle(
                              color: ColorsRes.mainTextColor,
                            ),
                            decoration: InputDecoration(
                              enabled: false,
                              border: InputBorder.none,
                              isDense: true,
                              hintStyle: TextStyle(
                                color: Colors.grey[300],
                              ),
                              hintText: "Wageningen",
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                    context, sellerConfirmLocationScreen,
                                    arguments: "seller_register")
                                .then((value) {
                              if (value != null &&
                                  value is SellerCityByLatLong) {
                                /*

                                {
                                  'address': possibleLocations.first['formatted_address'],
                                  'city': cityName,
                                  'state': stateName,
                                  'pin_code': pinCode,
                                  'country': countryName,
                                  'area': area,
                                  'landmark': landmark,
                                  'latitude': currentLocation.latitude,
                                  'longitude': currentLocation.longitude,
                                }

                              */
                                edtStoreLocation.text =
                                    Constant.cityAddressMap["address"];
                                cityId = value.data?.first.id.toString() ?? "0";
                                latitude = Constant.cityAddressMap["latitude"]
                                    .toString();
                                longitude = Constant.cityAddressMap["longitude"]
                                    .toString();
                                setState(() {});
                              }
                            });
                          },
                          icon: Icon(
                            Icons.my_location_rounded,
                            color: ColorsRes.appColor,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Categories
            Widgets.getSizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Store Categories
                  CustomTextLabel(
                    jsonKey: "categories",
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: edtStoreCategories,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: ColorsRes.mainTextColor,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintStyle: TextStyle(
                                color: Colors.grey[300],
                              ),
                              hintText: "Select Categories",
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              shape: DesignConfig.setRoundedBorderSpecific(20,
                                  istop: true),
                              builder: (BuildContext context) {
                                return ChangeNotifierProvider(
                                  create: (context) =>
                                      SellerCategoryListProvider(),
                                  child: Container(
                                    padding: EdgeInsetsDirectional.only(
                                        start: 15,
                                        end: 15,
                                        top: 15,
                                        bottom: 15),
                                    child: Wrap(
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              start: 10, end: 10),
                                          child: Text(
                                            getTranslatedValue(
                                                context, "categories"),
                                            softWrap: true,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsetsDirectional.only(
                                              start: 10,
                                              end: 10,
                                              top: 10,
                                              bottom: 10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Consumer<
                                                  SellerCategoryListProvider>(
                                                builder: (context,
                                                    sellerCategoryListProvider,
                                                    _) {
                                                  if (!sellerCategoryListProvider
                                                      .startedApiCalling) {
                                                    sellerCategoryListProvider
                                                            .sellerCategoryState =
                                                        SellerCategoryState
                                                            .loading;
                                                    sellerCategoryListProvider
                                                        .getCategoryApiProviderForRegistration(
                                                            context: context);
                                                    sellerCategoryListProvider
                                                            .startedApiCalling =
                                                        !sellerCategoryListProvider
                                                            .startedApiCalling;
                                                  }
                                                  return sellerCategoryListProvider
                                                              .sellerCategoryState ==
                                                          SellerCategoryState
                                                              .loaded
                                                      ? GridView.builder(
                                                          itemCount:
                                                              sellerCategoryListProvider
                                                                  .categories
                                                                  .length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            CategoryData
                                                                category =
                                                                sellerCategoryListProvider
                                                                        .categories[
                                                                    index];

                                                            return SellerCategoryItemContainer(
                                                              category:
                                                                  category,
                                                              voidCallBack: () {
                                                                sellerCategoryListProvider.addOrRemoveCategoryFromSelection(
                                                                    id: category
                                                                            .id ??
                                                                        "",
                                                                    name: category
                                                                            .name ??
                                                                        "");
                                                                setState(() {});
                                                              },
                                                              isSelected: sellerCategoryListProvider
                                                                  .selectedCategoryIdsList
                                                                  .contains(
                                                                      category
                                                                          .id),
                                                            );
                                                          },
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                                  childAspectRatio:
                                                                      0.8,
                                                                  crossAxisCount:
                                                                      3,
                                                                  crossAxisSpacing:
                                                                      10,
                                                                  mainAxisSpacing:
                                                                      10),
                                                        )
                                                      : sellerCategoryListProvider
                                                                  .sellerCategoryState ==
                                                              CategoryState
                                                                  .loading
                                                          ? getCategoryShimmer(
                                                              context: context,
                                                              count: 6,
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            )
                                                          : SizedBox.shrink();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Consumer<SellerCategoryListProvider>(
                                          builder: (context,
                                              sellerCategoryListProvider,
                                              child) {
                                            return Padding(
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      start: 10, end: 10),
                                              child: Widgets.gradientBtnWidget(
                                                context,
                                                10,
                                                title: getTranslatedValue(
                                                    context, "done"),
                                                callback: () {
                                                  edtStoreCategories.text =
                                                      sellerCategoryListProvider
                                                          .selectedCategoriesNames
                                                          .toString()
                                                          .replaceAll("]", "")
                                                          .replaceAll(" ", "")
                                                          .replaceAll("[", "");
                                                  selectedCategoriesIds =
                                                      sellerCategoryListProvider
                                                          .selectedCategoryIdsList
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
                          child: Container(
                            padding: EdgeInsetsDirectional.all(9),
                            child: Icon(
                              Icons.mode_edit_outline_rounded,
                              color: ColorsRes.appColor,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ), //Store Description
        CustomTextLabel(
          jsonKey: "store_description",
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
            minLines: 3,
            maxLines: 100,
            controller: edtStoreDescription,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(
                color: Colors.grey[300],
              ),
              hintText: "Store description goes here...",
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        //Store Logo
        CustomTextLabel(
          jsonKey: "store_logo",
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
            if (selectedLogoPath.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ColorsRes.textFieldBorderColor,
                  ),
                  color: Theme.of(context).cardColor,
                ),
                height: 105,
                width: 105,
                child: Center(
                  child: imgWidget(selectedLogoPath),
                ),
              ),
            if (selectedLogoPath.isNotEmpty) Widgets.getSizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  // Single file path
                  FilePicker.platform
                      .pickFiles(
                    allowMultiple: false,
                    allowCompression: true,
                    type: FileType.image,
                    lockParentWindow: true,
                  )
                      .then(
                    (value) {
                      cropImage(
                        value!.paths.first.toString(),
                      );
                    },
                  );
                },
                child: DottedBorder(
                  dashPattern: [5],
                  strokeWidth: 2,
                  strokeCap: StrokeCap.round,
                  color: Colors.grey[300]!,
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
                            iconColor: Colors.grey[300],
                            height: 40,
                            width: 40,
                          ),
                          CustomTextLabel(
                            jsonKey: "upload_logo_file_here",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[300],
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
      ],
    );
  }

  // STORE HOURS WIDGETS
  Widget storeHoursWidgets() {
    List lblWeekDaysNames = [
      "week_days_names_sunday",
      "week_days_names_monday",
      "week_days_names_tuesday",
      "week_days_names_wednesday",
      "week_days_names_thursday",
      "week_days_names_friday",
      "week_days_names_saturday",
    ];

    return ListView(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        CustomTextLabel(
          jsonKey: "store_time_title",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: ColorsRes.mainTextColor,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size50,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(7, (index) {
            return Padding(
              padding: EdgeInsetsDirectional.only(bottom: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: CustomCheckbox(
                            value: storeTime[index].storeOpen == "true",
                            onChanged: (value) {
                              storeTime[index].storeOpen =
                                  value == true ? "true" : "false";
                              setState(() {});
                            },
                            checkColor: ColorsRes.appColorWhite,
                            activeColor: ColorsRes.appColor,
                            side: BorderSide(
                              color: ColorsRes.menuTitleColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomTextLabel(
                            overflow: TextOverflow.ellipsis,
                            jsonKey: lblWeekDaysNames[index],
                            softWrap: true,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: storeTime[index].storeOpen == "true"
                                  ? ColorsRes.mainTextColor
                                  : ColorsRes.menuTitleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsetsDirectional.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ColorsRes.menuTitleColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomTextLabel(
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: storeTime[index].openTime,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: storeTime[index].storeOpen == "true"
                                  ? ColorsRes.mainTextColor
                                  : ColorsRes.menuTitleColor,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 24,
                            color: storeTime[index].storeOpen == "true"
                                ? ColorsRes.mainTextColor
                                : ColorsRes.menuTitleColor,
                          )
                        ],
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    onTap: () {
                      if (storeTime[index].storeOpen == "true") {
                        showStoreTimePicker().then((value) {
                          storeTime[index].openTime =
                              value.to24hours().toString();
                          setState(() {});
                        });
                      }
                    },
                  ),
                  Widgets.getSizedBox(width: 10),
                  CustomTextLabel(
                    overflow: TextOverflow.ellipsis,
                    text: "-",
                    softWrap: true,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Widgets.getSizedBox(width: 10),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsetsDirectional.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ColorsRes.menuTitleColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomTextLabel(
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: storeTime[index].closeTime,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: storeTime[index].storeOpen == "true"
                                    ? ColorsRes.mainTextColor
                                    : ColorsRes.menuTitleColor),
                          ),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            color: storeTime[index].storeOpen == "true"
                                ? ColorsRes.mainTextColor
                                : ColorsRes.menuTitleColor,
                          )
                        ],
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    onTap: () {
                      if (storeTime[index].storeOpen == "true") {
                        showStoreTimePicker().then((value) {
                          if (compareTimes(
                                  value,
                                  convertStringToTimeOfDay(
                                      storeTime[index].openTime.toString())) ==
                              1) {
                            storeTime[index].closeTime =
                                value.to24hours().toString();
                          } else {
                            storeTime[index].closeTime = "00:00";
                            GeneralMethods.showMessage(
                                context,
                                "wrong_shop_closing_time_message",
                                MessageType.warning);
                          }
                          setState(() {});
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<TimeOfDay> showStoreTimePicker() async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true,
              ),
              child: child!,
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        return value;
      } else {
        return TimeOfDay(hour: 0, minute: 0);
      }
    });
  }

  int compareTimes(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) {
      return -1;
    } else if (time1.hour > time2.hour) {
      return 1;
    } else {
      if (time1.minute < time2.minute) {
        return -1;
      } else if (time1.minute > time2.minute) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  TimeOfDay convertStringToTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  void storeHoursValidation() async {
    try {
      if (edtEmail.text.isEmpty &&
          GeneralMethods.validateEmail(edtEmail.text) != null) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "enter_valid_email"),
            MessageType.warning);
      } else if (edtPassword.text.contains(" ") ||
          edtDuplicatePassword.text.contains(" ")) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "password_should_not_contain_space"),
            MessageType.warning);
      } else if (edtPassword.text != edtDuplicatePassword.text) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(
                context, "password_and_confirm_password_does_not_matching"),
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

  // STORE HOURS WIDGETS END

  mobileNoWidget() {
    return Container(
      padding: EdgeInsetsDirectional.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: ColorsRes.textFieldBorderColor,
          ),
          color: Theme.of(context).cardColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CountryCodePicker(
            onInit: (countryCode) {
              selectedCountryCode = countryCode;
            },
            onChanged: (countryCode) {
              selectedCountryCode = countryCode;
            },
            initialSelection: Constant.initialCountryCode,
            textOverflow: TextOverflow.ellipsis,
            showCountryOnly: false,
            alignLeft: false,
            backgroundColor: Theme.of(context).cardColor,
            textStyle: TextStyle(color: ColorsRes.mainTextColor),
            dialogBackgroundColor: Theme.of(context).cardColor,
            dialogSize: Size(MediaQuery.sizeOf(context).width,
                MediaQuery.sizeOf(context).height * 0.9),
            showDropDownButton: true,
            padding: EdgeInsets.zero,
          ),
          Expanded(
            child: TextField(
              controller: edtPhoneNumber,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              style: TextStyle(
                color: ColorsRes.mainTextColor,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintStyle: TextStyle(color: Colors.grey[300]),
                hintText: "9999999999",
              ),
            ),
          )
        ],
      ),
    );
  }

  void userDetailsValidation() async {
    try {
      if (edtFullName.text.isEmpty &&
          GeneralMethods.emptyValidation(edtFullName.text) != null) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "enter_valid_name"),
            MessageType.warning);
      } else if (edtEmail.text.isEmpty &&
          GeneralMethods.validateEmail(edtEmail.text) != null) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "enter_valid_email"),
            MessageType.warning);
      } else if (edtPhoneNumber.text.isNotEmpty &&
          GeneralMethods.phoneValidation(edtPhoneNumber.text) != null) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "enter_valid_mobile"),
            MessageType.warning);
      } else if (edtPassword.text.contains(" ") ||
          edtDuplicatePassword.text.contains(" ")) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "password_should_not_contain_space"),
            MessageType.warning);
      } else if (edtPassword.text != edtDuplicatePassword.text) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(
                context, "password_and_confirm_password_does_not_matching"),
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

  void storeDetailsValidation() async {
    try {
      if (edtStoreName.text.isEmpty &&
          GeneralMethods.emptyValidation(edtStoreName.text) != null) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "enter_valid_store_name"),
            MessageType.warning);
      } else if (edtStoreLocation.text.isEmpty &&
          GeneralMethods.emptyValidation(edtStoreLocation.text) != null) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "enter_valid_store_location"),
            MessageType.warning);
      } else if (edtStoreCategories.text.isEmpty) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "enter_valid_store_categories"),
            MessageType.warning);
      } else if (edtStoreDescription.text.isEmpty) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "enter_valid_store_description"),
            MessageType.warning);
      } else if (selectedLogoPath.isEmpty) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "enter_valid_store_logo"),
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

  // STORE HOURS WIDGETS ND

  Widget personalInformationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Store Name
        CustomTextLabel(
          jsonKey: "personal_information_title",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: ColorsRes.mainTextColor,
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        //Bank Name
        CustomTextLabel(
          jsonKey: "bank_name",
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
            controller: edtBankName,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(
                color: Colors.grey[300],
              ),
              hintText: "Lokale Mand",
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        //Bank Account Name
        CustomTextLabel(
          jsonKey: "bank_account_name",
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
            controller: edtBankAcName,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(
                color: Colors.grey[300],
              ),
              hintText: "Lokale Mand",
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        //Bank Account Number
        CustomTextLabel(
          jsonKey: "bank_account_name",
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
            controller: edtBankAcNumber,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(
                color: Colors.grey[300],
              ),
              hintText: "Lokale Mand",
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        // IBAN or SWIFT code
        CustomTextLabel(
          jsonKey: "bank_iban_or_swift_code",
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
            controller: edtBankIbanSwiftCode,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(
                color: Colors.grey[300],
              ),
              hintText: "Lokale Mand",
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        // IBAN or SWIFT code
        CustomTextLabel(
          jsonKey: "national_id_number",
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
            controller: edtNidNumber,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(
                color: Colors.grey[300],
              ),
              hintText: "Lokale Mand",
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size20,
        ),
        //National Id Proof
        CustomTextLabel(
          jsonKey: "national_id_proof",
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
            if (selectedNationalIdPath.isNotEmpty)
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
                  child: imgWidget(selectedNationalIdPath),
                ),
              ),
            if (selectedNationalIdPath.isNotEmpty)
              Widgets.getSizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  // Single file path
                  FilePicker.platform
                      .pickFiles(
                          allowMultiple: false,
                          allowCompression: true,
                          type: FileType.custom,
                          allowedExtensions: ["pdf", "jpg", "jpeg", "png"],
                          lockParentWindow: true)
                      .then((value) {
                    if (value != null) {
                      selectedNationalIdPath = value.paths.first.toString();
                      setState(() {});
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
                            jsonKey: "upload_nid_file_here",
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
          height: Constant.size10,
        ),
        //National Id Proof
        CustomTextLabel(
          jsonKey: "address_id_proof",
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
            if (selectedAddressProofPath.isNotEmpty)
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
                  child: imgWidget(selectedAddressProofPath),
                ),
              ),
            if (selectedAddressProofPath.isNotEmpty)
              Widgets.getSizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  // Single file path
                  FilePicker.platform
                      .pickFiles(
                          allowMultiple: false,
                          allowCompression: true,
                          type: FileType.custom,
                          allowedExtensions: ["pdf", "jpg", "jpeg", "png"],
                          lockParentWindow: true)
                      .then((value) {
                    if (value != null) {
                      selectedAddressProofPath = value.paths.first.toString();
                      setState(() {});
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
                            jsonKey: "upload_address_proof_file_here",
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
          height: Constant.size10,
        ),
      ],
    );
  }

  void personalInformationValidation() async {
    try {
      if (edtBankName.text.isEmpty &&
          GeneralMethods.emptyValidation(edtBankName.text) != null) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "enter_valid_personal_info_bank_name"),
            MessageType.warning);
      } else if (edtBankAcName.text.isEmpty &&
          GeneralMethods.emptyValidation(edtBankAcName.text) != null) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(
                context, "enter_valid_personal_info_bank_ac_name"),
            MessageType.warning);
      } else if (edtBankAcNumber.text.isEmpty &&
          GeneralMethods.emptyValidation(edtBankAcNumber.text) != null) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(
                context, "enter_valid_personal_info_bank_ac_numbers"),
            MessageType.warning);
      } else if (edtBankIbanSwiftCode.text.isEmpty &&
          GeneralMethods.emptyValidation(edtBankIbanSwiftCode.text) != null) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(
                context, "enter_valid_personal_info_bank_ac_iban_swift_code"),
            MessageType.warning);
      } else if (edtNidNumber.text.isEmpty &&
          GeneralMethods.emptyValidation(edtNidNumber.text) != null) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "enter_valid_personal_info_nic_number"),
            MessageType.warning);
      } else if (selectedNationalIdPath.isEmpty) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(context, "enter_valid_personal_info_nic_proof"),
            MessageType.warning);
      } else if (selectedAddressProofPath.isEmpty) {
        GeneralMethods.showMessage(
            context,
            getTranslatedValue(
                context, "enter_valid_personal_info_address_proof"),
            MessageType.warning);
      } else {
        backendApiProcess();
      }
    } catch (e) {
      GeneralMethods.showMessage(context, e.toString(), MessageType.warning);
    }
  }

  // STORE HOURS WIDGETS END

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

  Future<void> cropImage(String filePath) async {
    await ImageCropper()
        .cropImage(
      sourcePath: filePath,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      maxHeight: 1024,
      maxWidth: 1024,
    )
        .then((croppedFile) {
      if (croppedFile != null) {
        setState(() {
          selectedLogoPath = croppedFile.path;
        });
      }
    });
  }

  @override
  void dispose() {
    edtBankName.dispose();
    edtBankAcNumber.dispose();
    edtBankAcName.dispose();
    edtBankIbanSwiftCode.dispose();
    edtNidNumber.dispose();
    edtStoreName.dispose();
    edtStoreLocation.dispose();
    edtStoreDescription.dispose();
    edtStoreCategories.dispose();
    edtEmail.dispose();
    edtPassword.dispose();
    edtDuplicatePassword.dispose();
    edtFullName.dispose();
    edtPhoneNumber.dispose();
    pageController.dispose();
    super.dispose();
  }
}
