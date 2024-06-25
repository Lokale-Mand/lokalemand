class ProductUnit {
  int? status;
  String? message;
  int? total;
  List<ProductUnitData>? data;

  ProductUnit({this.status, this.message, this.total, this.data});

  ProductUnit.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <ProductUnitData>[];
      json['data'].forEach((v) {
        data!.add(new ProductUnitData.fromJson(v));
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

class ProductUnitData {
  int? id;
  String? name;
  String? shortCode;
  int? parentId;
  int? conversion;

  ProductUnitData(
      {this.id, this.name, this.shortCode, this.parentId, this.conversion});

  ProductUnitData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortCode = json['short_code'];
    parentId = json['parent_id'];
    conversion = json['conversion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_code'] = this.shortCode;
    data['parent_id'] = this.parentId;
    data['conversion'] = this.conversion;
    return data;
  }
}
