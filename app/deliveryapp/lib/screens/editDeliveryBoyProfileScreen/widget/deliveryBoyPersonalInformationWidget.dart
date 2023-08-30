import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';import 'package:flutter/material.dart';

class DeliveryBoyPersonalInformationWidget extends StatefulWidget {
  final Map<String, String> personalData;
  final Map<String, String> personalDataFile;

  const DeliveryBoyPersonalInformationWidget(
      {Key? key, required this.personalData, required this.personalDataFile})
      : super(key: key);

  @override
  State<DeliveryBoyPersonalInformationWidget> createState() =>
      DeliveryBoyPersonalInformationWidgetState();
}

class DeliveryBoyPersonalInformationWidgetState extends State<DeliveryBoyPersonalInformationWidget> {

  late TextEditingController edtDeliveryBoyUsername,
      edtDeliveryBoyMobile,
      edtDeliveryBoyDateOfBirth,
      edtDeliveryBoyAddress,
      edtDeliveryBoyNationalIdentityCardFilePath,
      edtDeliveryBoyDrivingLicenseFilePath;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    edtDeliveryBoyUsername = TextEditingController(
      text: widget.personalData[ApiAndParams.name] == null
          ? Constant.session.getData(SessionManager.name)
          : widget.personalData[ApiAndParams.name],
    );
    edtDeliveryBoyMobile = TextEditingController(
      text: widget.personalData[ApiAndParams.mobile] == null
          ? Constant.session.getData(SessionManager.mobile)
          : widget.personalData[ApiAndParams.mobile],
    );
    edtDeliveryBoyDateOfBirth = TextEditingController(
      text: widget.personalData[ApiAndParams.dob] == null
          ? Constant.session.getData(SessionManager.dob)
          : widget.personalData[ApiAndParams.dob],
    );
    edtDeliveryBoyNationalIdentityCardFilePath = TextEditingController(
      text: widget.personalDataFile[ApiAndParams.national_identity_card] == null
          ? Constant.session.getData(SessionManager.national_identity_card)
          : widget.personalDataFile[ApiAndParams.national_identity_card],
    );
    edtDeliveryBoyDrivingLicenseFilePath = TextEditingController(
      text: widget.personalDataFile[ApiAndParams.driving_license] == null
          ? Constant.session.getData(SessionManager.driving_license)
          : widget.personalDataFile[ApiAndParams.driving_license],
    );
    edtDeliveryBoyAddress = TextEditingController(
      text: widget.personalData[ApiAndParams.address] == null
          ? Constant.session.getData(SessionManager.address)
          : widget.personalData[ApiAndParams.address],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsetsDirectional.all(15),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranslatedValue(context, "personal_information"),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              Divider(
                height: 15,
              ),
              editBoxWidget(
                context: context,
                edtController: edtDeliveryBoyUsername,
                validationFunction: GeneralMethods.emptyValidation,
                label: getTranslatedValue(context, "user_name"),
                inputType: TextInputType.text,
              ),
              Widgets.getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtDeliveryBoyDateOfBirth,
                validationFunction: GeneralMethods.emptyValidation,
                label: getTranslatedValue(context, "date_of_birth"),
                inputType: TextInputType.none,
                tailIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          keyboardType: TextInputType.datetime,
                          firstDate: DateTime(1800),
                          lastDate: DateTime.now(),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            // format date in required form here we use yyyy-MM-dd that means time is removed
                            edtDeliveryBoyDateOfBirth.text =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                          } else {
                            edtDeliveryBoyDateOfBirth.text = "";
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(10),
                        child: Widgets.defaultImg(
                          image: "date_picker",
                          iconColor: ColorsRes.appColor,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Widgets.getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtDeliveryBoyMobile,
                validationFunction: GeneralMethods.emptyValidation,
                label: getTranslatedValue(context, "mobile"),
                inputType: TextInputType.phone,
              ),
              Widgets.getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtDeliveryBoyNationalIdentityCardFilePath,
                validationFunction: GeneralMethods.emptyValidation,
                label: getTranslatedValue(
                    context, "national_identification_card"),
                inputType: TextInputType.none,
                isEditable: true,
                tailIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Single file path
                        GeneralMethods.getFileFromDevice().then(
                          (value) {
                            edtDeliveryBoyNationalIdentityCardFilePath.text = value;
                          },
                        );
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(10),
                        child: Widgets.defaultImg(
                          image: "file_icon",
                          iconColor: ColorsRes.appColor,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Widgets.getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtDeliveryBoyDrivingLicenseFilePath,
                validationFunction: GeneralMethods.emptyValidation,
                label: getTranslatedValue(context, "address_proof"),
                inputType: TextInputType.none,
                tailIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Single file path
                        GeneralMethods.getFileFromDevice().then((value) {
                          edtDeliveryBoyDrivingLicenseFilePath.text = value;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(10),
                        child: Widgets.defaultImg(
                          image: "file_icon",
                          iconColor: ColorsRes.appColor,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Widgets.getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtDeliveryBoyAddress,
                validationFunction: GeneralMethods.emptyValidation,
                label: getTranslatedValue(context, "select_city"),
                inputType: TextInputType.none,
                tailIcon: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, getLocationScreen).then(
                      (value) {
                        Map<String, String> tempMap =
                            value as Map<String, String>;

                        widget.personalData.addAll({
                          ApiAndParams.address:
                              tempMap[ApiAndParams.formatted_address].toString(),
                          ApiAndParams.city_id:
                              tempMap[ApiAndParams.city_id].toString(),
                        });
                        edtDeliveryBoyAddress.text =
                            tempMap[ApiAndParams.formatted_address].toString();
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
