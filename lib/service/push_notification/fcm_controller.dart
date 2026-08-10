import 'package:get/get.dart';
import 'package:loyalty_customer/service/push_notification/fcm_service.dart';

class FCMController extends GetxController {
  // Reactive FCM token
  final fcmToken = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _initializeFCM();
  }

  /// Initialize FCM and get token
  Future<void> _initializeFCM() async {
    final token = await FCMService.getToken();
    if (token != null) {
      fcmToken.value = token;
    }
  }

  /// Refresh FCM token
  Future<void> refreshToken() async {
    final token = await FCMService.getToken();
    if (token != null) {
      fcmToken.value = token;
    }
  }

  /// Delete FCM token (call on logout)
  Future<void> deleteToken() async {
    await FCMService.deleteToken();
    fcmToken.value = null;
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await FCMService.subscribeToTopic(topic);
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await FCMService.unsubscribeFromTopic(topic);
  }

  /// Get current token (non-reactive)
  String? get currentToken => fcmToken.value;

  /// Check if token is available
  bool get hasToken => fcmToken.value != null;
}
