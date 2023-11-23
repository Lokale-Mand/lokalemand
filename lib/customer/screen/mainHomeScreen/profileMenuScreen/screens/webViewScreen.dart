import 'package:lokale_mand/helper/utils/generalImports.dart';

class WebViewScreen extends StatefulWidget {
  final String dataFor;

  const WebViewScreen({Key? key, required this.dataFor}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool privacyPolicyExpanded = false;
  bool returnExchangePolicyExpanded = false;
  bool shippingPolicyExpanded = false;
  bool cancellationPolicyExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    String htmlContent = "";
    if (widget.dataFor ==
        getTranslatedValue(
          context,
          "contact_us",
        )) {
      htmlContent = Constant.contactUs;
    } else if (widget.dataFor ==
        getTranslatedValue(
          context,
          "about_us",
        )) {
      htmlContent = Constant.aboutUs;
    } else if (widget.dataFor ==
        getTranslatedValue(
          context,
          "terms_and_conditions",
        )) {
      htmlContent = Constant.termsConditions;
    } else if (widget.dataFor ==
        getTranslatedValue(
          context,
          "privacy_policy",
        )) {
      htmlContent = Constant.privacyPolicy;
    }

    return Scaffold(
      appBar: getAppBar(
          title: CustomTextLabel(
            text: widget.dataFor,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          context: context),
      body: SingleChildScrollView(
        child: widget.dataFor ==
                getTranslatedValue(
                  context,
                  "policies",
                )
            ? Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor,
                      10,
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: privacyPolicyExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() => privacyPolicyExpanded = expanded);
                      },
                      title: CustomTextLabel(
                        jsonKey: "privacy_policy",
                        style: TextStyle(color: ColorsRes.mainTextColor),
                      ),
                      trailing: Icon(
                        privacyPolicyExpanded ? Icons.remove : Icons.add,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: Constant.size30,
                              top: Constant.size5,
                              bottom: Constant.size10,
                              end: Constant.size10),
                          child: _getHtmlContainer(Constant.privacyPolicy),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor,
                      10,
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: returnExchangePolicyExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() => returnExchangePolicyExpanded = expanded);
                      },
                      title: CustomTextLabel(
                        jsonKey: "return_and_exchanges_policy",
                        style: TextStyle(color: ColorsRes.mainTextColor),
                      ),
                      trailing: Icon(
                        returnExchangePolicyExpanded ? Icons.remove : Icons.add,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: Constant.size30,
                              top: Constant.size5,
                              bottom: Constant.size10,
                              end: Constant.size10),
                          child: _getHtmlContainer(
                              Constant.returnAndExchangesPolicy),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor,
                      10,
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: shippingPolicyExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() => shippingPolicyExpanded = expanded);
                      },
                      title: CustomTextLabel(
                        jsonKey: "shopping_policy",
                        style: TextStyle(color: ColorsRes.mainTextColor),
                      ),
                      trailing: Icon(
                        shippingPolicyExpanded ? Icons.remove : Icons.add,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: Constant.size30,
                              top: Constant.size5,
                              bottom: Constant.size10,
                              end: Constant.size10),
                          child: _getHtmlContainer(Constant.shippingPolicy),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor,
                      10,
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: cancellationPolicyExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() => cancellationPolicyExpanded = expanded);
                      },
                      title: CustomTextLabel(
                        jsonKey: "cancellation_policy",
                        style: TextStyle(color: ColorsRes.mainTextColor),
                      ),
                      trailing: Icon(
                        cancellationPolicyExpanded ? Icons.remove : Icons.add,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: Constant.size30,
                              top: Constant.size5,
                              bottom: Constant.size10,
                              end: Constant.size10),
                          child: _getHtmlContainer(Constant.cancellationPolicy),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.all(Constant.size10),
                child: _getHtmlContainer(htmlContent),
              ),
      ),
    );
  }

  Widget _getHtmlContainer(String htmlContent) {
    return HtmlWidget(
      htmlContent,
      enableCaching: true,
      textStyle: TextStyle(
        color: ColorsRes.mainTextColor,
      ),
    );
  }
}
