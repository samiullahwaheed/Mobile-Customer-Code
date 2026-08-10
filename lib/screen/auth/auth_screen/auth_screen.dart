import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_const.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/auth/auth_screen/controller/auth_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_image/app_image_circular.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surfacePrimaryLight,
      body: Column(
        children: [
          Stack(
            children: [
              AppImage(path: AssetsPath.backgroundImage),
              Positioned(
                top: AppSize.size.width * 0.2,
                left: 0,
                right: 0,
                child: Column(
                  spacing: AppSize.width(value: 8),
                  children: [
                    AppImageCircular(
                      path: "assets/images/rewaldo-logo-white.png",
                      width: 240,
                      height: 90,
                    ),
                    SizedBox(height: AppSize.width(value: 12)),
                    AppText(
                      data: "Let's Get Started!",
                      fontSize: AppSize.width(value: 24),
                      fontWeight: FontWeight.w600,
                      color: AppColor.button1Light,
                    ),
                    AppText(
                      data: "Let's dive in into your occount",
                      fontSize: AppSize.width(value: 18),
                      fontWeight: FontWeight.w600,
                      color: AppColor.button1Light,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(height: AppSize.width(value: 12)),
          Padding(
            padding: EdgeInsets.all(AppSize.width(value: 12)),

            child: GetBuilder<AuthController>(
              init: AuthController(),
              builder: (controller) {
                return Column(
                  spacing: AppSize.size.height * 0.02,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Gap(height: AppSize.width(value: 30)),
                    Obx(() {
                      return controller.isLoading.value
                          ? CircularProgressIndicator()
                          : GestureDetector(
                              onTap: () {
                                controller.loginWithGoogle();
                              },
                              child: Container(
                                width: AppSize.width(value: double.infinity),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    width: 2,
                                    color: AppColor.button1Dark,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Center items horizontally
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Center items vertically
                                  children: [
                                    AppImage(
                                      path: AssetsPath.icGoogle,
                                      width: 22,
                                    ),
                                    Gap(width: AppSize.width(value: 12)),
                                    AppText(
                                      data: "Continue with Google",
                                      fontSize: AppSize.width(value: 18),
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.button2Light,
                                    ),
                                  ],
                                ),
                              ),
                            );
                    }),
                    GestureDetector(
                      onTap: () {
                        AppSnackBar.message("Not Implement Yet");
                      },
                      child: Container(
                        width: AppSize.width(value: double.infinity),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            width: 2,
                            color: AppColor.button1Dark,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Center items horizontally
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Center items vertically
                          children: [
                            AppImage(path: AssetsPath.icApple, width: 22),
                            Gap(width: AppSize.width(value: 12)),
                            AppText(
                              data: "Continue with Apple",
                              fontSize: AppSize.width(value: 18),
                              fontWeight: FontWeight.w400,
                              color: AppColor.button2Light,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppButton(
                      onTap: () {
                        Get.toNamed(AppRoutes.instance.signInScreen);
                      },
                      height: 60,
                      titleSize: 20,
                      title: "Sign In →",
                      borderRadius: BorderRadius.circular(30),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.instance.signupWithReffralIdScreen,
                        );
                      },
                      child: Container(
                        width: AppSize.width(value: double.infinity),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            width: 1.5,
                            color: AppColor.button5Dark,
                          ),

                          color: AppColor.button5Light.withValues(alpha: .3),
                        ),
                        child: Center(
                          child: AppText(
                            data: "Do not have an account? Sign up",
                            fontSize: AppSize.width(value: 18),
                            fontWeight: FontWeight.w400,
                            color: AppColor.button2Light,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
            ],
          ),
        ),
      ),
    );
  }
}
