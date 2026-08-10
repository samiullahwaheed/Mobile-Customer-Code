import 'package:get/get.dart';
import 'package:loyalty_customer/screen/splash_screen/controller/splash_controller.dart';

class SplashScreenBinding extends Bindings {
  @override
  dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
