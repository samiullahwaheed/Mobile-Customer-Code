import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/service/network/network_error_handler.dart';
import 'package:loyalty_customer/widget/app_log/error_log.dart';

class ConnectivityService extends GetxService {
  static ConnectivityService get instance => Get.find<ConnectivityService>();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<ConnectivityService> init() async {
    _subscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
    return this;
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      NetworkErrorHandler.instance.goToOfflineScreen();
    }
  }

  Future<bool> hasInternetConnection() async {
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.none)) {
      return false;
    }

    try {
      final domain = AppApiEndPoint.domain;
      if (domain.isNotEmpty) {
        final dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
          ),
        );
        final response = await dio.head(domain);
        return response.statusCode != null;
      }

      final lookup = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on DioException {
      return false;
    } on TimeoutException {
      return false;
    } catch (e) {
      errorLog('hasInternetConnection', e);
      return false;
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
