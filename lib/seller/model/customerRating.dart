class CustomerRating {
  String? status;
  String? message;
  String? total;
  List<CustomerRatingData>? data;

  CustomerRating({this.status, this.message, this.total, this.data});

  CustomerRating.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <CustomerRatingData>[];
      json['data'].forEach((v) {
        data!.add(new CustomerRatingData.fromJson(v));
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

class CustomerRatingData {
  String? id;
  String? userId;
  String? sellerId;
  String? rate;
  String? review;
  String? status;
  String? updatedAt;
  CustomerRatingUser? user;
  List<CustomerRatingImages>? images;

  CustomerRatingData(
      {this.id,
        this.userId,
        this.sellerId,
        this.rate,
        this.review,
        this.status,
        this.updatedAt,
        this.user,
        this.images});

  CustomerRatingData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    sellerId = json['seller_id'].toString();
    rate = json['rate'].toString();
    review = json['review'].toString();
    status = json['status'].toString();
    updatedAt = json['updated_at'].toString();
    user = json['user'] != null ? new CustomerRatingUser.fromJson(json['user']) : null;
    if (json['images'] != null) {
      images = <CustomerRatingImages>[];
      json['images'].forEach((v) {
        images!.add(new CustomerRatingImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['seller_id'] = this.sellerId;
    data['rate'] = this.rate;
    data['review'] = this.review;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerRatingUser {
  String? id;
  String? name;

  CustomerRatingUser({this.id, this.name});

  CustomerRatingUser.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class CustomerRatingImages {
  String? id;
  String? userRatingId;
  String? image;
  String? imageUrl;

  CustomerRatingImages({this.id, this.userRatingId, this.image, this.imageUrl});

  CustomerRatingImages.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userRatingId = json['user_rating_id'].toString();
    image = json['image'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_rating_id'] = this.userRatingId;
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
