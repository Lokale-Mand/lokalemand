class SellerCityByLatLong {
  String? status;
  String? message;
  String? total;
  SellerCityByLatLongData? data;

  SellerCityByLatLong({this.status, this.message, this.total, this.data});

  SellerCityByLatLong.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = json['data'] != null
        ? new SellerCityByLatLongData.fromJson(json['data'])
        : null;
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

class SellerCityByLatLongData {
  String? id;
  String? name;
  String? state;
  String? formattedAddress;
  String? latitude;
  String? longitude;
  String? minAmountForFreeDelivery;
  String? deliveryChargeMethod;
  String? fixedCharge;
  String? perKmCharge;
  String? timeToTravel;
  String? maxDeliverableDistance;
  String? distance;

  SellerCityByLatLongData(
      {this.id,
      this.name,
      this.state,
      this.formattedAddress,
      this.latitude,
      this.longitude,
      this.minAmountForFreeDelivery,
      this.deliveryChargeMethod,
      this.fixedCharge,
      this.perKmCharge,
      this.timeToTravel,
      this.maxDeliverableDistance,
      this.distance});

  SellerCityByLatLongData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    state = json['state'].toString();
    formattedAddress = json['formatted_address'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    minAmountForFreeDelivery = json['min_amount_for_free_delivery'].toString();
    deliveryChargeMethod = json['delivery_charge_method'].toString();
    fixedCharge = json['fixed_charge'].toString();
    perKmCharge = json['per_km_charge'].toString();
    timeToTravel = json['time_to_travel'].toString();
    maxDeliverableDistance = json['max_deliverable_distance'].toString();
    distance = json['distance'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state'] = this.state;
    data['formatted_address'] = this.formattedAddress;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['min_amount_for_free_delivery'] = this.minAmountForFreeDelivery;
    data['delivery_charge_method'] = this.deliveryChargeMethod;
    data['fixed_charge'] = this.fixedCharge;
    data['per_km_charge'] = this.perKmCharge;
    data['time_to_travel'] = this.timeToTravel;
    data['max_deliverable_distance'] = this.maxDeliverableDistance;
    data['distance'] = this.distance;
    return data;
  }
}
