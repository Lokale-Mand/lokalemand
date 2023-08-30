class OrderStatuses {
  String? status;
  String? message;
  String? total;
  List<OrderStatusesData>? data;

  OrderStatuses({this.status, this.message, this.total, this.data});

  OrderStatuses.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <OrderStatusesData>[];
      json['data'].forEach((v) {
        data!.add(
          new OrderStatusesData.fromJson(v),
        );
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this
          .data!
          .map(
            (v) => v.toJson(),
          )
          .toList();
    }
    return data;
  }
}

class OrderStatusesData {
  String? id;
  String? status;

  OrderStatusesData({this.id, this.status});

  OrderStatusesData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }
}
