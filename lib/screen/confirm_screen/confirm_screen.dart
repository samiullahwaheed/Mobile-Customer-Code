import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/home_screen/controller/home_controller.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/controller/profile_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class ConfirmScreen extends StatelessWidget {
  ConfirmScreen({super.key});

  /// navigation duplicate prevent করার জন্য
  final RxBool _hasNavigated = false.obs;

  void _navigate() {
    if (_hasNavigated.value) return;
    _hasNavigated.value = true;

    // ✅ HomeController and ProfileController are permanent/singleton
    // controllers (put once via lazyPut/put at app start), so their
    // onInit() never runs again just because we navigate back to the
    // home screen. Without this, the newly purchased package never
    // shows up on the home screen ("No Subscription" keeps showing)
    // until the app is restarted. Explicitly refresh them here so the
    // home screen reflects the subscription the user just bought.
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().getSubSummary();
    }
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().fetchProfileData();
    }

    Get.offAllNamed(AppRoutes.instance.navigationScreen);
  }

  @override
  Widget build(BuildContext context) {
    /// screen build হওয়ার পর 3 sec timer start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        _navigate();
      });
    });

    return Scaffold(
      backgroundColor: AppColor.surfacePrimaryLight,
      body: Column(
        spacing: AppSize.size.height * 0.02,
        children: [
          Stack(
            children: [
              AppImage(path: AssetsPath.backgroundImage),
              Positioned(
                top: AppSize.size.height * 0.07,
                left: 0,
                right: 0,
                child: Center(
                  child: AppImage(
                    width: AppSize.width(value: 230),
                    height: AppSize.width(value: 230),
                    path: AssetsPath.confirmImg,
                  ),
                ),
              ),
            ],
          ),

          Gap(height: AppSize.size.height * 0.1),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 50)),
            child: AppText(
              textAlign: TextAlign.center,
              data: "Thank you for purchasing",
              fontSize: AppSize.width(value: 18),
              fontWeight: FontWeight.w700,
              color: AppColor.button4Dark,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 30)),
            child: AppText(
              height: 1.5,
              textAlign: TextAlign.center,
              data:
                  "You're all set to enjoy premium features and exclusive benefits. Let’s get started! If you need any help, we're here for you.",
              fontSize: AppSize.width(value: 12),
              fontWeight: FontWeight.w500,
              color: AppColor.button4Dark,
            ),
          ),
        ],
      ),
    );
  }
}
