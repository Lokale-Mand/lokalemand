class ProductRating {
  String? status;
  String? message;
  String? total;
  List<ProductRatingData>? data;

  ProductRating({this.status, this.message, this.total, this.data});

  ProductRating.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <ProductRatingData>[];
      json['data'].forEach((v) {
        data!.add(new ProductRatingData.fromJson(v));
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

class ProductRatingData {
  String? id;
  String? productId;
  String? userId;
  String? rate;
  String? review;
  String? updatedAt;
  String? status;
  User? user;
  List<String>? images;

  ProductRatingData(
      {this.id,
        this.productId,
        this.userId,
        this.rate,
        this.review,
        this.updatedAt,
        this.status,
        this.user,
        this.images});

  ProductRatingData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    productId = json['product_id'].toString();
    userId = json['user_id'].toString();
    rate = json['rate'].toString();
    review = json['review'].toString();
    updatedAt = json['updated_at'].toString();
    status = json['status'].toString();
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['user_id'] = this.userId;
    data['rate'] = this.rate;
    data['review'] = this.review;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['images'] = this.images;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? profile;

  User({this.id, this.name, this.profile});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    profile = json['profile'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile'] = this.profile;
    return data;
  }
}
