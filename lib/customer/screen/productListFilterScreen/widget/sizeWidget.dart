import 'package:lokale_mand/helper/generalWidgets/customCheckbox.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

getSizeWidget(List<Sizes> sizes, BuildContext context) {
  return ListView(
    children: List.generate(sizes.length, (index) {
      Sizes size = sizes[index];
      String sizeKey = "${size.size}-${size.unitId}";
      return ListTile(
        onTap: () {
          context.read<ProductFilterProvider>().addRemoveSizes(sizeKey);
        },
        title: CustomTextLabel(
          text: "${size.size} ${size.shortCode}",
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        leading: CustomCheckbox(
          activeColor: ColorsRes.appColor,
          value: context
              .watch<ProductFilterProvider>()
              .selectedSizes
              .contains(sizeKey),
          onChanged: (bool? value) {
            context.read<ProductFilterProvider>().addRemoveSizes(sizeKey);
          },
        ),
      );
    }),
  );
}
