import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/utils/app_size.dart';

class NotificationCardShimmer extends StatelessWidget {
  const NotificationCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width(value: 16),
        vertical: AppSize.width(value: 4),
      ),
      child: Shimmer(
        duration: const Duration(milliseconds: 1400),
        interval: const Duration(milliseconds: 300),
        color: Colors.white,
        colorOpacity: 0.6,
        enabled: true,
        direction: const ShimmerDirection.fromLTRB(),
        child: Container(
          padding: EdgeInsets.all(AppSize.width(value: 16)),
          decoration: BoxDecoration(
            // 🌫 Glass base (same pattern)
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),

            // Subtle white border
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 0.5,
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
              // 🔔 Icon placeholder
              _shimmerBox(
                width: AppSize.width(value: 30),
                height: AppSize.width(value: 30),
                radius: 30,
              ),

              SizedBox(width: AppSize.width(value: 12)),

              // 📄 Text placeholders
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    _shimmerBox(
                      width: AppSize.width(value: 160),
                      height: AppSize.width(value: 16),
                    ),

                    SizedBox(height: AppSize.width(value: 8)),

                    Row(
                      children: [
                        // Message
                        Expanded(
                          child: _shimmerBox(
                            width: double.infinity,
                            height: AppSize.width(value: 12),
                          ),
                        ),

                        SizedBox(width: AppSize.width(value: 12)),

                        // Time
                        _shimmerBox(
                          width: AppSize.width(value: 50),
                          height: AppSize.width(value: 12),
                        ),
                      ],
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

  /// Reusable shimmer placeholder
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
