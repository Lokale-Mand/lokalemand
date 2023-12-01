class Dietary {
  String? status;
  String? message;
  String? total;
  List<DietaryData>? data;

  Dietary({this.status, this.message, this.total, this.data});

  Dietary.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <DietaryData>[];
      json['data'].forEach((v) {
        data!.add(new DietaryData.fromJson(v));
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

class DietaryData {
  String? id;
  String? name;
  String? slug;
  String? imageUrl;

  DietaryData({this.id, this.name, this.slug, this.imageUrl});

  DietaryData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    slug = json['slug'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
