import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class SignUpWithReffaleIDScreen extends StatelessWidget {
  const SignUpWithReffaleIDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surfacePrimaryLight,
      body: Column(
        spacing: AppSize.size.height * 0.02,
        children: [
          Stack(
            children: [
              AppImage(path: AssetsPath.backgroundImage),

              Positioned(
                top: AppSize.size.height * 0.07,
                left: 0,
                right: 0, // Ensure that it's horizontally centered
                child: Center(
                  // Center the text horizontally
                  child: AppImage(
                    width: AppSize.width(value: 230),
                    height: AppSize.width(value: 230),
                    path: AssetsPath.authImg1,
                  ),
                ),
              ),
            ],
          ),

          AppText(
            data: "Sign up",
            fontSize: AppSize.width(value: 30),
            fontWeight: FontWeight.w700,
            color: AppColor.button4Dark,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
            child: AppText(
              data:
                  "Are you signing up with a referral from one of our agents?",
              textAlign: TextAlign.center,
              fontSize: AppSize.width(value: 16),
              fontWeight: FontWeight.w400,
              color: AppColor.button4Dark,
            ),
          ),

          Padding(
            padding: EdgeInsets.all(AppSize.width(value: 12)),

            child: Column(
              spacing: AppSize.size.height * 0.01,
              children: [
                AppButton(
                  onTap: () {
                    Get.toNamed(AppRoutes.instance.enterReffralIdScreen);
                  },
                  height: 56,
                  title: "Yes, I have a Referral ID",
                  borderRadius: BorderRadius.circular(30),
                  titleSize: 20,
                ),
                Gap(height: AppSize.width(value: 4)),

                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.instance.signUpScreen);
                  },
                  child: Container(
                    width: AppSize.width(value: double.infinity),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 2, color: AppColor.button5Dark),

                      color: AppColor.button5Light.withValues(alpha: .3),
                    ),
                    child: Center(
                      child: AppText(
                        data: "No, I'll Sign Up on My Own",
                        fontSize: AppSize.width(value: 18),
                        fontWeight: FontWeight.w400,
                        color: AppColor.button2Light,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
