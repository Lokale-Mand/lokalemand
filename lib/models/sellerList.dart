class SellerList {
  String? status;
  String? message;
  String? total;
  List<SellerListData>? data;

  SellerList({this.status, this.message, this.total, this.data});

  SellerList.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null){
      data = <SellerListData>[];
      json['data'].forEach((v){
        data!.add(new SellerListData.fromJson(v));
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

class SellerListData {
  String? id;
  String? name;
  String? storeName;
  String? latitude;
  String? longitude;
  String? categories;
  String? distance;
  String? maxDeliverableDistance;
  String? logoUrl;

  SellerListData(
      {this.id,
        this.name,
        this.storeName,
        this.latitude,
        this.longitude,
        this.categories,
        this.distance,
        this.maxDeliverableDistance,
        this.logoUrl});

  SellerListData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    storeName = json['store_name'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    categories = json['categories'].toString();
    distance = json['distance'].toString();
    maxDeliverableDistance = json['max_deliverable_distance'].toString();
    logoUrl = json['logo_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['store_name'] = this.storeName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['categories'] = this.categories;
    data['distance'] = this.distance;
    data['max_deliverable_distance'] = this.maxDeliverableDistance;
    data['logo_url'] = this.logoUrl;
    return data;
  }
}
