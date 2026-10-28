import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' as get_x;

import '../common_api_kit.dart';

/// A comprehensive service class for handling HTTP network requests using [Dio],
/// managing automatic progress loaders, checking internet connectivity, and handling
/// authentication callbacks (such as unauthorized or session expired events).

class ApiService {
  /// Callback invoked when an unauthorized (401) response is received.
  static VoidCallback? onUnauthorized;

  /// Callback invoked when a session expired (203) response is received.
  static VoidCallback? onSessionExpired;

  /// Function that returns the current authorization token string.
  static String Function()? getAuthToken;

  /// App name displayed in alert dialogs and error popups.
  static String appName = "App";

  /// Performs an HTTP service call (GET, POST, PUT, DELETE) with optional progress dialog,
  /// internet connectivity check, and automatic error handling.

  static Future<void> serviceCall({
    required Map<String, dynamic> params,
    Map<String, dynamic>? headers,
    required String serviceUrl,
    required Function success,
    required Function error,
    required bool isProgressShow,
    required String methodType,
    bool isFromLogout = false,
    bool? isHideLoader = true,
    FormData? formValues,
  }) async {
    if (await checkInternet()) {
      if (isProgressShow) {
        showProgressDialog();
      }

      if (formValues != null) {
        Map<String, dynamic> tempMap = {};
        for (var element in formValues.fields) {
          tempMap[element.key] = element.value;
        }
        FormData reGenerateFormData = FormData.fromMap(tempMap);
        for (var element in formValues.files) {
          reGenerateFormData.files.add(MapEntry(element.key, element.value));
        }
        formValues = reGenerateFormData;
      }

      final token = getAuthToken != null ? getAuthToken!() : '';
      Map<String, dynamic> headerParameters = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      Response response;
      try {
        if (methodType == ApiConfig.methodGET) {
          response = await APIProvider.getDio().get(
            serviceUrl,
            queryParameters: params,
            options: Options(headers: headers ?? headerParameters),
          );
        } else if (methodType == ApiConfig.methodPUT) {
          response = await APIProvider.getDio().put(
            serviceUrl,
            data: params,
            options: Options(headers: headers ?? headerParameters),
          );
        } else if (methodType == ApiConfig.methodDELETE) {
          response = await APIProvider.getDio().delete(
            serviceUrl,
            data: params,
            options: Options(headers: headers ?? headerParameters),
          );
        } else {
          response = await APIProvider.getDio().post(
            serviceUrl,
            data: formValues ?? params,
            options: Options(headers: headers ?? headerParameters),
          );
        }

        if (kDebugMode) {
          debugPrint("serviceUrl ===> $serviceUrl");
          debugPrint("params ===> $params");
          debugPrint("status code ===> ${response.statusCode}");
          debugPrint("response ===> $response");
        }

        if (isHideLoader ?? true) {
          hideProgressDialog();
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          bool isSuccess = false;
          if (response.data is Map) {
            var status = response.data['status'];
            var successKey = response.data['success'];
            if (status == true ||
                status == 'success' ||
                status == 1 ||
                successKey == true ||
                successKey == 'true' ||
                successKey == 1) {
              isSuccess = true;
            } else if (status == null && successKey == null) {
              isSuccess = true;
            }
          } else {
            isSuccess = true;
          }

          if (isSuccess) {
            success(response.data);
          } else {
            if (response.data is Map && response.data['force_logout'] == 1) {
              if (onUnauthorized != null) onUnauthorized!();
            } else {
              error(response.data);
            }
          }
        } else if (response.statusCode == 203) {
          BooleanResponseModel? responseData = BooleanResponseModel.fromJson(
            response.data is String ? jsonDecode(response.data) : response.data,
          );
          handleAuthentication(
            boolResponse: responseData,
            isFromLogOut: isFromLogout,
          );
        } else if (response.statusCode == 204) {
        } else if (response.statusCode == 401) {
          if (onUnauthorized != null) onUnauthorized!();
        } else {
          var responseData = response.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          error(responseData);
        }
      } catch (e) {
        if (isHideLoader ?? true) {
          hideProgressDialog();
        }
        error({'message': e.toString()});
      }
    } else {
      showErrorMessage(
        message:
            "No internet connection, Please check your internet connection and try again later",
        callBack: () {
          get_x.Get.back();
          serviceCall(
            params: params,
            serviceUrl: serviceUrl,
            success: success,
            error: error,
            isProgressShow: isProgressShow,
            methodType: methodType,
            formValues: formValues,
            isFromLogout: isFromLogout,
            isHideLoader: isHideLoader,
            headers: headers,
          );
        },
      );
    }
  }

  /// Handles authentication responses (e.g. session expiration prompts).
  static void handleAuthentication({
    required BooleanResponseModel boolResponse,
    bool isFromLogOut = false,
  }) {
    if (!isFromLogOut) {
      apiAlertDialog(
        buttonTitle: "LogIn Again",
        message:
            boolResponse.message ??
            "The session has been Expired. Please log in again.",
        isShowGoBack: false,
        buttonCallBack: () {
          if (onSessionExpired != null) {
            onSessionExpired!();
          } else {
            get_x.Get.back();
          }
        },
      );
    } else {
      if (onSessionExpired != null) onSessionExpired!();
    }
  }

  static void showErrorMessage({required String message, Function? callBack}) {
    hideProgressDialog();
    apiAlertDialog(
      buttonTitle: "Try Again",
      message: message,
      buttonCallBack: () {
        if (callBack != null) {
          callBack();
        } else {
          get_x.Get.back();
        }
      },
    );
  }

  static void showProgressDialog() {
    get_x.Get.dialog(
      Container(
        color: Colors.black.withValues(alpha: 0.1),
        child: const Center(
          child: SpinKitFadingCircle(color: Colors.orange, size: 50),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideProgressDialog({
    bool isProgressShow = true,
    bool isHideLoader = true,
  }) {
    if ((isProgressShow || isHideLoader) && (get_x.Get.isDialogOpen ?? false)) {
      get_x.Get.back();
    }
  }

  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true;
    }
    return false;
  }

  static void apiAlertDialog({
    required String message,
    String? buttonTitle,
    Function? buttonCallBack,
    bool isShowGoBack = true,
  }) {
    if (get_x.Get.isDialogOpen ?? false) {
      get_x.Get.back();
    }
    get_x.Get.dialog(
      PopScope(
        canPop: isShowGoBack,
        child: CupertinoAlertDialog(
          title: Text(appName),
          content: Column(
            children: [
              const SizedBox(height: 10),
              Text(message),
              const SizedBox(height: 10),
            ],
          ),
          actions: isShowGoBack
              ? [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(buttonTitle ?? 'Try again'),
                    onPressed: () {
                      if (buttonCallBack != null) {
                        buttonCallBack();
                      } else {
                        get_x.Get.back();
                      }
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text("Go Back"),
                    onPressed: () => get_x.Get.back(),
                  ),
                ]
              : [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(buttonTitle ?? 'Try again'),
                    onPressed: () {
                      if (buttonCallBack != null) {
                        buttonCallBack();
                      } else {
                        get_x.Get.back();
                      }
                    },
                  ),
                ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
