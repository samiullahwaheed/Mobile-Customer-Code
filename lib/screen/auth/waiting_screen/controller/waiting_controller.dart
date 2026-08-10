import 'dart:async';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/controller/profile_controller.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
import 'package:loyalty_customer/service/socket_service.dart/socket_service.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class WaitingController extends GetxController {
  final SocketService _socketService = SocketService.instance;
  ProfileController profileController = Get.put(ProfileController());

  RxBool isButtonVisible = false.obs;
  Timer? _navigationTimer;

  @override
  void onInit() {
    super.onInit();

    // Fetch profile data first, then initialize socket
    _initializeWithProfile();
  }

  /// 🔹 Initialize profile and socket in correct order
  Future<void> _initializeWithProfile() async {
    // Fetch profile data first
    await profileController.fetchProfileData();
    // Wait a bit to ensure profile data is loaded
    await Future.delayed(Duration(milliseconds: 1000));

    // Now initialize socket with user ID
    _initializeSocket();
  }

  /// 🔹 Initialize socket connection and listeners
  void _initializeSocket() {
    final userId = profileController.profileData.value?.id;

    if (userId == null || userId.isEmpty) {
      AppPrint.appError(
        'User ID is null or empty. Cannot initialize socket.',
        title: '❌ Socket Init Failed',
      );
      return;
    }

    AppPrint.appLog(
      '📡 NavigationScreenController: Setting up socket listeners for user: $userId',
    );

    // Initialize socket with fresh token
    final token = GetStorageServices.instance.getToken();

    if (token.isEmpty) {
      AppPrint.appError(
        'Token is empty. Cannot initialize socket.',
        title: '❌ Socket Init Failed',
      );
      return;
    }

    // 🔹 Initialize socket with callback for when connection is established
    _socketService.initSocket(
      url: AppApiEndPoint.instance.socketGetPopupResponse,
      token: token,
      onConnected: () {
        // This callback executes AFTER socket connects successfully
        AppPrint.appLog(
          '✅ Socket connected! Now registering event listeners...',
        );
        _registerSocketListeners(userId);
      },
    );

    // 🔹 Connect to socket (listeners will be registered in onConnected callback)
    _socketService.connect();
  }

  /// 🔹 Register all socket event listeners
  void _registerSocketListeners(String userId) {
    // Listen to popup-response event with correct user ID
    final eventName = 'salesActivation::$userId';
    AppPrint.appLog('🎯 Registering event listener: $eventName');

    _socketService.onEvent(eventName, (data) {
      AppPrint.appPrint(data, title: '🔔 Socket Response Received');
      _handleSocketResponse(data);
    });
  }

  /// 🔹 Handle socket response
  void _handleSocketResponse(dynamic data) {
    AppPrint.appLog('✅ Processing socket response...');

    // Print the entire response
    AppPrint.appPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    AppPrint.appPrint('🚀 SOCKET RESPONSE DATA:');
    AppPrint.appPrint(data.toString());
    AppPrint.appPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // You can add your custom logic here
    // For example: show dialog, update UI, etc.
    if (data["status"] == "active") {
      _actWhenSocketResponseReceived();
    }
  }

  /// 🔹 Handles UI and navigation when socket response is received
  void _actWhenSocketResponseReceived() {
    // Show the "Back to Home" button
    isButtonVisible.value = true;

    // Start 3-second timer for automatic navigation
    _navigationTimer?.cancel(); // Cancel any existing timer
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      navigateToConfirm();
    });
  }

  /// 🔹 Navigate to confirmation screen
  void navigateToConfirm() {
    _navigationTimer?.cancel(); // Ensure timer is stopped

    // Using offAllNamed to match user requirement "auth offallname"
    // Assuming confirmedScreen is the target based on AppRoutes
    Get.offAllNamed(AppRoutes.instance.confirmScreen);
  }

  @override
  void onClose() {
    // Disconnect socket and cancel timer when controller is disposed
    _socketService.disconnect();
    _navigationTimer?.cancel();
    super.onClose();
  }
}
