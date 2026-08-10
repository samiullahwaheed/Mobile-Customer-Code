import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/auth/create_your_password_screen/controller/create_your_password_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_input/app_input_widget_two.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateYourPasswordController>(
      init: CreateYourPasswordController(),
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
                      right: 0,
                      child: Center(
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
                    key: _formKey,
                    child: Column(
                      spacing: AppSize.size.height * 0.01,
                      children: [
                        AppInputWidgetTwo(
                          borderRadius: 30,
                          hintText: "Password",
                          isPassWord: true,
                          controller: controller.passwordController,
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
                                controller.passwordController.text,
                              ),
                        ),
                        Gap(height: AppSize.width(value: 12)),
                        Obx(() {
                          return controller.isLoading.value
                              ? Center(child: CircularProgressIndicator())
                              : AppButton(
                                  onTap: () {
                                    controller.createPassword(_formKey);
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
