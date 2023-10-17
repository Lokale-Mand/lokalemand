import 'package:lokale_mand/helper/utils/generalImports.dart';

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
          params: {ApiAndParams.system_type: "1"}, context: context);

      context.read<LanguageProvider>().setSelectedLanguage(
          Constant.session.getData(SessionManager.keySelectedLanguageId));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Column(
          children: [
            Widgets.getSizedBox(
              height: 20,
            ),
            Center(
              child: CustomTextLabel(
                jsonKey: "change_language",
                softWrap: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.merge(
                      TextStyle(
                        letterSpacing: 0.5,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
              ),
            ),
            Widgets.getSizedBox(
              height: 10,
            ),
            if (languageProvider.languageState == LanguageState.loaded ||
                languageProvider.languageState == LanguageState.updating)
              ListView(
                shrinkWrap: true,
                children: List.generate(
                  languageProvider.languageList?.data?.length ?? 0,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        languageProvider.setSelectedLanguage(
                          languageProvider.languageList!.data![index].id
                              .toString(),
                        );
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: Constant.size10),
                              child: CustomTextLabel(
                                text:
                                    "${languageProvider.languageList!.data![index].displayName == 'null' ? languageProvider.languageList!.data![index].name : languageProvider.languageList!.data![index].displayName} - ${languageProvider.languageList!.data![index].code?.toUpperCase()}",
                              ),
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
                                languageProvider.languageList!.data![index].id
                                    .toString(),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
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
                      margin: EdgeInsetsDirectional.all(
                        10,
                      ),
                    );
                  },
                ),
              ),
            if (languageProvider.languageState == LanguageState.loaded ||
                languageProvider.languageState == LanguageState.updating)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.size10,
                ),
                child: Widgets.gradientBtnWidget(
                  context,
                  10,
                  callback: () {
                    Map<String, String> params = {};
                    params[ApiAndParams.system_type] = "1";
                    params[ApiAndParams.id] =
                        languageProvider.selectedLanguage.toString();
                    languageProvider
                        .getLanguageDataProvider(
                      params: params,
                      context: context,
                    )
                        .then((value) {
                      Navigator.pop(context);
                    });
                  },
                  otherWidgets: (languageProvider.languageState ==
                          LanguageState.updating)
                      ? CircularProgressIndicator(
                          color: ColorsRes.appColorWhite)
                      : CustomTextLabel(
                          jsonKey: "change",
                          softWrap: true,
                          style: Theme.of(context).textTheme.titleMedium!.merge(
                                TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        ),
                ),
              ),
            if (languageProvider.languageState == LanguageState.loading)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  top: Constant.size10,
                  start: Constant.size10,
                  end: Constant.size10,
                ),
                child: CustomShimmer(
                  height: 55,
                  width: double.maxFinite,
                ),
              ),
            Widgets.getSizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
