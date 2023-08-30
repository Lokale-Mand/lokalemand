
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';

class BottomSheetLanguageListContainer extends StatefulWidget {
  BottomSheetLanguageListContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetLanguageListContainer> createState() =>
      _BottomSheetLanguageListContainerState();
}

class _BottomSheetLanguageListContainerState
    extends State<BottomSheetLanguageListContainer> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      context.read<LanguageProvider>().getAvailableLanguageList(
          params: {ApiAndParams.system_type: "2"}, context: context);

      context.read<LanguageProvider>().setSelectedLanguage(
          Constant.session.getData(SessionManager.keySelectedLanguageId));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
                minHeight: MediaQuery.of(context).size.height * 0.2,
              ),
              padding: EdgeInsetsDirectional.only(
                start: Constant.paddingOrMargin15,
                end: Constant.paddingOrMargin15,
                top: Constant.paddingOrMargin15,
                bottom: Constant.paddingOrMargin15,
              ),
              child: Column(
                children: [
                  Center(
                    child: CustomTextLabel(
                      text: getTranslatedValue(context, "change_language"),
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.merge(
                            TextStyle(letterSpacing: 0.5),
                          ),
                    ),
                  ),
                  Widgets.getSizedBox(
                    height: 10,
                  ),
                  if (languageProvider.languageState == LanguageState.loaded ||
                      languageProvider.languageState == LanguageState.updating)
                    Flexible(
                      child: ListView(
                        children: List.generate(
                          languageProvider.languageList?.data?.length ?? 0,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                languageProvider.setSelectedLanguage(
                                    languageProvider
                                        .languageList!.data![index].id
                                        .toString());
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            start: Constant.paddingOrMargin10),
                                        child: CustomTextLabel(
                                            text: languageProvider.languageList!
                                                    .data![index].name ??
                                                ""),
                                      ),
                                    ),
                                    Radio(
                                      activeColor: ColorsRes.appColor,
                                      value: languageProvider.selectedLanguage,
                                      groupValue: languageProvider
                                          .languageList!.data![index].id
                                          .toString(),
                                      onChanged: (value) {
                                        languageProvider.setSelectedLanguage(
                                            languageProvider
                                                .languageList!.data![index].id
                                                .toString());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  Widgets.getSizedBox(
                    height: 10,
                  ),
                  if (languageProvider.languageState == LanguageState.loading)
                    Column(
                      children: List.generate(
                        8,
                        (index) {
                          return CustomShimmer(
                            height: 26,
                            width: double.maxFinite,
                            margin: EdgeInsetsDirectional.all(10),
                          );
                        },
                      ),
                    ),
                  if (languageProvider.languageState == LanguageState.loaded ||
                      languageProvider.languageState == LanguageState.updating)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Constant.paddingOrMargin10),
                      child: Widgets.gradientBtnWidget(
                        context,
                        10,
                        callback: () {
                          Map<String, String> params = {};
                          params[ApiAndParams.system_type] = "2";
                          params[ApiAndParams.id] =
                              languageProvider.selectedLanguage.toString();
                          languageProvider
                              .getLanguageDataProvider(
                                  params: params, context: context)
                              .then((value) {
                            Navigator.pop(context);
                            if (value is bool) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                mainHomeScreen,
                                (route) => false,
                              );
                            }
                          });
                        },
                        isSetShadow: false,
                        otherWidgets: Container(
                          child: (languageProvider.languageState ==
                                  LanguageState.updating)
                              ? CircularProgressIndicator(
                                  color: ColorsRes.appColorWhite)
                              : CustomTextLabel(
                                  text: getTranslatedValue(
                                    context,
                                    "change",
                                  ),
                                  softWrap: true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .merge(
                                        TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                ),
                        ),
                      ),
                    ),
                  if (languageProvider.languageState == LanguageState.loading)
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: Constant.paddingOrMargin10,
                        start: Constant.paddingOrMargin10,
                        end: Constant.paddingOrMargin10,
                      ),
                      child: CustomShimmer(
                        height: 55,
                        width: double.maxFinite,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
