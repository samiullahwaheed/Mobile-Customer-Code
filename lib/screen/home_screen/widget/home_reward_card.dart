import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/screen/home_screen/model/promotion_model.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class HomeRewardCard extends StatelessWidget {
  final VoidCallback? onTap;
  final Promotion promotion;
  const HomeRewardCard({super.key, this.onTap, required this.promotion});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 12),
        width: AppSize.size.width * 0.8,
        height: AppSize.height(value: 230),
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
                url: promotion.image ?? "",
                width: double.infinity,
                height: AppSize.height(
                  value: 150,
                ), // This will make the image take up 2/3 of the container height
              ),
            ),
            // Text widget below the image
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 8),
                vertical: AppSize.width(value: 4),
              ),
              child: Column(
                spacing: AppSize.width(value: 4),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    data: promotion.name ?? "",
                    maxLines: 2,
                    fontSize: AppSize.width(value: 18),
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  if (promotion.discountPercentage != null)
                    AppText(
                      data: "${promotion.discountPercentage} % OFF",
                      fontSize: AppSize.width(value: 14),
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  AppText(
                    data: "Visit Website",
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w700,
                    color: AppColor.button5Light,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      StarRating(
                        size: AppSize.width(value: 16),
                        color: AppColor.button5Light,
                        rating: promotion.averageRating?.toDouble() ?? 0.0,
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
    );
  }
}
