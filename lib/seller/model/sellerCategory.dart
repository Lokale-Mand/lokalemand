class CategoryList {
  String? status;
  String? message;
  String? total;
  List<CategoryData>? data;

  CategoryList({this.status, this.message, this.total, this.data});

  CategoryList.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(
          new CategoryData.fromJson(v),
        );
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this
          .data!
          .map(
            (v) => v.toJson(),
          )
          .toList();
    }
    return data;
  }
}

class CategoryData {
  String? id;
  String? name;
  String? parentId;
  String? imageUrl;
  bool? hasChild;

  CategoryData(
      {this.id, this.name, this.parentId, this.imageUrl, this.hasChild});

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    parentId = json['parent_id'].toString();
    imageUrl = json['image_url'].toString();
    hasChild = json['has_child'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent_id'] = this.parentId;
    data['image_url'] = this.imageUrl;
    data['has_child'] = this.hasChild;
    return data;
  }
}
