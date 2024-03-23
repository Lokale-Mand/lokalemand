import 'package:lokale_mand/customer/models/sellerRating.dart';

class SellerChatList {
  String? status;
  String? message;
  String? total;
  List<SellerChatListData>? data;

  SellerChatList({this.status, this.message, this.total, this.data});

  SellerChatList.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <SellerChatListData>[];
      json['data'].forEach((v) {
        data!.add(new SellerChatListData.fromJson(v));
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

class SellerChatListData {
  String? id;
  String? senderId;
  String? senderType;
  String? receiverId;
  String? orderId;
  String? message;
  String? createdAt;
  String? customerId;
  String? customerName;
  String? customerLogo;
  String? isEligibleRating;
  List<SellerRatingData>? rating;

  SellerChatListData(
      {this.id,
        this.senderId,
        this.senderType,
        this.receiverId,
        this.orderId,
        this.message,
        this.createdAt,
        this.customerId,
        this.customerName,
        this.customerLogo,
        this.isEligibleRating,
        this.rating});

  SellerChatListData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    senderId = json['sender_id'].toString();
    senderType = json['sender_type'].toString();
    receiverId = json['receiver_id'].toString();
    orderId = json['order_id'].toString();
    message = json['message'].toString();
    createdAt = json['created_at'].toString();
    customerId = json['customer_id'].toString();
    customerName = json['customer_name'].toString();
    customerLogo = json['customer_logo'].toString();
    isEligibleRating = json['is_eligible_rating'].toString();
    if (json['rating'] != null) {
      rating = <SellerRatingData>[];
      json['rating'].forEach((v) {
        rating!.add(new SellerRatingData.fromJson(v));
      });
    }
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
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['customer_logo'] = this.customerLogo;
    data['is_eligible_rating'] = this.isEligibleRating;
    if (this.rating != null) {
      data['rating'] = this.rating!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
