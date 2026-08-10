import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/utils/app_size.dart';

class TiarShimmer extends StatelessWidget {
  const TiarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.width(value: 16)),
      decoration: BoxDecoration(
        // 🌫 Glass base
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppSize.width(value: 12)),

        // Subtle border
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
        children: [
          // 🟡 Icon placeholder
          _shimmerBox(width: 18, height: 18, radius: 4),

          SizedBox(width: AppSize.width(value: 16)),

          // 📝 Left column (Tier & Points)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerBox(width: 100, height: 14, radius: 6),
              SizedBox(height: 6),
              _shimmerBox(width: 60, height: 16, radius: 6),
            ],
          ),

          Spacer(),

          // 🏆 Right column (Tier Rewards)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerBox(width: 60, height: 10, radius: 4),
              SizedBox(height: 4),
              _shimmerBox(width: 80, height: 10, radius: 4),
              SizedBox(height: 4),
              _shimmerBox(width: 40, height: 10, radius: 4),
            ],
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
