// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/screen/app_navigation_screen/model/sell_requist_model.dart';
import 'package:loyalty_customer/screen/home_screen/controller/home_controller.dart';
import 'package:loyalty_customer/screen/notification_screen/controller/notification_controller.dart';
import 'package:loyalty_customer/screen/notification_screen/model/notification_model.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/controller/profile_controller.dart';
import 'package:loyalty_customer/screen/app_navigation_screen/navigation_tab.dart';
import 'package:loyalty_customer/screen/app_navigation_screen/widget/payment_dilog.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/service/socket_service.dart/socket_service.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_log/error_log.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class NavigationScreenController extends GetxController {
  final Rx<NavigationTab> selectedTab = NavigationTab.home.obs;
  bool isExpanded = false;

  final ScrollController scrollController = ScrollController();
  ProfileController profileController = Get.put(ProfileController());
  PostRepository postRepository = PostRepository.instance;
  GetRepository getRepository = GetRepository.instance;
  Rxn<SellRequistModel> sellRequist = Rxn<SellRequistModel>();
  // Socket service instance
  final SocketService _socketService = SocketService.instance;
  NotificationController notificationController = Get.put(
    NotificationController(),
  );
  @override
  void onInit() {
    super.onInit();

    // Fetch profile data first, then initialize socket
    _initializeWithProfile();
  }

  void toggleExpansion() {
    isExpanded = !isExpanded;
    update(); // Notifies GetBuilder to rebuild
  }

  void fetchSellRequist() async {
    try {
      final response = await getRepository.getSellRequist();
      if (response != null) {
        sellRequist.value = response;
        final data = sellRequist.value?.data;
        showRedemptionRequestDialog(
          title: 'Redemption Request',
          message:
              'Merchant has initiated a redemption request for ${data?.pointRedeemed} points.',
          question: 'Do you want to approve this transaction?',
          onAccept: () {
            approveRedemptionRequest(
              digitalCardCode: data?.digitalCardCode ?? "",
              sellId: data?.sellId ?? "",
              userId: profileController.profileData.value?.id ?? "",
              endPoint: "accept",
            );
          },
          onDecline: () {
            approveRedemptionRequest(
              digitalCardCode: data?.digitalCardCode ?? "",
              sellId: data?.sellId ?? "",
              userId: profileController.profileData.value?.id ?? "",
              endPoint: "reject",
            );
          },
        );
        AppPrint.appLog("Sell Requist Response: ${response.toJson()}");
      } else {
        AppPrint.appError("Sell Requist Response is null");
      }
    } catch (e) {
      errorLog("fetchSellRequist", e);
    }
  }

  //------------Payment Confirmation Dialog--------------
  void showRedemptionRequestDialog({
    String? title,
    String? message,
    String? question,
    VoidCallback? onAccept,
    VoidCallback? onDecline,
  }) {
    showRedemptionDialog(
      title: title ?? 'Redemption Request',
      message:
          message ??
          'Merchant has initiated a redemption request for your points.',
      question: question ?? 'Do you want to approve this transaction?',
      acceptText: 'Accept',
      declineText: 'Decline',
      onAccept:
          onAccept ??
          () {
            // Handle accept action
            Get.snackbar(
              'Accepted',
              'Transaction has been approved',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
      onDecline:
          onDecline ??
          () {
            // Handle decline action
            Get.snackbar(
              'Declined',
              'Transaction has been declined',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
    );
  }

  void approveRedemptionRequest({
    required String digitalCardCode,
    required String userId,
    required String sellId,
    required String endPoint,
  }) async {
    final response = await postRepository.approveAndRejectRedemptionRequest(
      digitalCardCode: digitalCardCode,
      userId: userId,
      endPoint: endPoint,
      sellId: sellId,
    );
    if (response) {
      if (endPoint == "accept") {
        AppSnackBar.success('Transaction has been approved');
      } else {
        AppSnackBar.error('Transaction has been declined');
      }
    } else {
      AppSnackBar.error('Something went wrong');
    }
    // if (response) {
    //   AppSnackBar.success('Transaction has been approved');
    // } else {
    //   AppSnackBar.error('Transaction has been declined');
    // }
  }

  void changeTab(NavigationTab tab) {
    selectedTab.value = tab;
  }

  /// 🔹 Initialize profile and socket in correct order
  Future<void> _initializeWithProfile() async {
    // Fetch profile data first
    await profileController.fetchProfileData();

    // Wait a bit to ensure profile data is loaded
    await Future.delayed(Duration(milliseconds: 500));

    fetchSellRequist();

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
    final eventName = 'getApplyRequest::$userId';
    AppPrint.appLog('🎯 Registering event listener: $eventName');

    _socketService.onEvent(eventName, (data) {
      AppPrint.appPrint(data, title: '🔔 Socket Response Received');
      _handleSocketResponse(data);
    });

    // Listen to newNotification event
    AppPrint.appLog('🎯 Registering event listener: newNotification');
    _socketService.onEvent('newNotification', (data) {
      AppPrint.appPrint(data, title: '🔔 Notification Received');
      try {
        if (data is Map<String, dynamic>) {
          final notification = NotificationList.fromJson(data);
          notificationController.insertNotification(notification);
          AppPrint.appLog('✅ Notification added to list');
          if (Get.isRegistered<HomeController>()) {
            final homeController = Get.find<HomeController>();
            homeController.hasNotification.value = true;
          }
        } else {
          AppPrint.appError(
            'Invalid data type received: ${data.runtimeType}',
            title: '❌ Invalid Data',
          );
        }
      } catch (e) {
        AppPrint.appError(
          'Error parsing notification: $e',
          title: '❌ Parsing Error',
        );
      }
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

    // Example: If response contains redemption request
    showRedemptionRequestDialog(
      title: 'Redemption Request',
      message:
          'Merchant has initiated a redemption request for ${data['pointRedeemed']} points.',
      question: 'Do you want to approve this transaction?',
      onAccept: () {
        approveRedemptionRequest(
          digitalCardCode: data['digitalCardCode'] ?? "",
          sellId: data['sellId'] ?? "",
          userId: profileController.profileData.value?.id ?? "",
          endPoint: "accept",
        );
      },
      onDecline: () {
        approveRedemptionRequest(
          digitalCardCode: data['digitalCardCode'] ?? "",
          sellId: data['sellId'] ?? "",
          userId: profileController.profileData.value?.id ?? "",
          endPoint: "reject",
        );
      },
    );
  }

  @override
  void onClose() {
    // Disconnect socket when controller is disposed
    _socketService.disconnect();
    super.onClose();
  }
}
