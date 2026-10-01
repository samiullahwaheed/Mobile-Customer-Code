import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
import 'package:loyalty_customer/service/push_notification/notification_service.dart';

class FCMService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  /// Initialize FCM service
  static Future<void> initialize() async {
    try {
      // Request permission for notifications
      await _requestPermission();

      // Get and display FCM token
      await getToken();

      // Setup message handlers
      _setupMessageHandlers();

      // Check if app was opened from a notification (terminated state)
      await _checkInitialMessage();

      debugPrint('✅ FCM Service initialized');
    } catch (e) {
      debugPrint('❌ FCM Service initialization error: $e');
    }
  }

  /// Request notification permissions (iOS/Android)
  static Future<void> _requestPermission() async {
    try {
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
            announcement: false,
            carPlay: false,
            criticalAlert: false,
          );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ Notification permission granted');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        debugPrint('⚠️ Notification permission provisional');
      } else {
        debugPrint('❌ Notification permission denied');
      }
    } catch (e) {
      debugPrint('❌ Permission request error: $e');
    }
  }

  /// Get FCM token
  static Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();

      if (token != null) {
        debugPrint('📱 FCM Token: $token');

        // ✅ এখানে store করবা
        await GetStorageServices.instance.setFCMtoken(token);

        // ✅ তারপর read করে check করবা
        Future.delayed(Duration(milliseconds: 100), () {
          final savedToken = GetStorageServices.instance.getFCMtoken();
          debugPrint("✅ Saved Token: $savedToken");
        });

        return token;
      }
    } catch (e) {
      debugPrint('❌ Get token error: $e');
    }
    return null;
  }


  /// Delete FCM token (call on user logout)
  static Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      debugPrint('✅ FCM Token deleted');
    } catch (e) {
      debugPrint('❌ Delete token error: $e');
    }
  }

  /// Setup message handlers for different app states
  static void _setupMessageHandlers() {
    // Foreground messages (app is open and visible)
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background messages (app is minimized, user taps notification)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  /// Image URL from FCM: [notification.android]/[notification.apple] or data keys.
  /// Background handler থেকেও use করার জন্য public রাখা হয়েছে।
  static String? imageUrlFromMessage(RemoteMessage message) {
    final data = message.data;
    final fromData = data['image'] ?? data['imageUrl'] ?? data['image_url'];
    if (fromData != null && fromData.toString().trim().isNotEmpty) {
      return fromData.toString().trim();
    }
    final n = message.notification;
    if (n == null) return null;
    final android = n.android?.imageUrl;
    if (android != null && android.isNotEmpty) return android;
    final apple = n.apple?.imageUrl;
    if (apple != null && apple.isNotEmpty) return apple;
    return null;
  }

  /// `NotificationService.showNotification()` এর জন্য payload map তৈরি করে।
  /// Note: `message.notification` null হতে পারে (data-only message)।
  static Map<String, dynamic> localNotificationPayloadFromMessage(
    RemoteMessage message,
  ) {
    final title =
        message.notification?.title ??
        (message.data['title']?.toString() ?? 'New Message');
    final body =
        message.notification?.body ?? (message.data['body']?.toString() ?? '');

    return {
      'message': title,
      'type': body,
      'data': message.data,
      'imageUrl': imageUrlFromMessage(message),
    };
  }

  /// Handle foreground messages (app is open)
  static void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📬 Foreground Message Received');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');
    debugPrint('Image URL: ${imageUrlFromMessage(message)}');

    // Show local notification when app is in foreground
    NotificationService.showNotification(
      localNotificationPayloadFromMessage(message),
    );
  }

  /// Handle notification opened (app was in background)
  static void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('🔔 Notification Opened');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    
  }

  /// Check for initial message (app opened from terminated state)
  static Future<void> _checkInitialMessage() async {
    try {
      RemoteMessage? initialMessage = await _firebaseMessaging
          .getInitialMessage();

      if (initialMessage != null) {
        debugPrint('🚀 App opened from terminated state');
        debugPrint('Title: ${initialMessage.notification?.title}');
        debugPrint('Body: ${initialMessage.notification?.body}');
        debugPrint('Data: ${initialMessage.data}');

        // Handle the notification
        _handleMessageOpenedApp(initialMessage);
      }
    } catch (e) {
      debugPrint('❌ Check initial message error: $e');
    }
  }

  /// Subscribe to a topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('✅ Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('❌ Subscribe to topic error: $e');
    }
  }

  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('❌ Unsubscribe from topic error: $e');
    }
  }

  /// Get notification settings
  static Future<NotificationSettings> getNotificationSettings() async {
    return await _firebaseMessaging.getNotificationSettings();
  }

  /// iOS only: Get APNS token
  static Future<String?> getAPNSToken() async {
    return await _firebaseMessaging.getAPNSToken();
  }
}
