import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/screen/subscription_screen/controller/my_sub_controller.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KuickpayCheckoutWebViewScreen extends StatelessWidget {
  const KuickpayCheckoutWebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    final controller = Get.find<MySubController>();

    return Scaffold(
      appBar: CustomAppbar(text: "Checkout", appThemeColor: appThemeColor),
      body: Obx(() {
        if (controller.isPaymentLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.webViewController == null) {
          return const Center(child: Text('Failed to load checkout page'));
        }

        return WebViewWidget(controller: controller.webViewController!);
      }),
    );
  }
}
