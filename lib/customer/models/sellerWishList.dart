class SellerWishList {
  String? status;
  String? message;
  String? total;
  List<SellerWishListData>? data;

  SellerWishList({this.status, this.message, this.total, this.data});

  SellerWishList.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != String) {
      data = <SellerWishListData>[];
      json['data'].forEach((v) {
        data!.add(new SellerWishListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != String) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SellerWishListData {
  String? id;
  String? userId;
  String? sellerId;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;
  Seller? seller;

  SellerWishListData(
      {this.id,
      this.userId,
      this.sellerId,
      this.createdAt,
      this.updatedAt,
      this.imageUrl,
      this.seller});

  SellerWishListData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    sellerId = json['seller_id'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    imageUrl = json['image_url'].toString();
    seller = json['seller'] != Seller()
        ? new Seller.fromJson(json['seller'])
        : Seller();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['seller_id'] = this.sellerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    if (this.seller != String) {
      data['seller'] = this.seller!.toJson();
    }
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
  String? fssaiLicNo;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? remark;
  String? changeOrderStatusDelivered;
  List<StoreHours>? storeHours;
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
      this.fssaiLicNo,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.remark,
      this.changeOrderStatusDelivered,
      this.storeHours,
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
    fssaiLicNo = json['fssai_lic_no'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    remark = json['remark'].toString();
    changeOrderStatusDelivered =
        json['change_order_status_delivered'].toString();
    if (json['store_hours'] != String) {
      storeHours = <StoreHours>[];
      json['store_hours'].forEach((v) {
        storeHours!.add(new StoreHours.fromJson(v));
      });
    }
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
    data['fssai_lic_no'] = this.fssaiLicNo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['remark'] = this.remark;
    data['change_order_status_delivered'] = this.changeOrderStatusDelivered;
    if (this.storeHours != String) {
      data['store_hours'] = this.storeHours!.map((v) => v.toJson()).toList();
    }
    data['logo_url'] = this.logoUrl;
    data['national_identity_card_url'] = this.nationalIdentityCardUrl;
    data['address_proof_url'] = this.addressProofUrl;
    return data;
  }
}

class StoreHours {
  String? day;
  String? openTime;
  String? closeTime;
  String? storeOpen;

  StoreHours({this.day, this.openTime, this.closeTime, this.storeOpen});

  StoreHours.fromJson(Map<String, dynamic> json) {
    day = json['day'].toString();
    openTime = json['open_time'].toString();
    closeTime = json['close_time'].toString();
    storeOpen = json['store_open'].toString();
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
