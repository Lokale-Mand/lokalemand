class SellerProfile {
  String? status;
  String? message;
  String? total;
  SellerProfileData? data;

  SellerProfile({this.status, this.message, this.total, this.data});

  SellerProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = json['data'] != null ? new SellerProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != String) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SellerProfileData {
  SellerProfileUser? user;
  String? accessToken;

  SellerProfileData({this.user, this.accessToken});

  SellerProfileData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new SellerProfileUser.fromJson(json['user']) : null;
    accessToken = json['access_token'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != String) {
      data['user'] = this.user!.toJson();
    }
    data['access_token'] = this.accessToken;
    return data;
  }
}

class SellerProfileUser {
  String? id;
  String? username;
  String? email;
  String? roleId;
  String? createdBy;
  String? forgotPasswordCode;
  String? fcmId;
  String? rememberToken;
  String? status;
  String? loginAt;
  String? lastActiveAt;
  String? createdAt;
  String? updatedAt;
  List<String>? allPermissions;
  String? sellerStatus;
  String? deliveryBoyStatus;
  Seller? seller;
  Role? role;
  String? deliveryBoy;

  SellerProfileUser(
      {this.id,
      this.username,
      this.email,
      this.roleId,
      this.createdBy,
      this.forgotPasswordCode,
      this.fcmId,
      this.rememberToken,
      this.status,
      this.loginAt,
      this.lastActiveAt,
      this.createdAt,
      this.updatedAt,
      this.allPermissions,
      this.sellerStatus,
      this.deliveryBoyStatus,
      this.seller,
      this.role,
      this.deliveryBoy});

  SellerProfileUser.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    username = json['username'].toString();
    email = json['email'].toString();
    roleId = json['role_id'].toString();
    createdBy = json['created_by'].toString();
    forgotPasswordCode = json['forgot_password_code'].toString();
    fcmId = json['fcm_id'].toString();
    rememberToken = json['remember_token'].toString();
    status = json['status'].toString();
    loginAt = json['login_at'].toString();
    lastActiveAt = json['last_active_at'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    allPermissions = json['allPermissions'].cast<String>();
    sellerStatus = json['seller_status'].toString();
    deliveryBoyStatus = json['delivery_boy_status'].toString();
    seller = seller =
        json['seller'] != null ? new Seller.fromJson(json['seller']) : null;
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    deliveryBoy = json['delivery_boy'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['role_id'] = this.roleId;
    data['created_by'] = this.createdBy;
    data['forgot_password_code'] = this.forgotPasswordCode;
    data['fcm_id'] = this.fcmId;
    data['remember_token'] = this.rememberToken;
    data['status'] = this.status;
    data['login_at'] = this.loginAt;
    data['last_active_at'] = this.lastActiveAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['allPermissions'] = this.allPermissions;
    data['seller_status'] = this.sellerStatus;
    data['delivery_boy_status'] = this.deliveryBoyStatus;
    if (this.seller != String) {
      data['seller'] = this.seller!.toJson();
    }
    if (this.role != String) {
      data['role'] = this.role!.toJson();
    }
    data['delivery_boy'] = this.deliveryBoy;
    return data;
  }
}

class Seller {
  String? id;
  String? adminId;
  String? name;
  String? storeName;
  String? slug;
  String? email;
  String? mobile;
  String? balance;
  String? storeUrl;
  String? logo;
  String? storeDescription;
  String? street;
  String? pincodeId;
  String? cityId;
  String? state;
  String? categories;
  String? accountNumber;
  String? bankIfscCode;
  String? accountName;
  String? bankName;
  String? commission;
  String? status;
  String? requireProductsApproval;
  String? fcmId;
  String? nationalIdentityCard;
  String? addressProof;
  String? panNumber;
  String? taxName;
  String? taxNumber;
  String? customerPrivacy;
  String? latitude;
  String? longitude;
  String? placeName;
  String? formattedAddress;
  String? forgotPasswordCode;
  String? viewOrderOtp;
  String? assignDeliveryBoy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? remark;
  String? changeOrderStatusDelivered;
  String? logoUrl;
  String? nationalIdentityCardUrl;
  String? addressProofUrl;

  Seller(
      {this.id,
      this.adminId,
      this.name,
      this.storeName,
      this.slug,
      this.email,
      this.mobile,
      this.balance,
      this.storeUrl,
      this.logo,
      this.storeDescription,
      this.street,
      this.pincodeId,
      this.cityId,
      this.state,
      this.categories,
      this.accountNumber,
      this.bankIfscCode,
      this.accountName,
      this.bankName,
      this.commission,
      this.status,
      this.requireProductsApproval,
      this.fcmId,
      this.nationalIdentityCard,
      this.addressProof,
      this.panNumber,
      this.taxName,
      this.taxNumber,
      this.customerPrivacy,
      this.latitude,
      this.longitude,
      this.placeName,
      this.formattedAddress,
      this.forgotPasswordCode,
      this.viewOrderOtp,
      this.assignDeliveryBoy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.remark,
      this.changeOrderStatusDelivered,
      this.logoUrl,
      this.nationalIdentityCardUrl,
      this.addressProofUrl});

  Seller.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    adminId = json['admin_id'].toString();
    name = json['name'].toString();
    storeName = json['store_name'].toString();
    slug = json['slug'].toString();
    email = json['email'].toString();
    mobile = json['mobile'].toString();
    balance = json['balance'].toString();
    storeUrl = json['store_url'].toString();
    logo = json['logo'].toString();
    storeDescription = json['store_description'].toString();
    street = json['street'].toString();
    pincodeId = json['pincode_id'].toString();
    cityId = json['city_id'].toString();
    state = json['state'].toString();
    categories = json['categories'].toString();
    accountNumber = json['account_number'].toString();
    bankIfscCode = json['bank_ifsc_code'].toString();
    accountName = json['account_name'].toString();
    bankName = json['bank_name'].toString();
    commission = json['commission'].toString();
    status = json['status'].toString();
    requireProductsApproval = json['require_products_approval'].toString();
    fcmId = json['fcm_id'].toString();
    nationalIdentityCard = json['national_identity_card'].toString();
    addressProof = json['address_proof'].toString();
    panNumber = json['pan_number'].toString();
    taxName = json['tax_name'].toString();
    taxNumber = json['tax_number'].toString();
    customerPrivacy = json['customer_privacy'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    placeName = json['place_name'].toString();
    formattedAddress = json['formatted_address'].toString();
    forgotPasswordCode = json['forgot_password_code'].toString();
    viewOrderOtp = json['view_order_otp'].toString();
    assignDeliveryBoy = json['assign_delivery_boy'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    remark = json['remark'].toString();
    changeOrderStatusDelivered =
        json['change_order_status_delivered'].toString();
    logoUrl = json['logo_url'].toString();
    nationalIdentityCardUrl = json['national_identity_card_url'].toString();
    addressProofUrl = json['address_proof_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['admin_id'] = this.adminId;
    data['name'] = this.name;
    data['store_name'] = this.storeName;
    data['slug'] = this.slug;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['balance'] = this.balance;
    data['store_url'] = this.storeUrl;
    data['logo'] = this.logo;
    data['store_description'] = this.storeDescription;
    data['street'] = this.street;
    data['pincode_id'] = this.pincodeId;
    data['city_id'] = this.cityId;
    data['state'] = this.state;
    data['categories'] = this.categories;
    data['account_number'] = this.accountNumber;
    data['bank_ifsc_code'] = this.bankIfscCode;
    data['account_name'] = this.accountName;
    data['bank_name'] = this.bankName;
    data['commission'] = this.commission;
    data['status'] = this.status;
    data['require_products_approval'] = this.requireProductsApproval;
    data['fcm_id'] = this.fcmId;
    data['national_identity_card'] = this.nationalIdentityCard;
    data['address_proof'] = this.addressProof;
    data['pan_number'] = this.panNumber;
    data['tax_name'] = this.taxName;
    data['tax_number'] = this.taxNumber;
    data['customer_privacy'] = this.customerPrivacy;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['place_name'] = this.placeName;
    data['formatted_address'] = this.formattedAddress;
    data['forgot_password_code'] = this.forgotPasswordCode;
    data['view_order_otp'] = this.viewOrderOtp;
    data['assign_delivery_boy'] = this.assignDeliveryBoy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['remark'] = this.remark;
    data['change_order_status_delivered'] = this.changeOrderStatusDelivered;
    data['logo_url'] = this.logoUrl;
    data['national_identity_card_url'] = this.nationalIdentityCardUrl;
    data['address_proof_url'] = this.addressProofUrl;
    return data;
  }
}

class Role {
  String? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;

  Role({this.id, this.name, this.guardName, this.createdAt, this.updatedAt});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    guardName = json['guard_name'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['guard_name'] = this.guardName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
