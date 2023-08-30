import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';

class EditDeliveryBoyProfileScreen extends StatefulWidget {
  EditDeliveryBoyProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditDeliveryBoyProfileScreen> createState() =>
      _EditDeliveryBoyProfileScreenState();
}

class _EditDeliveryBoyProfileScreenState
    extends State<EditDeliveryBoyProfileScreen> {
  bool isLoading = false;
  String selectedImagePath = "";

  final globalKeyPersonalInformationWidgetState =
      GlobalKey<DeliveryBoyPersonalInformationWidgetState>();
  final globalKeyBankInformationWidgetState =
      GlobalKey<DeliveryBoyBankInformationWidgetState>();

  Map<String, String> registrationData = {};
  Map<String, String> registrationDataFiles = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: Text(
          getTranslatedValue(context, "title_profile"),
          style: TextStyle(
            color: ColorsRes.mainTextColor,
          ),
        ),
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, _) {
          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.all(7),
                    child: Card(
                      margin: EdgeInsetsDirectional.zero,
                      shape: DesignConfig.setRoundedBorder(7),
                      elevation: 0,
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor:
                                  userProfileProvider.currentPage >= 0
                                      ? ColorsRes.appColor
                                      : ColorsRes.grey,
                              child: Text(
                                "1",
                                style: TextStyle(
                                  color: ColorsRes.appColorWhite,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color:
                                    userProfileProvider.currentPage >= 1
                                        ? ColorsRes.appColor
                                        : ColorsRes.grey,
                                height: 5,
                                thickness: 5,
                              ),
                            ),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor:
                                  userProfileProvider.currentPage >= 1
                                      ? ColorsRes.appColor
                                      : ColorsRes.grey,
                              child: Text(
                                "2",
                                style: TextStyle(
                                  color: ColorsRes.appColorWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsetsDirectional.all(5),
                      children: [
                        if (userProfileProvider.currentPage == 0)
                          DeliveryBoyPersonalInformationWidget(
                            key: globalKeyPersonalInformationWidgetState,
                            personalData: registrationData,
                            personalDataFile: registrationDataFiles,
                          ),
                        if (userProfileProvider.currentPage == 1)
                          DeliveryBoyBankInformationWidget(
                            key: globalKeyBankInformationWidgetState,
                            personalData: registrationData,
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.all(10),
                    child: Row(
                      children: [
                        if (userProfileProvider.currentPage != 0)
                          Expanded(
                            child: Widgets.gradientBtnWidget(
                              context,
                              10,
                              title: getTranslatedValue(context, "previous"),
                              isSetShadow: false,
                              callback: () {
                                userProfileProvider.moveBack();
                              },
                            ),
                          ),
                        if (userProfileProvider.currentPage != 0)
                          Widgets.getSizedBox(width: 10),
                        Expanded(
                          child: Widgets.gradientBtnWidget(
                            context,
                            10,
                            title: userProfileProvider.currentPage == 1
                                ? getTranslatedValue(context, "save")
                                : getTranslatedValue(context, "next"),
                            isSetShadow: false,
                            callback: () {
                              if (userProfileProvider.currentPage == 0 &&
                                  globalKeyPersonalInformationWidgetState
                                          .currentState?.formKey.currentState
                                          ?.validate() ==
                                      true) {
                                //Personal information store action here

                                registrationData[ApiAndParams.name] =
                                    globalKeyPersonalInformationWidgetState
                                            .currentState?.edtDeliveryBoyUsername.text ??
                                        "";

                                registrationData[ApiAndParams.mobile] =
                                    globalKeyPersonalInformationWidgetState
                                            .currentState?.edtDeliveryBoyMobile.text ??
                                        "";

                                registrationData[ApiAndParams.dob] =
                                    globalKeyPersonalInformationWidgetState
                                            .currentState?.edtDeliveryBoyDateOfBirth.text ??
                                        "";

                                registrationData[ApiAndParams.address] =
                                    globalKeyPersonalInformationWidgetState
                                            .currentState?.edtDeliveryBoyAddress.text ??
                                        "";

                                registrationDataFiles[ApiAndParams.national_identity_card] =
                                    globalKeyPersonalInformationWidgetState
                                            .currentState?.edtDeliveryBoyNationalIdentityCardFilePath.text ??
                                        "";

                                registrationDataFiles[ApiAndParams.driving_license] =
                                    globalKeyPersonalInformationWidgetState
                                            .currentState?.edtDeliveryBoyDrivingLicenseFilePath.text ??
                                        "";

                                userProfileProvider.moveNext();

                              } else if (userProfileProvider
                                          .currentPage ==
                                      1 &&
                                  globalKeyBankInformationWidgetState
                                          .currentState?.formKey.currentState
                                          ?.validate() ==
                                      true) {
                                //Bank information store action here

                                registrationData[ApiAndParams.bank_name] =
                                    globalKeyBankInformationWidgetState
                                            .currentState?.edtBankName.text ??
                                        "";

                                registrationData[ApiAndParams.ifsc_code] =
                                    globalKeyBankInformationWidgetState
                                            .currentState?.edtIFSCCode.text ??
                                        "";

                                registrationData[ApiAndParams.account_name] =
                                    globalKeyBankInformationWidgetState
                                            .currentState?.edtAccountName.text ??
                                        "";

                                registrationData[ApiAndParams.bank_account_number] =
                                    globalKeyBankInformationWidgetState
                                            .currentState?.edtAccountNumber.text ??
                                        "";

                                /*
                                  1. Personal Information
                                    name
                                    mobile
                                    dob
                                    address
                                    driving_license //file
                                    national_identity_card //file

                                  2. Store Information
                                    bank_name
                                    ifsc_code
                                    account_name
                                    bank_account_number
                                */

                                userProfileProvider.updateUserApiProvider(
                                    context: context,
                                    params: registrationData,
                                    fileParamsNames:
                                        registrationDataFiles.keys.toList(),
                                    fileParamsFilesPath:
                                        registrationDataFiles.values.toList());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (userProfileProvider.updateProfileState ==
                  UpdateProfileState.loading)
                PositionedDirectional(
                  top: 0,
                  end: 0,
                  start: 0,
                  bottom: 0,
                  child: Container(
                    color: ColorsRes.appColorBlack.withOpacity(0.2),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
