import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
import 'package:loyalty_customer/service/connectivity/connectivity_service.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class NoInternetController extends GetxController {
  final RxBool isLoading = false.obs;

  Future<void> tryAgain() async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      final hasInternet = await ConnectivityService.instance
          .hasInternetConnection();

      if (!hasInternet) {
        AppSnackBar.error('Please check your internet connection');
        return;
      }

      final token = GetStorageServices.instance.getToken();
      if (token.isNotEmpty) {
        Get.offAllNamed(AppRoutes.instance.navigationScreen);
      } else {
        Get.offAllNamed(AppRoutes.instance.authScreen);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
