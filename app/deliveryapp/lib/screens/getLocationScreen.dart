
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class GetLocation extends StatefulWidget {
  GetLocation({Key? key}) : super(key: key);

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  final TextEditingController edtAddress = TextEditingController();
  late GeoAddress selectedAddress;

  List<GeoAddress> recentAddressList = [];
  List addressPlaceIdList = [];
  final recentAddressController = StreamController<GeoAddress>.broadcast();
  bool visibleRecentWidget = false;

  @override
  void initState() {
    super.initState();
    recentAddressData();
  }

  recentAddressData() {
    String recentadr =
        Constant.session.getData(SessionManager.keyRecentAddressSearch);
    if (recentadr.trim().isNotEmpty) {
      var addressJson = jsonDecode(recentadr)["address"] as List;

      recentAddressList.addAll(addressJson.map((e) {
        GeoAddress address = GeoAddress.fromJson(e);
        addressPlaceIdList.add(address.placeId);
        return address;
      }).toList());
      visibleRecentWidget = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: Text(
            getTranslatedValue(context, "select_location"),
            softWrap: true,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
          )),
      body: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.paddingOrMargin10,
              vertical: Constant.paddingOrMargin10),
          children: [
            lblSelectLocation(),
            if (visibleRecentWidget) recentAddressWidget(),
          ]),
    );
  }

  recentAddressWidget() {
    return Card(
        shape: DesignConfig.setRoundedBorder(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constant.paddingOrMargin10,
                vertical: Constant.paddingOrMargin12),
            child: Text(
              getTranslatedValue(context, "recent_searches"),
              softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            height: 1,
          ),
          recentAdrListWidget()
        ]));
  }

  lblSelectLocation() {
    return Card(
      shape: DesignConfig.setRoundedBorder(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.paddingOrMargin10,
              vertical: Constant.paddingOrMargin12),
          child: Text(
            getTranslatedValue(context, "select_delivery_location"),
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          height: 1,
        ),
        TextButton.icon(
          onPressed: () async {
            await GeneralMethods.determinePosition().then((value) {
              GeoAddress getAddress = GeoAddress(
                  lattitud: value.latitude, longitude: value.longitude);

              Navigator.pushNamed(
                context,
                confirmLocationScreen,
                arguments: getAddress,
              ).then((value) => Navigator.pop(context, value));
            });
          },
          icon: Icon(
            Icons.my_location_rounded,
            color: ColorsRes.appColor,
          ),
          label: Text(
            getTranslatedValue(context, "use_my_current_location"),
            softWrap: true,
            style: TextStyle(color: ColorsRes.appColor, letterSpacing: 0.5),
          ),
        ),
        Row(children: [
          Expanded(
              child: Divider(
            height: 1,
          )),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin5),
            child: Text(
              getTranslatedValue(context, "or").toUpperCase(),
              softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold, height: 0.5),
            ),
          ),
          Expanded(
              child: Divider(
            height: 1,
          )),
        ]),
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constant.paddingOrMargin10,
                vertical: Constant.paddingOrMargin12),
            child: Widgets.textFieldWidget(
                edtAddress,
                GeneralMethods.emptyValidation,
                getTranslatedValue(context, "type_location_manually"),
                TextInputType.text,
                getTranslatedValue(context, "type_location_manually"),
                context,
                currfocus: AlwaysDisabledFocusNode(),
                hint: getTranslatedValue(context, "type_location_manually"),
                floatingLbl: false,
                borderRadius: 8,
                bgcolor: Theme.of(context).scaffoldBackgroundColor,
                contentPadding: EdgeInsets.symmetric(
                    vertical: Constant.paddingOrMargin5,
                    horizontal: Constant.paddingOrMargin10),
                tapCallback: () => searchAddress)),
      ]),
    );
  }

  searchAddress() {
    try {
      Future.delayed(Duration.zero, () async {
        Prediction? p = await PlacesAutocomplete.show(
            context: context,
            apiKey: Constant.googleApiKey,
            onError: (PlacesAutocompleteResponse response) {},
            mode: Mode.overlay,
            components: [],
            types: [],
            strictbounds: false,
            logo: SizedBox(
              width: double.maxFinite,
              height: 0,
            ));

        await GeneralMethods.displayPrediction(p, context)
            .then((value) => getRedirects(value));
      });
    } catch (e) {}
  }

  getRedirects(GeoAddress? value) {
    if (value != null) {
      if (!addressPlaceIdList.contains(value.placeId)) {
        if (!visibleRecentWidget) {
          visibleRecentWidget = true;
          recentAddressList.add(value);
          setState(() {});
        }
        addressPlaceIdList.add(value.placeId);
        recentAddressController.sink.add(value);
      }
      edtAddress.text = value.address!;
      selectedAddress = value;

      Navigator.pushNamed(
        context,
        confirmLocationScreen,
        arguments: value,
      ).then((value) => Navigator.pop(context, value));
    }
  }

  recentAdrListWidget() {
    return StreamBuilder(
        stream: recentAddressController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            recentAddressList.insert(0, snapshot.data as GeoAddress);
          }
          return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: ((context, index) {
                GeoAddress address = recentAddressList[index];
                return ListTile(
                  leading: Card(
                    elevation: 0,
                    color: Colors.grey[100],
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Widgets.defaultImg(
                            image: "search_icon",
                            iconColor: ColorsRes.appColor)),
                  ),
                  title: Text(address.city ?? ""),
                  subtitle: Text(address.address ?? ""),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      confirmLocationScreen,
                      arguments: address,
                    ).then((value) => Navigator.pop(context, value));
                  },
                );
              }),
              separatorBuilder: (context, index) {
                return SizedBox(height: 8);
              },
              itemCount: recentAddressList.length);
        });
  }

  @override
  void dispose() {
    if (recentAddressList.isNotEmpty) {
      Map data = {"address": recentAddressList};
      Constant.session.setData(
          SessionManager.keyRecentAddressSearch, jsonEncode(data), false);
    }
    recentAddressController.close();
    super.dispose();
  }
}
