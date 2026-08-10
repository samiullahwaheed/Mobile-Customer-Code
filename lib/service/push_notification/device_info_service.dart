import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoService {
  static final DeviceInfoService _instance = DeviceInfoService._internal();
  factory DeviceInfoService() => _instance;
  DeviceInfoService._internal();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _printFcmToken();
    await printDeviceInfo();
  }

  /// 🔥 FCM TOKEN
  Future<void> _printFcmToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      debugPrint('🔥 FCM TOKEN: $token');
    } catch (e) {
      debugPrint('❌ FCM Token Error: $e');
    }
  }

  /// 📱 DEVICE INFO
  Future<void> printDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        debugPrint('📱 Device Type: Android');
        debugPrint('🆔 Device ID: ${androidInfo.id}');
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        debugPrint('📱 Device Type: iOS');
        debugPrint('🆔 Device ID: ${iosInfo.identifierForVendor}');
      }
    } catch (e) {
      debugPrint('❌ Device Info Error: $e');
    }
  }
}
