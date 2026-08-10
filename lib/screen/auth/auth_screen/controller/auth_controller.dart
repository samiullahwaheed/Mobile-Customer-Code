import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/service/google_auth_service/google_auth_service.dart';
import 'package:loyalty_customer/service/repository/auth_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class AuthController extends GetxController {
  final GoogleAuthService googleAuthService = GoogleAuthService();
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

  Future<void> googleAuth({required String idToken}) async {
    isLoading.value = true;
    try {
      final response = await authRepository.googleAuth(idToken: idToken);

      if (response == "active") {
        AppPrint.apiResponse(response, title: "if response active");
        Get.offAllNamed(AppRoutes.instance.navigationScreen);
      } else if (response == "inactive") {
        AppPrint.apiResponse(response, title: "if response inactive");
        Get.offAllNamed(AppRoutes.instance.mySubScreen);
      } else if (response == true) {
        AppPrint.apiResponse(response, title: "if response true");
        Get.offAllNamed(AppRoutes.instance.locationScreen);
      } else {
        AppSnackBar.error("Authentication failed");
      }
    } catch (e) {
      AppSnackBar.error("Server error. Please try again");
    } finally {
      isLoading.value = false;
    }
  }
}
