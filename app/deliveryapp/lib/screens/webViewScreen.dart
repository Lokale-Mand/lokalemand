import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class WebViewScreen extends StatefulWidget {
  final String dataFor;

  WebViewScreen({Key? key, required this.dataFor}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          title: Text(
            widget.dataFor,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin10),
          child: HtmlWidget(
            widget.dataFor == getTranslatedValue(context, "privacy_policy")
                ? Constant.privacyPolicy
                : Constant.termsConditions,
            enableCaching: true,
          ),
        ),
      ),
    );
  }
}
