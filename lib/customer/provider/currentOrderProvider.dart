import 'package:flutter/material.dart';
import 'package:lokale_mand/customer/models/order.dart';

class CurrentOrderProvider extends ChangeNotifier {
  Order? order;

  updateOrderItem({required String orderItemId, required String activeStatus}) {
    if (order != null) {
      List<ProductOrderItem> productOrderItem = order!.items;
      for (var i = 0; i < order!.items.length; i++) {
        if (productOrderItem[i].id == orderItemId.toString()) {
          productOrderItem[i] =
              order!.items[i].updateStatus(activeStatus); //Returned
        }
      }
    }
    notifyListeners();
  }
}
