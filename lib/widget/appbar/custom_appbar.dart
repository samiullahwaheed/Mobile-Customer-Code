import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? text;
  final List<Widget>? action;
  final AppThemeColor appThemeColor;
  final bool showLeading;
  final bool autoShowLeading;
  // Constructor
  const CustomAppbar({
    super.key,
    this.text,
    this.action,

    required this.appThemeColor,
    this.showLeading = true,
    this.autoShowLeading = false,
  });

  // Set the toolbarHeight to 56
  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appThemeColor.surfacePrimary,
      title: AppText(
        data: text ?? "No Text", // Use passed 'text' or default to "Profile"
        fontSize: AppSize.width(value: 18),
        fontWeight: FontWeight.w700,
        color: appThemeColor.text2,
      ),
      centerTitle: true,
      automaticallyImplyLeading: autoShowLeading,
      leading: showLeading
          ? InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AppImage(
                  path: AssetsPath.arrowBack,
                  iconColor: appThemeColor.icon2,
                  width: AppSize.width(value: 12),
                  height: AppSize.width(value: 12),
                  color: appThemeColor.icon2,
                ),
              ),
            )
          : null,
      actions: action ??
          [
          ],
    );
  }
}
