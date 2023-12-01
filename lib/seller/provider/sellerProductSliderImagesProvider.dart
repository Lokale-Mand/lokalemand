import 'package:lokale_mand/helper/utils/generalImports.dart';

class SellerSliderImagesProvider extends ChangeNotifier {
  int currentSliderImageIndex = 0;

  setSellerSliderCurrentIndexImage(int index) {
    currentSliderImageIndex = index;
    notifyListeners();
  }
}
