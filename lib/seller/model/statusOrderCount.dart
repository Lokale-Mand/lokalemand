class StatusOrderCount {
  StatusOrderCount({
    this.id,
    this.status,
    this.orderCount,
  });

  late final String? id;
  late final String? status;
  late final String? orderCount;

  StatusOrderCount.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    status = json['status'].toString();
    orderCount = json['order_count'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['status'] = status;
    _data['order_count'] = orderCount;
    return _data;
  }
}