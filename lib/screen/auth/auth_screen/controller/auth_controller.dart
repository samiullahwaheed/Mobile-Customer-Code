import 'package:get/get.dart';
import 'package:loyalty_customer/service/apple_auth_service/apple_auth_service.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
import 'package:loyalty_customer/service/auth_navigation/auth_navigation.dart';
import 'package:loyalty_customer/service/google_auth_service/google_auth_service.dart';
import 'package:loyalty_customer/service/push_notification/fcm_service.dart';
import 'package:loyalty_customer/service/repository/auth_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class AuthController extends GetxController {
  final GoogleAuthService googleAuthService = GoogleAuthService();
  final AppleAuthService appleAuthService = AppleAuthService();
  final AuthRepository authRepository = AuthRepository.instance;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeGoogle();
  }

  Future<void> initializeGoogle() async {
    try {
      await googleAuthService.initialize();
    } catch (e) {
      AppSnackBar.error("Google service initialization failed");
    }
  }

  Future<void> loginWithGoogle() async {
    if (isLoading.value) return;
    try {
      final success = await googleAuthService.signIn();

      if (!success) {
        AppSnackBar.error("Google Sign In Failed");
        return;
      }

      final idToken = googleAuthService.userData?.idToken;

      if (idToken == null || idToken.isEmpty) {
        AppSnackBar.error("Invalid Google token");
        return;
      }

      await googleAuth(idToken: idToken);
    } catch (e) {
      AppSnackBar.error("Login failed. Please try again");
    }
  }

  Future<void> googleAuth({required String idToken}) {
    return _socialLogin(
      title: "Google login user",
      request: (fcmToken) =>
          authRepository.googleAuth(idToken: idToken, fcmToken: fcmToken),
    );
  }

  Future<void> loginWithApple() async {
    if (isLoading.value) return;
    try {
      final result = await appleAuthService.signIn();
      if (result == null) return; // user closed the Apple sheet

      await _socialLogin(
        title: "Apple login user",
        request: (fcmToken) => authRepository.appleAuth(
          identityToken: result.identityToken,
          rawNonce: result.rawNonce,
          authorizationCode: result.authorizationCode,
          firstName: result.firstName,
          lastName: result.lastName,
          fcmToken: fcmToken,
        ),
      );
    } catch (e) {
      AppPrint.appError(e, title: "Apple Sign In Error");
      AppSnackBar.error("Apple Sign In Failed");
    }
  }

  /// Shared by Google and Apple: sends the login with the FCM token, then
  /// opens the same next screen as password login.
  Future<void> _socialLogin({
    required String title,
    required Future<Map<String, dynamic>?> Function(String? fcmToken) request,
  }) async {
    isLoading.value = true;
    try {
      final storage = GetStorageServices.instance;
      String? fcmToken = storage.getFCMtoken();
      if (fcmToken == null || fcmToken.isEmpty) {
        fcmToken = await FCMService.getToken();
      }

      final user = await request(fcmToken);
      if (user == null) return; // error already shown

      // Backend saved the FCM token with the login
      if (fcmToken != null && fcmToken.isNotEmpty) {
        await storage.setSyncedFCMtoken(fcmToken);
      }

      AppPrint.apiResponse(user, title: title);
      AuthNavigation.afterLogin(user);
    } catch (e) {
      AppSnackBar.error("Server error. Please try again");
    } finally {
      isLoading.value = false;
    }
  }
}
