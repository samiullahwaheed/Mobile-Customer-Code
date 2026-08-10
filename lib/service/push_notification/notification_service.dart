import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize local notifications
  static Future<void> initLocalNotification() async {
    try {
      // Android initialization settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      // Combined initialization settings
      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize the plugin
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create Android notification channel
      await _createAndroidNotificationChannel();

      debugPrint('✅ Notification Service initialized');
    } catch (e) {
      debugPrint('❌ Notification Service Error: $e');
    }
  }

  /// Create Android notification channel
  static Future<void> _createAndroidNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // Must match AndroidManifest.xml
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<Uint8List?> _downloadImageBytes(String url) async {
    try {
      final response = await Dio().get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 15),
        ),
      );
      final data = response.data;
      if (data == null || data.isEmpty) return null;
      return Uint8List.fromList(data);
    } catch (e) {
      debugPrint('❌ Notification image download failed: $e');
      return null;
    }
  }

  /// Show local notification (optional [imageUrl] → Android big picture / iOS attachment).
  static Future<void> showNotification(Map<String, dynamic> payload) async {
    try {
      final String? imageUrl = payload['imageUrl'] as String?;
      Uint8List? imageBytes;
      String? iosAttachmentPath;

      if (imageUrl != null && imageUrl.isNotEmpty) {
        imageBytes = await _downloadImageBytes(imageUrl);
        if (imageBytes != null) {
          final file = File(
            '${Directory.systemTemp.path}/fcm_notif_'
            '${DateTime.now().millisecondsSinceEpoch}.jpg',
          );
          await file.writeAsBytes(imageBytes);
          iosAttachmentPath = file.path;
        }
      }

      final String title = payload['message'] as String? ?? 'New Notification';
      final String body = payload['type'] as String? ?? '';

      final AndroidNotificationDetails androidDetails =
          imageBytes != null
              ? AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                channelDescription:
                    'This channel is used for important notifications.',
                importance: Importance.high,
                priority: Priority.high,
                enableVibration: true,
                playSound: true,
                icon: '@mipmap/ic_launcher',
                styleInformation: BigPictureStyleInformation(
                  ByteArrayAndroidBitmap(imageBytes),
                  contentTitle: title,
                  summaryText: body,
                  largeIcon: ByteArrayAndroidBitmap(imageBytes),
                ),
              )
              : const AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                channelDescription:
                    'This channel is used for important notifications.',
                importance: Importance.high,
                priority: Priority.high,
                enableVibration: true,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              );

      final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        attachments:
            iosAttachmentPath != null
                ? <DarwinNotificationAttachment>[
                  DarwinNotificationAttachment(iosAttachmentPath),
                ]
                : null,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique notification ID
        title,
        body,
        notificationDetails,
        payload: payload['data'].toString(),
      );

      debugPrint('📬 Local notification shown');
    } catch (e) {
      debugPrint('❌ Show notification error: $e');
    }
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');
    // TODO: Add navigation logic based on payload
  }
}
