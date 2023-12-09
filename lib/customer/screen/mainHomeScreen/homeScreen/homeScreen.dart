import 'package:google_maps_webservice/places.dart';
import 'package:lokale_mand/helper/generalWidgets/bottomSheetLocationSearch/widget/flutterGooglePlaces.dart';
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
    super.initState();
    Future.delayed(Duration.zero).then(
      (value) async {
        await getAppSettings(context: context);

        GeneralMethods.determinePosition().then((value) {
          updateMap(value.latitude, value.longitude);
        });
      },
    );
  }

  late GoogleMapController controller;
  late CameraPosition kGooglePlex;
  late LatLng kMapCenter;

  List<Marker> markers = [];

  Future<void> updateMap(double latitude, double longitude) async {
    Constant.session
        .setData(SessionManager.keyLatitude, latitude.toString(), false);
    Constant.session
        .setData(SessionManager.keyLongitude, longitude.toString(), false);

    kMapCenter = LatLng(latitude, longitude);
    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: 14.4746,
    );

    controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
    context.read<SellerListProvider>().getSellerListProvider(
      params: {
        ApiAndParams.latitude: latitude,
        ApiAndParams.longitude: longitude,
      },
      context: context,
    );
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
                      (value) => updateMap(
                        double.parse(value?.lattitud ?? "0.0"),
                        double.parse(
                          value?.longitude ?? "0.0",
                        ),
                      ),
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
                      updateMap(value.latitude, value.longitude);
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
              builder: (_, sellerListProvider, __) {
                if (sellerListProvider.itemsState == SellerListState.loaded) {
                  return Container(
                    height: 100, // Height of the container
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: sellerListProvider.sellerListData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              productListScreen,
                              arguments: [
                                "seller",
                                sellerListProvider.sellerListData[index].id
                                    .toString(),
                                getTranslatedValue(context, "seller"),
                                sellerListProvider
                                    .sellerListData[index].categories
                                    .toString(),
                              ],
                            );
                          },
                          child: Container(
                            margin: EdgeInsetsDirectional.symmetric(
                              horizontal: 10,
                            ),
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 130,
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
                                    image: sellerListProvider
                                            .sellerListData[index].logoUrl ??
                                        "",
                                    height: 80,
                                    width: 80,
                                  ),
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
                                          text: sellerListProvider
                                              .sellerListData[index].name,
                                          softWrap: true,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: ColorsRes.mainTextColor),
                                        ),
                                        CustomTextLabel(
                                          text:
                                              "${sellerListProvider.sellerListData[index].distance} KM away",
                                          softWrap: true,
                                          style: TextStyle(
                                            color:
                                                ColorsRes.subTitleMainTextColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            CustomTextLabel(
                                              text: "4.5",
                                              softWrap: true,
                                              style: TextStyle(
                                                color: ColorsRes
                                                    .subTitleMainTextColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Widgets.getSizedBox(
                                              width: 5,
                                            ),
                                            RatingBarIndicator(
                                              rating: 4.5,
                                              itemCount: 5,
                                              itemSize: 20.0,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
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
          )
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
      zoomControlsEnabled: false,
      onTap: (value) async {
        updateMap(value.latitude, value.longitude);
        context.read<SellerListProvider>().getSellerListProvider(
          params: {
            ApiAndParams.latitude: value.latitude.toString(),
            ApiAndParams.longitude: value.longitude.toString(),
          },
          context: context,
        ).then((value) {
          markers.addAll(context.read<SellerListProvider>().storeMarkers);
          setState(() {});
        });
      },
      onMapCreated: _onMapCreated,
      markers: markers.toSet(),

      // markers: markers,
    );
  }

  Future<void> _onMapCreated(GoogleMapController controllerParam) async {
    controller = controllerParam;

    if (Constant.session.getBoolData(SessionManager.isDarkTheme)) {
      controllerParam.setMapStyle(
          await rootBundle.loadString('assets/mapTheme/nightMode.json'));
    }
  }
}
