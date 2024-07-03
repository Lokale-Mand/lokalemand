import 'package:lokale_mand/seller/model/orderDetail.dart';

class OrderDetail {
  String? status;
  String? message;
  String? total;
  OrderDetailData? data;

  OrderDetail({this.status, this.message, this.total, this.data});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = json['data'] != null
        ? new OrderDetailData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OrderDetailData {
  Order? order;
  List<OrderItem>? orderItem;
  List<DeliveryBoys>? deliveryBoys;

  OrderDetailData({this.order, this.orderItem, this.deliveryBoys});

  OrderDetailData.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    if (json['order_items'] != null) {
      orderItem = <OrderItem>[];
      json['order_items'].forEach((v) {
        orderItem!.add(new OrderItem.fromJson(v));
      });
    }
    if (json['deliveryBoys'] != null) {
      deliveryBoys = <DeliveryBoys>[];
      json['deliveryBoys'].forEach((v) {
        deliveryBoys!.add(new DeliveryBoys.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    if (this.orderItem != null) {
      data['order_items'] = this.orderItem!.map((v) => v.toJson()).toList();
    }
    if (this.deliveryBoys != null) {
      data['deliveryBoys'] = this.deliveryBoys!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  String? id;
  String? userId;
  String? deliveryBoyId;
  String? deliveryBoyBonusDetails;
  String? deliveryBoyBonusAmount;
  String? transactionId;
  String? ordersId;
  String? otp;
  String? mobile;
  String? orderNote;
  String? total;
  String? deliveryCharge;
  String? taxAmount;
  String? taxPercentage;
  String? walletBalance;
  String? discount;
  String? promoCode;
  String? promoDiscount;
  String? finalTotal;
  String? paymentMethod;
  String? address;
  String? latitude;
  String? longitude;
  String? deliveryTime;
  String? status;
  String? activeStatus;
  String? orderFrom;
  String? pincodeId;
  String? addressId;
  String? areaId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? orderId;
  String? name;
  String? email;
  String? password;
  String? profile;
  String? countryCode;
  String? authUid;
  String? balance;
  String? referralCode;
  String? friendsCode;
  String? stripeId;
  String? pmType;
  String? pmLastFour;
  String? trialEndsAt;
  String? userName;
  String? userEmail;
  String? userMobile;
  String? type;
  String? alternateMobile;
  String? landmark;
  String? area;
  String? pincode;
  String? cityId;
  String? city;
  String? state;
  String? country;
  String? isDefault;
  String? customerAddress;
  String? customerLandmark;
  String? customerArea;
  String? customerPincode;
  String? customerCity;
  String? customerState;
  String? customerCountry;
  String? customerLatitude;
  String? customerLongitude;
  String? sellerName;
  String? sellerMobile;
  String? sellerEmail;
  String? storeName;
  String? sellerFormattedAddress;
  String? sellerPlaceName;
  String? sellerLatitude;
  String? sellerLongitude;
  String? deliveryBoyName;
  String? orderItemId;
  String? statusName;
  String? cityName;

  Order(
      {this.id,
      this.userId,
      this.deliveryBoyId,
      this.deliveryBoyBonusDetails,
      this.deliveryBoyBonusAmount,
      this.transactionId,
      this.ordersId,
      this.otp,
      this.mobile,
      this.orderNote,
      this.total,
      this.deliveryCharge,
      this.taxAmount,
      this.taxPercentage,
      this.walletBalance,
      this.discount,
      this.promoCode,
      this.promoDiscount,
      this.finalTotal,
      this.paymentMethod,
      this.address,
      this.latitude,
      this.longitude,
      this.deliveryTime,
      this.status,
      this.activeStatus,
      this.orderFrom,
      this.pincodeId,
      this.addressId,
      this.areaId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.orderId,
      this.name,
      this.email,
      this.password,
      this.profile,
      this.countryCode,
      this.authUid,
      this.balance,
      this.referralCode,
      this.friendsCode,
      this.stripeId,
      this.pmType,
      this.pmLastFour,
      this.trialEndsAt,
      this.userName,
      this.userEmail,
      this.userMobile,
      this.type,
      this.alternateMobile,
      this.landmark,
      this.area,
      this.pincode,
      this.cityId,
      this.city,
      this.state,
      this.country,
      this.isDefault,
      this.customerAddress,
      this.customerLandmark,
      this.customerArea,
      this.customerPincode,
      this.customerCity,
      this.customerState,
      this.customerCountry,
      this.customerLatitude,
      this.customerLongitude,
      this.sellerName,
      this.sellerMobile,
      this.sellerEmail,
      this.storeName,
      this.sellerFormattedAddress,
      this.sellerPlaceName,
      this.sellerLatitude,
      this.sellerLongitude,
      this.deliveryBoyName,
      this.orderItemId,
      this.statusName,
      this.cityName});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    deliveryBoyId = json['delivery_boy_id'].toString();
    deliveryBoyBonusDetails = json['delivery_boy_bonus_details'].toString();
    deliveryBoyBonusAmount = json['delivery_boy_bonus_amount'].toString();
    transactionId = json['transaction_id'].toString();
    ordersId = json['orders_id'].toString();
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
    status = json['status'].toString();
    activeStatus = json['active_status'].toString();
    orderFrom = json['order_from'].toString();
    pincodeId = json['pincode_id'].toString();
    addressId = json['address_id'].toString();
    areaId = json['area_id'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    orderId = json['order_id'].toString();
    name = json['name'].toString();
    email = json['email'].toString();
    password = json['password'].toString();
    profile = json['profile'].toString();
    countryCode = json['country_code'].toString();
    authUid = json['auth_uid'].toString();
    balance = json['balance'].toString();
    referralCode = json['referral_code'].toString();
    friendsCode = json['friends_code'].toString();
    stripeId = json['stripe_id'].toString();
    pmType = json['pm_type'].toString();
    pmLastFour = json['pm_last_four'].toString();
    trialEndsAt = json['trial_ends_at'].toString();
    userName = json['user_name'].toString();
    userEmail = json['user_email'].toString();
    userMobile = json['user_mobile'].toString();
    type = json['type'].toString();
    alternateMobile = json['alternate_mobile'].toString();
    landmark = json['landmark'].toString();
    area = json['area'].toString();
    pincode = json['pincode'].toString();
    cityId = json['city_id'].toString();
    city = json['city'].toString();
    state = json['state'].toString();
    country = json['country'].toString();
    isDefault = json['is_default'].toString();
    customerAddress = json['customer_address'].toString();
    customerLandmark = json['customer_landmark'].toString();
    customerArea = json['customer_area'].toString();
    customerPincode = json['customer_pincode'].toString();
    customerCity = json['customer_city'].toString();
    customerState = json['customer_state'].toString();
    customerCountry = json['customer_country'].toString();
    customerLatitude = json['customer_latitude'].toString();
    customerLongitude = json['customer_longitude'].toString();
    sellerName = json['seller_name'].toString();
    sellerMobile = json['seller_mobile'].toString();
    sellerEmail = json['seller_email'].toString();
    storeName = json['store_name'].toString();
    sellerFormattedAddress = json['seller_formatted_address'].toString();
    sellerPlaceName = json['seller_place_name'].toString();
    sellerLatitude = json['seller_latitude'].toString();
    sellerLongitude = json['seller_longitude'].toString();
    deliveryBoyName = json['delivery_boy_name'].toString();
    orderItemId = json['order_item_id'].toString();
    statusName = json['status_name'].toString();
    cityName = json['city_name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['delivery_boy_id'] = this.deliveryBoyId;
    data['delivery_boy_bonus_details'] = this.deliveryBoyBonusDetails;
    data['delivery_boy_bonus_amount'] = this.deliveryBoyBonusAmount;
    data['transaction_id'] = this.transactionId;
    data['orders_id'] = this.ordersId;
    data['otp'] = this.otp;
    data['mobile'] = this.mobile;
    data['order_note'] = this.orderNote;
    data['total'] = this.total;
    data['delivery_charge'] = this.deliveryCharge;
    data['tax_amount'] = this.taxAmount;
    data['tax_percentage'] = this.taxPercentage;
    data['wallet_balance'] = this.walletBalance;
    data['discount'] = this.discount;
    data['promo_code'] = this.promoCode;
    data['promo_discount'] = this.promoDiscount;
    data['final_total'] = this.finalTotal;
    data['payment_method'] = this.paymentMethod;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['delivery_time'] = this.deliveryTime;
    data['status'] = this.status;
    data['active_status'] = this.activeStatus;
    data['order_from'] = this.orderFrom;
    data['pincode_id'] = this.pincodeId;
    data['address_id'] = this.addressId;
    data['area_id'] = this.areaId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['order_id'] = this.orderId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['profile'] = this.profile;
    data['country_code'] = this.countryCode;
    data['auth_uid'] = this.authUid;
    data['balance'] = this.balance;
    data['referral_code'] = this.referralCode;
    data['friends_code'] = this.friendsCode;
    data['stripe_id'] = this.stripeId;
    data['pm_type'] = this.pmType;
    data['pm_last_four'] = this.pmLastFour;
    data['trial_ends_at'] = this.trialEndsAt;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['user_mobile'] = this.userMobile;
    data['type'] = this.type;
    data['alternate_mobile'] = this.alternateMobile;
    data['landmark'] = this.landmark;
    data['area'] = this.area;
    data['pincode'] = this.pincode;
    data['city_id'] = this.cityId;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['is_default'] = this.isDefault;
    data['customer_address'] = this.customerAddress;
    data['customer_landmark'] = this.customerLandmark;
    data['customer_area'] = this.customerArea;
    data['customer_pincode'] = this.customerPincode;
    data['customer_city'] = this.customerCity;
    data['customer_state'] = this.customerState;
    data['customer_country'] = this.customerCountry;
    data['customer_latitude'] = this.customerLatitude;
    data['customer_longitude'] = this.customerLongitude;
    data['seller_name'] = this.sellerName;
    data['seller_mobile'] = this.sellerMobile;
    data['seller_email'] = this.sellerEmail;
    data['store_name'] = this.storeName;
    data['seller_formatted_address'] = this.sellerFormattedAddress;
    data['seller_place_name'] = this.sellerPlaceName;
    data['seller_latitude'] = this.sellerLatitude;
    data['seller_longitude'] = this.sellerLongitude;
    data['delivery_boy_name'] = this.deliveryBoyName;
    data['order_item_id'] = this.orderItemId;
    data['status_name'] = this.statusName;
    data['city_name'] = this.cityName;
    return data;
  }
}

class OrderItem {
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
  String? orderStatus;
  String? sellerName;
  String? productId;
  String? statusName;

  OrderItem(
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
      this.orderStatus,
      this.sellerName,
      this.productId,
      this.statusName});

  OrderItem.fromJson(Map<String, dynamic> json) {
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
    orderStatus = json['order_status'].toString();
    sellerName = json['seller_name'].toString();
    productId = json['product_id'].toString();
    statusName = json['status_name'].toString();
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
    data['order_status'] = this.orderStatus;
    data['seller_name'] = this.sellerName;
    data['product_id'] = this.productId;
    data['status_name'] = this.statusName;
    return data;
  }
}

class DeliveryBoys {
  String? id;
  String? name;
  String? pendingOrderCount;

  DeliveryBoys({this.id, this.name, this.pendingOrderCount});

  DeliveryBoys.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    pendingOrderCount = json['pending_order_count'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['pending_order_count'] = this.pendingOrderCount;
    return data;
  }
}
