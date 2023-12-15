import 'package:google_maps_webservice/places.dart';
import 'package:lokale_mand/helper/generalWidgets/bottomSheetLocationSearch/widget/flutterGooglePlaces.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/helper/utils/mapDeliveredMarker.dart';
import 'package:lokale_mand/helper/utils/markergenerator.dart';
import 'package:lokale_mand/seller/model/sellerCityByLatLong.dart';
import 'package:lokale_mand/seller/screen/confirmLocationScreen/widget/sellerConfirmButtonWidget.dart';

class ConfirmLocation extends StatefulWidget {
  final GeoAddress? address;
  final String from;

  const ConfirmLocation({Key? key, this.address, required this.from})
      : super(key: key);

  @override
  State<ConfirmLocation> createState() => _SellerConfirmLocationState();
}

class _SellerConfirmLocationState extends State<ConfirmLocation> {
  late GoogleMapController controller;
  late CameraPosition kGooglePlex;
  late LatLng kMapCenter;
  double mapZoom = 14.4746;

  late SellerCityByLatLong cityByLatLong;

  List<Marker> customMarkers = [];

  @override
  void initState() {
    kMapCenter = LatLng(0.0, 0.0);

    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: mapZoom,
    );

    if (widget.address != null) {
      kMapCenter = LatLng(double.parse(widget.address!.lattitud!),
          double.parse(widget.address!.longitude!));

      kGooglePlex = CameraPosition(
        target: kMapCenter,
        zoom: mapZoom,
      );
    } else {
      GeneralMethods.determinePosition().then((value) async {
        updateMap(value.latitude, value.longitude);
      });
    }

    setMarkerIcon();
    super.initState();
  }

  updateMap(double latitude, double longitude) {
    kMapCenter = LatLng(latitude, longitude);
    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: mapZoom,
    );
    setMarkerIcon();

    controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
  }

  setMarkerIcon() async {
    MarkerGenerator(const MapDeliveredMarker(), (bitmaps) {
      setState(() {
        bitmaps.asMap().forEach((i, bmp) {
          customMarkers.add(Marker(
            markerId: MarkerId("$i"),
            position: kMapCenter,
            icon: BitmapDescriptor.fromBytes(bmp),
          ));
        });
      });
    }).generate(context);

    Constant.cityAddressMap =
        await GeneralMethods.getCityNameAndAddress(kMapCenter, context);

    if (widget.from == "location" || widget.from == "seller_register") {
      Map<String, dynamic> params = {};
      // params[ApiAndParams.cityName] = Constant.cityAddressMap["city"];

      params[ApiAndParams.longitude] = kMapCenter.longitude.toString();
      params[ApiAndParams.latitude] = kMapCenter.latitude.toString();

      await context
          .read<CityByLatLongProvider>()
          .getCityByLatLongApiProvider(context: context, params: params)
          .then((value) {
        if (value != null) {
          cityByLatLong = value;
        }
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: "confirm_location",
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            return Future.delayed(const Duration(milliseconds: 500))
                .then((value) => true);
          },
          child: Column(children: [
            Expanded(
              child: Stack(
                children: [
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    start: 0,
                    bottom: 0,
                    child: mapWidget(),
                  ),
                  PositionedDirectional(
                    top: 15,
                    end: 15,
                    start: 15,
                    child: Row(children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () async {
                          Prediction? p = await PlacesAutocomplete.show(
                              context: context,
                              apiKey: Constant.googleApiKey,
                              decoration: InputDecoration(
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
                          decoration: DesignConfig.boxDecoration(
                            Theme.of(context).scaffoldBackgroundColor,
                            10,
                          ),
                          child: ListTile(
                            title: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: context
                                            .read<LanguageProvider>()
                                            .currentLanguage[
                                        "product_search_hint"] ??
                                    "product_search_hint",
                              ),
                            ),
                            contentPadding: EdgeInsetsDirectional.only(
                              start: Constant.size12,
                            ),
                            trailing: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.search),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      )),
                      SizedBox(width: Constant.size10),
                      GestureDetector(
                        onTap: () =>
                            GeneralMethods.determinePosition().then((value) {
                          updateMap(value.latitude, value.longitude);
                        }),
                        child: Container(
                          decoration: DesignConfig.boxGradient(10),
                          padding: EdgeInsets.symmetric(
                            horizontal: Constant.size14,
                            vertical: Constant.size14,
                          ),
                          child: Icon(
                            Icons.my_location_outlined,
                            color: ColorsRes.appColorWhite,
                            size: 35,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: confirmBtnWidget()),
          ]),
        ));
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: kGooglePlex,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      onTap: (argument) async {
        updateMap(argument.latitude, argument.longitude);
      },
      onMapCreated: _onMapCreated,
      markers: customMarkers.toSet(),
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      onCameraMove: (position) {
        mapZoom = position.zoom;
      },
      // markers: markers,
    );
  }

  Future<void> _onMapCreated(GoogleMapController controllerParam) async {
    controller = controllerParam;
    // This callback is called every time the brightness changes from the device.
    if (Constant.session.getBoolData(SessionManager.isDarkTheme)) {
      controllerParam.setMapStyle(
          await rootBundle.loadString('assets/mapTheme/darkMode.json'));
    }
  }

  Widget confirmBtnWidget() {
    print(
        ">>>>>>>>>>>>>>>>>>> ${context.read<CityByLatLongProvider>().isDeliverable}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ((widget.from == "location" ||
                    widget.from == "seller_register" ||
                    widget.from == "address_detail") &&
                !context.read<CityByLatLongProvider>().isDeliverable)
            ? Padding(
                padding: EdgeInsetsDirectional.only(
                    start: 20, end: 20, top: 10, bottom: 10),
                child: CustomTextLabel(
                  jsonKey: "does_not_delivery_long_message",
                  style: TextStyle(
                    color: ColorsRes.appColorRed,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: 20,
            end: 20,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Widgets.defaultImg(
                image: "address_icon",
                iconColor: ColorsRes.appColor,
                height: 25,
                width: 25,
              ),
              Widgets.getSizedBox(
                width: 20,
              ),
              Expanded(
                child: CustomTextLabel(
                  text: Constant.cityAddressMap["address"] ?? "",
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (((widget.from == "location" || widget.from == "seller_register") &&
                context.read<CityByLatLongProvider>().isDeliverable) ||
            widget.from == "address")
          ConfirmButtonWidget(voidCallback: () {
            if (widget.from == "location" &&
                context.read<CityByLatLongProvider>().isDeliverable) {
              Constant.session.setData(SessionManager.keyAddress,
                  Constant.cityAddressMap["address"], true);
              Navigator.of(context).pushNamedAndRemoveUntil(
                mainHomeScreen,
                (Route<dynamic> route) => false,
              );
            } else if (widget.from == "address_detail" &&
                context.read<CityByLatLongProvider>().isDeliverable) {
              Navigator.pop(context, cityByLatLong);
            } else if (widget.from == "seller_register") {
              Navigator.pop(context, cityByLatLong);
            }
          })
      ],
    );
  }
}
