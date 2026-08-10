import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/controller/profile_controller.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class ContactUsController extends GetxController {
  PostRepository postRepository = PostRepository.instance;
  ProfileController profileController = Get.find<ProfileController>();

  TextEditingController messageController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  _validateForm() {
    if (messageController.text.isEmpty) {
      AppSnackBar.message("Please enter a message");
      return false;
    }
    if (subjectController.text.isEmpty) {
      AppSnackBar.message("Please enter a subject");
      return false;
    }
    return true;
  }

  void contactUs() async {
    if (!_validateForm()) {
      return;
    }
    try {
      isLoading.value = true;
      final response = await postRepository.contactUs(
        name: profileController.profileData.value?.firstName ?? "",
        email: profileController.profileData.value?.email ?? "",
        phone: profileController.profileData.value?.phone ?? "",
        address: profileController.profileData.value?.country ?? "",
        message: messageController.text,
        subject: subjectController.text,
      );
      if (response) {
        AppSnackBar.message("Feedback submitted successfully");
        AppPrint.apiResponse(
          "Contact Us Success",
          title: "Contact Us Controller",
        );
        _controllerClear();
        Get.back();
      } else {
        AppPrint.appError("Contact Us Failed");
      }
    } catch (e) {
      AppPrint.appError(e, title: "Contact Us Error");
    } finally {
      isLoading.value = false;
    }
  }

  RxBool isLoading = false.obs;
  @override
  void onInit() {
    _controllerInisilized();
    super.onInit();
  }

  void _controllerInisilized() {
    messageController = TextEditingController();
    subjectController = TextEditingController();
  }

  void _controllerDispose() {
    messageController.dispose();
    subjectController.dispose();
  }

  void _controllerClear() {
    messageController.clear();
    subjectController.clear();
  }

  @override
  void onClose() {
    _controllerDispose();
    super.onClose();
  }
}
