import 'package:egrocer/helper/utils/generalImports.dart';


class DefaultBlankItemMessageScreen extends StatelessWidget {
  final String image, title, description;
  final Function? callback;
  final String? buttonTitle;
  final double? height;

  const DefaultBlankItemMessageScreen({super.key, required this.image, required this.title, required this.description, this.callback, this.buttonTitle, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(30),
      height: height ?? MediaQuery.of(context).size.height*0.65,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            margin: const EdgeInsets.only(bottom: 50),
            decoration: ShapeDecoration(
              color: ColorsRes.defaultPageInnerCircle,
              shape: CircleBorder(
                side: BorderSide(
                    width: 20, color: ColorsRes.defaultPageOuterCircle),
              ),
            ),
            child: Center(
              child: Widgets.defaultImg(
                image: image,
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.width * 0.25,
              ),
            ),
          ),
          CustomTextLabel(
            jsonKey: title,
            softWrap: true,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall!.merge(
              TextStyle(
                color: ColorsRes.appColor,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(height: Constant.size10),
          CustomTextLabel(
            jsonKey: description,
            softWrap: true,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.merge(
              TextStyle(
                letterSpacing: 0.5,
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
          if (callback != null) const SizedBox(height: 20),
          if (callback != null)
            ElevatedButton(
              onPressed: () {
                callback!();
              },
              child: CustomTextLabel(
                jsonKey: buttonTitle!,
                softWrap: true,
              ),
            )
        ],
      ),
    );
  }
}