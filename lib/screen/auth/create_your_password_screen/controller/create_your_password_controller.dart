import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
import 'package:loyalty_customer/service/repository/auth_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class CreateYourPasswordController extends GetxController {
  String? name;
  String? email;
  String? phone;
  String? country;
  String? city;
  String? reffarelId;
  String? role;

  GetStorageServices getStorageServices = GetStorageServices.instance;

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  AuthRepository authRepository = AuthRepository.instance;

  RxBool isLoading = false.obs;

  Future<void> createPassword(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      isLoading.value = true;
      final response = await authRepository.signUp(
        phone: phone ?? "",
        name: name ?? "",
        email: email ?? "",
        country: country ?? "",
        city: city ?? "",
        password: passwordController.text,
        referenceId: reffarelId ?? "",
        role: "USER",
      );
      if (response) {
        Get.toNamed(
          AppRoutes.instance.verifyOtpScreen,
          arguments: {
            "email": email,
            "phone": phone,
            "name": name,
            "country": country,
            "city": city,
            "reffarelId": reffarelId,
            "role": role,
          },
        );
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
      return 'Password must be at least 8 characters long';
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
    passwordController.dispose();
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
    // Controllers are already initialized at the top.
    // If they need to be fresh every time onInit runs, keep them here.
    // However, the top-level initialization is fine.
  }

  void _getsignupArgument() {
    name = Get.arguments['name'];
    email = Get.arguments['email'];
    phone = Get.arguments['phone'];
    country = Get.arguments['country'];
    city = Get.arguments['city'];
    reffarelId = Get.arguments['reffarelId'];

    AppPrint.apiResponse(reffarelId, title: "CreateYourPasswordController");
  }
}
