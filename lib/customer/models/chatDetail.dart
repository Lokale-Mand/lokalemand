class CustomerChatDetail {
  String? status;
  String? message;
  String? total;
  List<CustomerChatDetailData>? data;

  CustomerChatDetail({this.status, this.message, this.total, this.data});

  CustomerChatDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <CustomerChatDetailData>[];
      json['data'].forEach((v) {
        data!.add(new CustomerChatDetailData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerChatDetailData {
  String? id;
  String? senderId;
  String? senderType;
  String? receiverId;
  String? orderId;
  String? message;
  String? createdAt;
  CustomerChatDetailOrder? order;

  CustomerChatDetailData(
      {this.id,
        this.senderId,
        this.senderType,
        this.receiverId,
        this.orderId,
        this.message,
        this.createdAt,
        this.order});

  CustomerChatDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    senderId = json['sender_id'].toString();
    senderType = json['sender_type'].toString();
    receiverId = json['receiver_id'].toString();
    orderId = json['order_id'].toString();
    message = json['message'].toString();
    createdAt = json['created_at'].toString();
    order = json['order'] != null ? new CustomerChatDetailOrder.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['sender_type'] = this.senderType;
    data['receiver_id'] = this.receiverId;
    data['order_id'] = this.orderId;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class CustomerChatDetailOrder {
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
  String? promoCodeId;
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
  List<Items>? items;
  User? user;

  CustomerChatDetailOrder(
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
        this.promoCodeId,
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
        this.items,
        this.user});

  CustomerChatDetailOrder.fromJson(Map<String, dynamic> json) {
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
    promoCodeId = json['promo_code_id'].toString();
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
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
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
    data['promo_code_id'] = this.promoCodeId;
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
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Items {
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
  String? imageUrl;

  Items(
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
        this.imageUrl});

  Items.fromJson(Map<String, dynamic> json) {
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
    imageUrl = json['image_url'].toString();
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
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? email;
  String? profile;
  String? countryCode;
  String? mobile;
  String? balance;
  String? referralCode;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  User(
      {this.id,
        this.name,
        this.email,
        this.profile,
        this.countryCode,
        this.mobile,
        this.balance,
        this.referralCode,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    email = json['email'].toString();
    profile = json['profile'].toString();
    countryCode = json['country_code'].toString();
    mobile = json['mobile'].toString();
    balance = json['balance'].toString();
    referralCode = json['referral_code'].toString();
    status = json['status'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['profile'] = this.profile;
    data['country_code'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['balance'] = this.balance;
    data['referral_code'] = this.referralCode;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
