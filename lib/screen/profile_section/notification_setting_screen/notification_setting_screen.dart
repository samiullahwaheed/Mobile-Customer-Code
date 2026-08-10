import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/screen/profile_section/notification_setting_screen/controller/notification_setting_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class NotificationSettingScreen extends StatelessWidget {
  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;

    return Scaffold(
      appBar: CustomAppbar(appThemeColor: appThemeColor, text: "Notifications"),
      body: GetBuilder<NotificationSettingController>(
        init: NotificationSettingController(),
        builder: (controller) {
          return Obx(() {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppSize.width(value: 16)),
                child: Column(
                  children: [
                    NotificationSettingSwitch(
                      text: "Enable All Notifications",
                      isSubTextHide: true,
                      isTrue: controller.switch1.value,
                      onTap: () => controller.toggleSwitch1(),
                    ),
                    Gap(height: AppSize.width(value: 20)),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: .1,
                            ), // Shadow color
                            offset: Offset(
                              0,
                              2,
                            ), // Vertical offset, giving shadow on bottom
                            blurRadius: 8, // Blur radius
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: .1,
                            ), // Shadow color
                            offset: Offset(
                              0,
                              -2,
                            ), // Vertical offset, giving shadow on top
                            blurRadius: 8, // Blur radius
                          ),
                        ],
                        borderRadius: BorderRadius.circular(
                          AppSize.width(value: 12),
                        ),
                        color: AppColor.surfacePrimaryLight,
                      ),
                      padding: EdgeInsets.all(AppSize.width(value: 12)),
                      child: Column(
                        spacing: AppSize.size.height * 0.015,
                        children: [
                          NotificationSettingSwitch(
                            text: "Promotional Emails",
                            subText:
                                "Receive offers, promotions, and marketing updates via email.",
                            isTrue: controller.switch2.value,
                            onTap: () => controller.toggleSwitch2(),
                          ),

                          NotificationSettingSwitch(
                            text: "App Notifications",
                            subText:
                                "Get notified about new features, updates, availability, and promotions.",
                            isTrue: controller.switch3.value,
                            onTap: () => controller.toggleSwitch3(),
                          ),

                          NotificationSettingSwitch(
                            text: "SMS Notifications",
                            subText:
                                "Receive important updates and alerts via SMS.",
                            isTrue: controller.switch4.value,
                            onTap: () => controller.toggleSwitch4(),
                          ),

                          NotificationSettingSwitch(
                            text: "Referral Notifications",
                            subText:
                                "Get updates about your referral status, rewards, and activities.",
                            isTrue: controller.switch5.value,
                            onTap: () => controller.toggleSwitch5(),
                          ),

                          NotificationSettingSwitch(
                            text: "Subscription Notifications",
                            subText:
                                "Receive reminders before your subscription expires or renews.",
                            isTrue: controller.switch6.value,
                            onTap: () => controller.toggleSwitch6(),
                          ),

                          NotificationSettingSwitch(
                            text: "Push Notifications",
                            subText:
                                "Stay updated with real-time alerts and important announcements.",
                            isTrue: controller.switch7.value,
                            onTap: () => controller.toggleSwitch7(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class NotificationSettingSwitch extends StatelessWidget {
  final String? text;
  final String? subText;
  final bool isTrue;
  final bool isSubTextHide;
  final VoidCallback? onTap;
  const NotificationSettingSwitch({
    super.key,
    this.text,
    this.isTrue = false,
    this.onTap,
    this.subText,
    this.isSubTextHide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1), // Shadow color
            offset: Offset(0, 2), // Vertical offset, giving shadow on bottom
            blurRadius: 8, // Blur radius
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: .1), // Shadow color
            offset: Offset(0, -2), // Vertical offset, giving shadow on top
            blurRadius: 8, // Blur radius
          ),
        ],
        borderRadius: BorderRadius.circular(AppSize.width(value: 16)),
        color: AppColor.surfacePrimaryLight,
      ),
      padding: EdgeInsets.all(AppSize.width(value: 16)),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  data: text ?? "No Text",
                  fontSize: AppSize.width(value: 18),
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  color: Colors.black,
                ),
                if (!isSubTextHide)
                  AppText(
                    data: subText ?? "No Text",
                    maxLines: null,
                    fontSize: AppSize.width(value: 12),
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    softWrap:
                        true, // Automatically wraps text when it's too long
                    overflow: TextOverflow.visible,
                  ),
              ],
            ),
          ),
          Spacer(),
          Expanded(
            flex: 1,
            child: Transform.scale(
              scale:
                  0.7, // Adjust the scale value to make the switch smaller or larger
              child: Switch(
                // This bool value toggles the switch.
                value: isTrue,
                activeThumbColor: AppColor.button5Dark,
                onChanged: (bool value) => onTap?.call(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
