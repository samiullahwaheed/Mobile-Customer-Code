import 'package:get/get.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/controller/profile_controller.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class NotificationSettingController extends GetxController {
  ProfileController profileController = Get.find<ProfileController>();

  PostRepository postRepository = PostRepository.instance;

  RxBool switch1 = false.obs;
  RxBool switch2 = false.obs;
  RxBool switch3 = false.obs;
  RxBool switch4 = false.obs;
  RxBool switch5 = false.obs;
  RxBool switch6 = false.obs;
  RxBool switch7 = false.obs;

  @override
  void onInit() {
    super.onInit();
    inisialValueSet();

    _allSwitchChecking();
  }

  void inisialValueSet() {
    switch2.value =
        profileController
            .profileData
            .value
            ?.notificationSettings
            ?.promotionalEmails ??
        false;
    switch3.value =
        profileController
            .profileData
            .value
            ?.notificationSettings
            ?.appNotifications ??
        false;
    switch4.value =
        profileController
            .profileData
            .value
            ?.notificationSettings
            ?.smsNotifications ??
        false;
    switch5.value =
        profileController
            .profileData
            .value
            ?.notificationSettings
            ?.referralNotifications ??
        false;
    switch6.value =
        profileController
            .profileData
            .value
            ?.notificationSettings
            ?.subscriptionNotifications ??
        false;
    switch7.value =
        profileController
            .profileData
            .value
            ?.notificationSettings
            ?.pushNotifications ??
        false;
  }

  Future<void> updateNotificationSettings() async {
    try {
      final response = await postRepository.updateUserProfile(
        promotionalEmails: switch2.value,
        appNotifications: switch3.value,
        smsNotifications: switch4.value,
        referralNotifications: switch5.value,
        subscriptionNotifications: switch6.value,
        pushNotifications: switch7.value,
      );
      if (response) {
        AppPrint.appLog("Notification settings updated successfully");
      }
    } catch (e) {
      AppPrint.appLog("Error updating notification settings: $e");
    }
  }

  void toggleSwitch1() async {
    switch1.value = !switch1.value;
    if (switch1.value) {
      switch2.value = true;
      switch3.value = true;
      switch4.value = true;
      switch5.value = true;
      switch6.value = true;
      switch7.value = true;

      final response = await postRepository.updateUserProfile(
        promotionalEmails: switch2.value,
        appNotifications: switch3.value,
        smsNotifications: switch4.value,
        referralNotifications: switch5.value,
        subscriptionNotifications: switch6.value,
        pushNotifications: switch7.value,
      );
      if (response) {
        profileController
                .profileData
                .value
                ?.notificationSettings
                ?.promotionalEmails =
            switch2.value;
        profileController
                .profileData
                .value
                ?.notificationSettings
                ?.appNotifications =
            switch3.value;
        profileController
                .profileData
                .value
                ?.notificationSettings
                ?.smsNotifications =
            switch4.value;
        profileController
                .profileData
                .value
                ?.notificationSettings
                ?.referralNotifications =
            switch5.value;
        profileController
                .profileData
                .value
                ?.notificationSettings
                ?.subscriptionNotifications =
            switch6.value;
        profileController
                .profileData
                .value
                ?.notificationSettings
                ?.pushNotifications =
            switch7.value;
        AppPrint.appLog("Notification settings updated successfully");
      } else {
        switch1.value = !switch1.value;
      }
    } else {
      switch2.value = false;
      switch3.value = false;
      switch4.value = false;
      switch5.value = false;
      switch6.value = false;
      switch7.value = false;

      final response = await postRepository.updateUserProfile(
        promotionalEmails: switch2.value,
        appNotifications: switch3.value,
        smsNotifications: switch4.value,
        referralNotifications: switch5.value,
        subscriptionNotifications: switch6.value,
        pushNotifications: switch7.value,
      );
      if (response) {
        profileController
                .profileData
                .value
                ?.notificationSettings
                ?.promotionalEmails =
            switch2.value;
        profileController
                .profileData
                .value
                ?.notificationSettings
                ?.appNotifications =
            switch3.value;
        profileController
                .profileData
                .value
                ?.notificationSettings
                ?.smsNotifications =
            switch4.value;
        profileController
                .profileData
                .value
                ?.notificationSettings
                ?.referralNotifications =
            switch5.value;
        profileController
                .profileData
                .value
                ?.notificationSettings
                ?.subscriptionNotifications =
            switch6.value;
        profileController
                .profileData
                .value
                ?.notificationSettings
                ?.pushNotifications =
            switch7.value;
        AppPrint.appLog("Notification settings updated successfully");
      } else {
        switch1.value = !switch1.value;
      }
    }
    AppPrint.appLog(switch1);
  }

  void _allSwitchChecking() {
    if (switch2.value &&
        switch3.value &&
        switch4.value &&
        switch5.value &&
        switch6.value &&
        switch7.value) {
      switch1.value = true;
    } else {
      switch1.value = false;
    }
  }

  void toggleSwitch2() async {
    switch2.value = !switch2.value;
    _allSwitchChecking();
    final response = await postRepository.updateUserProfile(
      promotionalEmails: switch2.value,
    );
    if (response) {
      profileController
              .profileData
              .value
              ?.notificationSettings
              ?.promotionalEmails =
          switch2.value;

      AppPrint.appLog("Notification settings updated successfully");
    } else {
      switch2.value = !switch2.value;

      AppSnackBar.error("Failed to update notification settings");
    }
    AppPrint.appLog(switch2);
  }

  void toggleSwitch3() async {
    switch3.value = !switch3.value;
    _allSwitchChecking();
    final response = await postRepository.updateUserProfile(
      appNotifications: switch3.value,
    );
    if (response) {
      profileController
              .profileData
              .value
              ?.notificationSettings
              ?.appNotifications =
          switch3.value;

      AppPrint.appLog("Notification settings updated successfully");
    } else {
      switch3.value = !switch3.value;

      AppSnackBar.error("Failed to update notification settings");
    }
    AppPrint.appLog(switch3);
  }

  void toggleSwitch4() async {
    switch4.value = !switch4.value;
    _allSwitchChecking();
    final response = await postRepository.updateUserProfile(
      smsNotifications: switch4.value,
    );
    if (response) {
      profileController
              .profileData
              .value
              ?.notificationSettings
              ?.smsNotifications =
          switch4.value;

      AppPrint.appLog("Notification settings updated successfully");
    } else {
      switch4.value = !switch4.value;

      AppSnackBar.error("Failed to update notification settings");
    }
    AppPrint.appLog(switch4);
  }

  void toggleSwitch5() async {
    switch5.value = !switch5.value;
    _allSwitchChecking();
    final response = await postRepository.updateUserProfile(
      referralNotifications: switch5.value,
    );
    if (response) {
      profileController
              .profileData
              .value
              ?.notificationSettings
              ?.referralNotifications =
          switch5.value;

      AppPrint.appLog("Notification settings updated successfully");
    } else {
      switch5.value = !switch5.value;

      AppSnackBar.error("Failed to update notification settings");
    }
    AppPrint.appLog(switch5);
  }

  void toggleSwitch6() async {
    switch6.value = !switch6.value;
    _allSwitchChecking();
    final response = await postRepository.updateUserProfile(
      subscriptionNotifications: switch6.value,
    );
    if (response) {
      profileController
              .profileData
              .value
              ?.notificationSettings
              ?.subscriptionNotifications =
          switch6.value;

      AppPrint.appLog("Notification settings updated successfully");
    } else {
      switch6.value = !switch6.value;

      AppSnackBar.error("Failed to update notification settings");
    }
    AppPrint.appLog(switch6);
  }

  void toggleSwitch7() async {
    switch7.value = !switch7.value;
    _allSwitchChecking();
    final response = await postRepository.updateUserProfile(
      pushNotifications: switch7.value,
    );
    if (response) {
      profileController
              .profileData
              .value
              ?.notificationSettings
              ?.pushNotifications =
          switch7.value;

      AppPrint.appLog("Notification settings updated successfully");
    } else {
      switch7.value = !switch7.value;

      AppSnackBar.error("Failed to update notification settings");
    }
    AppPrint.appLog(switch7);
  }
}
