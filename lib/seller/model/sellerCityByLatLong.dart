class SellerCityByLatLong {
  String? status;
  String? message;
  String? total;
  List<SellerCityByLatLongData>? data;

  SellerCityByLatLong({this.status, this.message, this.total, this.data});

  SellerCityByLatLong.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <SellerCityByLatLongData>[];
      json['data'].forEach((v) {
        data!.add(new SellerCityByLatLongData.fromJson(v));
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

class SellerCityByLatLongData {
  String? id;
  String? name;
  String? state;
  String? formattedAddress;
  String? latitude;
  String? longitude;

  SellerCityByLatLongData(
      {this.id,
        this.name,
        this.state,
        this.formattedAddress,
        this.latitude,
        this.longitude});

  SellerCityByLatLongData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    state = json['state'].toString();
    formattedAddress = json['formatted_address'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state'] = this.state;
    data['formatted_address'] = this.formattedAddress;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
