import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/utils/app_size.dart';

class RewardsSummaryShimmer extends StatelessWidget {
  const RewardsSummaryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(milliseconds: 1400),
      interval: const Duration(milliseconds: 300),
      color: Colors.white,
      colorOpacity: 0.6,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // 🌫 Glass base (same pattern)
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
            // Title
            _shimmerBox(
              width: AppSize.width(value: 100),
              height: AppSize.width(value: 14),
            ),

            SizedBox(height: AppSize.size.height * 0.01),

            // Current Points
            _shimmerBox(
              width: AppSize.width(value: 200),
              height: AppSize.width(value: 18),
            ),

            SizedBox(height: AppSize.size.height * 0.01),

            // Total Referrals
            _shimmerBox(
              width: AppSize.width(value: 160),
              height: AppSize.width(value: 14),
            ),

            SizedBox(height: AppSize.size.height * 0.01),

            // Total Join
            _shimmerBox(
              width: AppSize.width(value: 140),
              height: AppSize.width(value: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable shimmer line
  Widget _shimmerBox({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
