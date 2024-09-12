import 'package:lokale_mand/helper/utils/generalImports.dart';

getSellerOtherImagesBoxDecoration({bool? isActive}) {
  return BoxDecoration(
    borderRadius: Constant.borderRadius13,
    border: Border(
      left: BorderSide(
        width: 0.5,
        color: isActive == true ? ColorsRes.appColor : ColorsRes.grey,
      ),
      bottom: BorderSide(
        width: 0.5,
        color: isActive == true ? ColorsRes.appColor : ColorsRes.grey,
      ),
      top: BorderSide(
        width: 0.5,
        color: isActive == true ? ColorsRes.appColor : ColorsRes.grey,
      ),
      right: BorderSide(
        width: 0.5,
        color: isActive == true ? ColorsRes.appColor : ColorsRes.grey,
      ),
    ),
  );
}
