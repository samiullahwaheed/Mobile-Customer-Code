import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/Merchants_screen/Merchants_screen.dart';
import 'package:loyalty_customer/screen/app_navigation_screen/controller/navigation_screen_controller.dart';
import 'package:loyalty_customer/screen/app_navigation_screen/navigation_tab.dart';
import 'package:loyalty_customer/screen/home_screen/home_screen.dart';
import 'package:loyalty_customer/screen/my_wallet_screen/my_wallet_screen.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/profile_screen.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor color = Theme.of(context).extension<AppThemeColor>()!;
    return GetBuilder<NavigationScreenController>(
      init: NavigationScreenController(),
      builder: (controller) {
        return Scaffold(
          body: Obx(
            () => IndexedStack(
              index: controller.selectedTab.value.stackIndex,
              children: [
                const HomeScreen(),
                controller.selectedTab.value == NavigationTab.merchants
                    ? MerchantsScreen()
                    : const SizedBox(),
                controller.selectedTab.value == NavigationTab.wallet
                    ? const MyWalletScreen()
                    : const SizedBox(),
                const ProfileScreen(),
              ],
            ),
          ),
          
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(
              bottom: AppSize.width(value: 12),
              top: AppSize.width(value: 12),
            ),
            decoration: BoxDecoration(
              color: color.surfacePrimary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), // Circular top-left border
                topRight: Radius.circular(12), // Circular top-right border
              ),
              boxShadow: [
                BoxShadow(
                  color: color.text2,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Obx(
              () => SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: NavigationTab.values.map((tab) {
                    final isSelected = controller.selectedTab.value == tab;

                    return InkWell(
                      onTap: () => controller.changeTab(tab),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppImage(
                              path: _iconPathForTab(tab),
                              width: 24,
                              height: 24,
                              iconColor: isSelected ? color.icon : color.text2,
                            ),
                            // Text below the icon with circular progress indicator
                            Builder(
                              builder: (context) {
                                final textStyle = TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected ? color.icon : color.text2,
                                );
                                final text = tab.title;
                                final textWidth = _getTextWidth(
                                  text,
                                  textStyle,
                                );

                                return Column(
                                  children: [
                                    Text(text, style: textStyle),
                                    if (isSelected) // Show the circular progress indicator for selected item
                                      Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        height: 4,
                                        width: textWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          color: color
                                              .icon, // Makes all corners circular
                                          border: Border.all(
                                            color: color.icon,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _iconPathForTab(NavigationTab tab) {
    switch (tab) {
      case NavigationTab.home:
        return AssetsPath.icNavHome;
      case NavigationTab.merchants:
        return AssetsPath.icNavmerchants;
      case NavigationTab.wallet:
        return AssetsPath.icNavWallet;
      case NavigationTab.profile:
        return AssetsPath.icNavProfile;
    }
  }

  // Function to calculate text width
  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.size.width;
  }
}
