import 'package:lokale_mand/helper/utils/generalImports.dart';

class StepperCounter extends StatelessWidget {
  final String? firstCounterText;
  final VoidCallback? firstItemVoidCallback;

  String? secondCounterText;
  VoidCallback? secondItemVoidCallback;

  String? thirdCounterText;
  VoidCallback? thirdItemVoidCallback;

  StepperCounter(
      {super.key,
      this.firstCounterText,
      this.firstItemVoidCallback,
      this.secondCounterText,
      this.secondItemVoidCallback,
      this.thirdCounterText,
      this.thirdItemVoidCallback});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: firstItemVoidCallback,
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (firstCounterText != null)
                    Icon(
                      Icons.arrow_back,
                      color: ColorsRes.subTitleMainTextColor,
                    ),
                  if (firstCounterText != null)
                    Widgets.getSizedBox(
                      width: 10,
                    ),
                  if (firstCounterText != null)
                    Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: CustomTextLabel(
                        jsonKey: firstCounterText ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorsRes.subTitleMainTextColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: AlignmentDirectional.center,
            child: CustomTextLabel(
              text: secondCounterText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: thirdItemVoidCallback,
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (thirdCounterText != null)
                    Expanded(
                      child: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        child: CustomTextLabel(
                          jsonKey: thirdCounterText ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorsRes.appColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  if (thirdCounterText != null)
                    Widgets.getSizedBox(
                      width: 10,
                    ),
                  if (thirdCounterText != null)
                    Icon(
                      Icons.arrow_forward,
                      color: ColorsRes.appColor,
                    )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
