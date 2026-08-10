import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/screen/merchants_screen/widgets/merchent_card.dart';
import 'package:loyalty_customer/screen/recently_view_screen/controller/recently_view_controller.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class RecentlyViewScreen extends StatelessWidget {
  const RecentlyViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme data
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return GetBuilder<RecentlyViewController>(
      init: RecentlyViewController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(
            text: "Your Recently Viewed",
            appThemeColor: appThemeColor,
          ),
          body: ListView.builder(
            shrinkWrap: true, // Ensures ListView takes only the space it needs
            physics:
                AlwaysScrollableScrollPhysics(), // Disable ListView's scrolling
            itemCount: 4,
            itemBuilder: (context, index) {
              return Obx(() {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: MerchantCard(
                    favorateValue: controller
                        .favorites[index]
                        .value, // ✅ boolean for this merchant
                    appThemeColor: appThemeColor,
                    toggoleFavorate: () => controller.toggoleFavorate(index),
                  ),
                );
              });
            },
          ),
        );
      },
    );
  }
}
