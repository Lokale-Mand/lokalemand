
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
Future<Map<String, dynamic>> getCategoryListRepository(
    {required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiCategories, params: params, isPost: false);

  return json.decode(response);
}

Future<Map<String, dynamic>> getMainCategoryListRepository() async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiMainCategories, params: {}, isPost: false);

  return json.decode(response);
}
