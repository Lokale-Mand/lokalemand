class DeliveryBoyDashBoard {
  String? status;
  String? message;
  String? total;
  DeliveryBoyDashBoardData? data;

  DeliveryBoyDashBoard({this.status, this.message, this.total, this.data});

  DeliveryBoyDashBoard.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = json['data'] != null ? new DeliveryBoyDashBoardData.fromJson(json['data']) : null;
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

class DeliveryBoyDashBoardData {
  String? orderCount;
  String? balance;

  DeliveryBoyDashBoardData({this.orderCount, this.balance});

  DeliveryBoyDashBoardData.fromJson(Map<String, dynamic> json) {
    orderCount = json['order_count'].toString();
    balance = json['balance'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_count'] = this.orderCount;
    data['balance'] = this.balance;
    return data;
  }
}
