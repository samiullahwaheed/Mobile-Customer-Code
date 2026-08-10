import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/screen/no_internet_screen/controller/no_internet_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor color = Theme.of(context).extension<AppThemeColor>()!;
    return GetBuilder<NoInternetController>(
      init: NoInternetController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.surfacePrimary,
          body: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSize.width(value: 24)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: AppSize.width(value: 80),
                    color: color.icon,
                  ),
                  Gap(height: AppSize.size.height * 0.03),
                  AppText(
                    data: 'No Internet Connection',
                    fontSize: AppSize.width(value: 20),
                    fontWeight: FontWeight.w700,
                    color: color.text,
                    textAlign: TextAlign.center,
                  ),
                  Gap(height: AppSize.size.height * 0.015),
                  AppText(
                    data:
                        'Please check your internet connection and try again.',
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w500,
                    color: color.text2,
                    textAlign: TextAlign.center,
                    height: 1.5,
                  ),
                  Gap(height: AppSize.size.height * 0.05),
                  Obx(
                    () => AppButton(
                      title: 'Try Again',
                      isLoading: controller.isLoading.value,
                      onTap: controller.tryAgain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
