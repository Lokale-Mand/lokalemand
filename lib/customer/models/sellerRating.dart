class SellerRating {
  String? status;
  String? message;
  String? total;
  List<SellerRatingData>? data;

  SellerRating({this.status, this.message, this.total, this.data});

  SellerRating.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <SellerRatingData>[];
      json['data'].forEach((v) {
        data!.add(new SellerRatingData.fromJson(v));
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

class SellerRatingData {
  String? id;
  String? sellerId;
  String? userId;
  String? rate;
  String? review;
  String? status;
  String? updatedAt;
  SellerRatingSeller? seller;
  List<SellerRatingImages>? images;

  SellerRatingData(
      {this.id,
      this.sellerId,
      this.userId,
      this.rate,
      this.review,
      this.status,
      this.updatedAt,
      this.seller,
      this.images});

  SellerRatingData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    sellerId = json['seller_id'].toString();
    userId = json['user_id'].toString();
    rate = json['rate'].toString();
    review = json['review'].toString();
    status = json['status'].toString();
    updatedAt = json['updated_at'].toString();
    seller = json['seller'] != null
        ? new SellerRatingSeller.fromJson(json['seller'])
        : null;
    if (json['images'] != null) {
      images = <SellerRatingImages>[];
      json['images'].forEach((v) {
        images!.add(new SellerRatingImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['seller_id'] = this.sellerId;
    data['user_id'] = this.userId;
    data['rate'] = this.rate;
    data['review'] = this.review;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    if (this.seller != null) {
      data['seller'] = this.seller!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SellerRatingSeller {
  String? id;
  String? name;
  String? logoUrl;
  String? nationalIdentityCardUrl;
  String? addressProofUrl;

  SellerRatingSeller(
      {this.id,
      this.name,
      this.logoUrl,
      this.nationalIdentityCardUrl,
      this.addressProofUrl});

  SellerRatingSeller.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    logoUrl = json['logo_url'].toString();
    nationalIdentityCardUrl = json['national_identity_card_url'].toString();
    addressProofUrl = json['address_proof_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo_url'] = this.logoUrl;
    data['national_identity_card_url'] = this.nationalIdentityCardUrl;
    data['address_proof_url'] = this.addressProofUrl;
    return data;
  }
}

class SellerRatingImages {
  String? id;
  String? sellerRatingId;
  String? image;
  String? imageUrl;

  SellerRatingImages({this.id, this.sellerRatingId, this.image, this.imageUrl});

  SellerRatingImages.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    sellerRatingId = json['seller_rating_id'].toString();
    image = json['image'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['seller_rating_id'] = this.sellerRatingId;
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
