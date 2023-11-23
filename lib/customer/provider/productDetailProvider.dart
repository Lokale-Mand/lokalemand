import 'package:lokale_mand/helper/utils/generalImports.dart';

enum ProductDetailState {
  initial,
  loading,
  loaded,
  error,
}

class ProductDetailProvider extends ChangeNotifier {
  ProductDetailState productDetailState = ProductDetailState.initial;
  String message = '';
  late ProductData productData;
  late ProductDetail productDetail;
  late int currentImage = 0;
  late List<String> images = [];
  late List<StoreTime> storeTime = [];

  Future getProductDetailProvider(
      {required Map<String, dynamic> params,
      required BuildContext context,
      String? productId}) async {
    productDetailState = ProductDetailState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> data =
          await getProductDetailApi(context: context, params: params);
      if (data[ApiAndParams.status].toString() == "1") {
        productDetail = ProductDetail.fromJson(data);

        productData = productDetail.data;

        storeTime = (jsonDecode(productDetail.data.storeHours) as List)
            .map((e) => StoreTime.fromJson(Map.from(e)))
            .toList();

        setOtherImages(0, productDetail.data);

        productDetailState = ProductDetailState.loaded;

        notifyListeners();
      } else {
        message = Constant.somethingWentWrong;
        productDetailState = ProductDetailState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      productDetailState = ProductDetailState.error;
      notifyListeners();
      rethrow;
    }
  }

  setOtherImages(int currentIndex, ProductData product) {
    currentImage = 0;
    images = [];
    images.add(product.imageUrl);
    if (product.images.isNotEmpty) {
      images.addAll(product.images);
    }
    notifyListeners();
  }
}
