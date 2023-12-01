import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:lokale_mand/helper/generalWidgets/customTextLabel.dart';
import 'package:lokale_mand/helper/styles/colorsRes.dart';

class HtmlEditorScreen extends StatefulWidget {
  final String? htmlContent;

  const HtmlEditorScreen({super.key, this.htmlContent});

  @override
  State<HtmlEditorScreen> createState() => _HtmlEditorScreenState();
}

class _HtmlEditorScreenState extends State<HtmlEditorScreen> {
  final HtmlEditorController controller = HtmlEditorController(
      processOutputHtml: true,
      processInputHtml: true,
      processNewLineAsBr: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: HtmlEditor(
          controller: controller,
          otherOptions: OtherOptions(
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
          ),
          htmlEditorOptions: HtmlEditorOptions(
            adjustHeightForKeyboard: true,
            hint: 'Your text here...',
            initialText: widget.htmlContent ?? "",
            shouldEnsureVisible: true,
            autoAdjustHeight: true,
            androidUseHybridComposition: true,
          ),
          htmlToolbarOptions: HtmlToolbarOptions(
              toolbarPosition: ToolbarPosition.aboveEditor,
              toolbarType: ToolbarType.nativeGrid,
              buttonColor: ColorsRes.mainTextColor,
              buttonFillColor: ColorsRes.appColorLight,
              buttonBorderRadius: BorderRadius.circular(10),
              renderBorder: true,
              buttonBorderColor: ColorsRes.mainTextColor,
              buttonSelectedBorderColor: ColorsRes.mainTextColor,
              buttonSelectedColor: ColorsRes.mainTextColor),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context, controller.getText()),
            child: Container(
              decoration: BoxDecoration(
                color: ColorsRes.appColor,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 50,
              alignment: Alignment.center,
              padding: EdgeInsetsDirectional.all(10),
              margin: EdgeInsetsDirectional.all(10),
              child: CustomTextLabel(
                jsonKey: "done",
                style: TextStyle(
                  color: ColorsRes.appColorWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
