class Order {
  Order(
      {required this.id,
      required this.userId,
      required this.transactionId,
      required this.otp,
      required this.mobile,
      required this.orderNote,
      required this.total,
      required this.deliveryCharge,
      required this.taxAmount,
      required this.taxPercentage,
      required this.walletBalance,
      required this.discount,
      required this.promoCode,
      required this.promoDiscount,
      required this.finalTotal,
      required this.paymentMethod,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.deliveryTime,
      required this.activeStatus,
      required this.orderFrom,
      required this.pincodeId,
      required this.addressId,
      required this.areaId,
      required this.bankTransferMessage,
      required this.bankTransferStatus,
      required this.userName,
      required this.discountRupees,
      required this.items,
      required this.createdAt,
      required this.status});

  late final String id;
  late final List<List> status;
  late final String userId;
  late final String transactionId;
  late final String otp;
  late final String mobile;
  late final String orderNote;
  late final String total;
  late final String deliveryCharge;
  late final String taxAmount;
  late final String taxPercentage;
  late final String walletBalance;
  late final String discount;
  late final String promoCode;
  late final String promoDiscount;
  late final String finalTotal;
  late final String paymentMethod;
  late final String address;
  late final String latitude;
  late final String longitude;
  late final String deliveryTime;
  late final String activeStatus;
  late final String orderFrom;
  late final String pincodeId;
  late final String addressId;
  late final String areaId;
  late final String bankTransferMessage;
  late final String bankTransferStatus;
  late final String userName;
  late final String discountRupees;
  late final String createdAt;
  late final List<ProductOrderItem> items;

  Order copyWith(
      {List<ProductOrderItem>? ProductOrderItem,
      String? updatedActiveStatus,
      String? newTotal,
      String? newFinalTotal}) {
    return Order(
      id: id,
      userId: userId,
      transactionId: transactionId,
      otp: otp,
      mobile: mobile,
      orderNote: orderNote,
      total: newTotal ?? total,
      deliveryCharge: deliveryCharge,
      taxAmount: taxAmount,
      taxPercentage: taxPercentage,
      walletBalance: walletBalance,
      discount: discount,
      promoCode: promoCode,
      promoDiscount: promoDiscount,
      finalTotal: newFinalTotal ?? finalTotal,
      paymentMethod: paymentMethod,
      address: address,
      latitude: latitude,
      longitude: longitude,
      deliveryTime: deliveryTime,
      activeStatus: updatedActiveStatus ?? activeStatus,
      orderFrom: orderFrom,
      pincodeId: pincodeId,
      addressId: addressId,
      areaId: areaId,
      bankTransferMessage: bankTransferMessage,
      bankTransferStatus: bankTransferStatus,
      userName: userName,
      discountRupees: discountRupees,
      items: ProductOrderItem ?? items,
      createdAt: createdAt,
      status: status,
    );
  }

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    createdAt = json['created_at'].toString();
    userId = json['user_id'].toString();
    transactionId = json['transaction_id'].toString();
    otp = json['otp'].toString();
    mobile = json['mobile'].toString();
    orderNote = json['order_note'].toString();
    total = json['total'].toString();
    deliveryCharge = json['delivery_charge'].toString();
    taxAmount = json['tax_amount'].toString();
    taxPercentage = json['tax_percentage'].toString();
    walletBalance = json['wallet_balance'].toString();
    discount = json['discount'].toString();
    promoCode = json['promo_code'].toString();
    promoDiscount = json['promo_discount'].toString();
    finalTotal = json['final_total'].toString();
    paymentMethod = json['payment_method'].toString();
    address = json['address'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    deliveryTime = json['delivery_time'].toString();
    activeStatus = json['active_status'].toString();
    orderFrom = json['order_from'].toString();
    pincodeId = json['pincode_id'].toString();
    addressId = json['address_id'].toString();
    areaId = json['area_id'].toString();
    bankTransferMessage = json['bank_transfer_message'].toString();
    bankTransferStatus = json['bank_transfer_status'].toString();
    userName = json['user_name'].toString();
    discountRupees = json['discount_rupees'].toString();

    status = ((json['status'] ?? []) as List)
        .map((orderStatus) => List.from(orderStatus))
        .toList();

    items = ((json['items'] ?? []) as List)
        .map((orderItem) => ProductOrderItem.fromJson(Map.from(orderItem ?? {})))
        .toList();
  }
}

class ProductOrderItem {
  ProductOrderItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.orderId,
    required this.productName,
    required this.variantName,
    required this.productVariantId,
    required this.quantity,
    required this.price,
    required this.taxAmount,
    required this.taxPercentage,
    required this.subTotal,
    required this.status,
    required this.activeStatus,
    required this.sellerId,
    required this.variantId,
    required this.name,
    required this.manufacturer,
    required this.madeIn,
    required this.measurement,
    required this.unit,
    required this.imageUrl,
    required this.cancelStatus,
    required this.returnStatus,
    required this.sellerName,
    required this.tillStatus,
    required this.itemRating,
  });

  late final String id;
  late final String userId;
  late final String productId;
  late final String orderId;
  late final String productName;
  late final String variantName;
  late final String productVariantId;
  late final String quantity;
  late final String price;
  late final String taxAmount;
  late final String taxPercentage;
  late final String subTotal;
  late final String status;
  late final String activeStatus;
  late final String sellerId;
  late final String variantId;
  late final String name;
  late final String manufacturer;
  late final String madeIn;
  late final String measurement;
  late final String unit;
  late final String imageUrl;
  late final String cancelStatus;
  late final String returnStatus;
  late final String tillStatus;
  late final String sellerName;
  List<ItemRating>? itemRating;

  ProductOrderItem updateStatus(String itemActiveStatus) {
    return ProductOrderItem(
      id: id,
      userId: userId,
      productId: productId,
      orderId: orderId,
      productName: productName,
      variantName: variantName,
      productVariantId: productVariantId,
      quantity: quantity,
      price: price,
      taxAmount: taxAmount,
      taxPercentage: taxPercentage,
      subTotal: subTotal,
      status: status,
      activeStatus: itemActiveStatus,
      sellerId: sellerId,
      variantId: variantId,
      name: name,
      manufacturer: manufacturer,
      madeIn: madeIn,
      measurement: measurement,
      unit: unit,
      imageUrl: imageUrl,
      cancelStatus: cancelStatus,
      returnStatus: returnStatus,
      sellerName: sellerName,
      tillStatus: tillStatus,
      itemRating: itemRating,
    );
  }

  ProductOrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    productId = json['product_id'].toString();
    returnStatus = json['return_status'].toString();
    cancelStatus = json['cancelable_status'].toString();
    tillStatus = json['till_status'].toString();
    orderId = json['order_id'].toString();
    productName = json['product_name'].toString();
    variantName = json['variant_name'].toString();
    productVariantId = json['product_variant_id'].toString();
    quantity = json['quantity'].toString();
    price = json['price'].toString();
    taxAmount = json['tax_amount'].toString();
    taxPercentage = json['tax_percentage'].toString();
    subTotal = json['sub_total'].toString();
    status = json['status'].toString();
    activeStatus = json['active_status'].toString();
    sellerId = json['seller_id'].toString();
    variantId = json['variant_id'].toString();
    name = json['name'].toString();
    manufacturer = json['manufacturer'].toString();
    madeIn = json['made_in'].toString();
    measurement = json['measurement'].toString();
    unit = json['unit'].toString();
    imageUrl = json['image_url'].toString();
    sellerName = json['seller_name'].toString();
    if (json['item_rating'] != null) {
      itemRating = <ItemRating>[];
      json['item_rating'].forEach((v) {
        itemRating!.add(new ItemRating.fromJson(v));
      });
    }
  }
}

class ItemRating {
  String? id;
  String? productId;
  String? userId;
  String? rate;
  String? review;
  String? status;
  String? updatedAt;
  User? user;
  List<Images>? images;

  ItemRating(
      {this.id,
      this.productId,
      this.userId,
      this.rate,
      this.review,
      this.status,
      this.updatedAt,
      this.user,
      this.images});

  ItemRating.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    productId = json['product_id'].toString();
    userId = json['user_id'].toString();
    rate = json['rate'].toString();
    review = json['review'].toString();
    status = json['status'].toString();
    updatedAt = json['updated_at'].toString();
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['user_id'] = this.userId;
    data['rate'] = this.rate;
    data['review'] = this.review;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? profile;

  User({this.id, this.name, this.profile});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    profile = json['profile'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile'] = this.profile;
    return data;
  }
}

class Images {
  String? id;
  String? productRatingId;
  String? image;
  String? imageUrl;

  Images({this.id, this.productRatingId, this.image, this.imageUrl});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    productRatingId = json['product_rating_id'].toString();
    image = json['image'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_rating_id'] = this.productRatingId;
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
