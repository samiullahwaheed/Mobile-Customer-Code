import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
import 'package:loyalty_customer/service/auth_navigation/auth_navigation.dart';
import 'package:loyalty_customer/service/push_notification/fcm_service.dart';
import 'package:loyalty_customer/service/repository/auth_repository.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class SignInController extends GetxController {
  final GlobalKey<FormState> signinKey = GlobalKey<FormState>();
  final PostRepository postRepository = PostRepository.instance;
  final AuthRepository authRepository = AuthRepository.instance;

  // Controllers are final and initialized once
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _controllerInisilized();
  }

  void _controllerInisilized() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> signIn() async {
    if (!signinKey.currentState!.validate()) return;

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }

    try {
      isLoading.value = true;

      final response = await authRepository.login(
        email: emailController.text,
        password: passwordController.text,
        device: "user",
      );

      if (response != null && response["user"] != null) {
        final userData = response["user"];

        await updateFcmToken();
        _handleNavigation(userData);
        _controllerClear();
      } else {
        throw "Invalid login response";
      }
    } catch (e) {
      AppPrint.appError(e, title: "SignInController");
    } finally {
      isLoading.value = false;
    }
  }

  void _handleNavigation(dynamic user) {
    // Same rules as Google login
    AuthNavigation.afterLogin(Map<String, dynamic>.from(user));
  }

  Future<void> updateFcmToken() async {
    try {
      final storage = GetStorageServices.instance;
      String? fcmToken = storage.getFCMtoken();
      if (fcmToken == null || fcmToken.isEmpty) {
        fcmToken = await FCMService.getToken();
      }
      if (fcmToken == null || fcmToken.isEmpty) {
        AppPrint.appError(
          "FCM token unavailable (permission, simulator, or APNS delay)",
          title: "updateFcmToken",
        );
        return;
      }
      // Always sent on login (another account may have used this device)
      final ok = await postRepository.updateUserProfile(fcmToken: fcmToken);
      if (ok) await storage.setSyncedFCMtoken(fcmToken);
      AppPrint.apiResponse(fcmToken, title: "FCM Token Updated correctly");
    } catch (e) {
      AppPrint.appError(e, title: "FCM Update Failed");
    }
  }

  void _controllerClear() {
    emailController.clear();
    passwordController.clear();
  }

  // Validation functions kept as is
  String? validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty)
      return 'Please enter email or phone number';
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    final phoneRegex = RegExp(r"^\+?[0-9]{10,14}$");
    if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
      return 'Please enter a valid email or phone number';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Please enter a password';
    if (password.length < 6)
      return 'Password must be at least 6 characters long';
    return null;
  }
}
