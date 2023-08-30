import 'package:egrocer/helper/utils/generalImports.dart';

Widget getPriceRangeWidget(
    double minPrice, double maxPrice, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomTextLabel(
        text:
            "Minimum Selected Range\n${GeneralMethods.getCurrencyFormat(double.parse(context.watch<ProductFilterProvider>().currentRangeValues.start.toString()))}",
      ),
      Widgets.getSizedBox(
        height: 25,
      ),
      CustomTextLabel(
        text:
            "Maximum Selected Range\n${GeneralMethods.getCurrencyFormat(double.parse(context.watch<ProductFilterProvider>().currentRangeValues.end.toString()))}",
      ),
      Widgets.getSizedBox(
        height: 25,
      ),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
            thumbColor: Colors.transparent,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0)),
        child: RangeSlider(
          values: context.watch<ProductFilterProvider>().currentRangeValues,
          divisions: (maxPrice.toInt() - minPrice.toInt()),
          activeColor: ColorsRes.appColor,
          inactiveColor: ColorsRes.grey,
          min: minPrice,
          max: maxPrice,
          onChanged: (value) {
            context.read<ProductFilterProvider>().setPriceRange(value);
          },
        ),
      ),
    ],
  );
}
