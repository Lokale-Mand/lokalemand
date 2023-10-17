import 'package:lokale_mand/helper/utils/generalImports.dart';

class ProductChangeListingTypeProvider extends ChangeNotifier {
  // Product Grid/List Layout Provider

  changeListingType() {
    Constant.session.setBoolData(SessionManager.keyIsGrid,
        !Constant.session.getBoolData(SessionManager.keyIsGrid), false);

    notifyListeners();
  }

  getListingType() {
    return Constant.session.getBoolData(SessionManager.keyIsGrid);
  }
}
