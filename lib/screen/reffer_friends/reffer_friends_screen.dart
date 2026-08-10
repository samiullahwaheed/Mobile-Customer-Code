import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class RefferFriendsScreen extends StatelessWidget {
  const RefferFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String referralCode = Get.arguments ?? "";
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
            path: AssetsPath.refferFrnd,
          ),
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

          Container(
            width: AppSize.size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: appThemeColor.text2),
            ),
            padding: EdgeInsets.all(40),
            child: Column(
              children: [
                AppText(
                  data: "Use this Referral code:",
                  fontSize: AppSize.width(value: 16),
                  fontWeight: FontWeight.w400,
                  color: appThemeColor.text2,
                ),
                Gap(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      data: referralCode,
                      fontSize: AppSize.width(value: 16),
                      fontWeight: FontWeight.w700,
                      color: appThemeColor.text2,
                    ),
                    Gap(width: 10),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: referralCode));

                        AppSnackBar.success("Code copied");
                      },
                      child: Icon(
                        Icons.copy,
                        size: 16,
                        color: appThemeColor.text2,
                      ),
                    ),
                  ],
                ),

               
              ],
            ),
          ),
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
            title: "Share",
            filColor: appThemeColor.icon,
            titleColor: appThemeColor.text1,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
