import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/screen/splash_screen/controller/splash_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';

/// Invisible bootstrap screen: the native splash screen (configured via
/// flutter_native_splash) stays on top of this the whole time and is only
/// removed once [SplashController] has decided where to navigate, so the
/// user only ever sees one logo screen.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize.size = MediaQuery.of(context).size;
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(backgroundColor: AppColor.button5Light);
      },
    );
  }
}
