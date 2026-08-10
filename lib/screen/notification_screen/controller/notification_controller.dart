import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/screen/notification_screen/model/notification_model.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/service/repository/patch_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class NotificationController extends GetxController {
  RxList<NotificationList> notificationList = <NotificationList>[].obs;
  PatchRepository patchRepository = PatchRepository.instance;
  GetRepository getRepository = GetRepository.instance;
  RxBool isLoading = false.obs;
  ScrollController scrollController = ScrollController();
  int page = 1;
  int limit = 10;
  RxBool isMoreDataAvailable = true.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    getNotification();
  }

  void readNotification() async {
    final response = await patchRepository.readNotification();
    if (response) {
      // forEach দিয়ে সব notification এর isRead true করা
      for (var notification in notificationList) {
        notification.isRead = true;
      }
      notificationList.refresh();
    } else {
      AppSnackBar.error("Failed to read notification");
    }
  }

  Future<void> getNotification() async {
    try {
      isLoading.value = true;
      final response = await getRepository.getNotification(
        page: page,
        limit: limit,
      );

      if (response.isNotEmpty) {
        // Clear list only when it's a new load or first page
        if (page == 1) {
          notificationList.clear();
        }
        notificationList.addAll(response);
        AppPrint.apiResponse(
          response.length,
          title: "Notification List - Page $page",
        );

        // Check if we've reached the last page
        if (response.length < limit) {
          isMoreDataAvailable.value = false;
        }
      } else {
        if (page == 1) {
          notificationList.clear();
        }
        AppPrint.apiResponse(
          "No notifications found",
          title: "Notification Status",
        );
        isMoreDataAvailable.value = false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "NotificationController.getNotification()");
      isMoreDataAvailable.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  //----------------For Reload Page------------------------------
  void reloadPage() {
    page = 1;
    notificationList.clear();
    isMoreDataAvailable.value = true;
    getNotification();
  }

  //----------------Reset Pagination------------------------------
  void resetPagination() {
    page = 1;
    isMoreDataAvailable.value = true;
    notificationList.clear();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isMoreDataAvailable.value && !isLoading.value) {
        page++;
        getNotification();
      }
    }
  }

  //----------------Insert New Notification from Socket------------------------------
  /// Insert a single notification at the beginning of the list
  /// Used when receiving real-time notifications via socket
  void insertNotification(NotificationList notification) {
    // Insert at the beginning (index 0) so new notification appears on top
    notificationList.insert(0, notification);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
