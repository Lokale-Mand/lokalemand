library flutter_google_places.src;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:lokale_mand/helper/generalWidgets/customTextLabel.dart';
import 'package:lokale_mand/helper/generalWidgets/widgets.dart';
import 'package:lokale_mand/helper/styles/colorsRes.dart';
import 'package:lokale_mand/helper/styles/designConfig.dart';
import 'package:lokale_mand/helper/utils/constant.dart';
import 'package:rxdart/rxdart.dart';

class PlacesAutocompleteWidget extends StatefulWidget {
  final String apiKey;
  final String? startText;
  final String hint;
  final BorderRadius? overlayBorderRadius;
  final Location? location;
  final num? offset;
  final num? radius;
  final String? language;
  final String? sessionToken;
  final List<String>? types;
  final List<Component>? components;
  final bool? strictbounds;
  final String? region;
  final Widget? logo;
  final ValueChanged<PlacesAutocompleteResponse>? onError;
  final int debounce;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final ThemeData? themeData;

  /// optional - sets 'proxy' value in google_maps_webservice
  ///
  /// In case of using a proxy the baseUrl can be set.
  /// The apiKey is not required in case the proxy sets it.
  /// (Not storing the apiKey in the app is good practice)
  final String? proxyBaseUrl;

  /// optional - set 'client' value in google_maps_webservice
  ///
  /// In case of using a proxy url that requires authentication
  /// or custom configuration
  final BaseClient? httpClient;

  /// optional - set 'resultTextStyle' value in google_maps_webservice
  ///
  /// In case of changing the default text style of result's text
  final TextStyle? resultTextStyle;

  const PlacesAutocompleteWidget({
    required this.apiKey,
    this.hint = "Search",
    this.overlayBorderRadius,
    this.offset,
    this.location,
    this.radius,
    this.language,
    this.sessionToken,
    this.types,
    this.components,
    this.strictbounds,
    this.region,
    this.logo,
    this.onError,
    Key? key,
    this.proxyBaseUrl,
    this.httpClient,
    this.startText,
    this.debounce = 300,
    this.decoration,
    this.textStyle,
    this.themeData,
    this.resultTextStyle,
  }) : super(key: key);

  @override
  State<PlacesAutocompleteWidget> createState() =>
      _PlacesAutocompleteOverlayState();

  static PlacesAutocompleteState? of(BuildContext context) =>
      context.findAncestorStateOfType<PlacesAutocompleteState>();
}

class _PlacesAutocompleteOverlayState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final header = Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Theme.of(context).cardColor,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black45
                    : null,
                icon: Icon(Icons.search_rounded),
                onPressed: () {},
              ),
              Expanded(
                child: _textField(context),
              ),
            ],
          ),
        ),
      ],
    );

    Widget body;

    if (_searching) {
      body = Stack(
        alignment: FractionalOffset.bottomCenter,
        children: <Widget>[_Loader()],
      );
    } else if (_queryTextController!.text.isEmpty ||
        _response == null ||
        _response!.predictions.isEmpty) {
      body = Container();
    } else {
      body = SingleChildScrollView(
        child: ListBody(
          children: _response!.predictions
              .map(
                (p) => PredictionTile(
                  prediction: p,
                  onTap: Navigator.of(context).pop,
                  resultTextStyle: widget.resultTextStyle,
                ),
              )
              .toList(),
        ),
      );
    }

    final container = Container(
      child: Stack(
        children: <Widget>[
          header,
          Padding(
            padding: const EdgeInsets.only(top: 48.0),
            child: body,
          ),
        ],
      ),
    );

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return Padding(
        padding: const EdgeInsets.all(0),
        child: container,
      );
    }
    return container;
  }

  Widget _textField(BuildContext context) => TextField(
        controller: _queryTextController,
        autofocus: true,
        style: widget.textStyle,
        decoration: InputDecoration(border: InputBorder.none),
      );
}

class _Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(
            5,
            (index) => CustomShimmer(
                  height: 50,
                  margin: EdgeInsetsDirectional.only(bottom: 10),
                )),
      ),
    );
  }
}

class PlacesAutocompleteResult extends StatefulWidget {
  final ValueChanged<Prediction>? onTap;
  final Widget? logo;
  final TextStyle? resultTextStyle;

  const PlacesAutocompleteResult({
    Key? key,
    this.onTap,
    this.logo,
    this.resultTextStyle,
  }) : super(key: key);

  @override
  PlacesAutocompleteResultState createState() =>
      PlacesAutocompleteResultState();
}

class PlacesAutocompleteResultState extends State<PlacesAutocompleteResult> {
  @override
  Widget build(BuildContext context) {
    final state = PlacesAutocompleteWidget.of(context)!;

    if (state._queryTextController!.text.isEmpty ||
        state._response == null ||
        state._response!.predictions.isEmpty) {
      final children = <Widget>[];
      if (state._searching) {
        children.add(_Loader());
      }
      return Stack(children: children);
    }
    return PredictionsListView(
      predictions: state._response!.predictions,
      onTap: widget.onTap,
      resultTextStyle: widget.resultTextStyle,
    );
  }
}

class PredictionsListView extends StatelessWidget {
  final List<Prediction> predictions;
  final ValueChanged<Prediction>? onTap;
  final TextStyle? resultTextStyle;

  const PredictionsListView({
    Key? key,
    required this.predictions,
    this.onTap,
    this.resultTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: predictions
          .map(
            (Prediction p) => PredictionTile(
              prediction: p,
              onTap: onTap,
              resultTextStyle: resultTextStyle,
            ),
          )
          .toList(),
    );
  }
}

class PredictionTile extends StatelessWidget {
  final Prediction prediction;
  final ValueChanged<Prediction>? onTap;
  final TextStyle? resultTextStyle;

  const PredictionTile({
    Key? key,
    required this.prediction,
    this.onTap,
    this.resultTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call(prediction);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black45
                      : null,
                  icon: Icon(Icons.location_on_rounded),
                  onPressed: () {},
                ),
                Expanded(
                  child: CustomTextLabel(
                    text: prediction.description!,
                  ),
                ),
              ],
            ),
            Divider(
              height: 2,
            ),
          ],
        ),
      ),
    );
  }
}

abstract class PlacesAutocompleteState extends State<PlacesAutocompleteWidget> {
  TextEditingController? _queryTextController;
  PlacesAutocompleteResponse? _response;
  GoogleMapsPlaces? _places;
  late bool _searching;
  Timer? _debounce;

  final _queryBehavior = BehaviorSubject<String>.seeded('');

  @override
  void initState() {
    super.initState();

    _queryTextController = TextEditingController(text: widget.startText);
    _queryTextController!.selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.startText?.length ?? 0,
    );

    _initPlaces();
    _searching = false;

    _queryTextController!.addListener(_onQueryChange);

    _queryBehavior.stream.listen(doSearch);
  }

  Future<void> _initPlaces() async {
    _places = GoogleMapsPlaces(
      apiKey: widget.apiKey,
      baseUrl: widget.proxyBaseUrl,
      httpClient: widget.httpClient,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
  }

  Future<void> doSearch(String value) async {
    if (mounted && value.isNotEmpty && _places != null) {
      setState(() {
        _searching = true;
      });

      final res = await _places!.autocomplete(
        value,
        offset: widget.offset,
        location: widget.location,
        radius: widget.radius,
        language: widget.language,
        sessionToken: widget.sessionToken,
        types: widget.types ?? [],
        components: widget.components ?? [],
        strictbounds: widget.strictbounds ?? false,
        region: widget.region,
      );

      if (res.errorMessage?.isNotEmpty == true ||
          res.status == "REQUEST_DENIED") {
        onResponseError(res);
      } else {
        onResponse(res);
      }
    } else {
      onResponse(null);
    }
  }

  void _onQueryChange() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: widget.debounce), () {
      if (!_queryBehavior.isClosed) {
        _queryBehavior.add(_queryTextController!.text);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _places?.dispose();
    _debounce?.cancel();
    _queryBehavior.close();
    _queryTextController?.removeListener(_onQueryChange);
  }

  @mustCallSuper
  void onResponseError(PlacesAutocompleteResponse res) {
    if (!mounted) return;

    widget.onError?.call(res);
    setState(() {
      _response = null;
      _searching = false;
    });
  }

  @mustCallSuper
  void onResponse(PlacesAutocompleteResponse? res) {
    if (!mounted) return;

    setState(() {
      _response = res;
      _searching = false;
    });
  }
}

class PlacesAutocomplete {
  static Future<Prediction?> show({
    required BuildContext context,
    required String apiKey,
    String hint = "Search",
    BorderRadius? overlayBorderRadius,
    num? offset,
    Location? location,
    num? radius,
    String? language,
    String? sessionToken,
    List<String>? types,
    List<Component>? components,
    bool? strictbounds,
    String? region,
    ValueChanged<PlacesAutocompleteResponse>? onError,
    String? proxyBaseUrl,
    Client? httpClient,
    InputDecoration? decoration,
    String startText = "",
    Duration transitionDuration = const Duration(seconds: 300),
    TextStyle? textStyle,
    ThemeData? themeData,
    TextStyle? resultTextStyle,
  }) {
    final autoCompleteWidget = PlacesAutocompleteWidget(
      apiKey: apiKey,
      overlayBorderRadius: overlayBorderRadius,
      language: language,
      sessionToken: sessionToken,
      components: components,
      types: types,
      location: location,
      radius: radius,
      strictbounds: strictbounds,
      region: region,
      offset: offset,
      hint: hint,
      onError: onError,
      proxyBaseUrl: proxyBaseUrl,
      httpClient: httpClient as BaseClient?,
      startText: startText,
      decoration: decoration,
      textStyle: textStyle,
      themeData: themeData,
      resultTextStyle: resultTextStyle,
    );

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              Container(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.sizeOf(context).height * 0.5),
                padding: EdgeInsetsDirectional.only(
                    start: Constant.size15,
                    end: Constant.size15,
                    top: Constant.size15,
                    bottom: Constant.size15),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Widgets.defaultImg(
                                image: "ic_arrow_back",
                                iconColor: ColorsRes.mainTextColor,
                                height: 15,
                                width: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: CustomTextLabel(
                              jsonKey: "search_location",
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .merge(
                                    TextStyle(
                                      letterSpacing: 0.5,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Widgets.getSizedBox(
                              height: 15,
                              width: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: autoCompleteWidget,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
