
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class EditSellerProfileScreen extends StatefulWidget {
  EditSellerProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditSellerProfileScreen> createState() =>
      _EditSellerProfileScreenState();
}

class _EditSellerProfileScreenState extends State<EditSellerProfileScreen> {
  bool isLoading = false;
  String selectedImagePath = "";

  final globalKeyPersonalInformationWidgetState =
      GlobalKey<SellerPersonalInformationWidgetState>();
  final globalKeyBankInformationWidgetState =
      GlobalKey<SellerBankInformationWidgetState>();
  final globalKeyStoreInformationWidgetState =
      GlobalKey<SellerStoreInformationWidgetState>();

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
                                color: userProfileProvider.currentPage >= 1
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
                            Expanded(
                              child: Divider(
                                color: userProfileProvider.currentPage >= 2
                                    ? ColorsRes.appColor
                                    : ColorsRes.grey,
                                height: 5,
                                thickness: 5,
                              ),
                            ),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor:
                                  userProfileProvider.currentPage >= 2
                                      ? ColorsRes.appColor
                                      : ColorsRes.grey,
                              child: Text(
                                "3",
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
                          SellerPersonalInformationWidget(
                            key: globalKeyPersonalInformationWidgetState,
                            personalData: registrationData,
                            personalDataFile: registrationDataFiles,
                          ),
                        if (userProfileProvider.currentPage == 1)
                          SellerBankInformationWidget(
                            key: globalKeyBankInformationWidgetState,
                            personalData: registrationData,
                          ),
                        if (userProfileProvider.currentPage == 2)
                          SellerStoreInformationWidget(
                            key: globalKeyStoreInformationWidgetState,
                            personalData: registrationData,
                            personalDataFile: registrationDataFiles,
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
                            title: userProfileProvider.currentPage == 2
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
                                            .currentState?.edtUsername.text ??
                                        "";
                                registrationData[ApiAndParams.email] =
                                    globalKeyPersonalInformationWidgetState
                                            .currentState?.edtEmail.text ??
                                        "";
                                registrationData[ApiAndParams.mobile] =
                                    globalKeyPersonalInformationWidgetState
                                            .currentState?.edtMobile.text ??
                                        "";
                                registrationData[ApiAndParams.pan_number] =
                                    globalKeyPersonalInformationWidgetState
                                            .currentState?.edtPanNumber.text ??
                                        "";

                                if (!globalKeyPersonalInformationWidgetState
                                        .currentState!
                                        .edtNationalIdentityCardFilePath
                                        .text
                                        .contains("https://") ||
                                    !globalKeyPersonalInformationWidgetState
                                        .currentState!
                                        .edtNationalIdentityCardFilePath
                                        .text
                                        .contains("http://")) {
                                  registrationDataFiles[
                                          ApiAndParams.national_id_card] =
                                      globalKeyPersonalInformationWidgetState
                                              .currentState
                                              ?.edtNationalIdentityCardFilePath
                                              .text ??
                                          "";
                                }

                                if (!globalKeyPersonalInformationWidgetState
                                        .currentState!
                                        .edtAddressProofFilePath
                                        .text
                                        .contains("https://") ||
                                    !globalKeyPersonalInformationWidgetState
                                        .currentState!
                                        .edtAddressProofFilePath
                                        .text
                                        .contains("http://")) {
                                  registrationDataFiles[
                                          ApiAndParams.address_proof] =
                                      globalKeyPersonalInformationWidgetState
                                              .currentState
                                              ?.edtAddressProofFilePath
                                              .text ??
                                          "";
                                }

                                userProfileProvider.moveNext();
                              } else if (userProfileProvider.currentPage == 1 &&
                                  globalKeyBankInformationWidgetState
                                          .currentState?.formKey.currentState
                                          ?.validate() ==
                                      true) {
                                //Bank information store action here
                                registrationData[ApiAndParams.bank_name] =
                                    globalKeyBankInformationWidgetState
                                            .currentState?.edtBankName.text ??
                                        "";
                                registrationData[ApiAndParams.account_number] =
                                    globalKeyBankInformationWidgetState
                                            .currentState
                                            ?.edtAccountNumber
                                            .text ??
                                        "";
                                registrationData[ApiAndParams.ifsc_code] =
                                    globalKeyBankInformationWidgetState
                                            .currentState?.edtIFSCCode.text ??
                                        "";
                                registrationData[ApiAndParams.account_name] =
                                    globalKeyBankInformationWidgetState
                                            .currentState
                                            ?.edtAccountName
                                            .text ??
                                        "";

                                userProfileProvider.moveNext();
                              } else if (userProfileProvider.currentPage == 2 &&
                                  globalKeyStoreInformationWidgetState
                                          .currentState?.formKey.currentState
                                          ?.validate() ==
                                      true) {
                                //Store information store action here
                                registrationData[ApiAndParams.categories_ids] =
                                    globalKeyStoreInformationWidgetState
                                            .currentState
                                            ?.edtCategoryIds
                                            .text ??
                                        "";

                                registrationData[ApiAndParams.store_name] =
                                    globalKeyStoreInformationWidgetState
                                            .currentState?.edtStoreName.text ??
                                        "";

                                if (globalKeyStoreInformationWidgetState
                                        .currentState?.edtStoreUrl.text !=
                                    null) {
                                  registrationData[ApiAndParams.store_url] =
                                      globalKeyStoreInformationWidgetState
                                          .currentState!.edtStoreUrl.text;
                                }

                                /*registrationData[ApiAndParams.commission] =
                                    globalKeyStoreInformationWidgetState
                                            .currentState?.edtCommission.text ??
                                        "";*/
                                if (!globalKeyStoreInformationWidgetState
                                        .currentState!.edtStoreLogo.text
                                        .contains("https://") ||
                                    !globalKeyStoreInformationWidgetState
                                        .currentState!.edtStoreLogo.text
                                        .contains("http://")) {
                                  registrationDataFiles[
                                          ApiAndParams.store_logo] =
                                      globalKeyStoreInformationWidgetState
                                              .currentState
                                              ?.edtStoreLogo
                                              .text ??
                                          "";
                                }

                                registrationData[
                                        ApiAndParams.store_description] =
                                    globalKeyStoreInformationWidgetState
                                            .currentState
                                            ?.edtStoreDescription
                                            .text ??
                                        "";

                                registrationData[ApiAndParams.tax_name] =
                                    globalKeyStoreInformationWidgetState
                                            .currentState?.edtTaxName.text ??
                                        "";
                                registrationData[ApiAndParams.tax_number] =
                                    globalKeyStoreInformationWidgetState
                                            .currentState?.edtTaxName.text ??
                                        "";
                                /*
                              1. Personal Information
                              name
                              email
                              mobile
                              pan_number
                              address_proof //file
                              national_id_card //file

                              2. Store Information
                              store_url
                              store_name
                              categories_ids
                              tax_name
                              tax_number
                              store_description
                              store_logo //file

                              3.Bank Information
                              account_number
                              ifsc_code
                              bank_name
                              account_name

                              4. Store Location Information
                              street
                              city_id
                              state
                              latitude
                              longitude
                              place_name
                              formatted_address
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
