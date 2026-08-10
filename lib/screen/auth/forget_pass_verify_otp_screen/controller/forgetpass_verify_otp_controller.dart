import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/service/repository/auth_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class ForgetPassVerifyOtpController extends GetxController {
  TextEditingController otpTextEditingController = TextEditingController();
  AuthRepository authRepository = AuthRepository.instance;
  RxInt remainingSeconds = 180.obs; // 3 minutes in seconds
  var canResend = false.obs;
  late String email;
  late Timer _timer;
  RxBool isLoading = false.obs;
  var clearOtpField = false.obs; // To trigger clearing of OTP fields

  Future<void> verifyPhoneOtp() async {
    try {
      isLoading.value = true;
      final response = await authRepository.resendPhoneOtp(phone: phone ?? "");
      if (response) {
        clearOtpFields(); // Clear OTP fields
        AppSnackBar.success("A new OTP has been sent to your phone.");
        resendCode();
      }
    } catch (e) {
      AppPrint.appError(e, title: "Verify Phone OTP Error");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    try {
      isLoading.value = true;
      final response = await authRepository.forgetPassphoneVerify(
        phone: phone ?? "",
        otp: otpTextEditingController.text,
      );
      if (response != null) {
        
        Get.toNamed(
          AppRoutes.instance.cteateNewPasswordScreen,
          arguments: response,
        );
      }
    } catch (e) {
      AppPrint.appError(e, title: "Verify OTP Error");
    } finally {
      isLoading.value = false;
    }
  }

  String? phone;
  @override
  void onInit() {
    super.onInit();
    startTimer();
    phone = Get.arguments;
  }

  void startTimer() {
    // This will keep the timer going in the background
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        // Timer has completed
        canResend.value = true;
        _timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer.cancel();
    otpTextEditingController.dispose();
    super.onClose();
  }

  void resetTimer() {
    remainingSeconds.value = 180; // Reset the timer back to 180 seconds
    canResend.value = false; // Disable the resend button
    startTimer(); // Restart the timer
  }

  String formatTime() {
    final minutes = remainingSeconds.value ~/ 60;
    final remainingSec = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSec.toString().padLeft(2, '0')}';
  }

  /// Resend the OTP code
  void resendCode() async {
    try {
      bool isSuccess = true; // Assume success for now
      if (isSuccess) {
        resetTimer(); // Reset the timer after sending the OTP
      }
    } catch (e) {
      AppSnackBar.error("An error occurred. Please try again.");
    }
  }

  /// Clear OTP fields
  void clearOtpFields() {
    clearOtpField.value = true;
    otpTextEditingController.clear();

    // Reset the flag after a short delay to allow UI to update
    Future.delayed(Duration(milliseconds: 100), () {
      clearOtpField.value = false;
    });
  }
}
