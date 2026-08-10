import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/auth/sign_in_screen/sign_in_screen.dart';
import 'package:loyalty_customer/service/repository/auth_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class CreateNewPasswordController extends GetxController {
  final GlobalKey<FormState> newpasswordFormKey = GlobalKey<FormState>();

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  AuthRepository authRepository = AuthRepository.instance;

  RxBool isLoading = false.obs;

  Future<void> createPassword() async {
    if (!newpasswordFormKey.currentState!.validate()) {
      return;
    }
    try {
      isLoading.value = true;
      final response = await authRepository.resetPassword(
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
        resetToken: resetToken ?? "",
      );
      if (response) {
        Get.until(
          (route) => route.settings.name == AppRoutes.instance.signInScreen,
        );
        // Get.offAllNamed(AppRoutes.instance.signInScreen);
        // Get.offAll(() => SignInScreen());
      } else {
        AppPrint.appError("Failed to create password");
      }
    } catch (e) {
      AppPrint.appError(e, title: "Create Password Error");
    } finally {
      isLoading.value = false;
    }
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? validateConfirmPassword(
    String? confirmPassword,
    String originalPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmPassword != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    _getsignupArgument();
    _controllerInisializ();

    super.onInit();
  }

  void _controllerInisializ() {
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  String? resetToken;
  void _getsignupArgument() {
    final token = Get.arguments;
    if (token != null && token is String) {
      resetToken = token;
    }
  }
}
