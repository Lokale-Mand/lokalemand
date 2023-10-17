import 'package:lokale_mand/helper/utils/generalImports.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  final String message;
  final double? height;
  final Function? callback;

  const NoInternetConnectionScreen({
    super.key,
    required this.message,
    this.height,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultBlankItemMessageScreen(
        height: height ?? MediaQuery.sizeOf(context).height,
        image: message == Constant.noInternetConnection
            ? "no_internet_icon"
            : "something_went_wrong",
        title: message == Constant.noInternetConnection
            ? "no_internet_message_title"
            : "something_went_wrong_message_title",
        description: message == Constant.noInternetConnection
            ? "no_internet_message_description"
            : "something_went_wrong_message_description",
        buttonTitle: "try_again",
        callback: callback);
  }
}
