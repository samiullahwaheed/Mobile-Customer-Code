import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/utils/app_size.dart';

class MerchantCardShimmer extends StatelessWidget {
  const MerchantCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Shimmer(
        duration: const Duration(milliseconds: 1400),
        interval: const Duration(milliseconds: 300),
        color: Colors.white,
        colorOpacity: 0.6,
        enabled: true,
        direction: const ShimmerDirection.fromLTRB(),
        child: Container(
          width: double.infinity,
          height: AppSize.size.height * 0.34,
          decoration: BoxDecoration(
            // 🌫 Glass base
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(16),

            // Subtle white border
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼 Image placeholder
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // 👤 Profile image placeholder
                    _shimmerBox(
                      width: AppSize.width(value: 56),
                      height: AppSize.width(value: 56),
                      radius: 56,
                    ),

                    SizedBox(width: AppSize.width(value: 12)),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Business name + favorite
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _shimmerBox(
                                width: AppSize.width(value: 160),
                                height: AppSize.width(value: 18),
                              ),
                              _shimmerBox(
                                width: AppSize.width(value: 20),
                                height: AppSize.width(value: 20),
                                radius: 20,
                              ),
                            ],
                          ),

                          SizedBox(height: AppSize.width(value: 4)),

                          // Location row
                          Row(
                            children: [
                              _shimmerBox(
                                width: AppSize.width(value: 12),
                                height: AppSize.width(value: 12),
                              ),
                              SizedBox(width: AppSize.width(value: 8)),
                              _shimmerBox(
                                width: AppSize.width(value: 120),
                                height: AppSize.width(value: 14),
                              ),
                            ],
                          ),

                          SizedBox(height: AppSize.width(value: 4)),

                          // Service
                          _shimmerBox(
                            width: AppSize.width(value: 100),
                            height: AppSize.width(value: 14),
                          ),

                          SizedBox(height: AppSize.width(value: 8)),

                          // Button + rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _shimmerBox(
                                width: AppSize.width(value: 120),
                                height: AppSize.width(value: 18),
                              ),
                              _shimmerBox(
                                width: AppSize.width(value: 80),
                                height: AppSize.width(value: 16),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
