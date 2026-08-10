import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class ChnagePassController extends GetxController {
  //All Repositories
  PostRepository postRepository = PostRepository.instance;

  //TextEditingController
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  //form key
  final GlobalKey<FormState> changePassKey = GlobalKey<FormState>();

  //loading indicator
  RxBool isLoading = false.obs;

  // Validate Old Password
  String? validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your old password";
    } else if (value.length < 8) {
      return "Old password should be at least 8 characters long";
    }
    return null;
  }

  // Validate New Password
  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter a new password";
    } else if (value.length < 8) {
      return "New password should be at least 8 characters long";
    }
    return null;
  }

  // Validate Confirm Password
  String? validateConfirmPassword(String? value, String newPassword) {
    if (value == null || value.isEmpty) {
      return "Confirm your new password";
    } else if (value != newPassword) {
      return "Passwords do not match";
    }
    return null;
  }

  // change password function
  Future<void> changePassword() async {
    if (changePassKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        var response = await postRepository.changePassword(
          oldPassword: oldPasswordController.text,
          newPassword: newPasswordController.text,
          confirmPassword: confirmPasswordController.text,
        );

        if (response) {
          controllerClear();
          Get.close(1);
        } else {
          isLoading.value = false;
        //   AppSnackbar.error(title: "Error", message: "Password change failed");
        }
      } catch (e) {
        AppPrint.appError(e, title: "changePassword");
      } finally {
        isLoading.value = false;
      }
    }
  }

  ///dispose
  void controllerDispose() {
    oldPasswordController.dispose();

    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  //controller initialize
  void controllerInisialize() {
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  //controller Clear
  void controllerClear() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onInit() {
    controllerInisialize();
    super.onInit();
  }

  @override
  void onClose() {
    controllerDispose();
    super.onClose();
  }
}
