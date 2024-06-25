// ignore_for_file: non_constant_identifier_names

import 'package:lokale_mand/helper/utils/generalImports.dart';

Widget MessageContainer({
  required BuildContext context,
  required String text,
  required MessageType type,
}) {
  return Material(
    child: ToastAnimation(
      delay: Constant.messageDisplayDuration,
      child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            // using gradient to apply one side dark color in container
            gradient: LinearGradient(
              stops: const [0.02, 0.02],
              colors: [
                messageColors[type]!,
                messageColors[type]!.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: messageColors[type]!.withOpacity(0.5),
            ),
          ),
          width: MediaQuery.sizeOf(context).width,
          constraints: BoxConstraints(minHeight: 50),
          child: Row(
            children: [
              Widgets.getSizedBox(width: 15),
              messageIcon[type]!,
              SizedBox(
                width: MediaQuery.sizeOf(context).width - 90,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextLabel(
                    text: text,
                    softWrap: true,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: messageColors[type],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              Widgets.getSizedBox(width: 10),
            ],
          )),
    ),
  );
}
