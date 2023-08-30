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
    data = json['data'] != null ? new OrderDetailData.fromJson(json['data']) : null;
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
  List<OrderItems>? orderItems;

  OrderDetailData({this.order, this.orderItems});

  OrderDetailData.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    if (json['order_items'] != null){
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v){
        orderItems!.add(
          new OrderItems.fromJson(v),
        );
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    if (this.orderItems != null) {
      data['order_items'] = this
          .orderItems!
          .map(
            (v) => v.toJson(),
          )
          .toList();
    }
    return data;
  }
}

class Order {
  String? id;
  String? userId;
  String? deliveryBoyId;
  String? mobile;
  String? orderNote;
  String? total;
  String? deliveryCharge;
  String? discount;
  String? promoDiscount;
  String? finalTotal;
  String? paymentMethod;
  String? address;
  String? latitude;
  String? longitude;
  String? deliveryTime;
  String? activeStatus;
  String? statusName;
  String? orderDate;
  String? orderId;
  String? type;
  String? userName;
  String? userEmail;
  String? alternateMobile;
  String? landmark;
  String? area;
  String? pincode;
  String? city;
  String? state;
  String? country;
  String? street;
  String? customerPrivacy;
  String? deliveryBoyName;

  Order(
      {this.id,
      this.userId,
      this.deliveryBoyId,
      this.mobile,
      this.orderNote,
      this.total,
      this.deliveryCharge,
      this.discount,
      this.promoDiscount,
      this.finalTotal,
      this.paymentMethod,
      this.address,
      this.latitude,
      this.longitude,
      this.deliveryTime,
      this.activeStatus,
      this.statusName,
      this.orderDate,
      this.orderId,
      this.type,
      this.userName,
      this.userEmail,
      this.alternateMobile,
      this.landmark,
      this.area,
      this.pincode,
      this.city,
      this.state,
      this.country,
      this.street,
      this.customerPrivacy,
      this.deliveryBoyName});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    deliveryBoyId = json['delivery_boy_id'].toString();
    mobile = json['mobile'].toString();
    orderNote = json['order_note'].toString();
    total = json['total'].toString();
    deliveryCharge = json['delivery_charge'].toString();
    discount = json['discount'].toString();
    promoDiscount = json['promo_discount'].toString();
    finalTotal = json['final_total'].toString();
    paymentMethod = json['payment_method'].toString();
    address = json['address'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    deliveryTime = json['delivery_time'].toString();
    activeStatus = json['active_status'].toString();
    statusName = json['status_name'].toString();
    orderDate = json['created_at'] ??"2023-05-16T07:38:36.000000Z";
    orderId = json['order_id'].toString();
    type = json['type'].toString();
    userName = json['user_name'].toString();
    userEmail = json['user_email'].toString();
    alternateMobile = json['alternate_mobile'].toString();
    landmark = json['landmark'].toString();
    area = json['area'].toString();
    pincode = json['pincode'].toString();
    city = json['city'].toString();
    state = json['state'].toString();
    country = json['country'].toString();
    street = json['street'].toString();
    customerPrivacy = json['customer_privacy'].toString();
    deliveryBoyName = json['delivery_boy_name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['delivery_boy_id'] = this.deliveryBoyId;
    data['mobile'] = this.mobile;
    data['order_note'] = this.orderNote;
    data['total'] = this.total;
    data['delivery_charge'] = this.deliveryCharge;
    data['discount'] = this.discount;
    data['promo_discount'] = this.promoDiscount;
    data['final_total'] = this.finalTotal;
    data['payment_method'] = this.paymentMethod;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['delivery_time'] = this.deliveryTime;
    data['active_status'] = this.activeStatus;
    data['status_name'] = this.statusName;
    data['created_at'] = this.orderDate;
    data['order_id'] = this.orderId;
    data['type'] = this.type;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['alternate_mobile'] = this.alternateMobile;
    data['landmark'] = this.landmark;
    data['area'] = this.area;
    data['pincode'] = this.pincode;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['street'] = this.street;
    data['customer_privacy'] = this.customerPrivacy;
    data['delivery_boy_name'] = this.deliveryBoyName;
    return data;
  }
}

class OrderItems {
  String? orderId;
  String? productName;
  String? variantName;
  String? deliveryBoyId;
  String? quantity;
  String? price;
  String? discountedPrice;
  String? taxAmount;
  String? taxPercentage;
  String? subTotal;
  String? mobile;
  String? total;
  String? deliveryCharge;
  String? finalTotal;
  String? paymentMethod;
  String? address;
  String? deliveryTime;
  String? userName;
  String? productId;

  OrderItems(
      {this.orderId,
      this.productName,
      this.variantName,
      this.deliveryBoyId,
      this.quantity,
      this.price,
      this.discountedPrice,
      this.taxAmount,
      this.taxPercentage,
      this.subTotal,
      this.mobile,
      this.total,
      this.deliveryCharge,
      this.finalTotal,
      this.paymentMethod,
      this.address,
      this.deliveryTime,
      this.userName,
      this.productId});

  OrderItems.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'].toString();
    productName = json['product_name'].toString();
    variantName = json['variant_name'].toString();
    deliveryBoyId = json['delivery_boy_id'].toString();
    quantity = json['quantity'].toString();
    price = json['price'].toString();
    discountedPrice = json['discounted_price'].toString();
    taxAmount = json['tax_amount'].toString();
    taxPercentage = json['tax_percentage'].toString();
    subTotal = json['sub_total'].toString();
    mobile = json['mobile'].toString();
    total = json['total'].toString();
    deliveryCharge = json['delivery_charge'].toString();
    finalTotal = json['final_total'].toString();
    paymentMethod = json['payment_method'].toString();
    address = json['address'].toString();
    deliveryTime = json['delivery_time'].toString();
    userName = json['user_name'].toString();
    productId = json['product_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['product_name'] = this.productName;
    data['variant_name'] = this.variantName;
    data['delivery_boy_id'] = this.deliveryBoyId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['discounted_price'] = this.discountedPrice;
    data['tax_amount'] = this.taxAmount;
    data['tax_percentage'] = this.taxPercentage;
    data['sub_total'] = this.subTotal;
    data['mobile'] = this.mobile;
    data['total'] = this.total;
    data['delivery_charge'] = this.deliveryCharge;
    data['final_total'] = this.finalTotal;
    data['payment_method'] = this.paymentMethod;
    data['address'] = this.address;
    data['delivery_time'] = this.deliveryTime;
    data['user_name'] = this.userName;
    data['product_id'] = this.productId;
    return data;
  }
}
