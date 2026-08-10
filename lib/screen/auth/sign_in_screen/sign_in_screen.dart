import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_const.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/auth/sign_in_screen/controller/sign_in_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_image/app_image_circular.dart';
import 'package:loyalty_customer/widget/app_input/app_input_widget_two.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(
      init: SignInController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.surfacePrimaryLight,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    AppImage(path: AssetsPath.backgroundImage),
                    Positioned(
                      left: AppSize.width(value: 12),
                      top:
                          AppSize.size.height *
                          0.1, // Ensure that it's horizontally centered
                      child: Column(
                        children: [
                          AppText(
                            data: "Welcome Back!",
                            fontSize: AppSize.width(value: 40),
                            fontWeight: FontWeight.w700,
                            color: AppColor.button1Light,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: AppSize.size.height * 0.2,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 240,
                          height: 90,
                          child: AppImageCircular(
                            path: "assets/images/rewaldo-logo-white.png",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(height: AppSize.width(value: 12)),
                Padding(
                  padding: EdgeInsets.all(AppSize.width(value: 12)),

                  child: Column(
                    spacing: AppSize.size.height * 0.015,
                    children: [
                      Form(
                        key: controller.signinKey,
                        child: Column(
                          children: [
                            AppInputWidgetTwo(
                              borderRadius: 30,
                              hintText: "Email Or Phone Number",
                              controller: controller.emailController,
                              // validator: controller.validateEmailOrPhone,
                            ),
                            AppInputWidgetTwo(
                              isPassWord: true,
                              borderRadius: 30,
                              hintText: "Password",
                              controller: controller.passwordController,
                              // validator: controller.validatePassword,
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.instance.forgetPassScreen);
                          },
                          child: AppText(
                            data: "Forgot Password",
                            fontSize: AppSize.width(value: 12),
                            fontWeight: FontWeight.w700,
                            color: AppColor.textLight,
                          ),
                        ),
                      ),
                      Gap(height: AppSize.width(value: 12)),
                      Obx(() {
                        return controller.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : AppButton(
                                onTap: () {
                                  controller.signIn();
                                },
                                title: "Sign In",
                                borderRadius: BorderRadius.circular(30),
                              );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSize.width(value: 12)),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.instance.privicyScreen,
                        arguments: {
                          "name": "Terms & Conditions",
                          "endpoint": "customer-terms-and-conditions",
                        },
                      );
                    },
                    child: Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        fontFamily: AppConst.fontFamily1,
                        fontSize: AppSize.width(value: 12),
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                        color: AppColor.button1Dark, // Underlines the text
                        // You can specify style of the underline if needed
                      ),
                    ),
                  ),
                  Gap(width: AppSize.width(value: 20)),
                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.instance.privicyScreen,
                        arguments: {
                          "name": "Privacy Policy",
                          "endpoint": "customer-privacy-policy",
                        },
                      );
                    },
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontFamily: AppConst.fontFamily1,
                        fontSize: AppSize.width(value: 12),
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                        color: AppColor.button1Dark, // Underlines the text
                        // You can specify style of the underline if needed
                      ),
                    ),
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        data: "Don’t Have an Account?",
                        fontSize: AppSize.width(value: 12),
                        fontWeight: FontWeight.w700,
                        color: AppColor.button1Dark,
                      ),
                      InkWell(
                        onTap: () {
                          Get.offNamed(AppRoutes.instance.signUpScreen);
                        },
                        child: AppText(
                          data: "Sign Up",
                          fontSize: AppSize.width(value: 22),
                          fontWeight: FontWeight.w700,
                          color: AppColor.button5Dark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
