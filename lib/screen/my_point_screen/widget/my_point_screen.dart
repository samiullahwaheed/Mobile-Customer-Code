import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class MyPointCard extends StatelessWidget {
  String? iconPath;
  String? text1;
  String? text2;
  MyPointCard({
    this.iconPath,
    this.text1,
    this.text2,
    super.key,
    required this.appThemeColor,
  });

  final AppThemeColor appThemeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.width(value: 38),
        horizontal: AppSize.width(value: 34),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appThemeColor.cart4),
        color: appThemeColor.cart3,
      ),
      child: Column(
        spacing: AppSize.size.height * 0.005,
        children: [
          AppImage(
            width: AppSize.width(value: 34),
            height: AppSize.width(value: 34),
            path: iconPath,
          ),
          AppText(
            data: text1 ?? "No Text",
            fontSize: AppSize.width(value: 14),
            fontWeight: FontWeight.w400,
            color: appThemeColor.cart4,
          ),
          AppText(
            data: text2 ?? "",
            fontSize: AppSize.width(value: 18),
            fontWeight: FontWeight.w600,
            color: appThemeColor.cart4,
          ),
        ],
      ),
    );
  }
}