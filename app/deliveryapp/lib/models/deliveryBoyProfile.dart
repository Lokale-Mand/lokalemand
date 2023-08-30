class DeliveryBoyProfile {
  String? id;
  String? adminId;
  String? cityId;
  String? name;
  String? mobile;
  String? orderNote;
  String? address;
  String? bonus;
  String? balance;
  String? drivingLicense;
  String? nationalIdentityCard;
  String? dob;
  String? bankAccountNumber;
  String? bankName;
  String? accountName;
  String? ifscCode;
  String? otherPaymentInformation;
  String? status;
  String? isAvailable;
  String? fcmId;
  String? pincodeId;
  String? cashReceived;
  String? createdAt;
  String? updatedAt;
  String? pendingOrderCount;

  DeliveryBoyProfile(
      {this.id,
      this.adminId,
      this.cityId,
      this.name,
      this.mobile,
      this.orderNote,
      this.address,
      this.bonus,
      this.balance,
      this.drivingLicense,
      this.nationalIdentityCard,
      this.dob,
      this.bankAccountNumber,
      this.bankName,
      this.accountName,
      this.ifscCode,
      this.otherPaymentInformation,
      this.status,
      this.isAvailable,
      this.fcmId,
      this.pincodeId,
      this.cashReceived,
      this.createdAt,
      this.updatedAt,
      this.pendingOrderCount});

  DeliveryBoyProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    adminId = json['admin_id'].toString();
    cityId = json['city_id'].toString();
    name = json['name'].toString();
    mobile = json['mobile'].toString();
    orderNote = json['order_note'].toString();
    address = json['address'].toString();
    bonus = json['bonus'].toString();
    balance = json['balance'].toString();
    drivingLicense = json['driving_license'].toString();
    nationalIdentityCard = json['national_identity_card'].toString();
    dob = json['dob'].toString();
    bankAccountNumber = json['bank_account_number'].toString();
    bankName = json['bank_name'].toString();
    accountName = json['account_name'].toString();
    ifscCode = json['ifsc_code'].toString();
    otherPaymentInformation = json['other_payment_information'].toString();
    status = json['status'].toString();
    isAvailable = json['is_available'].toString();
    fcmId = json['fcm_id'].toString();
    pincodeId = json['pincode_id'].toString();
    cashReceived = json['cash_received'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    pendingOrderCount = json['pending_order_count'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['admin_id'] = this.adminId;
    data['city_id'] = this.cityId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['order_note'] = this.orderNote;
    data['address'] = this.address;
    data['bonus'] = this.bonus;
    data['balance'] = this.balance;
    data['driving_license'] = this.drivingLicense;
    data['national_identity_card'] = this.nationalIdentityCard;
    data['dob'] = this.dob;
    data['bank_account_number'] = this.bankAccountNumber;
    data['bank_name'] = this.bankName;
    data['account_name'] = this.accountName;
    data['ifsc_code'] = this.ifscCode;
    data['other_payment_information'] = this.otherPaymentInformation;
    data['status'] = this.status;
    data['is_available'] = this.isAvailable;
    data['fcm_id'] = this.fcmId;
    data['pincode_id'] = this.pincodeId;
    data['cash_received'] = this.cashReceived;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['pending_order_count'] = this.pendingOrderCount;
    return data;
  }
}
