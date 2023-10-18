import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/provider/sellersListProvider.dart';

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

  List<Marker> customMarkers = [];

  Future<void> updateMap(double latitude, double longitude) async {
    Constant.session
        .setData(SessionManager.keyLatitude, latitude.toString(), false);
    Constant.session
        .setData(SessionManager.keyLongitude, longitude.toString(), false);

    kMapCenter = LatLng(latitude, longitude);
    setMarkerIcon();
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

  setMarkerIcon() async {
    MarkerGenerator(const MaptLocationMarker(), (bitmaps) {
      setState(() {
        bitmaps.asMap().forEach((i, bmp) {
          customMarkers.add(
            Marker(
              markerId: MarkerId("$i"),
              position: kMapCenter,
              icon: BitmapDescriptor.fromBytes(bmp),
            ),
          );
        });
      });
    }).generate(context);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GeneralMethods.determinePosition().then((value) {
            updateMap(value.latitude, value.longitude);
          });
        },
        child: Icon(
          Icons.near_me,
          color: ColorsRes.appColorWhite,
        ),
      ),
      body: Stack(
        children: [
          PositionedDirectional(
            top: 0,
            bottom: 0,
            start: 0,
            end: 0,
            child: mapWidget(),
          ),
          Positioned(
            left: 0,
            right: 0,
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
                                getTranslatedValue(context, "seller"),
                                sellerListProvider
                                    .sellerListData[index].id
                                    .toString(),
                                "seller",
                                sellerListProvider.sellerListData[index].categories.toString(),
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
                                            ),
                                          ),
                                          CustomTextLabel(
                                            text:
                                                "${sellerListProvider.sellerListData[index].distance} KM away",
                                            softWrap: true,
                                            style: TextStyle(
                                              color: ColorsRes
                                                  .subTitleMainTextColor,
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
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemBuilder: (context, _) =>
                                                    Icon(
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
                              )),
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
        );
      },
      onMapCreated: _onMapCreated,
      markers: customMarkers.toSet(),

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
