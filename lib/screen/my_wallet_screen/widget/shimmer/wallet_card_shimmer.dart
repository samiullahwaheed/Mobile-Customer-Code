import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/utils/app_size.dart';

class WalletCardShimmer extends StatelessWidget {
  const WalletCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: EdgeInsets.all(AppSize.width(value: 24)),
        width: double.infinity,
        height: AppSize.height(value: 230),
        decoration: BoxDecoration(
          // 🌫 Glass base
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(AppSize.width(value: 12)),

          // Subtle white border
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.35),
          ),

          // ✨ Soft glow
          boxShadow: [
            BoxShadow(
              color: AppColor.button5Light.withValues(alpha: 0.18),
              blurRadius: 22,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column (Name, Points, Card ID)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: AppSize.width(value: 180), height: AppSize.width(value: 18)),
                SizedBox(height: AppSize.width(value: 10)),
                _shimmerBox(width: AppSize.width(value: 160), height: AppSize.width(value: 18)),
                Spacer(),
                _shimmerBox(width: AppSize.width(value: 140), height: AppSize.width(value: 18)),
              ],
            ),

            // Right Circular Image Placeholder
            _shimmerBox(width: AppSize.width(value: 56), height: AppSize.width(value: 56), radius: 56),
          ],
        ),
      ),
    );
  }

  /// Reusable shimmer box
  Widget _shimmerBox({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // same placeholder color
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
