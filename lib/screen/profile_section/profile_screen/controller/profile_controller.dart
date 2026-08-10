import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/model/profile_model.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
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

  void updateFcmToken() async {
    final response = await postRepository.updateUserProfile(
      fcmToken: getStorage.getFCMtoken(),
    );
    if (response) {
      AppPrint.apiResponse(
        "Update FCM Token Success",
        title: "token update form profileController",
      );
    } else {
      AppPrint.appError("Update FCM Token Failed", title: "profileController");
    }
  }

  void deleteAccount() async {
    
    final response = await deleteRepository.deleteAccount(
      password: passwordController.text,
    );
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
