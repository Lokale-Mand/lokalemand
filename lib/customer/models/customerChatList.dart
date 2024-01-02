class CustomerChatList {
  String? status;
  String? message;
  String? total;
  List<CustomerChatListData>? data;

  CustomerChatList({this.status, this.message, this.total, this.data});

  CustomerChatList.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <CustomerChatListData>[];
      json['data'].forEach((v) {
        data!.add(new CustomerChatListData.fromJson(v));
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

class CustomerChatListData {
  String? id;
  String? senderId;
  String? senderType;
  String? receiverId;
  String? orderId;
  String? message;
  String? createdAt;
  String? sellerId;
  String? sellerName;
  String? sellerLogo;

  CustomerChatListData(
      {this.id,
        this.senderId,
        this.senderType,
        this.receiverId,
        this.orderId,
        this.message,
        this.createdAt,
        this.sellerId,
        this.sellerName,
        this.sellerLogo});

  CustomerChatListData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    senderId = json['sender_id'].toString();
    senderType = json['sender_type'].toString();
    receiverId = json['receiver_id'].toString();
    orderId = json['order_id'].toString();
    message = json['message'].toString();
    createdAt = json['created_at'].toString();
    sellerId = json['seller_id'].toString();
    sellerName = json['seller_name'].toString();
    sellerLogo = json['seller_logo'].toString();
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
    data['seller_id'] = this.sellerId;
    data['seller_name'] = this.sellerName;
    data['seller_logo'] = this.sellerLogo;
    return data;
  }
}
