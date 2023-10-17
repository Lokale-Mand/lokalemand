import 'package:lokale_mand/helper/utils/generalImports.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController controller;
  late CameraPosition kGooglePlex;
  late LatLng kMapCenter;

  List<Marker> customMarkers = [];

  @override
  void initState() {
    GeneralMethods.determinePosition().then((value) {
      updateMap(value.latitude, value.longitude);
    });
    super.initState();
  }

  updateMap(double latitude, double longitude) {
    kMapCenter = LatLng(latitude, longitude);
    setMarkerIcon();
    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: 14.4746,
    );

    controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
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
            child: Container(
              height: 100, // Height of the container
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 130,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: kGooglePlex,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onTap: (argument) async {
        updateMap(argument.latitude, argument.longitude);
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
