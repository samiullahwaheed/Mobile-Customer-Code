import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/utils/app_size.dart';

class GiftListItemCardShimmer extends StatelessWidget {
  const GiftListItemCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSize.size.height * 0.37,
      decoration: BoxDecoration(
        // 🌫 Glass base
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼 Image placeholder
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              width: double.infinity,
              height: AppSize.height(value: 150),
              color: Colors.white,
            ),
          ),

          // Text placeholders
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(value: 8),
              vertical: AppSize.width(value: 4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Icon row
                Row(
                  children: [
                    _shimmerBox(width: AppSize.width(value: 160), height: AppSize.width(value: 18)),
                    Spacer(),
                    _shimmerBox(width: AppSize.width(value: 24), height: AppSize.width(value: 24), radius: 6),
                  ],
                ),

                SizedBox(height: AppSize.width(value: 4)),

                // Merchant name
                _shimmerBox(width: AppSize.width(value: 100), height: AppSize.width(value: 14)),

                SizedBox(height: AppSize.width(value: 4)),

                // Card ID
                _shimmerBox(width: AppSize.width(value: 140), height: AppSize.width(value: 14)),

                SizedBox(height: AppSize.width(value: 4)),

                // Tier
                _shimmerBox(width: AppSize.width(value: 120), height: AppSize.width(value: 14)),

                SizedBox(height: AppSize.width(value: 4)),

                // Rewards
                _shimmerBox(width: AppSize.width(value: 160), height: AppSize.width(value: 14)),

                SizedBox(height: AppSize.width(value: 8)),

                // Apply button placeholder (right aligned)
                Align(
                  alignment: Alignment.bottomRight,
                  child: _shimmerBox(width: AppSize.width(value: 62), height: AppSize.width(value: 32), radius: 16),
                ),
              ],
            ),
          ),
        ],
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
        color: Colors.white, // shimmer color
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
