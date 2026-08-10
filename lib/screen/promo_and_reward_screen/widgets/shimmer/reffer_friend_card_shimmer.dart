import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/utils/app_size.dart';

class RefferFriendCardShimmer extends StatelessWidget {
  const RefferFriendCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSize.width(value: 8)),
      child: Shimmer(
        duration: const Duration(milliseconds: 1400),
        interval: const Duration(milliseconds: 300),
        color: Colors.white,
        colorOpacity: 0.6, // same soft shimmer glow
        enabled: true,
        direction: const ShimmerDirection.fromLTRB(),
        child: Container(
          padding: EdgeInsets.all(AppSize.width(value: 16)),
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
            children: [
              // 🔵 Circular shimmer for profile image
              _shimmerBox(
                width: AppSize.width(value: 56),
                height: AppSize.width(value: 56),
                radius: 100,
              ),

              SizedBox(width: AppSize.width(value: 16)),

              // 📄 Column shimmer for name and address
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(
                    width: AppSize.width(value: 120),
                    height: AppSize.width(value: 18),
                  ),
                  SizedBox(height: AppSize.width(value: 12)),
                  _shimmerBox(
                    width: AppSize.width(value: 150),
                    height: AppSize.width(value: 12),
                  ),
                ],
              ),

              const Spacer(),

              // 📊 Column shimmer for points and status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _shimmerBox(
                    width: AppSize.width(value: 50),
                    height: AppSize.width(value: 18),
                  ),
                  SizedBox(height: AppSize.width(value: 4)),
                  _shimmerBox(
                    width: AppSize.width(value: 60),
                    height: AppSize.width(value: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable shimmer placeholder box
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
