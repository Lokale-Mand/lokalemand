

import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class ConfirmLocation extends StatefulWidget {
  final GeoAddress address;

  ConfirmLocation({Key? key, required this.address}) : super(key: key);

  @override
  State<ConfirmLocation> createState() => _ConfirmLocationState();
}

class _ConfirmLocationState extends State<ConfirmLocation> {
  late GoogleMapController controller;
  late CameraPosition kGooglePlex;
  late LatLng kMapCenter;

  List<Marker> customMarkers = [];

  @override
  void initState() {
    super.initState();
    kMapCenter = LatLng(
      widget.address.lattitud!,
      widget.address.longitude!,
    );
    setMarkerIcon();
    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: 14.4746,
    );
  }

  updateMap(double latitude, double longitude) {
    kMapCenter = LatLng(
      latitude,
      longitude,
    );
    setMarkerIcon();
    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: 14.4746,
    );

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        kGooglePlex,
      ),
    );
  }

  setMarkerIcon() async {
    MarkerGenerator(
      MapDeliveredMarker(),
      (bitmaps) {
        setState(
          () {
            bitmaps.asMap().forEach(
              (i, bmp) {
                customMarkers.add(
                  Marker(
                    markerId: MarkerId(
                      "$i",
                    ),
                    position: kMapCenter,
                    icon: BitmapDescriptor.fromBytes(
                      bmp,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ).generate(context);

    Constant.cityAddressMap =
        await GeneralMethods.getCityNameAndAddress(kMapCenter, context);

    Map<String, dynamic> params = {};
    params[ApiAndParams.name] = Constant.cityAddressMap["city"];

    params[ApiAndParams.longitude] = kMapCenter.longitude.toString();
    params[ApiAndParams.latitude] = kMapCenter.latitude.toString();
    await context.read<CityByLatLongProvider>().getCityByLatLongApiProvider(
          context: context,
          params: params,
        );

    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(
            context: context,
            title: Text(
              getTranslatedValue(
                context,
                "confirm_location",
              ),
              style: TextStyle(
                color: ColorsRes.mainTextColor,
              ),
            )),
        body: WillPopScope(
          onWillPop: () async {
            return Future.delayed(
              Duration(
                milliseconds: 500,
              ),
            ).then(
              (value) => true,
            );
          },
          child: Column(children: [
            Expanded(
              child: mapWidget(),
            ),
            confirmBtnWidget(),
          ]),
        ));
  }

  mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: kGooglePlex,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      onTap: (argument) async {
        updateMap(
          argument.latitude,
          argument.longitude,
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
        await rootBundle.loadString('assets/mapTheme/nightMode.json'),
      );
    }
  }

  confirmBtnWidget() {
    return Consumer<CityByLatLongProvider>(
      builder: (context, cityByLatLongProvider, child) {
        return Card(
          color: Theme.of(context).cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.paddingOrMargin10,
                  vertical: Constant.paddingOrMargin10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslatedValue(context, "select_your_location"),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: () {
                        GeneralMethods.determinePosition().then(
                          (value) {
                            updateMap(
                              value.latitude,
                              value.longitude,
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.my_location_rounded,
                        color: ColorsRes.appColor,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                indent: 8,
                endIndent: 8,
              ),
              ListTile(
                leading: Padding(
                  padding: EdgeInsets.all(
                    8,
                  ),
                  child: Widgets.defaultImg(
                    image: "address_icon",
                    iconColor: ColorsRes.appColor,
                  ),
                ),
                title: (!context.read<CityByLatLongProvider>().isDeliverable)
                    ? Text(
                        getTranslatedValue(
                            context, "does_not_delivery_long_message"),
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                              color: ColorsRes.appColorRed,
                            ),
                      )
                    : SizedBox.shrink(),
                subtitle: Text(
                  Constant.cityAddressMap["address"] ?? "",
                ),
                trailing: Container(
                  child: Text(
                    getTranslatedValue(context, "change"),
                    style: Theme.of(context).textTheme.bodySmall!.apply(
                          color: ColorsRes.appColor,
                        ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Constant.paddingOrMargin8,
                    vertical: Constant.paddingOrMargin5,
                  ),
                  decoration: DesignConfig.boxDecoration(
                    ColorsRes.appColorLightHalfTransparent,
                    5,
                    isboarder: true,
                    bordercolor: ColorsRes.appColor,
                  ),
                ),
              ),
              if (!context.read<CityByLatLongProvider>().isDeliverable)
                Widgets.getSizedBox(
                  height: 10,
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.paddingOrMargin15,
                  vertical: Constant.paddingOrMargin15,
                ),
                child: Widgets.gradientBtnWidget(
                  context,
                  10,
                  otherWidgets: cityByLatLongProvider.cityByLatLongState !=
                          CityByLatLongState.loading
                      ? Text(
                          getTranslatedValue(
                            context,
                            "confirm_location",
                          ),
                          softWrap: true,
                          style: Theme.of(context).textTheme.titleMedium!.merge(
                                TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color: ColorsRes.appColorWhite,
                          ),
                        ),
                  callback: () {
                    if (cityByLatLongProvider.cityByLatLongState ==
                            CityByLatLongState.loaded &&
                        cityByLatLongProvider.isDeliverable) {
                      cityByLatLongProvider.changeState();
                      GeneralMethods.getStoreAddressFromMap(
                        LatLng(
                          kMapCenter.latitude,
                          kMapCenter.longitude,
                        ),
                        context,
                      ).then(
                        (value) {
                          if (mounted) {
                            Navigator.pop(
                              context,
                              value,
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
