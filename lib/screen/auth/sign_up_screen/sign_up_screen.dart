import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_const.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/auth/sign_up_screen/controller/signup_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_image/app_image_circular.dart';
import 'package:loyalty_customer/widget/app_input/app_input_widget_two.dart';
import 'package:loyalty_customer/widget/app_input/country_city_dropdown.dart';
import 'package:loyalty_customer/widget/app_input/email_and_phone_field.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      init: SignUpController(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            data: "Join Miltech Today!",
                            fontSize: AppSize.width(value: 34),
                            fontWeight: FontWeight.w700,
                            color: AppColor.button1Light,
                          ),
                          AppText(
                            data: "Unlock Rewards, Start Earning Now!",
                            fontSize: AppSize.width(value: 16),
                            fontWeight: FontWeight.w400,
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
                        key: controller.signUpKey,
                        child: Column(
                          children: [
                            AppInputWidgetTwo(
                              controller: controller.nameController,
                              validator: controller.validateName,
                              borderRadius: 30,
                              hintText: "Enter Your Name",
                            ),
                            AppInputWidgetTwo(
                              controller: controller.emailController,
                              validator: controller.validateEmail,
                              borderRadius: 30,
                              hintText: "Enter Your Email",
                            ),
                            // Example 2: Always phone only (no radio button, no email option)
                            Gap(height: AppSize.width(value: 12)),
                            EmailAndPhoneField(
                              controller: controller.phoneController,
                              alwaysPhone: true, // শুধু phone field দেখাবে
                              allowedCountryCodes: ["PK"],
                              defaultCountryCode: 'PK',
                              fillColor: Colors.grey[100],
                              borderRadius: 24,
                              isOptional: false,
                              validator: controller.validatePhone,
                            ),
                            // AppInputWidgetTwo(
                            //   controller: controller.phoneController,
                            //   validator: controller.validatePhone,
                            //   borderRadius: 30,
                            //   hintText: "123456789301",
                            //   keyboardType: TextInputType.phone,
                            // ),
                            Gap(height: AppSize.width(value: 12)),
                            CountryCityDropdown(
                              isTitleShow: false,
                              fillColor: Colors.white,
                              textColor: Colors.black,
                              borderColor: Colors.black,
                              borderRadius: AppSize.width(value: 24),
                              height: AppSize.height(value: 56),
                              width: double.infinity,

                              onCountryChanged: (country) {
                                controller.countryController.text =
                                    country ?? "";
                              },
                              onCityChanged: (city) {
                                controller.cityController.text = city ?? "";
                              },
                            ),
                          ],
                        ),
                      ),
                      Gap(height: AppSize.width(value: 12)),

                      Obx(() {
                        return !controller.isChecked.value
                            ? AppButton(
                                onTap: () {
                                  AppSnackBar.message(
                                    "Please agree to the terms and conditions",
                                  );
                                },
                                title: "Sign Up",
                                filColor: AppColor.button1Dark.withValues(
                                  alpha: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              )
                            : AppButton(
                                onTap: () {
                                  controller.signUp();
                                },
                                title: "Sign Up",
                                borderRadius: BorderRadius.circular(30),
                              );
                      }),
                      Obx(
                        () => Row(
                          children: [
                            Checkbox(
                              value: controller.isChecked.value,
                              onChanged: (bool? value) {
                                controller.toggleCheckbox(value ?? false);
                              },
                            ),
                            Flexible(
                              child: AppText(
                                data:
                                    "I agree to (Company Name) Terms & Conditions.",
                                fontSize: AppSize.width(value: 12),
                                fontWeight: FontWeight.w400,
                                color: AppColor.button1Dark,
                                textAlign: TextAlign
                                    .start, // Align the text to the start
                              ),
                            ),
                          ],
                        ),
                      ),
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
                        data: "All Ready Sign Up?",
                        fontSize: AppSize.width(value: 12),
                        fontWeight: FontWeight.w700,
                        color: AppColor.button1Dark,
                      ),
                      InkWell(
                        onTap: () {
                          Get.offNamed(AppRoutes.instance.signInScreen);
                        },
                        child: AppText(
                          data: "Sign In",
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
