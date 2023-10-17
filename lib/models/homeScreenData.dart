import 'package:lokale_mand/helper/utils/generalImports.dart';

class Shop {
  String? status;
  String? message;
  String? total;
  HomeScreenData? data;

  Shop({this.status, this.message, this.total, this.data});

  Shop.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data =
        json['data'] != null ? new HomeScreenData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class HomeScreenData {
  List<Sliders>? sliders;
  List<Offers>? offers;
  List<Sections>? sections;
  String? isCategorySectionInHomepage;
  String? isBrandSectionInHomepage;
  List<CategoryItem>? category;
  List<Brand>? brand;

  HomeScreenData(
      {this.sliders,
      this.offers,
      this.sections,
      this.isCategorySectionInHomepage,
      this.isBrandSectionInHomepage,
      this.category,
      this.brand});

  HomeScreenData.fromJson(Map<String, dynamic> json) {
    if (json['sliders'] != null) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders!.add(new Sliders.fromJson(v));
      });
    }
    if (json['offers'] != null) {
      offers = <Offers>[];
      json['offers'].forEach((v) {
        offers!.add(new Offers.fromJson(v));
      });
    }
    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(new Sections.fromJson(v));
      });
    }
    isCategorySectionInHomepage =
        json['is_category_section_in_homepage'].toString();
    isBrandSectionInHomepage = json['is_brand_section_in_homepage'].toString();
    if (json['categories'] != null) {
      category = <CategoryItem>[];
      json['categories'].forEach((v) {
        category!.add(new CategoryItem.fromJson(v));
      });
    }
    if (json['brands'] != null) {
      brand = <Brand>[];
      json['brands'].forEach((v) {
        brand!.add(new Brand.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sliders != null) {
      data['sliders'] = this.sliders!.map((v) => v.toJson()).toList();
    }
    if (this.offers != null) {
      data['offers'] = this.offers!.map((v) => v.toJson()).toList();
    }
    if (this.sections != null) {
      data['sections'] = this.sections!.map((v) => v.toJson()).toList();
    }
    data['is_category_section_in_homepage'] = this.isCategorySectionInHomepage;
    data['is_brand_section_in_homepage'] = this.isBrandSectionInHomepage;
    if (this.category != null) {
      data['categories'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.brand != null) {
      data['brands'] = this.brand!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sliders {
  String? id;
  String? type;
  String? typeId;
  String? sliderUrl;
  String? typeName;
  String? imageUrl;

  Sliders(
      {this.id,
      this.type,
      this.typeId,
      this.sliderUrl,
      this.typeName,
      this.imageUrl});

  Sliders.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    type = json['type'].toString();
    typeId = json['type_id'].toString();
    sliderUrl = json['slider_url'].toString();
    typeName = json['type_name'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['type_id'] = this.typeId;
    data['slider_url'] = this.sliderUrl;
    data['type_name'] = this.typeName;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class Offers {
  String? id;
  String? position;
  String? sectionPosition;
  String? imageUrl;

  Offers({this.id, this.position, this.sectionPosition, this.imageUrl});

  Offers.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    position = json['position'].toString();
    sectionPosition = json['section_position'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['position'] = this.position;
    data['section_position'] = this.sectionPosition;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class Sections {
  String? id;
  String? title;
  String? shortDescription;
  String? productType;
  List<ProductListItem>? products;
  String? categoryIds;

  Sections(
      {this.id,
      this.title,
      this.shortDescription,
      this.productType,
      this.products,
      this.categoryIds});

  Sections.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'].toString();
    shortDescription = json['short_description'].toString();
    productType = json['product_type'].toString();
    if (json['products'] != null) {
      products = <ProductListItem>[];
      json['products'].forEach((v) {
        products!.add(new ProductListItem.fromJson(v));
      });
    }
    categoryIds = json['category_ids'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['short_description'] = this.shortDescription;
    data['product_type'] = this.productType;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['category_ids'] = this.categoryIds;
    return data;
  }
}

class CategoryItem {
  String? id;
  String? name;
  String? subtitle;
  String? imageUrl;
  bool? hasChild;

  CategoryItem(
      {this.id, this.name, this.subtitle, this.imageUrl, this.hasChild});

  CategoryItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    subtitle = json['subtitle'].toString();
    imageUrl = json['image_url'].toString();
    hasChild = json['has_child'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['subtitle'] = this.subtitle;
    data['image_url'] = this.imageUrl;
    data['has_child'] = this.hasChild;
    return data;
  }
}

class Brand {
  String? id;
  String? name;
  String? imageUrl;

  Brand({this.id, this.name, this.imageUrl});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
