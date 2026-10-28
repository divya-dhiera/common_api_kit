import 'package:common_api_kit/common_api_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'get_all_product_model.dart';
import 'main.dart';

class CommonController extends GetxController {
  void callLoginApi(Map<String, dynamic> params, Function() callback) {
    ApiService.serviceCall(
      serviceUrl: "$baseUrl/loginStore",
      methodType: ApiConfig.methodPOST,
      params: params,
      isProgressShow: true,
      success: (data) {
        debugPrint('Success: $data');
        box.write('auth_token', data['token']);
        callback();
      },
      error: (errorResponse) {
        Get.snackbar('Error', errorResponse['message']);
        debugPrint('Error: $errorResponse');
      },
    );
  }

  Rx<GetAllProductModel> getAllProductModel = GetAllProductModel().obs;

  void getAllProductApi(Map<String, dynamic> params, Function() callback) {
    ApiService.serviceCall(
      serviceUrl: "https://dummyjson.com/products",
      methodType: ApiConfig.methodGET,
      params: params,
      isProgressShow: true,
      success: (data) {
        debugPrint('Success: $data');
        getAllProductModel.value = GetAllProductModel.fromJson(data);
        callback();
      },
      error: (errorResponse) {
        debugPrint('Error: $errorResponse');
      },
    );
  }
}
