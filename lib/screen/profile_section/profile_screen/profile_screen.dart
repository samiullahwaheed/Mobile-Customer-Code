import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/controller/profile_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_image/app_image_circular.dart';
import 'package:loyalty_customer/widget/app_input/app_input_widget_two.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme data
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;

    // ProfileController profileController = Get.put(ProfileController());
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return Scaffold(
          appBar: TempAppBarForProfileScreen(
            appThemeColor: appThemeColor,
            profileController: controller,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(AppSize.width(value: 16)),
                  child: Obx(() {
                    return Row(
                      children: [
                        AppImageCircular(
                          fit: BoxFit.cover,
                          url:
                          AppApiEndPoint.mediaUrl(controller.profileData.value?.profile),
                          width: AppSize.width(value: 124),
                          height: AppSize.width(value: 124),
                        ),
                        Gap(width: AppSize.width(value: 20)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: AppSize.size.height * 0.014,
                          children: [
                            AppText(
                              data:
                              controller.profileData.value?.firstName ??
                                  "Loading...",
                              fontSize: AppSize.width(value: 18),
                              fontWeight: FontWeight.w700,
                              color: appThemeColor.text2,
                            ),
                            AppText(
                              data:
                              controller.profileData.value?.phone ??
                                  "Loading...",
                              fontSize: AppSize.width(value: 14),
                              fontWeight: FontWeight.w500,
                              // Use the text color from the current theme
                              color: appThemeColor.text2,
                            ),

                            AppButton(
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.instance.changeProfileScreen,
                                );
                              },
                              title: "Edit Profile",
                              filColor: appThemeColor.icon,
                              titleColor: appThemeColor.text3,
                              width: AppSize.size.width * 0.3,
                              height: AppSize.size.width * 0.1,
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: appThemeColor
                        .surfacePrimary, // Background color of the container
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ), // Border radius

                    boxShadow: [
                      BoxShadow(
                        color: appThemeColor.text2,
                        blurRadius: 6,
                        offset: const Offset(0, 4),
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
                  ),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    spacing: AppSize.size.height * 0.03,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileRow(
                        appThemeColor: appThemeColor,
                        iconPath: AssetsPath.icLock,
                        onTap: () {
                          Get.toNamed(AppRoutes.instance.changePassScreen);
                        },
                        text: "Password",
                      ),
                      ProfileRow(
                        appThemeColor: appThemeColor,
                        iconPath: AssetsPath.icMySub,
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.instance.mySubScreen,
                            arguments: {"value": 1},
                          );
                        },
                        text: "My Membership",
                      ),
                      ProfileRow(
                        appThemeColor: appThemeColor,
                        iconPath: AssetsPath.icTransactionHistory,
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.instance.transactionHistoryScreen,
                            arguments: controller.profileData.value?.id,
                          );
                        },
                        text: "Transaction History",
                      ),
                      ProfileRow(
                        appThemeColor: appThemeColor,
                        iconPath: AssetsPath.icReffer,
                        onTap: () {
                          if (controller.profileData.value?.hasUsedFreePlan ??
                              false) {
                            Get.toNamed(
                              AppRoutes.instance.refferFriendListScreen,
                            );
                          } else {
                            Get.toNamed(
                              AppRoutes.instance.refferFriendListScreen,
                            );
                          }
                        },
                        text: "Refer Friends",
                      ),
                      ProfileRow(
                        appThemeColor: appThemeColor,
                        iconPath: AssetsPath.icTheme,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ThemeChangeAlertDilog(
                                appThemeColor: appThemeColor,
                                profileController: controller,
                              );
                            },
                          );
                        },
                        text: "Appearance  ",
                      ),
                      ProfileRow(
                        appThemeColor: appThemeColor,
                        iconPath: AssetsPath.icNotification,
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.instance.notificationSettingScreen,
                          );
                        },
                        text: "Notification",
                      ),
                      ProfileRow(
                        appThemeColor: appThemeColor,
                        iconPath: AssetsPath.icContactUs,
                        onTap: () {
                          Get.toNamed(AppRoutes.instance.contactUsScreen);
                        },
                        text: "Contact Us",
                      ),
                      ProfileRow(
                        appThemeColor: appThemeColor,
                        iconPath: AssetsPath.icTarms,
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.instance.privicyScreen,
                            arguments: {
                              "name": "Terms & Conditions",
                              "endpoint": "customer-terms-and-conditions",
                            },
                          );
                        },
                        text: "Terms & Conditions",
                      ),
                      ProfileRow(
                        appThemeColor: appThemeColor,
                        iconPath: AssetsPath.icPrivicyPolicy,
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.instance.privicyScreen,
                            arguments: {
                              "name": "Privacy Policy",
                              "endpoint": "customer-privacy-policy",
                            },
                          );
                        },
                        text: "Privacy Policy",
                      ),
                      ProfileRow(
                        appThemeColor: appThemeColor,
                        iconPath: AssetsPath.icPrivicyPolicy,
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.instance.privicyScreen,
                            arguments: {
                              "name": "User Manual",
                              "endpoint": "customer-user-manual",
                            },
                          );
                        },
                        text: "User Manual",
                      ),
                      ProfileRow(
                        appThemeColor: appThemeColor,
                        iconPath: AssetsPath.icFeedBack,
                        onTap: () {
                          AppSnackBar.message("Not Implement Yet");
                        },
                        text: "Submit App Feedback",
                      ),
                      ProfileRow(
                        appThemeColor: appThemeColor,
                        iconPath: AssetsPath.isDelete,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    spacing: AppSize.size.height * 0.013,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        size: AppSize.width(value: 66),
                                        color: appThemeColor.icon1,
                                      ),
                                      AppText(
                                        data: "Want to delete account !",
                                        fontSize: AppSize.width(value: 18),
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                      AppText(
                                        data:
                                        "Please confirm your password to remove your account.",
                                        fontSize: AppSize.width(value: 16),
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.center,
                                        color: Colors.black,
                                      ),
                                      AppInputWidgetTwo(
                                        isPassWord: true,
                                        title: "Password",
                                        hintText: "Password",
                                        isOptional: true,
                                        controller:
                                        controller.passwordController,
                                      ),
                                      Gap(height: 4),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: AppSize.width(
                                                    value: 18,
                                                  ),
                                                  vertical: AppSize.width(
                                                    value: 8,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: appThemeColor.icon1,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: AppText(
                                                    data: "Cancel",
                                                    fontSize: AppSize.width(
                                                      value: 16,
                                                    ),
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Gap(width: 20),
                                          Expanded(
                                            child: AppButton(
                                              filColor: appThemeColor.icon1,
                                              onTap: () {
                                                controller.deleteAccount();
                                                AppPrint.appPrint(
                                                  "Delete Account",
                                                );
                                              },
                                              height: 36,
                                              title: "Delete",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        text: "Delete Account",
                      ),
                      ProfileRow(
                        appThemeColor: appThemeColor,
                        iconPath: AssetsPath.icLogOut,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return LogOutpopUp(
                                appThemeColor: appThemeColor,
                                onTapLogout: () => controller.logout(),
                              );
                            },
                          );
                        },
                        text: "Log Out",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LogOutpopUp extends StatelessWidget {
  final AppThemeColor appThemeColor;
  final VoidCallback? onTapLogout;
  const LogOutpopUp({super.key, this.onTapLogout, required this.appThemeColor});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: AppSize.size.height * 0.025,
          children: [
            Icon(
              Icons.logout,
              size: AppSize.width(value: 66),
              color: appThemeColor.icon1,
            ),
            AppText(
              data: "Do you want to log out of your profile?",
              fontSize: AppSize.width(value: 16),
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(value: 18),
                        vertical: AppSize.width(value: 8),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: appThemeColor.icon1),
                      ),
                      child: Center(
                        child: AppText(
                          data: "Cancel",
                          fontSize: AppSize.width(value: 16),
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(width: 20),
                Expanded(
                  child: AppButton(
                    filColor: appThemeColor.icon1,
                    onTap: onTapLogout,
                    height: 36,
                    title: "Logout",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeChangeAlertDilog extends StatelessWidget {
  const ThemeChangeAlertDilog({
    super.key,
    required this.appThemeColor,
    required this.profileController,
  });

  final AppThemeColor appThemeColor;
  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        spacing: AppSize.size.height * 0.01,
        children: [
          AppImage(
            width: AppSize.size.width * 0.25,
            path: AssetsPath.icThemeChnage,
            iconColor: appThemeColor.icon1,
          ),
          AppText(
            data: "Customize Your Appearance",
            fontSize: AppSize.width(value: 18),
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          AppText(
            data: "Customize your experience by adjusting theme.",
            fontSize: AppSize.width(value: 16),
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
            color: Colors.black,
          ),

          Row(
            spacing: AppSize.width(value: 12),
            children: [
              Expanded(
                child: Column(
                  children: [
                    AppImage(path: AssetsPath.themeLight),

                    Row(
                      children: [
                        Radio<bool>(
                          value: false,
                          groupValue: profileController.isDark.value,
                          onChanged: (bool? value) {
                            profileController.changeTheme();
                            Navigator.of(context).pop();
                          },
                        ),
                        AppText(
                          data: "Light Mode",
                          fontSize: AppSize.width(value: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    AppImage(
                      // width: AppSize.width(value: 100),
                      // height: AppSize.width(value: 60),
                      path: AssetsPath.themeDark,
                    ),

                    Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: profileController.isDark.value,
                          onChanged: (bool? value) {
                            profileController.changeTheme();
                            Navigator.of(context).pop();
                          },
                        ),
                        AppText(
                          data: "Dark Mode",
                          fontSize: AppSize.width(value: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TempAppBarForProfileScreen extends StatelessWidget
    implements PreferredSizeWidget {
  final String? text;
  final List<Widget>? action;
  final AppThemeColor appThemeColor;
  final ProfileController profileController;

  // Constructor
  const TempAppBarForProfileScreen({
    super.key,
    this.text,
    this.action,
    required this.appThemeColor,
    required this.profileController,
  });

  // Set the toolbarHeight to 56
  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appThemeColor.surfacePrimary,
      title: AppText(
        data: text ?? "Profile", // Use passed 'text' or default to "Profile"
        fontSize: AppSize.width(value: 18),
        fontWeight: FontWeight.w700,
        color: appThemeColor.text2,
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String? iconPath;
  final String? text;
  final VoidCallback? onTap;
  const ProfileRow({
    super.key,
    this.appThemeColor,
    this.iconPath,
    this.text,
    this.onTap,
  });

  final AppThemeColor? appThemeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        spacing: AppSize.width(value: 20),
        children: [
          AppImage(
            path: iconPath ?? AssetsPath.icLock,
            iconColor: appThemeColor?.icon,
            width: AppSize.width(value: 24),
            height: AppSize.width(value: 24),
          ),
          AppText(
            data: text ?? "",
            fontWeight: FontWeight.w500,
            color: appThemeColor?.text2,
            fontSize: AppSize.width(value: 14),
          ),
          Spacer(),
          AppImage(
            iconColor: appThemeColor?.icon,
            path: AssetsPath.icArrowRight,
            width: AppSize.width(value: 24),
            height: AppSize.width(value: 24),
          ),
        ],
      ),
    );
  }
}