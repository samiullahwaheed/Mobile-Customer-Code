import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:loyalty_customer/const/app_color.dart';

class TransectionShimmerCard extends StatelessWidget {
  const TransectionShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(milliseconds: 1400),
      interval: const Duration(milliseconds: 300),
      color: Colors.white,
      colorOpacity: 0.6, // same soft glow
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          // 🌫 Glass base (same as HomeCardShimmer)
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(10),

          // Subtle white border
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.35),
          ),

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
            _shimmerLine(width: 160, height: 16),
            const SizedBox(height: 8),
            Divider(color: Colors.white.withValues(alpha: 0.35)),

            _rowShimmer(),
            const SizedBox(height: 12),
            _rowShimmer(),
            const SizedBox(height: 12),
            _rowShimmer(),
            const SizedBox(height: 12),
            _rowShimmer(),
            const SizedBox(height: 8),

            Divider(color: Colors.white.withValues(alpha: 0.35)),
            _rowShimmer(isBold: true),
          ],
        ),
      ),
    );
  }

  /// Single shimmer bar
  Widget _shimmerLine({double width = double.infinity, double height = 12}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // same placeholder color
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  /// Row shimmer (left + right)
  Widget _rowShimmer({bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _shimmerLine(
          width: 140,
          height: isBold ? 14 : 12,
        ),
        _shimmerLine(
          width: 120,
          height: isBold ? 14 : 12,
        ),
      ],
    );
  }
}
