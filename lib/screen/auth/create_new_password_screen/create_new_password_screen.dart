import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/auth/create_new_password_screen/controller/create_new_password_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_input/app_input_widget_two.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateNewPasswordController>(
      init: CreateNewPasswordController(),

      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.surfacePrimaryLight,
          body: SingleChildScrollView(
            child: Column(
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
                          path: AssetsPath.authImage,
                        ),
                      ),
                    ),
                  ],
                ),

                AppText(
                  data: "Create Your Password",
                  fontSize: AppSize.width(value: 30),
                  fontWeight: FontWeight.w700,
                  color: AppColor.button4Dark,
                ),

                AppText(
                  data: "Choose a strong password to secure your new account.",
                  textAlign: TextAlign.center,
                  fontSize: AppSize.width(value: 16),
                  fontWeight: FontWeight.w400,
                  color: AppColor.button4Dark,
                ),

                Padding(
                  padding: EdgeInsets.all(AppSize.width(value: 12)),

                  child: Form(
                    key: controller.newpasswordFormKey,
                    child: Column(
                      spacing: AppSize.size.height * 0.01,
                      children: [
                        AppInputWidgetTwo(
                          borderRadius: 30,
                          hintText: "New Password",
                          isPassWord: true,
                          controller: controller.newPasswordController,
                          validator: (value) =>
                              controller.validatePassword(value),
                        ),
                        AppInputWidgetTwo(
                          isPassWord: true,
                          borderRadius: 30,
                          hintText: "Confirm Password",
                          controller: controller.confirmPasswordController,
                          validator: (value) =>
                              controller.validateConfirmPassword(
                                value,
                                controller.newPasswordController.text,
                              ),
                        ),
                        Gap(height: AppSize.width(value: 12)),

                        Obx(() {
                          return controller.isLoading.value
                              ? Center(child: CircularProgressIndicator())
                              : AppButton(
                                  onTap: () {
                                    controller.createPassword();
                                  },
                                  title: "Set Password",
                                  borderRadius: BorderRadius.circular(30),
                                );
                        }),
                      ],
                    ),
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
