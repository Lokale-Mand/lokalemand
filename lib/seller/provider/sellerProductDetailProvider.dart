import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerProductDetail.dart';

enum SellerProductDetailState {
  initial,
  loading,
  loaded,
  error,
}

class SellerProductDetailProvider extends ChangeNotifier {
  SellerProductDetailState productDetailState =
      SellerProductDetailState.initial;
  String message = '';
  late SellerProductDetailData productData;
  late SellerProductDetail productDetail;
  late int currentImage = 0;
  late List<String> images = [];
  late List<StoreTime> storeTime = [];

  Future getSellerProductDetailProvider(
      {required Map<String, dynamic> params,
      required BuildContext context,
      String? productId}) async {
    productDetailState = SellerProductDetailState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> data =
          await getProductDetailApi(context: context, params: params);

      if (data[ApiAndParams.status].toString() == "1") {
        productDetail = SellerProductDetail.fromJson(data);

        productData = productDetail.data;

        storeTime = (jsonDecode(productDetail.data.storeHours) as List)
            .map((e) => StoreTime.fromJson(Map.from(e)))
            .toList();

        setOtherImages(0, productDetail.data);

        productDetailState = SellerProductDetailState.loaded;

        notifyListeners();
      } else {
        message = Constant.somethingWentWrong;
        productDetailState = SellerProductDetailState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showMessage(context, message, MessageType.error);
      productDetailState = SellerProductDetailState.error;
      notifyListeners();
      rethrow;
    }
  }

  setOtherImages(int currentIndex, SellerProductDetailData product) {
    currentImage = 0;
    images = [];
    images.add(product.imageUrl);
    if (product.images.isNotEmpty) {
      images.addAll(product.images);
    }
    notifyListeners();
  }
}
