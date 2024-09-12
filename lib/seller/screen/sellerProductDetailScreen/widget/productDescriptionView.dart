import 'package:lokale_mand/helper/utils/generalImports.dart';

class SellerProductDescriptionView extends StatelessWidget {
  final ProductData product;
  final BuildContext context;

  const SellerProductDescriptionView(
      {Key? key, required this.context, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HtmlWidget(
          product.description,
          enableCaching: true,
          renderMode: RenderMode.column,
          buildAsync: false,
          textStyle: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ],
    );
  }

  getHtmlWidget() {
    return HtmlWidget(
      product.description,
      enableCaching: true,
      renderMode: RenderMode.column,
      buildAsync: false,
      textStyle: TextStyle(color: ColorsRes.mainTextColor),
    );
  }
}
