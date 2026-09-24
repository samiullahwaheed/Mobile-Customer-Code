import 'dart:io' show Platform;

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/model/profile_model.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
import 'package:loyalty_customer/service/push_notification/fcm_service.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class SplashController extends GetxController {
  final GetStorageServices storageServices = GetStorageServices.instance;
  final GetRepository getRepository = GetRepository.instance;
  final PostRepository postRepository = PostRepository.instance;

  Rxn<ProfileModelData> profileModelData = Rxn<ProfileModelData>();

  @override
  void onInit() {
    super.onInit();
    onInitialDataLoadScreen();
  }

  Future<void> onInitialDataLoadScreen() async {
    try {
      await Future.wait([
        Future.delayed(const Duration(milliseconds: 1000)),
        _fetchInitialData(),
      ]);

      _handleNavigation();
    } catch (e) {
      AppPrint.appError(e, title: "onInitialDataLoadScreen");
      _navigateTo(AppRoutes.instance.onBoardingScreen);
    }
  }

  void _navigateTo(String route, {Object? arguments}) {
    FlutterNativeSplash.remove();
    Get.offAllNamed(route, arguments: arguments);
  }

  /// Logged-in user ka profile aur push tokens sync karta hai.
  Future<void> _fetchInitialData() async {
    final String token = storageServices.getToken();

    if (token.isNotEmpty) {
      await getSubscription();
      await syncPushTokens();
    }
  }

  /// FCM aur iOS APNs token backend par save karta hai.
  Future<void> syncPushTokens() async {
    try {
      final String? fcmToken = await FCMService.getToken();

      if (fcmToken == null || fcmToken.isEmpty) {
        AppPrint.appError(
          "FCM token not available",
          title: "Push Token Sync",
        );
        return;
      }

      String? apnsToken;

      if (Platform.isIOS) {
        // iOS par APNs token aane mein kuch seconds lag sakte hain.
        for (int i = 0; i < 10; i++) {
          apnsToken = await FCMService.getAPNSToken();

          if (apnsToken != null && apnsToken.isNotEmpty) {
            break;
          }

          await Future.delayed(const Duration(seconds: 1));
        }

        if (apnsToken == null || apnsToken.isEmpty) {
          AppPrint.appError(
            "APNs token not available after waiting",
            title: "Push Token Sync",
          );
          return;
        }
      }

      final bool updated = await postRepository.updateUserProfile(
        fcmToken: fcmToken,
        apnsToken: apnsToken,
      );

      AppPrint.apiResponse(
        {
          "updated": updated,
          "fcmTokenAvailable": fcmToken.isNotEmpty,
          "apnsTokenAvailable": apnsToken?.isNotEmpty == true,
        },
        title: "Push Tokens Synced",
      );
    } catch (e) {
      AppPrint.appError(
        e,
        title: "Push Token Sync Failed",
      );
    }
  }

  void _handleNavigation() {
    final String token = storageServices.getToken();

    if (token.isEmpty) {
      if (storageServices.getIsUserFirstTime() == true) {
        _navigateTo(AppRoutes.instance.authScreen);
      } else {
        _navigateTo(AppRoutes.instance.onBoardingScreen);
      }
      return;
    }

    final data = profileModelData.value;

    bool isLocationEmpty =
        data?.location?.coordinates == null ||
        data!.location!.coordinates!.isEmpty ||
        data.location!.coordinates!.any((e) => e == 0.0 || e == null);

    if (isLocationEmpty) {
      _navigateTo(AppRoutes.instance.locationScreen);
      return;
    }

    if (data.isUserWaiting == true) {
      _navigateTo(AppRoutes.instance.waitingScreen);
      return;
    }

    if (data.subscription == "active") {
      _navigateTo(AppRoutes.instance.navigationScreen);
    } else {
      _navigateTo(
        AppRoutes.instance.mySubScreen,
        arguments: {'value': 1},
      );
    }
  }

  Future<void> getSubscription() async {
    try {
      final response = await getRepository.getProfile();

      if (response != null) {
        profileModelData.value = response;

        AppPrint.apiResponse(
          profileModelData.value?.subscription ?? "No Subscription Found",
          title: "Splash Profile Status",
        );
      }
    } catch (e) {
      AppPrint.appError(
        e,
        title: "getSubscription API Call Failed",
      );
    }
  }
}