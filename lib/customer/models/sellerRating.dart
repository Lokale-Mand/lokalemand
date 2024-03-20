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

  SellerRatingData(
      {this.id,
      this.sellerId,
      this.userId,
      this.rate,
      this.review,
      this.status,
      this.updatedAt});

  SellerRatingData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    sellerId = json['seller_id'].toString();
    userId = json['user_id'].toString();
    rate = json['rate'].toString();
    review = json['review'].toString();
    status = json['status'].toString();
    updatedAt = json['updated_at'].toString();
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
    return data;
  }
}
