import 'dart:ui' as ui;

import 'package:google_maps_webservice/places.dart';
import 'package:lokale_mand/helper/generalWidgets/bottomSheetLocationSearch/widget/flutterGooglePlaces.dart';
import 'package:lokale_mand/helper/generalWidgets/ratingBuilderWidget.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;

  const HomeScreen({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (value) async {
        regularSeller =
            await getBytesFromAsset(Constant.getAssetsPath(0, 'regular_seller_map_icon.png'), 100);
        organicSeller = await getBytesFromAsset(
            Constant.getAssetsPath(0, 'organic_seller_map_icon.png'), 100);

        await getAppSettings(context: context);
        GeneralMethods.determinePosition().then((value) {
          updateMap(value.latitude, value.longitude, "");
        });
      },
    );
    super.initState();
  }

  late GoogleMapController controller;
  late CameraPosition kGooglePlex;
  late LatLng kMapCenter;
  int currentPage = 0;
  PageController pageController = PageController(
    viewportFraction: 0.9,
  );

  late Uint8List regularSeller;
  late Uint8List organicSeller;

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> updateMap(double latitude, double longitude, String from) async {
    Constant.session
        .setData(SessionManager.keyLatitude, latitude.toString(), false);
    Constant.session
        .setData(SessionManager.keyLongitude, longitude.toString(), false);

    kMapCenter = LatLng(latitude, longitude);
    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: 14,
    );

    controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
    if (from.isEmpty) {
      context.read<SellerListProvider>().getSellerListProvider(
        params: {
          ApiAndParams.latitude: latitude,
          ApiAndParams.longitude: longitude,
        },
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PositionedDirectional(
            top: 0,
            bottom: 0,
            start: 0,
            end: 0,
            child: mapWidget(),
          ),
          PositionedDirectional(
            top: 45,
            end: 15,
            start: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    Prediction? p = await PlacesAutocomplete.show(
                        context: context,
                        apiKey: Constant.googleApiKey,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: TextStyle(
                            color: ColorsRes.mainTextColor,
                          ),
                        ),
                        textStyle: TextStyle(
                          color: ColorsRes.mainTextColor,
                        ));

                    GeneralMethods.displayPrediction(p, context).then(
                      (value) {
                        if (value != null) {
                          updateMap(
                            double.parse(value.lattitud ?? "0.0"),
                            double.parse(
                              value.longitude ?? "0.0",
                            ),
                            "",
                          );
                        }
                      },
                    );
                  },
                  child: Container(
                    height: 55,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: ColorsRes.menuTitleColor,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.search,
                            color: ColorsRes.mainTextColor,
                            size: 30,
                          ),
                        ),
                        Expanded(
                          child: CustomTextLabel(
                            jsonKey: "search_location_hint",
                            style: TextStyle(color: ColorsRes.menuTitleColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.filter_list_rounded,
                            color: ColorsRes.mainTextColor,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Widgets.getSizedBox(height: 10),
                IconButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => ColorsRes.appColor)),
                  padding: EdgeInsets.all(10),
                  color: ColorsRes.appColor,
                  onPressed: () {
                    GeneralMethods.determinePosition().then((value) {
                      updateMap(value.latitude, value.longitude, "");
                    });
                  },
                  icon: Icon(
                    Icons.near_me_rounded,
                    color: ColorsRes.appColorWhite,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 20,
            child: Consumer<SellerListProvider>(
              builder: (context, sellerListProvider, _) {
                if (sellerListProvider.itemsState == SellerListState.loaded) {
                  return Container(
                    height: 100,
                    child: PageView.builder(
                      physics: ClampingScrollPhysics(),
                      onPageChanged: (value) {
                        currentPage = value;
                        updateMap(
                          sellerListProvider
                              .sellerListData[currentPage].latitude
                              .toString()
                              .toDouble,
                          sellerListProvider
                              .sellerListData[currentPage].longitude
                              .toString()
                              .toDouble,
                          "seller",
                        );
                        setState(() {});
                      },
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: sellerListProvider.sellerListData.length,
                      itemBuilder: (context, index) {
                        SellerListData seller =
                            sellerListProvider.sellerListData[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              productListScreen,
                              arguments: [
                                "seller",
                                seller.id.toString(),
                                getTranslatedValue(context, "seller"),
                                seller.categories.toString(),
                                seller.storeName.toString(),
                                seller.logoUrl.toString()
                              ],
                            );
                          },
                          child: Container(
                            margin: EdgeInsetsDirectional.symmetric(
                              horizontal: 10,
                            ),
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Row(
                              children: [
                                Widgets.getSizedBox(width: 10),
                                ClipRRect(
                                  child: Widgets.setNetworkImg(
                                      image: seller.logoUrl ?? "",
                                      height: 80,
                                      width: 80,
                                      boxFit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextLabel(
                                          text: seller.name,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: ColorsRes.mainTextColor,
                                          ),
                                        ),
                                        CustomTextLabel(
                                          overflow: TextOverflow.ellipsis,
                                          jsonKey: seller.type == "2"
                                              ? "organic_seller"
                                              : "regular_seller",
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: ColorsRes.appColorGreen,
                                          ),
                                        ),
                                        CustomTextLabel(
                                          text:
                                              "${seller.distance} ${getTranslatedValue(context, "km_away")}",
                                          softWrap: true,
                                          style: TextStyle(
                                            color:
                                                ColorsRes.subTitleMainTextColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: RatingBuilderWidget(
                                                averageRating: double.parse(
                                                    seller.averageRating
                                                        .toString()),
                                                totalRatings: int.parse(seller
                                                    .ratingCount
                                                    .toString()),
                                                size: 17,
                                                spacing: 0,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  productListScreen,
                                                  arguments: [
                                                    "seller",
                                                    seller.id.toString(),
                                                    getTranslatedValue(
                                                        context, "seller"),
                                                    seller.categories
                                                        .toString(),
                                                    seller.storeName.toString(),
                                                    seller.logoUrl.toString()
                                                  ],
                                                );
                                              },
                                              child: CustomTextLabel(
                                                jsonKey: "view",
                                                style: TextStyle(
                                                  color: ColorsRes.appColor,
                                                  fontWeight:
                                                      ui.FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationThickness: 2,
                                                  decorationColor:
                                                      ColorsRes.appColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (sellerListProvider.itemsState ==
                    SellerListState.loading) {
                  return Container(
                    height: 100, // Height of the container
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return CustomShimmer(
                          margin: EdgeInsetsDirectional.symmetric(
                            horizontal: 10,
                          ),
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 130,
                          borderRadius: 10,
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget mapWidget() {
    kMapCenter = LatLng(0.0, 0.0);
    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: 14.4746,
    );
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: kGooglePlex,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      onTap: (value) async {
        updateMap(value.latitude, value.longitude, "");
        context.read<SellerListProvider>().getSellerListProvider(
          params: {
            ApiAndParams.latitude: value.latitude.toString(),
            ApiAndParams.longitude: value.longitude.toString(),
          },
          context: context,
        );
      },
      onMapCreated: _onMapCreated,
      markers: context.read<SellerListProvider>().sellerListData.isNotEmpty
          ? List.generate(
              context.read<SellerListProvider>().sellerListData.length,
              (index) {
                SellerListData seller =
                    context.read<SellerListProvider>().sellerListData[index];
                return Marker(
                  onTap: () {
                    pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeInOut);
                    currentPage = index;
                    setState(() {});
                  },
                  anchor: ui.Offset(0, 0),
                  infoWindow: InfoWindow(
                      title: seller.storeName.toString(), snippet: seller.name),
                  visible: true,
                  zIndex: -1,
                  consumeTapEvents: true,
                  markerId: MarkerId(seller.storeName.toString()),
                  position: LatLng(
                    seller.latitude.toString().toDouble,
                    seller.longitude.toString().toDouble,
                  ),
                  icon: BitmapDescriptor.fromBytes(
                      seller.type == "2" ? organicSeller : regularSeller,
                      size: Size(200, 200)),
                );
              },
            ).toSet()
          : Set(),
      buildingsEnabled: false,
      indoorViewEnabled: false,

      // markers: markers,
    );
  }

// This callback will be invoked every time the platform brightness changes.
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (Constant.session.getBoolData(SessionManager.isDarkTheme)) {
      controller.setMapStyle(
          await rootBundle.loadString('assets/mapTheme/nightMode.json'));
      setState(() {});
    } else {
      controller.setMapStyle(
          await rootBundle.loadString('assets/mapTheme/dayMode.json'));
      setState(() {});
    }
  }

  Future<void> _onMapCreated(GoogleMapController controllerParam) async {
    controller = controllerParam;
    if (Constant.session.getBoolData(SessionManager.isDarkTheme)) {
      controller.setMapStyle(
          await rootBundle.loadString('assets/mapTheme/nightMode.json'));
      setState(() {});
    } else {
      controller.setMapStyle(
          await rootBundle.loadString('assets/mapTheme/dayMode.json'));
      setState(() {});
    }
  }
}
