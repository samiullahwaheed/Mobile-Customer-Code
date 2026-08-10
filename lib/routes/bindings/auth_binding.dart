import 'package:get/get.dart';
import 'package:loyalty_customer/screen/auth/auth_screen/controller/auth_controller.dart';
import 'package:loyalty_customer/screen/auth/create_new_password_screen/controller/create_new_password_controller.dart';
import 'package:loyalty_customer/screen/auth/create_your_password_screen/controller/create_your_password_controller.dart';
import 'package:loyalty_customer/screen/auth/forget_pass_screen/controller/forget_password_controller.dart';
import 'package:loyalty_customer/screen/auth/forget_pass_verify_otp_screen/controller/forgetpass_verify_otp_controller.dart';
import 'package:loyalty_customer/screen/auth/location_screen/controller/location_controller.dart';
import 'package:loyalty_customer/screen/auth/sign_in_screen/controller/sign_in_controller.dart';
import 'package:loyalty_customer/screen/auth/sign_up_screen/controller/signup_controller.dart';
import 'package:loyalty_customer/screen/auth/verify_otp_screen/controller/verify_otp_controller.dart';
import 'package:loyalty_customer/screen/auth/waiting_screen/controller/waiting_controller.dart';

class AuthBinding extends Bindings {
  @override
  dependencies() {
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => CreateYourPasswordController());
    Get.lazyPut(() => CreateNewPasswordController());
    Get.lazyPut(() => VerifyOtpController());
    Get.lazyPut(() => ForgetPassVerifyOtpController());
    Get.lazyPut(() => ForgetPasswordController());
    Get.lazyPut(() => LocationController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => WaitingController());
  }
}
