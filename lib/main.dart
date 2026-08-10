import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loyalty_customer/firebase_options.dart';
import 'package:loyalty_customer/screen/my_app.dart';
import 'package:loyalty_customer/service/api_service/cookie_service.dart';
import 'package:loyalty_customer/service/connectivity/connectivity_service.dart';
import 'package:loyalty_customer/service/push_notification/device_info_service.dart';
import 'package:loyalty_customer/service/push_notification/fcm_service.dart';
import 'package:loyalty_customer/service/push_notification/notification_service.dart';
import 'package:loyalty_customer/service/socket_service.dart/socket_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 🔥 Top-level background message handler
/// This MUST be a top-level function (not inside a class)
/// Called when app receives notification in terminated/background state
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('📩 Background Message Received');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: ${message.data}');

  // ✅ Background/terminated state এ image সহ notification দেখাতে হলে
  // local notification manually show করতে হবে (OS default notification সবসময় image render করে না)।
  try {
    await NotificationService.initLocalNotification();
    await NotificationService.showNotification(
      FCMService.localNotificationPayloadFromMessage(message),
    );
  } catch (e) {
    debugPrint('❌ Background local notification error: $e');
  }
}

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await CookieService.instance.init();

  await dotenv.load(fileName: ".env");

  await GetStorage.init();

  // 🔥 Register background message handler BEFORE Firebase initialization
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔔 Initialize Notification Service (local notifications)
  await NotificationService.initLocalNotification();

  // 🔥 Initialize FCM Service (push notifications)
  await FCMService.initialize();

  /// 📱 Device Info Service (prints device info and FCM token)
  await DeviceInfoService().init();

  Get.put(SocketService.instance, permanent: true);
  await Get.putAsync(() => ConnectivityService().init(), permanent: true);

  runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()));
}

