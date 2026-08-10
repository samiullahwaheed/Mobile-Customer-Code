import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/screen/notification_screen/controller/notification_controller.dart';
import 'package:loyalty_customer/screen/notification_screen/widgets/notification_card.dart';
import 'package:loyalty_customer/screen/notification_screen/widgets/shimmer/notification_card_shimmer.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/utils/formet_notification_time.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return GetBuilder<NotificationController>(
      init: NotificationController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(
            text: "Notification",
            appThemeColor: appThemeColor,
            action: [
              TextButton(
                onPressed: () {
                  controller.readNotification();
                },
                child: AppText(
                  data: "Read All",
                  color: appThemeColor.text2,
                  fontSize: AppSize.width(value: 12),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async => controller.reloadPage(),
            child: Obx(() {
              // If loading for the first time and list is empty
              if (controller.isLoading.value &&
                  controller.notificationList.isEmpty) {
                return const NotificationCardShimmer();
              }

              // If list is empty and loading is finished
              if (controller.notificationList.isEmpty &&
                  !controller.isLoading.value) {
                return Center(
                  child: AppText(
                    data: "No Notifications Found",
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w600,
                    color: appThemeColor.text2,
                  ),
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.notificationList.length + 1,
                itemBuilder: (context, index) {
                  if (index < controller.notificationList.length) {
                    final notification = controller.notificationList[index];
                    return NotificationCard(
                      appThemeColor: appThemeColor,
                      title: notification.title,
                      message: notification.body,
                      time: formatNotificationTime(notification.createdAt),
                      isRead: notification.isRead ?? true,
                    );
                  } else {
                    if (controller.isMoreDataAvailable.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AppText(
                            data: "No more notifications",
                            fontSize: AppSize.width(value: 16),
                            fontWeight: FontWeight.w600,
                            color: appThemeColor.text2,
                          ),
                        ),
                      );
                    }
                  }
                },
              );
            }),
          ),
        );
      },
    );
  }
}
