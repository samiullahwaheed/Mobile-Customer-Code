import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/service/api_service/api.dart';
import 'package:loyalty_customer/service/api_service/non_auth_api.dart';
import 'package:loyalty_customer/service/network/network_error_handler.dart';
import 'package:loyalty_customer/widget/app_log/error_log.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class ApiServices {
  ApiServices._privateConstructor();
  static final ApiServices _instance = ApiServices._privateConstructor();
  static ApiServices get instance => _instance;

  final api = NonAuthApi();
  final apiAuth = AppApi.instance;

  /// ============================= PUT =============================
  Future<dynamic> apiPutServices({
    required String url,
    dynamic body,
    int statusCode = 200,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await apiAuth.sendRequest.put(
        url,
        data: body,
        queryParameters: query,
      );

      if (response.statusCode == statusCode) {
        return response.data;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      NetworkErrorHandler.handleIfNetworkError(e);
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      NetworkErrorHandler.handleIfNetworkError(e);
      return null;
    } on DioException catch (e) {
      NetworkErrorHandler.handleIfNetworkError(e);
      if (e.response != null) {
        if (e.response?.statusCode == 400 &&
            e.response?.data["message"] != null) {
          Get.snackbar("error", "${e.response?.data["message"]}");
        }
      }
      errorLog('api dio exception', e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  /// ============================= POST =============================
  Future<dynamic> apiPostServices({
    required String url,
    dynamic body,
    int statusCodeStart = 200,
    int statusCodeEnd = 299,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await apiAuth.sendRequest.post(
        url,
        data: body,
        queryParameters: query,
      );
      if (response.statusCode! >= statusCodeStart &&
          response.statusCode! <= statusCodeEnd) {
        return response.data;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      NetworkErrorHandler.handleIfNetworkError(e);
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      NetworkErrorHandler.handleIfNetworkError(e);
      return null;
    } on DioException catch (e) {
      NetworkErrorHandler.handleIfNetworkError(e);
      if (e.response != null) {
        if (e.response?.statusCode == 400 &&
            e.response?.data["message"] != null) {
          AppSnackBar.error("${e.response?.data["message"]}");
        }
      }
      errorLog('api dio exception', e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  /// ============================= GET =============================
  Future<dynamic> apiGetServices(
    String url, {
    int statusCode = 200,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    try {
      final response = await AppApi.instance.sendRequest.get(
        url,
        queryParameters: queryParameters,
        data: body,
      );

      if (response.statusCode == statusCode) {
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else if (response.data is List) {
          return response.data;
        } else {
          return response.data;
        }
      } else {
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      NetworkErrorHandler.handleIfNetworkError(e);
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      NetworkErrorHandler.handleIfNetworkError(e);
      return null;
    } on DioException catch (e) {
      NetworkErrorHandler.handleIfNetworkError(e);
      if (e.response != null) {
        if (e.response?.statusCode == 400 &&
            e.response?.data["message"] != null) {
          Get.snackbar("error", "${e.response?.data["message"]}");
        }
      }
      errorLog('api dio exception', e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  /// ============================= PATCH =============================
  Future<dynamic> apiPatchServices({
    required String url,
    Object? body,
    int statusCode = 200,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      final response = await apiAuth.sendRequest.patch(
        url,
        data: body,
        queryParameters: query,
        options: options,
      );

      if (response.statusCode == statusCode) {
        return response.data;
      } else {
        Get.snackbar(
          "error",
          "Unexpected response: ${response.statusCode} ${response.statusMessage}",
        );
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      NetworkErrorHandler.handleIfNetworkError(e);
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      NetworkErrorHandler.handleIfNetworkError(e);
      return null;
    } on DioException catch (e) {
      NetworkErrorHandler.handleIfNetworkError(e);
      if (e.response != null) {
        if (e.response?.statusCode == 400 &&
            e.response?.data["message"] != null) {
          Get.snackbar("error", "${e.response?.data["message"]}");
        }
      }
      errorLog('api dio exception', e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  /// ============================= DELETE =============================
  Future<dynamic> apiDeleteServices({
    required String url,
    Object? body,
    int statusCode = 200,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      final response = await apiAuth.sendRequest.delete(
        url,
        data: body,
        queryParameters: query,
        options: options,
      );

      if (response.statusCode == statusCode) {
        return response.data;
      } else {
        Get.snackbar(
          "error",
          "Unexpected response: ${response.statusCode} ${response.statusMessage}",
        );
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      NetworkErrorHandler.handleIfNetworkError(e);
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      NetworkErrorHandler.handleIfNetworkError(e);
      return null;
    } on DioException catch (e) {
      NetworkErrorHandler.handleIfNetworkError(e);
      if (e.response != null) {
        if (e.response?.statusCode == 400 &&
            e.response?.data["message"] != null) {
          Get.snackbar("error", "${e.response?.data["message"]}");
        }
      }
      errorLog('api dio exception', e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }
}
