import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/service/api_service/cookie_service.dart';
import 'package:loyalty_customer/service/network/network_error_handler.dart';
import 'package:loyalty_customer/service/repository/auth_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_log/error_log.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'get_storage_services.dart';

class AppApi {
  final Dio _dio = Dio();
  var storageServices = GetStorageServices.instance;

  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  // Private constructor where Dio is configured
  AppApi._privateConstructor() {
    _dio.options.baseUrl = AppApiEndPoint.instance.baseUrl;
    _dio.options.sendTimeout = const Duration(seconds: 60);
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
    _dio.options.followRedirects = false;

    _dio.interceptors.add(CookieManager(CookieService.instance.cookieJar));

    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.baseUrl = AppApiEndPoint.instance.baseUrl;
          options.contentType = 'application/json';
          options.headers["Accept"] = "application/json";

          String token = storageServices.getToken();
          if (token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (NetworkErrorHandler.isNetworkError(error)) {
            NetworkErrorHandler.instance.goToOfflineScreen();
            return handler.next(error);
          }

          AppPrint.appLog("API error occurred:");
          AppPrint.appLog("Status code: ${error.response?.statusCode}");
          AppPrint.appLog("Error message: ${error.message}");

          try {
            if (error.response?.statusCode == 401) {
              final message = error.response?.data?["message"];
              AppPrint.appLog("401 message: $message");

              if (error.requestOptions.extra['_retriedAfterRefresh'] == true) {
                AppPrint.appLog(
                  "Request already retried after refresh — logging out.",
                );
                await _logout();
                return handler.next(error);
              }

              final authHeader =
                  error.requestOptions.headers["Authorization"]?.toString();
              final expiredToken =
                  authHeader != null && authHeader.startsWith("Bearer ")
                  ? authHeader.substring(7)
                  : storageServices.getToken();

              AppPrint.appLog("401 — calling resetToken before logout...");
              final newToken = await _refreshAccessToken(
                expiredAccessToken: expiredToken,
              );

              if (newToken != null) {
                try {
                  final requestOptions = error.requestOptions;
                  requestOptions.headers["Authorization"] =
                      "Bearer $newToken";
                  requestOptions.extra['_retriedAfterRefresh'] = true;

                  AppPrint.appLog("Retrying failed request with new token...");
                  final response = await _dio.fetch(requestOptions);
                  return handler.resolve(response);
                } catch (e) {
                  errorLog("retry after token refresh", e);
                  if (e is DioException && e.response?.statusCode == 401) {
                    await _logout();
                  }
                  return handler.next(error);
                }
              }

              AppPrint.appLog("resetToken failed — logging out.");
              await _logout();
              return handler.next(error);
            }
            if (error.response?.statusCode == 400) {
              // Display error message using AppSnackBar
              if (error.response?.data["message"] != null) {
                AppSnackBar.error("${error.response?.data["message"]}");
              }
              AppPrint.appLog("error message: ${error.message}");
              return handler.next(error);
            }
          } catch (e) {
            errorLog("error form api try and catch bloc", e);
            return handler.next(error);
          }

          return handler.next(error);
        },
      ),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          request: true,
          compact: true,
          error: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
    ]);
  }

  // Singleton instance
  static final AppApi _instance = AppApi._privateConstructor();

  // Getter for singleton instance
  static AppApi get instance => _instance;

  // Expose Dio client
  Dio get sendRequest => _dio;

  Future<String?> _refreshAccessToken({String? expiredAccessToken}) async {
    if (_isRefreshing) {
      return _refreshCompleter?.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final newToken = await AuthRepository.instance.resetToken(
        expiredAccessToken: expiredAccessToken,
      );
      _refreshCompleter?.complete(newToken);
      return newToken;
    } catch (e) {
      errorLog("refreshAccessToken", e);
      _refreshCompleter?.complete(null);
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _logout() async {
    await storageServices.storageClear();
    await CookieService.instance.cookieJar.deleteAll();
    Get.offAllNamed(AppRoutes.instance.authScreen);
  }
}
