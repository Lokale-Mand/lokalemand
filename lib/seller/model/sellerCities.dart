class SellerCities {
  String? status;
  String? message;
  String? total;
  List<SellerCitiesData>? data;

  SellerCities({this.status, this.message, this.total, this.data});

  SellerCities.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <SellerCitiesData>[];
      json['data'].forEach((v) {
        data!.add(new SellerCitiesData.fromJson(v));
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

class SellerCitiesData {
  String? id;
  String? name;
  String? state;
  String? formattedAddress;
  String? latitude;
  String? longitude;

  SellerCitiesData(
      {this.id,
      this.name,
      this.state,
      this.formattedAddress,
      this.latitude,
      this.longitude});

  SellerCitiesData.fromJson(Map<String, dynamic> json) {
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
