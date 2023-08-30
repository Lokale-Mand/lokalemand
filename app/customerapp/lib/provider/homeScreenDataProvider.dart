import 'package:egrocer/helper/utils/generalImports.dart';

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
        notifyListeners();
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

  Future<Map<String, List<String>>> getSliderImages(
      HomeScreenData homeScreenData) async {
    Map<String, List<String>> map = {};

    for (int i = 0; i < homeScreenData.offers.length; i++) {
      Offers offerImage = homeScreenData.offers[i];
      if (offerImage.position == "top") {
        addOfferImagesIntoMap(map, "top", offerImage.imageUrl);
      } else if (offerImage.position == "below_category") {
        addOfferImagesIntoMap(map, "below_category", offerImage.imageUrl);
      } else if (offerImage.position == "below_slider") {
        addOfferImagesIntoMap(map, "below_slider", offerImage.imageUrl);
      } else if (offerImage.position == "below_section") {
        addOfferImagesIntoMap(map,
            "below_section-${offerImage.sectionPosition}", offerImage.imageUrl);
      }
    }
    return map;
  }

  Map<String, List<String>> addOfferImagesIntoMap(
      Map<String, List<String>> map, String key, String imageUrl) {
    if (map.containsKey(key)) {
      map[key]?.add(imageUrl);
    } else {
      map[key] = [];
      map[key]?.add(imageUrl);
    }
    return map;
  }
}
