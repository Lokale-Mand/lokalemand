import '../helper/utils/generalImports.dart';

class SellerDashBoard {
  SellerDashBoard({
    this.status,
    this.message,
    this.total,
    this.data,
  });

  late final String? status;
  late final String? message;
  late final String? total;
  late final SellerDashBoardData? data;

  SellerDashBoard.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = SellerDashBoardData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['total'] = total;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class SellerDashBoardData {
  SellerDashBoardData({
    this.sellerOrderCount,
    this.productCount,
    this.categoryCount,
    this.soldOutCount,
    this.lowStockCount,
    this.balance,
    this.categoryProductCount,
    this.weeklySales,
    this.statusOrderCount,
  });

  late final String? sellerOrderCount;
  late final String? productCount;
  late final String? categoryCount;
  late final String? soldOutCount;
  late final String? lowStockCount;
  late final String? balance;
  late final List<CategoryProductCount>? categoryProductCount;
  late final List<WeeklySales>? weeklySales;
  late final List<StatusOrderCount>? statusOrderCount;

  SellerDashBoardData.fromJson(Map<String, dynamic> json) {
    sellerOrderCount = json['order_count'].toString();
    productCount = json['product_count'].toString();
    categoryCount = json['category_count'].toString();
    soldOutCount = json['sold_out_count'].toString();
    lowStockCount = json['low_stock_count'].toString();
    balance = json['balance'].toString();
    categoryProductCount = List.from(json['category_product_count'])
        .map(
          (e) => CategoryProductCount.fromJson(e),
        )
        .toList();
    weeklySales = List.from(json['weekly_sales'])
        .map(
          (e) => WeeklySales.fromJson(e),
        )
        .toList();
    statusOrderCount = List.from(json['status_order_count'])
        .map(
          (e) => StatusOrderCount.fromJson(e),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['order_count'] = sellerOrderCount;
    _data['product_count'] = productCount;
    _data['category_count'] = categoryCount;
    _data['sold_out_count'] = soldOutCount;
    _data['low_stock_count'] = lowStockCount;
    _data['balance'] = balance;
    _data['category_product_count'] = categoryProductCount
        ?.map(
          (e) => e.toJson(),
        )
        .toList();
    _data['weekly_sales'] = weeklySales
        ?.map(
          (e) => e.toJson(),
        )
        .toList();
    _data['status_order_count'] = statusOrderCount
        ?.map(
          (e) => e.toJson(),
        )
        .toList();
    return _data;
  }
}

class CategoryProductCount {
  CategoryProductCount({
    this.id,
    this.name,
    this.productCount,
  });

  late final String? id;
  late final String? name;
  late final String? productCount;

  CategoryProductCount.fromJson(Map<String, dynamic> json) {
    id = (json['id']??"0").toString();
    name = (json['name']??"0").toString();
    productCount = (json['product_count']??"0").toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['product_count'] = productCount;
    return _data;
  }
}

class WeeklySales {
  WeeklySales({
    this.totalSale,
    this.orderDate,
  });

  late final String? totalSale;
  late final String? orderDate;

  WeeklySales.fromJson(Map<String, dynamic> json) {
    totalSale = json['total_sale'].toString();
    orderDate = json['order_date'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['total_sale'] = totalSale;
    _data['order_date'] = orderDate;
    return _data;
  }
}


