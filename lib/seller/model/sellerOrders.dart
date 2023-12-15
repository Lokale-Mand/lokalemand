import 'package:lokale_mand/seller/model/statusOrderCount.dart';

class SellerOrder {
  SellerOrder({
    this.status,
    this.message,
    this.total,
    this.data,
  });

  late final String? status;
  late final String? message;
  late final String? total;
  late final SellerOrderData? data;

  SellerOrder.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = SellerOrderData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['total'] = total;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class SellerOrderData {
  SellerOrderData({
    this.statusOrderCount,
    this.orders,
  });

  late final List<StatusOrderCount>? statusOrderCount;
  late final List<SellerOrdersListItem>? orders;
  late final List<SellerOrdersListProductItem>? ordersItems;

  SellerOrderData.fromJson(Map<String, dynamic> json) {
    statusOrderCount = List.from(json['status_order_count'])
        .map(
          (e) => StatusOrderCount.fromJson(e),
        )
        .toList();
    orders = List.from(json['orders'])
        .map(
          (e) => SellerOrdersListItem.fromJson(e),
        )
        .toList();
    ordersItems = List.from(json['order_items'])
        .map(
          (e) => SellerOrdersListProductItem.fromJson(e),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status_order_count'] = statusOrderCount
        ?.map(
          (e) => e.toJson(),
        )
        .toList();
    _data['orders'] = orders
        ?.map(
          (e) => e.toJson(),
        )
        .toList();
    return _data;
  }
}

class SellerOrdersListItem {
  SellerOrdersListItem({
    this.id,
    this.deliveryBoyId,
    this.orderId,
    this.mobile,
    this.orderNote,
    this.total,
    this.deliveryCharge,
    this.taxAmount,
    this.taxPercentage,
    this.discount,
    this.finalTotal,
    this.paymentMethod,
    this.address,
    this.latitude,
    this.longitude,
    this.deliveryTime,
    this.activeStatus,
    this.addressId,
    this.createdAt,
    this.deliveryBoyName,
    this.sellerName,
    this.userName,
    this.orderStatus,
  });

  late final String? id;
  late final String? deliveryBoyId;
  late final String? orderId;
  late final String? mobile;
  late final String? orderNote;
  late final String? total;
  late final String? deliveryCharge;
  late final String? taxAmount;
  late final String? taxPercentage;
  late final String? discount;
  late final String? finalTotal;
  late final String? paymentMethod;
  late final String? address;
  late final String? latitude;
  late final String? longitude;
  late final String? deliveryTime;
  late final String? activeStatus;
  late final String? addressId;
  late final String? createdAt;
  late final String? deliveryBoyName;
  late final String? sellerName;
  late final String? userName;
  late final String? orderStatus;

  SellerOrdersListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    deliveryBoyId = json['delivery_boy_id'].toString();
    orderId = json['order_id'].toString();
    mobile = json['mobile'].toString();
    orderNote = json['order_note'].toString();
    total = json['total'].toString();
    deliveryCharge = json['delivery_charge'].toString();
    taxAmount = json['tax_amount'].toString();
    taxPercentage = json['tax_percentage'].toString();
    discount = json['discount'].toString();
    finalTotal = json['final_total'].toString();
    paymentMethod = json['payment_method'].toString();
    address = json['address'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    deliveryTime = json['delivery_time'].toString();
    activeStatus = json['active_status'].toString();
    addressId = json['address_id'].toString();
    createdAt = json['created_at'].toString();
    deliveryBoyName = json['delivery_boy_name'].toString();
    sellerName = json['seller_name'].toString();
    userName = json['user_name'].toString();
    orderStatus = json['order_status'].toString();
  }

  SellerOrdersListItem copyWith(
      {String? newDeliveryBoyId,
      String? newDeliveryBoyName,
      String? activeStatus}) {
    return SellerOrdersListItem(
      id: this.id,
      deliveryBoyId: newDeliveryBoyId ?? this.deliveryBoyId,
      orderId: this.orderId,
      mobile: this.mobile,
      orderNote: this.orderNote,
      total: this.total,
      deliveryCharge: this.deliveryCharge,
      taxAmount: this.taxAmount,
      taxPercentage: this.taxPercentage,
      discount: this.discount,
      finalTotal: this.finalTotal,
      paymentMethod: this.paymentMethod,
      address: this.address,
      latitude: this.latitude,
      longitude: this.longitude,
      deliveryTime: this.deliveryTime,
      activeStatus: activeStatus ?? this.activeStatus,
      addressId: this.addressId,
      createdAt: this.createdAt,
      deliveryBoyName: newDeliveryBoyName ?? this.deliveryBoyName,
      sellerName: sellerName,
      userName: this.userName,
      orderStatus: this.orderStatus,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['delivery_boy_id'] = deliveryBoyId;
    _data['order_id'] = orderId;
    _data['mobile'] = mobile;
    _data['order_note'] = orderNote;
    _data['total'] = total;
    _data['delivery_charge'] = deliveryCharge;
    _data['tax_amount'] = taxAmount;
    _data['tax_percentage'] = taxPercentage;
    _data['discount'] = discount;
    _data['final_total'] = finalTotal;
    _data['payment_method'] = paymentMethod;
    _data['address'] = address;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['delivery_time'] = deliveryTime;
    _data['active_status'] = activeStatus;
    _data['address_id'] = addressId;
    _data['created_at'] = createdAt;
    _data['delivery_boy_name'] = deliveryBoyName;
    _data['seller_name'] = sellerName;
    _data['user_name'] = userName;
    _data['order_status'] = orderStatus;
    return _data;
  }
}

class SellerOrdersListProductItem {
  String? id;
  String? userId;
  String? orderId;
  String? ordersId;
  String? productName;
  String? variantName;
  String? productVariantId;
  String? deliveryBoyId;
  String? quantity;
  String? price;
  String? discountedPrice;
  String? taxAmount;
  String? taxPercentage;
  String? discount;
  String? subTotal;
  String? status;
  String? activeStatus;
  String? sellerId;
  String? isCredited;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? mobile;
  String? total;
  String? deliveryCharge;
  String? promoCode;
  String? promoDiscount;
  String? walletBalance;
  String? finalTotal;
  String? paymentMethod;
  String? address;
  String? deliveryTime;
  String? userName;
  String? image;
  String? orderStatus;
  String? sellerName;

  SellerOrdersListProductItem(
      {this.id,
      this.userId,
      this.orderId,
      this.ordersId,
      this.productName,
      this.variantName,
      this.productVariantId,
      this.deliveryBoyId,
      this.quantity,
      this.price,
      this.discountedPrice,
      this.taxAmount,
      this.taxPercentage,
      this.discount,
      this.subTotal,
      this.status,
      this.activeStatus,
      this.sellerId,
      this.isCredited,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.mobile,
      this.total,
      this.deliveryCharge,
      this.promoCode,
      this.promoDiscount,
      this.walletBalance,
      this.finalTotal,
      this.paymentMethod,
      this.address,
      this.deliveryTime,
      this.userName,
      this.image,
      this.orderStatus,
      this.sellerName});

  SellerOrdersListProductItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    orderId = json['order_id'].toString();
    ordersId = json['orders_id'].toString();
    productName = json['product_name'].toString();
    variantName = json['variant_name'].toString();
    productVariantId = json['product_variant_id'].toString();
    deliveryBoyId = json['delivery_boy_id'].toString();
    quantity = json['quantity'].toString();
    price = json['price'].toString();
    discountedPrice = json['discounted_price'].toString();
    taxAmount = json['tax_amount'].toString();
    taxPercentage = json['tax_percentage'].toString();
    discount = json['discount'].toString();
    subTotal = json['sub_total'].toString();
    status = json['status'].toString();
    activeStatus = json['active_status'].toString();
    sellerId = json['seller_id'].toString();
    isCredited = json['is_credited'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    mobile = json['mobile'].toString();
    total = json['total'].toString();
    deliveryCharge = json['delivery_charge'].toString();
    promoCode = json['promo_code'].toString();
    promoDiscount = json['promo_discount'].toString();
    walletBalance = json['wallet_balance'].toString();
    finalTotal = json['final_total'].toString();
    paymentMethod = json['payment_method'].toString();
    address = json['address'].toString();
    deliveryTime = json['delivery_time'].toString();
    userName = json['user_name'].toString();
    image = json['image'].toString();
    orderStatus = json['order_status'].toString();
    sellerName = json['seller_name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_id'] = this.orderId;
    data['orders_id'] = this.ordersId;
    data['product_name'] = this.productName;
    data['variant_name'] = this.variantName;
    data['product_variant_id'] = this.productVariantId;
    data['delivery_boy_id'] = this.deliveryBoyId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['discounted_price'] = this.discountedPrice;
    data['tax_amount'] = this.taxAmount;
    data['tax_percentage'] = this.taxPercentage;
    data['discount'] = this.discount;
    data['sub_total'] = this.subTotal;
    data['status'] = this.status;
    data['active_status'] = this.activeStatus;
    data['seller_id'] = this.sellerId;
    data['is_credited'] = this.isCredited;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['mobile'] = this.mobile;
    data['total'] = this.total;
    data['delivery_charge'] = this.deliveryCharge;
    data['promo_code'] = this.promoCode;
    data['promo_discount'] = this.promoDiscount;
    data['wallet_balance'] = this.walletBalance;
    data['final_total'] = this.finalTotal;
    data['payment_method'] = this.paymentMethod;
    data['address'] = this.address;
    data['delivery_time'] = this.deliveryTime;
    data['user_name'] = this.userName;
    data['image'] = this.image;
    data['order_status'] = this.orderStatus;
    data['seller_name'] = this.sellerName;
    return data;
  }
}
