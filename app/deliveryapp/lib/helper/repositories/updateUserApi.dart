import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
Future<Map<String, dynamic>> updateUserApiRepository(
    {required Map<String, String> params,
    required List<String> fileParamsNames,
    required List<String> fileParamsFilesPath}) async {
  var response = await GeneralMethods.sendApiMultiPartRequest(
    apiName: ApiAndParams.apiUpdateUser,
    params: params,
    fileParamsNames: fileParamsNames,
    fileParamsFilesPath: fileParamsFilesPath,
  );

  return json.decode(response);
}
