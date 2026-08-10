import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/auth/waiting_screen/controller/waiting_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class WaitningScreen extends StatelessWidget {
  const WaitningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WaitingController>(
      init: WaitingController(),
      builder: (controller) {
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
                    right: 0,
                    child: Center(
                      child: AppImage(
                        width: AppSize.width(value: 230),
                        height: AppSize.width(value: 230),
                        path: AssetsPath.authImg1,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSize.size.height * 0.05),

              // ✅ Main Heading
              AppText(
                data: "Waiting for approval",
                fontSize: AppSize.width(value: 30),
                fontWeight: FontWeight.w700,
                color: AppColor.button4Dark,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSize.size.height * 0.02),

              // ✅ Subtext / Description
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 20),
                ),
                child: AppText(
                  data:
                      "Thanks for signing up! Your account will be approved shortly.",
                  textAlign: TextAlign.center,
                  fontSize: AppSize.width(value: 16),
                  fontWeight: FontWeight.w400,
                  color: AppColor.button4Dark,
                ),
              ),

              SizedBox(height: AppSize.size.height * 0.04),

              // ✅ Optional action button (visible when socket response received)
              Obx(
                () => controller.isButtonVisible.value
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.width(value: 20),
                        ),
                        child: AppButton(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            controller.navigateToConfirm();
                          },
                          title: 'Back to Home',
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}
