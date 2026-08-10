import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

void showRedemptionDialog({
  required String title,
  required String message,
  required String question,
  String acceptText = 'Accept',
  String declineText = 'Decline',
  VoidCallback? onAccept,
  VoidCallback? onDecline,
  Widget? icon,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Builder(
        builder: (context) {
          final AppThemeColor color = Theme.of(
            context,
          ).extension<AppThemeColor>()!;

          return Container(
            padding: EdgeInsets.all(AppSize.width(value: 24)),
            decoration: BoxDecoration(
              color: AppColor.button2Dark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon at the top
                icon ??
                    Container(
                      width: AppSize.width(value: 80),
                      height: AppSize.width(value: 80),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.button4Dark,
                          width: 3,
                        ),
                      ),
                      child: SvgPicture.asset(AssetsPath.popupRight),
                      // child: Icon(
                      //   Icons.check,
                      //   size: AppSize.width(value: 40),
                      //   color: AppColor.button4Dark,
                      // ),
                    ),
                SizedBox(height: AppSize.width(value: 20)),

                // Title
                AppText(
                  data: title,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColor.button4Dark,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSize.width(value: 12)),

                // Message
                AppText(
                  data: message,
                  fontSize: 14,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w400,
                  color: AppColor.button4Dark,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSize.width(value: 16)),

                // Question
                AppText(
                  data: question,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.button4Dark,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSize.width(value: 24)),

                // Buttons
                Row(
                  children: [
                    // Decline Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          if (onDecline != null) onDecline();
                        },
                        child: Container(
                          height: AppSize.width(value: 34),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColor.text1Dark,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: AppText(
                            data: declineText,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.button4Dark,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.width(value: 12)),

                    // Accept Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          if (onAccept != null) onAccept();
                        },
                        child: Container(
                          height: AppSize.width(value: 34),
                          decoration: BoxDecoration(
                            color: color.button,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: AppText(
                            data: acceptText,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ),
    barrierDismissible: false,
  );
}

// Keep the old function for backward compatibility
void showConfirmDialog({
  required String title,
  required String message,
  String yesText = 'Yes',
  String noText = 'No',
  VoidCallback? onYes,
  VoidCallback? onNo,
}) {
  Get.dialog(
    AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            if (onNo != null) onNo();
          },
          child: Text(noText),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            if (onYes != null) onYes();
          },
          child: Text(yesText),
        ),
      ],
    ),
  );
}
