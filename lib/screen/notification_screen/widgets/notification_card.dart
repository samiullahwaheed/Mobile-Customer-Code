import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class NotificationCard extends StatelessWidget {
  final String? title;
  final String? message;
  final String? time;
  final bool isRead;
  const NotificationCard({
    super.key,
    required this.appThemeColor,
    this.title,
    this.message,
    this.time,
    this.isRead = true,
  });

  final AppThemeColor appThemeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width(value: 16),
        vertical: AppSize.width(value: 4),
      ),
      child: Container(
        padding: EdgeInsets.all(AppSize.width(value: 16)),
        decoration: BoxDecoration(
          color: !isRead
              ? appThemeColor.icon.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appThemeColor.icon, width: 0.5),
        ),
        child: Row(
          spacing: AppSize.width(value: 12),
          children: [
            Container(
              width: AppSize.width(value: 30),
              height: AppSize.width(value: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: appThemeColor.icon, width: 0.5),
                // color: appThemeColor.cart,
              ),
              child: Icon(
                Icons.notification_add,
                color: appThemeColor.icon,
                size: AppSize.width(value: 16), // Adjust the size as needed
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                spacing: AppSize.width(value: 8),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    data: title ?? "No Data",
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    color: appThemeColor.text2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          data: message ?? "No Data",
                          fontSize: AppSize.width(value: 12),
                          fontWeight: FontWeight.w400,
                          color: appThemeColor.text2,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: AppSize.width(value: 8)),
                        child: AppText(
                          data: time ?? "No Data",
                          fontSize: AppSize.width(value: 12),
                          fontWeight: FontWeight.w500,
                          color: appThemeColor.text2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child:
            // ),
          ],
        ),
      ),
    );
  }
}
