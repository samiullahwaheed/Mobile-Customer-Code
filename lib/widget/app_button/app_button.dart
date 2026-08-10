import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.onTap,
    required this.title,
    this.isLoading = false,
    this.margin,
    this.circularHeight,
    this.height,
    this.width,
    this.borderRadius,
    this.decoration,
    this.titleColor,
    this.titleSize,
    this.filColor,
  });

  final void Function()? onTap;
  final double? height;
  final double? circularHeight;
  final double? width;
  final String title;
  final bool isLoading;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final BoxDecoration? decoration;
  final Color? titleColor;
  final double? titleSize;
  final Color? filColor;

  @override
  Widget build(BuildContext context) {
    final AppThemeColor color = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width ?? Get.width,
        height: height ?? AppSize.width(value: 50.0),
        alignment: Alignment.center,
        margin: margin,
        decoration:
            decoration ??
            BoxDecoration(
              color: filColor ?? color.button,
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),

        child: isLoading
            ? SizedBox(
                height: circularHeight ?? AppSize.width(value: 30.0),
                width: circularHeight ?? AppSize.width(value: 30.0),
                child: const CircularProgressIndicator(
                  // color: AppColors.white50,
                  strokeWidth: 2,
                ),
              )
            : AppText(
                data: title,
                color: titleColor ?? Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: titleSize ?? 16,
              ),
      ),
    );
  }
}
