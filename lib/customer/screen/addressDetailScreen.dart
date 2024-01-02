import 'package:lokale_mand/helper/utils/generalImports.dart';

class AddressDetailScreen extends StatefulWidget {
  const AddressDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddressDetailScreen> createState() => _AddressDetailScreenState();
}

class _AddressDetailScreenState extends State<AddressDetailScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController edtAddress = TextEditingController();
  final TextEditingController edtLandmark = TextEditingController();
  final TextEditingController edtCity = TextEditingController();
  final TextEditingController edtArea = TextEditingController();
  final TextEditingController edtZipcode = TextEditingController();
  final TextEditingController edtState = TextEditingController();
  String longitude = "";
  String latitude = "";
  late AddressData? address;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        try {
          if (Constant.session
              .getData(SessionManager.keyShippingAddress)
              .isNotEmpty) {
            address = AddressData.fromJson(
              jsonDecode(
                Constant.session.getData(SessionManager.keyShippingAddress),
              ),
            );

            edtAddress.text = address?.address ?? "";
            edtLandmark.text = address?.landmark ?? "";
            edtCity.text = address?.city ?? "";
            edtArea.text = address?.area ?? "";
            edtZipcode.text = address?.pincode ?? "";
            edtState.text = address?.state ?? "";
            longitude = address?.longitude ?? "";
            latitude = address?.latitude ?? "";
            setState(() {});
          }
        } catch (_) {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: "address_detail",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ColorsRes.mainTextColor,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10.0),
        child: Widgets.gradientBtnWidget(
          context,
          8,
          height: 45,
          title: getTranslatedValue(
            context,
            Constant.session
                    .getData(SessionManager.keyShippingAddress)
                    .isNotEmpty
                ? "update"
                : "add",
          ),
          callback: () async {
            formKey.currentState!.save();
            if (formKey.currentState!.validate()) {
              if (longitude.isNotEmpty && latitude.isNotEmpty) {
                Map<String, String> params = {};
                try {
                  String id = address?.id.toString() ?? "";

                  if (id.isNotEmpty) {
                    params[ApiAndParams.id] = id;
                  }
                } catch (ignore) {}
                params[ApiAndParams.name] =
                    Constant.session.getData(SessionManager.keyUserName);
                params[ApiAndParams.mobile] =
                    Constant.session.getData(SessionManager.keyPhone);

                params[ApiAndParams.type] = "other";

                params[ApiAndParams.address] =
                    edtAddress.text.trim().toString();
                params[ApiAndParams.landmark] =
                    edtLandmark.text.trim().toString();
                params[ApiAndParams.area] = edtArea.text.trim().toString();
                params[ApiAndParams.pinCode] =
                    edtZipcode.text.trim().toString();
                params[ApiAndParams.city] = edtCity.text.trim().toString();
                params[ApiAndParams.state] = edtState.text.trim().toString();
                params[ApiAndParams.country] = "Netherlands";
                params[ApiAndParams.latitude] = latitude;
                params[ApiAndParams.longitude] = longitude;
                params[ApiAndParams.isDefault] = "1";

                setState(
                  () {
                    isLoading = !isLoading;
                  },
                );
                context.read<AddressProvider>().addOrUpdateAddress(
                    context: context, params: params, function: () {
                      Navigator.pop(context);
                });
              } else {
                setState(
                  () {
                    isLoading = !isLoading;
                  },
                );
                GeneralMethods.showMessage(
                  context,
                  getTranslatedValue(
                    context,
                    "please_select_address_from_map",
                  ),
                  MessageType.warning,
                );
              }
            }
          },
        ),
      ),
      body: Stack(
        children: [
          ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.size10, vertical: Constant.size10),
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      addressDetailWidget(),
                    ],
                  ),
                ),
              ]),
          isLoading == true
              ? PositionedDirectional(
                  top: 0,
                  end: 0,
                  start: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  addressDetailWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextLabel(
              jsonKey: "address_details",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: ColorsRes.mainTextColor,
              ),
            ),
            Widgets.getSizedBox(
              height: 15,
            ),
            editBoxWidget(
              context,
              edtAddress,
              GeneralMethods.emptyValidation,
              getTranslatedValue(
                context,
                "address",
              ),
              getTranslatedValue(
                context,
                "please_select_address_from_map",
              ),
              TextInputType.text,
              tailIcon: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, confirmLocationScreen,
                          arguments: "address_detail")
                      .then(
                    (value) {
                      edtAddress.text = Constant.cityAddressMap["address"];

                      edtCity.text = Constant.cityAddressMap["city"];

                      edtArea.text = Constant.cityAddressMap["area"];

                      edtLandmark.text = edtLandmark.text.toString().isNotEmpty
                          ? edtLandmark.text.toString()
                          : Constant.cityAddressMap["landmark"];

                      edtZipcode.text = edtZipcode.text.isNotEmpty
                          ? edtZipcode.text.toString()
                          : Constant.cityAddressMap["pin_code"];

                      edtState.text =
                          Constant.cityAddressMap["state"].toString().isNotEmpty
                              ? Constant.cityAddressMap["state"].toString()
                              : "";

                      longitude =
                          Constant.cityAddressMap["longitude"].toString();

                      latitude = Constant.cityAddressMap["latitude"].toString();
                      setState(
                        () {},
                      );
                      formKey.currentState?.validate();
                    },
                  );
                },
                icon: Icon(
                  Icons.my_location_rounded,
                  color: ColorsRes.appColor,
                ),
              ),
            ),
            SizedBox(height: Constant.size15),
            editBoxWidget(
                context,
                edtLandmark,
                GeneralMethods.emptyValidation,
                getTranslatedValue(
                  context,
                  "landmark",
                ),
                getTranslatedValue(
                  context,
                  "enter_landmark",
                ),
                TextInputType.text),
            SizedBox(height: Constant.size15),
            editBoxWidget(
                context,
                edtCity,
                GeneralMethods.emptyValidation,
                getTranslatedValue(
                  context,
                  "city",
                ),
                getTranslatedValue(
                  context,
                  "please_select_address_from_map",
                ),
                TextInputType.text,
                isEditable: false),
            SizedBox(height: Constant.size15),
            editBoxWidget(
              context,
              edtArea,
              GeneralMethods.emptyValidation,
              getTranslatedValue(
                context,
                "area",
              ),
              getTranslatedValue(
                context,
                "enter_area",
              ),
              TextInputType.text,
            ),
            SizedBox(height: Constant.size15),
            editBoxWidget(
              context,
              edtZipcode,
              GeneralMethods.emptyValidation,
              getTranslatedValue(
                context,
                "pin_code",
              ),
              getTranslatedValue(
                context,
                "enter_pin_code",
              ),
              TextInputType.text,
            ),
            SizedBox(height: Constant.size15),
            editBoxWidget(
              context,
              edtState,
              GeneralMethods.emptyValidation,
              getTranslatedValue(
                context,
                "state",
              ),
              getTranslatedValue(
                context,
                "enter_state",
              ),
              TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }
}
