import 'package:lokale_mand/helper/utils/generalImports.dart';

class RatingBuilderWidget extends StatelessWidget {
  final double averageRating;
  final int totalRatings;
  final double? size;
  final double? spacing;

  RatingBuilderWidget({
    super.key,
    required this.averageRating,
    required this.totalRatings,
    this.size,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return totalRatings != 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (index) {
                        return Padding(
                          padding:
                              EdgeInsetsDirectional.only(end: spacing ?? 0),
                          child: Icon(
                            Icons.star_rate_rounded,
                            color: averageRating.toString().toDouble.round() >=
                                    index + 1
                                ? Colors.amber
                                : ColorsRes.menuTitleColor,
                            size: size,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                  CustomTextLabel(
                    text: "(${totalRatings})",
                    style: TextStyle(
                      color: ColorsRes.subTitleMainTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
            ],
          )
        : SizedBox.shrink();
  }
}
