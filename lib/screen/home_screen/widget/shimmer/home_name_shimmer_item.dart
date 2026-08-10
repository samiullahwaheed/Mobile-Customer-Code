import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';

class HomeNameShimmerItem extends StatelessWidget {
  const HomeNameShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(milliseconds: 1400),
      interval: const Duration(milliseconds: 300),
      color: Colors.white,     // highlight
      colorOpacity: 0.9,       // 🔥 strong gloss for white bg
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Hello Name Placeholder
          _shimmerLine(
            width: AppSize.width(value: 200),
            height: AppSize.width(value: 18),
          ),

          const Gap(height: 12),

          /// Address Placeholder (2 lines look)
          SizedBox(
            width: AppSize.width(value: 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerLine(
                  width: AppSize.width(value: 160),
                  height: AppSize.width(value: 12),
                ),
                const Gap(height: 6),
                _shimmerLine(
                  width: AppSize.width(value: 120),
                  height: AppSize.width(value: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable shimmer bar
  Widget _shimmerLine({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0), // base contrast for white bg
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
