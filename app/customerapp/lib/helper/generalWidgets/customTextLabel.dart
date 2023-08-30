import 'package:egrocer/helper/utils/generalImports.dart';

class CustomTextLabel extends StatelessWidget {
  final String? text;
  final String? jsonKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const CustomTextLabel({
    Key? key,
    this.text,
    this.jsonKey,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return jsonKey != null
        ? Consumer<LanguageProvider>(
            builder: (context, languageProvider, _) {
              return Text(
                context.read<LanguageProvider>().currentLanguage[jsonKey] ??
                    jsonKey,
                style: style ?? TextStyle(color: ColorsRes.mainTextColor),
                textAlign: textAlign,
                maxLines: maxLines,
                overflow: overflow,
                softWrap: softWrap,
              );
            },
          )
        : Text(
            text ?? "",
            style: style ?? TextStyle(color: ColorsRes.mainTextColor),
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
            softWrap: softWrap,
          );
  }
}
