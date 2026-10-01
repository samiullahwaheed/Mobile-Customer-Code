import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/model/profile_model.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
import 'package:loyalty_customer/service/push_notification/fcm_service.dart';
import 'package:loyalty_customer/service/repository/account_repository.dart';
import 'package:loyalty_customer/service/repository/delete_repository.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class ProfileController extends GetxController {
  RxBool isDark = false.obs;
  Rxn<ProfileModelData> profileData = Rxn<ProfileModelData>();
  GetRepository getRepository = GetRepository.instance;
  DeleteRepository deleteRepository = DeleteRepository.instance;
  GetStorageServices getStorage = GetStorageServices.instance;
  PostRepository postRepository = PostRepository.instance;

  TextEditingController passwordController = TextEditingController();

  // Delete confirmation for accounts without a password (Google sign-up)
  TextEditingController deleteOtpController = TextEditingController();
  RxBool deleteOtpSent = false.obs;
  RxBool isSendingDeleteOtp = false.obs;

  /// False for accounts created with Google until they set a password.
  bool get hasPassword => profileData.value?.hasPassword ?? true;

  //----------Theme Mode-----------
  void changeTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
    getStorage.setThemeMode(isDark.value);
    AppPrint.appPrint(isDark);
  }

  @override
  void dispose() {
    passwordController.dispose();
    deleteOtpController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    // Load theme mode on controller initialization
    // Priority: 1. Saved preference, 2. System theme
    final savedTheme = getStorage.getThemeMode();
    if (savedTheme != null) {
      // User has explicitly set a theme preference
      isDark.value = savedTheme;
    } else {
      // No saved preference, sync with system theme
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      isDark.value = brightness == Brightness.dark;
    }
    AppPrint.apiResponse(getStorage.getFCMtoken(), title: "FCM Token");
    updateFcmToken();
  }

  /// Hits the API only if the token changed since the last successful sync.
  void updateFcmToken() async {
    await FCMService.syncTokenWithBackend();
  }

  /// Sends the SMS code that confirms deleting an account without a password.
  Future<void> sendDeleteOtp() async {
    if (isSendingDeleteOtp.value) return;
    isSendingDeleteOtp.value = true;
    final sent = await AccountRepository.instance.sendDeleteAccountOtp();
    isSendingDeleteOtp.value = false;
    if (sent) {
      deleteOtpSent.value = true;
      AppSnackBar.success("We sent a code to your phone");
    }
  }

  void deleteAccount() async {
    final response = hasPassword
        ? await deleteRepository.deleteAccount(password: passwordController.text)
        : await deleteRepository.deleteAccount(otp: deleteOtpController.text);
    if (response) {
      getStorage.completeLogout();
      AppSnackBar.success("Account deleted successfully");
    } else {
      AppPrint.appError("Account deletion failed");
    }
  }

  Future<void> fetchProfileData() async {
    final response = await getRepository.getProfile();
    if (response != null) {
      profileData.value = response;
    } else {
      AppPrint.appError("No Data Found");
    }
  }

  //Logout
  void logout() {
    try {
      getStorage.completeLogout();
    } catch (e) {
      AppPrint.appError(e, title: 'ProfileController.logout()');
    }
  }
}
