import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/merchants_screen/model/all_merchant_model.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/utils/url_luncher.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_image/app_image_circular.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class MerchantCard extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? toggoleFavorate;
  final AllMerchantModelData? merchant;
  final bool favorateValue;
  const MerchantCard({
    this.merchant,
    super.key,
    required this.appThemeColor,
    this.onTap,
    this.toggoleFavorate,
    this.favorateValue = false,
  });

  final AppThemeColor appThemeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSize.size.width * double.infinity,
        height: AppSize.size.height * 0.34,
        decoration: BoxDecoration(
          color: AppColor.cart1Light,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColor.button1Dark.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image widget with border radius
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: AppImage(
                fit: BoxFit.cover,
                url: AppApiEndPoint.mediaUrl(merchant?.photo),
                width: double.infinity,
                height: AppSize.height(
                  value: 150,
                ), // This will make the image take up 2/3 of the container height
              ),
            ),
            // Text widget below the image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  AppImageCircular(
                    width: AppSize.width(value: 56),
                    height: AppSize.width(value: 56),
                    url: AppApiEndPoint.mediaUrl(merchant?.profile),
                  ),
                  Gap(width: AppSize.width(value: 12)),
                  Expanded(
                    child: Column(
                      spacing: AppSize.width(value: 4),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              data: merchant?.displayName.isNotEmpty == true
                                  ? merchant!.displayName
                                  : "N/A",
                              fontSize: AppSize.width(value: 18),
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                            InkWell(
                              onTap: toggoleFavorate,
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: favorateValue
                                    ? Icon(
                                  Icons.favorite_sharp,
                                  color: AppColor.buttonLight,
                                )
                                    : Icon(
                                  Icons.favorite_border,
                                  color: AppColor.button1Dark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            AppImage(
                              path: AssetsPath.icLocationIcon,
                              width: AppSize.width(value: 12),
                              // iconColor: appThemeColor.text2,
                              iconColor: Colors.black,
                            ),
                            Gap(width: AppSize.width(value: 8)),
                            AppText(
                              data:
                              "${merchant?.city ?? "N/A"} | ${merchant?.country ?? "N/A"}",
                              // fontSize: AppSize.width(value: 12),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        AppText(
                          data: merchant?.service ?? "N/A",
                          // fontSize: AppSize.width(value: 12),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                if (merchant?.website != null) {
                                  UrlLauncherHelper.open(
                                    merchant?.website ?? "",
                                  );
                                } else {
                                  AppSnackBar.error("Website not found");
                                }
                              },
                              child: AppText(
                                data: "Visit Website",
                                fontSize: AppSize.width(value: 18),
                                fontWeight: FontWeight.w700,
                                color: AppColor.iconLight,
                              ),
                            ),
                            StarRating(
                              size: AppSize.width(value: 16),
                              color: AppColor.button5Light,
                              rating: merchant?.rating ?? 0.0,
                              allowHalfRating: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}