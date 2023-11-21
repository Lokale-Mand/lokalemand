class StoreTime {
  String? day;
  String? openTime;
  String? closeTime;
  String? storeOpen;

  StoreTime({this.day, this.openTime, this.closeTime, this.storeOpen});

  StoreTime.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    storeOpen = json['store_open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['open_time'] = this.openTime;
    data['close_time'] = this.closeTime;
    data['store_open'] = this.storeOpen;
    return data;
  }
}
