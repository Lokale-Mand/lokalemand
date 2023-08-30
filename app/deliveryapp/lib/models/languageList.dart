class LanguageList {
  String? status;
  String? message;
  String? total;
  List<LanguageListData>? data;

  LanguageList({this.status, this.message, this.total, this.data});

  LanguageList.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    if (json['data'] != null) {
      data = <LanguageListData>[];
      json['data'].forEach((v) {
        data!.add(new LanguageListData.fromJson(v));
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

class LanguageListData {
  String? id;
  String? name;
  String? code;
  String? type;
  String? systemType;
  String? isDefault;
  String? systemTypeName;

  LanguageListData(
      {this.id,
      this.name,
      this.code,
      this.type,
      this.systemType,
      this.isDefault,
      this.systemTypeName});

  LanguageListData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    code = json['code'].toString();
    type = json['type'].toString();
    systemType = json['system_type'].toString();
    isDefault = json['is_default'].toString();
    systemTypeName = json['system_type_name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['type'] = this.type;
    data['system_type'] = this.systemType;
    data['is_default'] = this.isDefault;
    data['system_type_name'] = this.systemTypeName;
    return data;
  }
}
