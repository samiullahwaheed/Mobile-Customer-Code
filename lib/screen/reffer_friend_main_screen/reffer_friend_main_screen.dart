import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class RefferFriendMainScreen extends StatelessWidget {
  const RefferFriendMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return Scaffold(
      appBar: CustomAppbar(text: "Refer Friends", appThemeColor: appThemeColor),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppImage(
            width: AppSize.size.width * 0.9,
            path: AssetsPath.refferFriendImage2,
          ),
          Gap(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 30)),
            child: AppText(
              textAlign: TextAlign.center,
              data: "Refer a Friend and Get a Subscription Discount!",
              fontSize: AppSize.width(value: 18),
              fontWeight: FontWeight.w700,
              color: appThemeColor.text2,
            ),
          ),
          Gap(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 45)),
            child: AppText(
              textAlign: TextAlign.center,
              data:
                  "Share your referral Code, and enjoy a subscription discount when your friends sign up.",
              fontSize: AppSize.width(value: 12),
              fontWeight: FontWeight.w500,
              color: appThemeColor.text2,
            ),
          ),
          Gap(height: AppSize.size.height * 0.2),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: appThemeColor.text2,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: appThemeColor.surfacePrimary,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.width(value: 16),
            vertical: AppSize.width(value: 24),
          ),
          child: AppButton(
            onTap: () {
              Get.toNamed(AppRoutes.instance.refferFriendListScreen);
            },
            title: "Continue",
            filColor: appThemeColor.icon,
            titleColor: appThemeColor.text1,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
