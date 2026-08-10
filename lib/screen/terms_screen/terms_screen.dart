import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return Scaffold(
      appBar: CustomAppbar(
        appThemeColor: appThemeColor,
        text: "Terms & conditions",
      ),
      body: Center(
        child: AppImage(
          width: AppSize.size.width * 0.6,
          path: AssetsPath.emptyTarmImg,
        ),
      ),
    );
  }
}
