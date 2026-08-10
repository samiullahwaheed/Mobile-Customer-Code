import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class TransRatingShimmer extends StatelessWidget {
  const TransRatingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSize.width(value: 8)),
      child: Shimmer(
        duration: const Duration(milliseconds: 1400),
        interval: const Duration(milliseconds: 300),
        color: Colors.white,
        colorOpacity: 0.6,
        direction: const ShimmerDirection.fromLTRB(),
        enabled: true,
        child: Container(
          padding: EdgeInsets.all(AppSize.width(value: 16)),
          decoration: BoxDecoration(
            // 🌫 Glass base
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(AppSize.width(value: 12)),

            // Subtle border
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),

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
              // 👤 Circular profile shimmer
              _shimmerBox(width: 40, height: 40, radius: 40),

              SizedBox(width: AppSize.width(value: 16)),

              // 📝 Text info shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(width: 120, height: 18, radius: 8),
                    SizedBox(height: 6),
                    _shimmerBox(width: 80, height: 12, radius: 6),
                    SizedBox(height: 6),
                    _shimmerBox(width: 100, height: 12, radius: 6),
                  ],
                ),
              ),

              SizedBox(width: AppSize.width(value: 16)),

              // ⭐ Points + Rating shimmer
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _shimmerBox(width: 50, height: 18, radius: 8),
                  SizedBox(height: 12),

                  // Rating stars
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 0 : 4),
                        child: _shimmerBox(width: 16, height: 16, radius: 4),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
        color: Colors.white, // shimmer color
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
