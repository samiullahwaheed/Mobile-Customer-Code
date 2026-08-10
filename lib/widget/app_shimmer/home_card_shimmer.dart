import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/utils/app_size.dart';

class HomeCardShimmer extends StatelessWidget {
  const HomeCardShimmer({super.key});

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
        margin: const EdgeInsets.only(right: 12),
        width: AppSize.size.width * 0.8,
        decoration: BoxDecoration(
          // 🌫 Glass base
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),

          // ✨ Soft Glow
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
            // 🔲 Image placeholder
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                height: AppSize.height(value: 150),
                color: Colors.white,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 8),
                vertical: AppSize.width(value: 6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔲 Title
                  _shimmerBox(height: 18, width: double.infinity),
                  const SizedBox(height: 6),

                  // 🔲 Discount
                  _shimmerBox(height: 14, width: 120),
                  const SizedBox(height: 6),

                  // 🔲 Button text
                  _shimmerBox(height: 16, width: 140),
                  const SizedBox(height: 10),

                  // 🔲 Rating (right aligned)
                  Align(
                    alignment: Alignment.centerRight,
                    child: _shimmerBox(height: 16, width: 80),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
