import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/service/repository/auth_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class ForgetPasswordController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthRepository authRepository = AuthRepository.instance;
  final isLoading = false.obs;

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    if (value.startsWith('+')) {
      // Phone validation: check if there's anything after the country code
      // User requested: if total length <= 4, show error
      if (value.length <= 4) {
        return 'please enter valid phone number';
      }
      return null;
    } else {
      // Email validation
      if (!GetUtils.isEmail(value)) {
        return 'Please enter a valid email';
      }
      return null;
    }
  }

  Future<void> forgetPassword() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }
    try {
      isLoading.value = true;
      final response = await authRepository.forgetPassword(
        phone: phoneController.text,
      );
      if (response) {
        Get.toNamed(
          AppRoutes.instance.forgetPassVerifyOtpScreen,
          arguments: phoneController.text,
        );
      } else {
        AppPrint.appError("Failed to send OTP", title: "forgetPassword");
      }
    } catch (e) {
      AppPrint.appError(e, title: "forgetPassword");
    } finally {
      isLoading.value = false;
    }
  }
}
