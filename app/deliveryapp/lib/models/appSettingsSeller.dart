class AppSettingsSeller {
  AppSettingsSeller({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final String status;
  late final String message;
  late final String total;
  late final AppSettingsSellerData data;

  AppSettingsSeller.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = AppSettingsSellerData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['total'] = total;
    _data['data'] = data.toJson();
    return _data;
  }
}

class AppSettingsSellerData {
  AppSettingsSellerData({
    this.currency,
    this.currencyCode,
    this.decimalPoint,
    this.appModeSeller,
    this.privacyPolicySeller,
    this.termsConditionsSeller,
    this.googlePlaceApiKey,
    this.allPermissions,
  });

  late final String? currency;
  late final String? currencyCode;
  late final String? decimalPoint;
  late final String? appModeSeller;
  late final String? privacyPolicySeller;
  late final String? termsConditionsSeller;
  late final String? googlePlaceApiKey;
  late final List<String>? allPermissions;

  AppSettingsSellerData.fromJson(Map<String, dynamic> json) {
    currency = json['currency'].toString();
    currencyCode = json['currency_code'].toString();
    decimalPoint = json['decimal_point'].toString();
    appModeSeller = json['app_mode_seller'].toString();
    privacyPolicySeller = json['privacy_policy_seller'].toString();
    termsConditionsSeller = json['terms_conditions_seller'].toString();
    googlePlaceApiKey = json['google_place_api_key'].toString();
    allPermissions = List.castFrom<dynamic, String>(json['allPermissions']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['currency'] = currency;
    _data['currency_code'] = currencyCode;
    _data['decimal_point'] = decimalPoint;
    _data['app_mode_seller'] = appModeSeller;
    _data['privacy_policy_seller'] = privacyPolicySeller;
    _data['terms_conditions_seller'] = termsConditionsSeller;
    _data['google_place_api_key'] = googlePlaceApiKey;
    _data['allPermissions'] = allPermissions;
    return _data;
  }
}
