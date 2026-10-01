import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';

/// Picks the first screen after any login (email/password or Google), so both
/// flows always go through the same steps.
class AuthNavigation {
  AuthNavigation._();

  /// Login summary from the last login, reused after the Google phone step.
  static Map<String, dynamic>? _lastUser;

  static void afterLogin(Map<String, dynamic> user) {
    _lastUser = user;

    // Google sign-up not finished: referral question (until one is applied),
    // then phone + OTP.
    if (user["needsPhone"] == true) {
      if (user["hasReferral"] == true) {
        Get.offAllNamed(AppRoutes.instance.addPhoneScreen);
      } else {
        Get.offAllNamed(
          AppRoutes.instance.signupWithReffralIdScreen,
          arguments: {"googleSignUp": true},
        );
      }
      return;
    }

    if (user["isUserWaiting"] == true) {
      Get.offAllNamed(AppRoutes.instance.waitingScreen);
    } else if (_isLocationEmpty(user["location"])) {
      Get.offAllNamed(AppRoutes.instance.locationScreen);
    } else if (user["subscription"] == "active") {
      Get.offAllNamed(AppRoutes.instance.navigationScreen);
    } else {
      Get.offAllNamed(AppRoutes.instance.mySubScreen, arguments: {'value': 1});
    }
  }

  /// Google sign-up phone verified: continue like a normal login.
  static void afterPhoneVerified() {
    afterLogin({...?_lastUser, "needsPhone": false});
  }

  static bool _isLocationEmpty(dynamic location) {
    if (location is! Map || location["coordinates"] is! List) return true;
    final coords = location["coordinates"] as List;
    if (coords.length < 2) return true;
    return coords[0] == 0 && coords[1] == 0;
  }
}
