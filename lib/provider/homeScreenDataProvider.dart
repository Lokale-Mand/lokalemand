import 'package:lokale_mand/helper/utils/generalImports.dart';

enum HomeScreenState {
  initial,
  loading,
  loaded,
  error,
}

class HomeScreenProvider extends ChangeNotifier {
  HomeScreenState homeScreenState = HomeScreenState.initial;
  String message = '';
  late HomeScreenData homeScreenData;
  Map<String, List<String>> homeOfferImagesMap = {};

  Future getHomeScreenApiProvider(
      {required Map<String, dynamic> params,
      required BuildContext context}) async {
    homeScreenState = HomeScreenState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> data =
          await getHomeScreenDataApi(context: context, params: params);
      if (data[ApiAndParams.status].toString() == "1") {
        homeScreenData = HomeScreenData.fromJson(data[ApiAndParams.data]);
        homeScreenState = HomeScreenState.loaded;
        getSliderImages(homeScreenData.offers);
      } else {
        message = Constant.somethingWentWrong;
        homeScreenState = HomeScreenState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      homeScreenState = HomeScreenState.error;
      notifyListeners();
    }
  }

  Future getSliderImages(List<Offers>? offers) async {
    homeOfferImagesMap = {};
    if (offers != null) {
      for (int i = 0; i < offers.length; i++) {
        Offers offerImage = offers[i];
        if (offerImage.position == "top") {
          if (homeOfferImagesMap.containsKey("top")) {
            homeOfferImagesMap["top"]?.add(offerImage.imageUrl.toString());
          } else {
            homeOfferImagesMap["top"] = [];
            homeOfferImagesMap["top"]?.add(offerImage.imageUrl.toString());
          }
        } else if (offerImage.position == "below_category") {
          if (homeOfferImagesMap.containsKey("below_category")) {
            homeOfferImagesMap["below_category"]
                ?.add(offerImage.imageUrl.toString());
          } else {
            homeOfferImagesMap["below_category"] = [];
            homeOfferImagesMap["below_category"]
                ?.add(offerImage.imageUrl.toString());
          }
        } else if (offerImage.position == "below_slider") {
          if (homeOfferImagesMap.containsKey("below_slider")) {
            homeOfferImagesMap["below_slider"]
                ?.add(offerImage.imageUrl.toString());
          } else {
            homeOfferImagesMap["below_slider"] = [];
            homeOfferImagesMap["below_slider"]
                ?.add(offerImage.imageUrl.toString());
          }
        } else if (offerImage.position == "below_section") {
          if (homeOfferImagesMap
              .containsKey("below_section-${offerImage.sectionPosition}")) {
            homeOfferImagesMap["below_section-${offerImage.sectionPosition}"]
                ?.add(offerImage.imageUrl.toString());
          } else {
            homeOfferImagesMap["below_section-${offerImage.sectionPosition}"] =
                [];
            homeOfferImagesMap["below_section-${offerImage.sectionPosition}"]
                ?.add(offerImage.imageUrl.toString());
          }
        }
      }
    }
    notifyListeners();
  }
}
